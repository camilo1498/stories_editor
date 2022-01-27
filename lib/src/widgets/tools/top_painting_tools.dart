import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/constants/painting_type.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/widgets/common_widgets/tool_button.dart';

class TopPaintingTools extends StatefulWidget {
  const TopPaintingTools({Key? key}) : super(key: key);

  @override
  _TopPaintingToolsState createState() => _TopPaintingToolsState();
}

class _TopPaintingToolsState extends State<TopPaintingTools> {
  @override
  Widget build(BuildContext context) {

    return Consumer2<ControlVariableProvider, PaintingProvider>(
      builder: (context, controlProvider, paintingProvider, child){
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// remove last line
                if(paintingProvider.lines.isNotEmpty)
                  ToolButton(
                    onTap:  paintingProvider.removeLast,
                    onLongPress: paintingProvider.clearAll,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    backGroundColor: Colors.black12,
                    child: Transform.scale(
                        scale: 0.6,
                        child: const ImageIcon(
                          AssetImage('assets/icons/return.png', package: 'stories_editor'),
                          color: Colors.white,
                        )
                    ),
                  ),

                /// select pen
                ToolButton(
                  onTap: (){
                    paintingProvider.paintingType = PaintingType.PEN;
                  },
                  colorBorder: paintingProvider.paintingType == PaintingType.PEN ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  backGroundColor: paintingProvider.paintingType == PaintingType.PEN ? Colors.white.withOpacity(0.9) : Colors.black12,
                  child: Transform.scale(
                      scale: 1.2,
                      child: ImageIcon(
                        const AssetImage('assets/icons/pen.png', package: 'stories_editor'),
                        color: paintingProvider.paintingType == PaintingType.PEN ? Colors.black : Colors.white,
                      )
                  ),
                ),

                /// select marker
                ToolButton(
                  onTap: (){
                    paintingProvider.paintingType = PaintingType.MARKER;
                  },
                  colorBorder: paintingProvider.paintingType == PaintingType.MARKER ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  backGroundColor: paintingProvider.paintingType == PaintingType.MARKER ? Colors.white.withOpacity(0.9): Colors.black12,
                  child: Transform.scale(
                      scale: 1.2,
                      child:  ImageIcon(
                        const AssetImage('assets/icons/marker.png', package: 'stories_editor'),
                        color: paintingProvider.paintingType == PaintingType.MARKER ? Colors.black : Colors.white,
                      )
                  ),
                ),

                /// select neon marker
                ToolButton(
                  onTap: (){
                    paintingProvider.paintingType = PaintingType.NEON;
                  },
                  colorBorder: paintingProvider.paintingType == PaintingType.NEON ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  backGroundColor: paintingProvider.paintingType == PaintingType.NEON ? Colors.white.withOpacity(0.9) : Colors.black12,
                  child: Transform.scale(
                      scale: 1.1,
                      child: ImageIcon(
                        const AssetImage('assets/icons/neon.png', package: 'stories_editor'),
                        color: paintingProvider.paintingType == PaintingType.NEON ? Colors.black : Colors.white,
                      )
                  ),
                ),

                /// done button
                ToolButton(
                  onTap: (){
                    controlProvider.isPainting = false;
                    paintingProvider.resetDefaults();
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  backGroundColor: Colors.black12,
                  child: Transform.scale(
                      scale: 0.7,
                      child: const ImageIcon(
                        AssetImage('assets/icons/check.png', package: 'stories_editor'),
                        color: Colors.white,
                      )
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
