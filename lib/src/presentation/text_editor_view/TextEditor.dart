import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/text_editor_view/widgets/animation_selector.dart';
import 'package:stories_editor/src/presentation/text_editor_view/widgets/font_selector.dart';
import 'package:stories_editor/src/presentation/text_editor_view/widgets/text_field_widget.dart';
import 'package:stories_editor/src/presentation/text_editor_view/widgets/top_text_tools.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/color_selector.dart';
import 'package:stories_editor/src/presentation/widgets/size_slider_selector.dart';

class TextEditor extends StatefulWidget {
  final BuildContext context;
  final bool isRtl;
  const TextEditor({Key? key, required this.context, required this.isRtl}) : super(key: key);

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  List<String> splitList = [];
  String sequenceList = '';
  String lastSequenceList = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final _editorNotifier =
          Provider.of<TextEditingNotifier>(widget.context, listen: false);
      _editorNotifier
        ..textController.text = _editorNotifier.text
        ..fontFamilyController = PageController(viewportFraction: .125);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();
    return Material(
        color: Colors.transparent,
        child: Consumer2<ControlNotifier, TextEditingNotifier>(
          builder: (_, controlNotifier, editorNotifier, __) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                /// onTap => Close view and create/modify item object
                onTap: () => _onTap(context, controlNotifier, editorNotifier),
                child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    height: screenUtil.screenHeight,
                    width: screenUtil.screenWidth,
                    child: Stack(
                      children: [
                        /// text field
                        const Align(
                          alignment: Alignment.center,
                          child: TextFieldWidget(),
                        ),

                        /// text size
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: SizeSliderWidget(),
                        ),

                        /// top tools
                        SafeArea(
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: TopTextTools(
                                isRtl: widget.isRtl,
                                onDone: () => _onTap(
                                    context, controlNotifier, editorNotifier),
                              )),
                        ),

                        /// font family selector (bottom)
                        Positioned(
                          bottom: screenUtil.screenHeight * 0.21,
                          child: Visibility(
                            visible: editorNotifier.isFontFamily &&
                                !editorNotifier.isTextAnimation,
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: FontSelector(),
                              ),
                            ),
                          ),
                        ),

                        /// font color selector (bottom)
                        Positioned(
                          bottom: screenUtil.screenHeight * 0.21,
                          child: Visibility(
                              visible: !editorNotifier.isFontFamily &&
                                  !editorNotifier.isTextAnimation,
                              child: const Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: ColorSelector(),
                                ),
                              )),
                        ),

                        /// font animation selector (bottom
                        Positioned(
                          bottom: screenUtil.screenHeight * 0.21,
                          child: Visibility(
                              visible: editorNotifier.isTextAnimation,
                              child: const Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: AnimationSelector(),
                                ),
                              )),
                        ),
                      ],
                    )),
              ),
            );
          },
        ));
  }

  void _onTap(context, ControlNotifier controlNotifier,
      TextEditingNotifier editorNotifier) {
    final _editableItemNotifier =
        Provider.of<DraggableWidgetNotifier>(context, listen: false);

    /// create text list
    if (editorNotifier.text.trim().isNotEmpty) {
      splitList = editorNotifier.text.split(' ');
      for (int i = 0; i < splitList.length; i++) {
        if (i == 0) {
          editorNotifier.textList.add(splitList[0]);
          sequenceList = splitList[0];
        } else {
          lastSequenceList = sequenceList;
          editorNotifier.textList.add(sequenceList + ' ' + splitList[i]);
          sequenceList = lastSequenceList + ' ' + splitList[i];
        }
      }

      /// create Text Item
      _editableItemNotifier.draggableWidget.add(EditableItem()
        ..type = ItemType.text
        ..text = editorNotifier.text.trim()
        ..backGroundColor = editorNotifier.backGroundColor
        ..textColor = controlNotifier.colorList![editorNotifier.textColor]
        ..fontFamily = editorNotifier.fontFamilyIndex
        ..fontSize = editorNotifier.textSize
        ..fontAnimationIndex = editorNotifier.fontAnimationIndex
        ..textAlign = editorNotifier.textAlign
        ..textList = editorNotifier.textList
        ..animationType =
            editorNotifier.animationList[editorNotifier.fontAnimationIndex]
        ..position = const Offset(0.0, 0.0));
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    } else {
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    }
  }
}
