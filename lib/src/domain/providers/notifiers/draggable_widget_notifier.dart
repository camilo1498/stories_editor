import 'package:flutter/material.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';

class DraggableWidgetNotifier extends ChangeNotifier {
  List<EditableItem> _draggableWidget = [];
  List<EditableItem> get draggableWidget => _draggableWidget;
  set draggableWidget(List<EditableItem> item) {
    _draggableWidget = item;
    notifyListeners();
  }

  GiphyGif? _gif;
  GiphyGif? get giphy => _gif;
  set giphy(GiphyGif? giphy) {
    _gif = giphy;
    notifyListeners();
  }

  setDefaults() {
    _draggableWidget = [];
  }
}
