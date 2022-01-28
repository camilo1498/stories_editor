import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/constants/item_type.dart';
import 'package:stories_editor/src/models/editable_items.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';
import 'package:stories_editor/src/widgets/selector/color_selector.dart';
import 'package:stories_editor/src/widgets/selector/size_slider_selector.dart';
import 'package:stories_editor/src/widgets/text_editor/font_selector.dart';
import 'package:stories_editor/src/widgets/text_editor/text_field_widget.dart';
import 'package:stories_editor/src/widgets/tools/top_text_tools.dart';


class TextEditor extends StatefulWidget {
  const TextEditor({Key? key}) : super(key: key);

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  void initState() {
   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     final _editorProvider = Provider.of<TextEditorProvider>(context, listen: false);
     _editorProvider
       ..textController.text = _editorProvider.text
       ..fontFamilyController = PageController(viewportFraction: .125);
   });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Consumer2<ControlVariableProvider,TextEditorProvider>(
        builder: (context, controlProvider, editorProvider, child){
          return WillPopScope(
            onWillPop: () async{
              controlProvider.isTextEditing = false;
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                editorProvider.disposeController();
              });
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                /// onTap => Close view and create/modify item object
                onTap: () => _onTap(context,
                    controlProvider,
                    editorProvider),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5)
                    ),
                    height: _size.height,
                    width: _size.width,
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
                                onDone: () => _onTap(context,
                                    controlProvider,
                                    editorProvider),
                              )
                          ),
                        ),

                        /// font family selector (bottom)
                        Visibility(
                          visible: editorProvider.isFontFamily,
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: FontSelector(),
                            ),
                          ),
                        ),

                        /// font color selector (bottom)
                        Visibility(
                            visible: !editorProvider.isFontFamily,
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: ColorSelector(),
                              ),
                            )
                        ),

                        /// top black container
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).padding.top + 10,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)
                                )
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ),
            ),
          );
        },
      )
    );
  }

  void _onTap(context, ControlVariableProvider controlProvider, TextEditorProvider editorProvider){
    final _editableItem = Provider.of<DraggableWidgetProvider>(context, listen: false);
    /// create Text Item
    if(editorProvider.text.trim().isNotEmpty){
      _editableItem.draggableWidget.add(
          EditableItem()
            ..type = ItemType.TEXT
            ..text = editorProvider.text.trim()
            ..backGroundColor = editorProvider.backGroundColor
            ..textColor = controlProvider.colorList![editorProvider.textColor]
            ..fontFamily = editorProvider.fontFamilyIndex
            ..fontSize = editorProvider.textSize
            ..textAlign = editorProvider.textAlign
            ..position = const Offset(0.0, 0.0)
      );
      editorProvider.setDefaults();
      controlProvider.isTextEditing = false;
      Navigator.pop(context);
    } else{
      editorProvider.setDefaults();
      controlProvider.isTextEditing = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
