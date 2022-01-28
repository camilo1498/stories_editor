import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';
import 'package:stories_editor/src/widgets/common_widgets/tool_button.dart';

class TopTextTools extends StatelessWidget {
  final void Function() onDone;
  const TopTextTools({Key? key,
    required this.onDone
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TextEditorProvider>(
      builder: (context, editorProvider, child){
        return Container(
          padding: const EdgeInsets.only(top: 15),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// font family / font color
                  ToolButton(
                    onTap: (){
                      editorProvider.isFontFamily = !editorProvider.isFontFamily;
                      if(editorProvider.isFontFamily){
                        editorProvider.fontFamilyController.jumpToPage(editorProvider.fontFamilyIndex);
                      }
                    },
                    child: Transform.scale(
                        scale: !editorProvider.isFontFamily ? 0.8 : 1.3,
                        child: !editorProvider.isFontFamily ? const ImageIcon(
                          AssetImage(
                              'assets/icons/text.png', package: 'stories_editor'),
                          size: 20,
                          color: Colors.white,
                        ) : Image.asset('assets/icons/circular_gradient.png', package: 'stories_editor',)
                    ),
                  ),

                  /// text align
                  ToolButton(
                    onTap: editorProvider.onAlignmentChange,
                    child: Transform.scale(
                        scale: 0.8,
                        child: Icon(
                          editorProvider.textAlign == TextAlign.center
                              ? Icons.format_align_center :
                          editorProvider.textAlign == TextAlign.right ? Icons.format_align_right :
                          Icons.format_align_left,
                          color: Colors.white,
                        )
                    ),
                  ),

                  /// background color
                  ToolButton(
                    onTap: editorProvider.onBackGroundChange,
                    child: Transform.scale(
                        scale: 0.7,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5,bottom: 3),
                            child: ImageIcon(
                              AssetImage('assets/icons/font_backGround.png', package: 'stories_editor'),
                              color: Colors.white,
                            ),
                          ),
                        )
                    ),
                  )

                ],
              ),

              /// close and create item
              GestureDetector(
                onTap: onDone,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Colors.white,
                              width: 1.5
                          ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}