import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/domain/providers/photo_provider.dart';
import 'package:stories_editor/src/presentation/gallery/widgets/asset_path_grid_view.dart';
import 'package:stories_editor/src/presentation/gallery/widgets/asset_widget.dart';
import 'package:stories_editor/src/presentation/gallery/widgets/current_path_selector.dart';
import 'package:stories_editor/src/presentation/utils/constants/item_type.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

typedef PickAppBarBuilder = PreferredSizeWidget Function(BuildContext context);

class GalleryPicker extends StatelessWidget {
  final PickerDataProvider? provider;
  final int thumbSize;
  final Function? onTapPreview;

  const GalleryPicker({
    Key? key,
    required this.provider,
    this.thumbSize = 100,
    this.onTapPreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    return Consumer2<PickerDataProvider, DraggableWidgetNotifier>(
      builder: (context, imageProvider, widgetProvider, child) {
        return Column(
          children: [
            Container(
              color: Colors.black,
              alignment: Alignment.bottomLeft,
              height: 145,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectedPathDropdownButton(
                      dropdownRelativeKey: key,
                      provider: provider!,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, top: 85),
                      child: IntrinsicHeight(
                        child: AnimatedOnTapButton(
                          onTap: () {
                            Provider.of<ScrollNotifier>(context, listen: false)
                                .pageController
                                .animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white)),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: provider != null
                  ? AnimatedBuilder(
                      animation: provider!.currentPathNotifier,
                      builder: (BuildContext context, child) => AssetPathWidget(
                          path: provider!.currentPath,
                          buildItem: (ctx, asset, thumbSize) {
                            return AssetWidget(asset: asset);
                          },
                          onAssetItemClick: (ctx, asset, index) async {
                            var _file = await asset.file;

                            /// save selected asset
                            imageProvider.imagePath.add(_file);
                            if (imageProvider.imagePath.isNotEmpty) {
                              widgetProvider.draggableWidget.insert(
                                  0,
                                  EditableItem()
                                    ..type = ItemType.image
                                    ..position = const Offset(0.0, 0));
                            }
                            imageProvider.isEmpty = false;

                            /// go to Page 0
                            Provider.of<ScrollNotifier>(context, listen: false)
                                .pageController
                                .animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                          }),
                    )
                  : Container(),
            ))
          ],
        );
      },
    );
  }
}
