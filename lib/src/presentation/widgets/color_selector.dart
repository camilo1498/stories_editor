import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();
    return Consumer3<ControlNotifier, TextEditingNotifier, PaintingNotifier>(
      builder:
          (context, controlProvider, editorProvider, paintingProvider, child) {
        return Container(
          height: screenUtil.screenWidth * 0.1,
          width: screenUtil.screenWidth,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            children: [
              /// current selected color
              Container(
                height: screenUtil.screenWidth * 0.1,
                width: screenUtil.screenWidth * 0.1,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: controlProvider.isPainting
                        ? controlProvider.colorList![paintingProvider.lineColor]
                        : controlProvider.colorList![editorProvider.textColor],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)),
                child: ImageIcon(
                  const AssetImage('assets/icons/pickColor.png',
                      package: 'stories_editor'),
                  color: controlProvider.isPainting
                      ? (paintingProvider.lineColor == 0
                          ? Colors.black
                          : Colors.white)
                      : (editorProvider.textColor == 0
                          ? Colors.black
                          : Colors.white),
                  size: 20,
                ),
              ),

              /// color list
              Expanded(
                child: ListView.builder(
                  itemCount: controlProvider.colorList!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AnimatedOnTapButton(
                      onTap: () {
                        if (controlProvider.isPainting) {
                          paintingProvider.lineColor = index;
                        } else {
                          editorProvider.textColor = index;
                        }
                      },
                      child: Container(
                        height: screenUtil.screenWidth * 0.08,
                        width: screenUtil.screenHeight * 0.08,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: controlProvider.colorList![index],
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
