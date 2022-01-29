import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/constants/item_type.dart';
import 'package:stories_editor/src/models/editable_items.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/gradientProvider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';
import 'package:stories_editor/src/utils/animated_onTap_button.dart';
import 'package:stories_editor/src/utils/file_image_bg.dart';
import 'package:stories_editor/src/utils/modal_sheets/modal_sheets.dart';

class DraggableWidget extends StatelessWidget {
  final EditableItem draggableWidget;
  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerMoveEvent)? onPointerMove;

  const DraggableWidget({
    Key? key,
    required this.draggableWidget,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _imageProvider = Provider.of<PickerDataProvider>(context, listen: false);
    var _colorProvider = Provider.of<GradientProvider>(context, listen: false);
    var _controlProvider = Provider.of<ControlVariableProvider>(context, listen: false);
    Widget overlayWidget;
    switch (draggableWidget.type) {
      case ItemType.TEXT:
        overlayWidget = IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 50,
                minWidth: 50,
                maxWidth: _size.width - 120,
              ),
              width: draggableWidget.deletePosition ? 100 : null,
              height: draggableWidget.deletePosition ? 100 : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: AnimatedOnTapButton(
                        onTap: () => _onTap(context, draggableWidget, _controlProvider),
                        child: _text(controlProvider: _controlProvider, paintingStyle: PaintingStyle.fill)
                    ),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child:  _text(controlProvider: _controlProvider, paintingStyle: PaintingStyle.stroke),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        break;

    /// image [file_image_gb.dart]
      case ItemType.IMAGE:
        if(_imageProvider.imagePath.isNotEmpty){
          overlayWidget = SizedBox(
            width: _size.width - 72,
            child: FileImageBG(
              filePath: _imageProvider.imagePath[0],
              generatedGradient: (color1, color2){
                _colorProvider.color1 = color1;
                _colorProvider.color2 = color2;
              },
            ),
          );
        } else{
          overlayWidget = Container();
        }

        break;

      case ItemType.GIF:
        overlayWidget = SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// create Gif widget
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),color: Colors.transparent
                  ),
                  child: GiphyRenderImage.original(gif: draggableWidget.gif),
                ),
              ),
            ],
          ),
        );
        break;

      case ItemType.VIDEO:
        overlayWidget = const Center();
    }

    /// set widget data position on main screen
    return AnimatedAlignPositioned(
      duration: const Duration(milliseconds: 50),
      dy:  (draggableWidget.deletePosition ? _deleteTopOffset(_size): (draggableWidget.position.dy * _size.height)),
      dx: (draggableWidget.deletePosition ? 0 : (draggableWidget.position.dx * _size.width)),
      alignment: Alignment.center,

      child: Transform.scale(
        scale: draggableWidget.deletePosition ? _deleteScale() : draggableWidget.scale,
        child: Transform.rotate(
          angle: draggableWidget.rotation,
          child: Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerCancel: (details) {},
            onPointerMove: onPointerMove,
            /// show widget
            child: overlayWidget,
          ),
        ),
      ),
    );
  }

  /// text widget
  Widget _text({
    required ControlVariableProvider controlProvider,
    required PaintingStyle paintingStyle
  }){
    return Text(
      draggableWidget.text,
      textAlign: draggableWidget.textAlign,
      style: TextStyle(
          fontFamily : controlProvider.fontList![draggableWidget.fontFamily],
          package: controlProvider.fontPackage ?? 'stories_editor',
          fontWeight: FontWeight.w500,
          shadows: <Shadow>[
            Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: draggableWidget.textColor == Colors.black ? Colors.white54 : Colors.black
            )
          ]
      ).copyWith(
          color: draggableWidget.textColor,
          fontSize: draggableWidget.deletePosition ? 8 : draggableWidget.fontSize,
          background: Paint()
            ..strokeWidth = 20.0
            ..color = draggableWidget.backGroundColor
            ..style = paintingStyle
            ..strokeJoin = StrokeJoin.round
            ..filterQuality = FilterQuality.high
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1)
      ),
    );
  }

  double? _deleteTopOffset(size){
    double top = 0.0;
    if(draggableWidget.type == ItemType.TEXT){
      top = size.width / 1.3;
      return top;
    } else if(draggableWidget.type == ItemType.GIF){
      top = size.width / 1.3;
      return top;
    }
  }

  _deleteScale(){
    double scale = 0.0;
    if(draggableWidget.type == ItemType.TEXT){
      scale = 0.4;
      return scale;
    } else if(draggableWidget.type == ItemType.GIF){
      scale = 0.3;
      return scale;
    }
  }

  /// onTap text
  void _onTap(BuildContext context, EditableItem item, ControlVariableProvider controlProvider) {
    var _editorProvider = Provider.of<TextEditorProvider>(context, listen: false);
    var _itemProvider = Provider.of<DraggableWidgetProvider>(context, listen: false);
    var _scrollProvider = Provider.of<ControlVariableProvider>(context, listen: false);

    /// load text attributes
    _editorProvider.textController.text = item.text.trim();
    _editorProvider.text = item.text.trim();
    _editorProvider.fontFamilyIndex = item.fontFamily;
    _editorProvider.textSize = item.fontSize;
    _editorProvider.backGroundColor = item.backGroundColor;
    _editorProvider.textAlign = item.textAlign;
    _editorProvider.textColor = controlProvider.colorList!.indexOf(item.textColor);
    _itemProvider.draggableWidget.removeAt(_itemProvider.draggableWidget.indexOf(item));

    _editorProvider.fontFamilyController = PageController(
      initialPage: item.fontFamily,
      viewportFraction: .1,
    );
    /// create new text item
    createText(
        context: context,
        controlProvider: _scrollProvider
    );

  }
}