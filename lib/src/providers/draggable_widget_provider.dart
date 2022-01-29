import 'package:flutter/cupertino.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:stories_editor/src/models/editable_items.dart';

class DraggableWidgetProvider extends ChangeNotifier{
  List<EditableItem> _draggableWidget = [];
  GiphyGif? _gif;

  List<EditableItem> get draggableWidget => _draggableWidget;
  GiphyGif? get giphy => _gif;


  set draggableWidget(List<EditableItem> item){
    _draggableWidget = item;
    notifyListeners();
  }

  set giphy(GiphyGif? giphy){
    _gif = giphy;
    notifyListeners();
  }
  setDefaults(){
    _draggableWidget = [];
  }
}