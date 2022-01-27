import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';
import 'package:stories_editor/src/utils/animated_onTap_button.dart';

class FontSelector extends StatelessWidget {
  const FontSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Consumer2<TextEditorProvider, ControlVariableProvider>(
      builder: (context, editorProvider, controlProvider, child){
        return Container(
          height: _size.width * 0.1,
          width: _size.width,
          alignment: Alignment.center,
          child: PageView.builder(
            controller: editorProvider.fontFamilyController,
            itemCount: controlProvider.fontList!.length,
            onPageChanged: (index){
              editorProvider.fontFamilyIndex = index;
              HapticFeedback.heavyImpact();
            },
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index){
              return AnimatedOnTapButton(
                onTap: (){
                  editorProvider.fontFamilyIndex = index;
                  editorProvider.fontFamilyController.jumpToPage(index);

                },
                child: Container(
                  height: _size.width * 0.1,
                  width:  _size.width * 0.1,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: index ==  editorProvider.fontFamilyIndex ? Colors.white : Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)
                  ),
                  child: Center(
                    child: Text(
                      'Aa',
                      style: TextStyle(
                          fontFamily: controlProvider.fontList![index],
                          package: controlProvider.fontPackage ?? 'stories_editor'
                      )
                          .copyWith(
                          color: index ==  editorProvider.fontFamilyIndex ? Colors.red : Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
