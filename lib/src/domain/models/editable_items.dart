import 'package:flutter/material.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:stories_editor/src/presentation/utils/constants/item_type.dart';
import 'package:stories_editor/src/presentation/utils/constants/text_animation_type.dart';

class EditableItem {
  /// delete
  bool deletePosition = false;

  /// item position
  Offset position = const Offset(0.0, 0.0);
  double scale = 1;
  double rotation = 0;
  ItemType type = ItemType.text;

  /// text
  String text = '';
  List<String> textList = [];
  Color textColor = Colors.transparent;
  TextAlign textAlign = TextAlign.center;
  double fontSize = 20;
  int fontFamily = 0;
  int fontAnimationIndex = 0;
  Color backGroundColor = Colors.transparent;
  TextAnimationType animationType = TextAnimationType.none;

  /// Gif
  String sticker = '';
}
