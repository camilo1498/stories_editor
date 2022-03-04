import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/presentation/gallery/widgets/asset_widget.dart';

typedef AssetPathGridView = Widget Function(
    BuildContext context, AssetPathEntity path);

typedef OnAssetItemClick = void Function(
    BuildContext context, AssetEntity entity, int index);

class AssetPathWidget extends StatefulWidget {
  final AssetPathEntity? path;
  final AssetWidgetBuilder? buildItem;
  final bool loadWhenScrolling;
  final OnAssetItemClick? onAssetItemClick;

  const AssetPathWidget({
    Key? key,
    required this.path,
    this.buildItem = AssetWidget.buildWidget,
    this.onAssetItemClick,
    this.loadWhenScrolling = false,
  }) : super(key: key);

  @override
  _AssetPathWidgetState createState() => _AssetPathWidgetState();
}

class _AssetPathWidgetState extends State<AssetPathWidget> {
  static Map<int?, AssetEntity?> _createMap() {
    return {};
  }

  /// create cache for images
  var cacheMap = _createMap();

  /// notifier for scroll events
  final scrolling = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    /// generate asset grid view
    return widget.path != null
        ? NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: Container(
                color: Colors.black,
                child: Consumer2<ScrollNotifier, DraggableWidgetNotifier>(
                  builder: (context, scrollController, widgetProvider, child) {
                    return GridView.builder(
                      key: ValueKey(widget.path),
                      controller: scrollController.gridController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(5),
                      physics: widgetProvider.draggableWidget.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : const ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.5,
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.5,
                        crossAxisSpacing: 2.5,
                      ),
                      itemBuilder: (context, index) =>
                          _buildItem(context, index),
                      itemCount: widget.path!.assetCount,
                      addRepaintBoundaries: true,
                    );
                  },
                )),
          )
        : Container();
  }

  Widget _buildScrollItem(BuildContext context, int index) {
    final asset = cacheMap[index];
    if (asset != null) {
      return widget.buildItem!(context, asset, 100);
    } else {
      /// read the assets from selected album
      return FutureBuilder<List<AssetEntity>>(
        future: widget.path!.getAssetListRange(start: index, end: index + 1),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              //nop
              color: const Color(0xFF4A4748),
            );
          }
          final asset = snapshot.data![0];
          cacheMap[index] = asset;
          return widget.buildItem!(context, asset, 100);
        },
      );
    }
  }

  Widget _buildItem(BuildContext context, index) {
    if (widget.loadWhenScrolling) {
      return GestureDetector(
        onTap: () async {
          var asset = cacheMap[index];
          if (asset == null) {
            asset = (await widget.path!
                .getAssetListRange(start: index, end: index + 1))[0];
            cacheMap[index] = asset;
          }
          widget.onAssetItemClick?.call(context, asset, index);
        },
        child: _buildScrollItem(context, index),
      );
    }
    return GestureDetector(
      /// get asset item on tap event
      onTap: () async {
        var asset = cacheMap[index];
        if (asset == null) {
          asset = (await widget.path!
              .getAssetListRange(start: index, end: index + 1))[0];
          cacheMap[index] = asset;
        }

        /// return asset item
        widget.onAssetItemClick?.call(context, asset, index);
      },

      /// render image from asset item
      child: _WrapItem(
        cacheMap: cacheMap,
        path: widget.path!,
        index: index,
        onLoaded: (AssetEntity entity) {
          cacheMap[index] = entity;
        },
        buildItem: widget.buildItem!,
        loaded: cacheMap.containsKey(index),
        thumbSize: 100,
        valueNotifier: scrolling,
        scrollingPlaceHolder: Container(
          width: double.infinity,
          height: double.infinity,
          //nop
          color: const Color(0xFF4A4748),
          child: Transform.scale(
            scale: 0.1,
            child: const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                    color: Colors.red, strokeWidth: 5)),
          ),
        ),
        entity: cacheMap[index],
      ),
    );
  }

  /// scroll notifier
  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      scrolling.value = false;
    } else if (notification is ScrollStartNotification) {
      scrolling.value = true;
    }
    return false;
  }

  /// update widget on scroll
  @override
  void didUpdateWidget(AssetPathWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      cacheMap.clear();
      scrolling.value = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

class _WrapItem extends StatefulWidget {
  final AssetPathEntity path;
  final int index;
  final void Function(AssetEntity entity) onLoaded;
  final ValueNotifier<bool> valueNotifier;
  final bool loaded;
  final AssetWidgetBuilder buildItem;
  final int thumbSize;
  final Widget scrollingPlaceHolder;
  final AssetEntity? entity;
  final Map<int?, AssetEntity?> cacheMap;
  const _WrapItem({
    Key? key,
    required this.path,
    required this.index,
    required this.onLoaded,
    required this.valueNotifier,
    required this.loaded,
    required this.buildItem,
    required this.thumbSize,
    required this.scrollingPlaceHolder,
    required this.entity,
    required this.cacheMap,
  }) : super(key: key);

  @override
  __WrapItemState createState() => __WrapItemState();
}

class __WrapItemState extends State<_WrapItem> {
  bool get scrolling => widget.valueNotifier.value;

  bool _loaded = false;

  bool get loaded => _loaded || widget.loaded;
  AssetEntity? assetEntity;

  @override
  void initState() {
    super.initState();
    assetEntity = widget.cacheMap[widget.index];
    widget.valueNotifier.addListener(onChange);
    if (!scrolling) {
      _load();
    }
  }

  /// validate state
  void onChange() {
    if (assetEntity != null) {
      return;
    }
    if (loaded) {
      return;
    }
    if (scrolling) {
      return;
    }
    _load();
  }

  /// dispose scroll notifier
  @override
  void dispose() {
    widget.valueNotifier.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (assetEntity == null) {
      return widget.scrollingPlaceHolder;
    }
    return widget.buildItem(context, assetEntity!, widget.thumbSize);
  }

  /// load more asset item when scroll arrive to end od the page
  Future<void> _load() async {
    final list = await widget.path
        .getAssetListRange(start: widget.index, end: widget.index + 1);
    if (list.isNotEmpty) {
      final asset = list[0];
      _loaded = true;
      widget.onLoaded(asset);
      assetEntity = asset;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
