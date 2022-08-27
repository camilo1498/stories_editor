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

  String? _sticker;
  String? get sticker => _sticker;

  set sticker(String? sticker) {
    _sticker = sticker;
    notifyListeners();
  }

  setDefaults() {
    _draggableWidget = [];
  }
}
