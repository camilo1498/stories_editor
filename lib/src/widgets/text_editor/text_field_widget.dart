import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';


class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    FocusNode _textNode = FocusNode();
    return Consumer2<TextEditorProvider, ControlVariableProvider>(
      builder: (context, editorProvider, controlProvider, child){
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _size.width - 100,
            ),
            child: IntrinsicWidth(
              /// textField Box decoration
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: _text(
                        editorProvider: editorProvider,
                        textNode: _textNode,
                        controlProvider: controlProvider,
                        paintingStyle: PaintingStyle.fill,
                      ),
                    ),
                    _textField(
                      editorProvider: editorProvider,
                      textNode: _textNode,
                      controlProvider: controlProvider,
                      paintingStyle: PaintingStyle.stroke,
                    )
                  ],
                )
            ),
          ),
        );
      },
    );
  }

  Widget _text({
    required TextEditorProvider editorProvider,
    required FocusNode textNode,
    required ControlVariableProvider controlProvider,
    required PaintingStyle paintingStyle,
  }){
    return Text(
      editorProvider.textController.text,
      textAlign: editorProvider.textAlign,
      style: TextStyle(
          fontFamily : controlProvider.fontList![editorProvider.fontFamilyIndex],
          package: controlProvider.fontPackage ?? 'stories_editor',
          shadows: <Shadow>[
            Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: editorProvider.textColor == Colors.black ? Colors.white54 : Colors.black
            )
          ]
      ).copyWith(
          color: controlProvider.colorList![editorProvider.textColor],
          fontSize: editorProvider.textSize,
          background: Paint()
            ..strokeWidth = 20.0
            ..color = editorProvider.backGroundColor
            ..style = paintingStyle
            ..strokeJoin = StrokeJoin.round
            ..filterQuality = FilterQuality.high
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1)
      ),
    );
  }

  Widget _textField ({
    required TextEditorProvider editorProvider,
    required FocusNode textNode,
    required ControlVariableProvider controlProvider,
    required PaintingStyle paintingStyle,
  }){
    return TextField(
      focusNode: textNode,
      autofocus: true,
      textInputAction: TextInputAction.newline,
      controller: editorProvider.textController,
      textAlign: editorProvider.textAlign,
      style: TextStyle(
          fontFamily: controlProvider.fontList![editorProvider.fontFamilyIndex],
          package: controlProvider.fontPackage ?? 'stories_editor',
          shadows: <Shadow>[
            Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: editorProvider.textColor == Colors.black ? Colors.white54 : Colors.black
            )
          ],
          backgroundColor: Colors.redAccent
      ).copyWith(
        color: controlProvider.colorList![editorProvider.textColor],
        fontSize: editorProvider.textSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = editorProvider.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
        shadows: <Shadow>[
          Shadow(
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: editorProvider.textColor == Colors.black ? Colors.white54 : Colors.black
          )
        ],

      ),

      cursorColor: controlProvider.colorList![editorProvider.textColor],
      minLines: 1,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: null,
      onChanged: (value){
        editorProvider.text = value;
      },
    );
  }
}
