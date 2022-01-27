import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

import '../constants/item_type.dart';

class EditableItem {
  /// delete
  bool deletePosition = false;

  /// item position
  Offset position = const Offset(0.0, 0.0);
  double scale = 1;
  double rotation = 0;
  ItemType type = ItemType.TEXT;

  /// text
  String text = ''; //
  Color textColor = Colors.transparent;//
  TextAlign textAlign = TextAlign.center;//
  double fontSize = 20;//
  int fontFamily = 0;//
  Color backGroundColor = Colors.transparent;//

  /// Gif
  GiphyGif gif = GiphyGif(id: '0');

}
