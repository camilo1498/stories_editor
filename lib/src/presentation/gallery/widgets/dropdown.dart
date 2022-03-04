import 'dart:async';

import 'package:flutter/material.dart';

typedef DropdownWidgetBuilder<T> = Widget Function(
    BuildContext context, ValueSetter<T> close);

class FeatureController<T> {
  final Completer<T?> completer;

  final ValueSetter<T?> close;

  FeatureController(this.completer, this.close);

  Future<T?> get closed => completer.future;
}

FeatureController<T> _showDropDown<T>({
  required BuildContext context,
  required DropdownWidgetBuilder<T> builder,
  double? height,
  Duration animationDuration = const Duration(milliseconds: 250),
  required TickerProvider tickerProvider,
}) {
  final animationController = AnimationController(
    vsync: tickerProvider,
    duration: animationDuration,
  );
  final completer = Completer<T?>();
  var isReply = false;
  OverlayEntry? entry;
  void close(T? value) async {
    if (isReply) {
      return;
    }
    isReply = true;
    animationController.animateTo(0).whenCompleteOrCancel(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      completer.complete(value);
      entry?.remove();
    });
  }

  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final space = screenHeight - height!;

  entry = OverlayEntry(builder: (context) {
    return Padding(
      padding: EdgeInsets.only(
        top: space,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Builder(
          builder: (ctx) => GestureDetector(
            onTap: () {
              close(null);
            },
            child: AnimatedBuilder(
              child: builder(ctx, close),
              animation: animationController,
              builder: (BuildContext context, child) {
                return Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: height * animationController.value,
                      width: screenWidth,
                    ),
                    SizedBox(
                      height: height * animationController.value,
                      width: screenWidth * 0.5,
                      child: child,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  });
  Overlay.of(context)!.insert(entry);
  animationController.animateTo(1);
  return FeatureController(
    completer,
    close,
  );
}

class DropDown<T> extends StatefulWidget {
  final Widget child;
  final DropdownWidgetBuilder<T> dropdownWidgetBuilder;
  final ValueChanged<T?>? onResult;
  final ValueChanged<bool>? onShow;
  final GlobalKey? relativeKey;

  const DropDown({
    Key? key,
    required this.child,
    required this.dropdownWidgetBuilder,
    this.onResult,
    this.onShow,
    this.relativeKey,
  }) : super(key: key);
  @override
  _DropDownState<T> createState() => _DropDownState<T>();
}

class _DropDownState<T> extends State<DropDown<T>>
    with TickerProviderStateMixin {
  FeatureController<T?>? controller;
  var isShow = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () async {
        if (controller != null) {
          controller!.close(null);
          return;
        }
        final height = MediaQuery.of(context).size.height;
        final ctx = widget.relativeKey?.currentContext ?? context;
        RenderBox box = ctx.findRenderObject() as RenderBox;
        final offsetStart = box.localToGlobal(Offset.zero);
        final dialogHeight = height - (offsetStart.dy + box.paintBounds.bottom);
        widget.onShow?.call(true);
        controller = _showDropDown<T>(
          context: context,
          height: dialogHeight,
          builder: (_, close) {
            return widget.dropdownWidgetBuilder.call(context, close);
          },
          tickerProvider: this,
        );
        isShow = true;
        var result = await controller!.closed;
        controller = null;
        isShow = false;
        widget.onResult!(result);
        widget.onShow?.call(false);
      },
    );
  }
}
