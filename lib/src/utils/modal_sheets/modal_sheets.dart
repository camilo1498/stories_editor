import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/constants/item_type.dart';
import 'package:stories_editor/src/models/editable_items.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';
import 'package:stories_editor/src/services/save_as_image.dart';
import 'package:stories_editor/src/utils/animated_onTap_button.dart';
import 'package:stories_editor/src/utils/color/hexColor.dart';
import 'package:stories_editor/src/views/TextEditor.dart';
import 'package:stories_editor/src/views/painting.dart';


/// create item of type TEXT
void createText({
  required BuildContext context,
  ControlVariableProvider? controlProvider
}) {
  controlProvider!.isTextEditing = true;
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 200,
    ), // how long it takes to popup dialog after button click
    pageBuilder: (_, __, ___) {
      /// open text editor
      return const TextEditor();
    },
  );
}


/// create item of type GIF
Future createGiphyItem({
  required BuildContext context,
  required giphyKey
}) async{
  final _editableItem = Provider.of<DraggableWidgetProvider>(context, listen: false);
  _editableItem.giphy = await GiphyPicker.pickModalSheetGif(
    context: context,
    apiKey: giphyKey,
    rating: GiphyRating.r,
    sticker: true,
    backDropColor: Colors.black,
    crossAxisCount: 3,
    childAspectRatio: 1.2,
    topDragColor: Colors.white.withOpacity(0.2),
  );
  /// create item of type GIF
  if(_editableItem.giphy != null) {
    _editableItem.draggableWidget.add(
        EditableItem()
          ..type = ItemType.GIF
          ..gif = _editableItem.giphy!
          ..position = const Offset(0.0, 0.0)
    );
  }
}


/// create Line Painting
Future createLinePainting({
  required BuildContext context
}) async {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 200,
    ), // how long it takes to popup dialog after button click
    pageBuilder: (_, __, ___) {
      /// open text painting screen
      return const Painting();
    },
  );
}

/// custom exit dialog
Future<bool> exitDialog({
  required context,
  required contentKey
}) async{
  return ( await showDialog(
    context: context,
    barrierColor: Colors.black38,
    barrierDismissible: true,
    builder:(context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetAnimationDuration: const Duration(milliseconds: 300),
      insetAnimationCurve: Curves.ease,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.only(top: 25, bottom: 5, right: 20, left: 20),
          alignment: Alignment.center,
          height: 280,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: HexColor.fromHex('#262626'),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.white10,offset: Offset(0,1),
                    blurRadius: 4
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Discard Edits?',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5
                ),
              ),
              const SizedBox(height: 20,),
              const Text("If you go back now, you'll lose all the edits you've made.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white54,
                    letterSpacing: 0.1
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40,),
              AnimatedOnTapButton(
                onTap: () async{
                  _resetDefaults(context: context);
                  Navigator.of(context).pop(true);
                },
                child: Text('Discard',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent.shade200,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22,child: Divider(color: Colors.white10,),),
              AnimatedOnTapButton(
                onTap: () async{
                  final _paintingProvider = Provider.of<PaintingProvider>(context, listen: false);
                  final _widgetProvider = Provider.of<DraggableWidgetProvider>(context, listen: false);
                  if(_paintingProvider.lines.isNotEmpty || _widgetProvider.draggableWidget.isNotEmpty){
                    /// save image
                    var response = await takePicture(
                        contentKey: contentKey,
                        context: context,
                        saveToGallery: true
                    );
                    if(response){
                      _dispose(context: context, message: 'Successfully saved');
                    } else{
                      _dispose(context: context, message: 'Error');
                    }
                  } else{
                    _dispose(context: context, message: 'Draft Empty');
                  }
                },
                child: const Text('Save Draft',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22,child: Divider(color: Colors.white10,),),
              AnimatedOnTapButton(
                onTap: (){
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  )) ?? false;
}

_resetDefaults({required context}){
  final _paintingProvider = Provider.of<PaintingProvider>(context, listen: false);
  final _widgetProvider = Provider.of<DraggableWidgetProvider>(context, listen: false);
  final _controlProvider = Provider.of<ControlVariableProvider>(context, listen: false);
  final _editingProvider = Provider.of<TextEditorProvider>(context, listen: false);
  final _imageProvider = Provider.of<PickerDataProvider>(context, listen:  false);
  _paintingProvider.lines.clear();
  _widgetProvider.draggableWidget.clear();
  _widgetProvider.setDefaults();
  _paintingProvider.resetDefaults();
  _controlProvider.setDefaults();
  _editingProvider.setDefaults();
  _imageProvider.imagePath.clear();
  _imageProvider.isEmpty = true;
}

_dispose({required context, required message}){
  _resetDefaults(context: context);
  Fluttertoast.showToast(msg: message);
  Navigator.of(context).pop(true);
}