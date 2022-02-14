import 'package:flutter/material.dart';

class TextEditingNotifier extends ChangeNotifier {
  String _text = '';
  int _textColor = 0;
  double _textSize = 25.0;
  int _fontFamilyIndex = 0;
  TextAlign _textAlign = TextAlign.center;
  Color _backGroundColor = Colors.transparent;

  bool _isFontFamily = true;

  PageController _fontFamilyController = PageController(viewportFraction: .125);
  TextEditingController _textController = TextEditingController();

  int _currentColorBackground = 0;
  final List<Color> _textColorBackGround = [
    Colors.transparent,
    Colors.black,
    Colors.white
  ];

  int _currentAlign = 0;
  final List<TextAlign> _texAlignment = [
    TextAlign.center,
    TextAlign.right,
    TextAlign.left
  ];

  String get text => _text;
  int get textColor => _textColor;
  double get textSize => _textSize;
  int get fontFamilyIndex => _fontFamilyIndex;
  TextAlign get textAlign => _textAlign;
  Color get backGroundColor => _backGroundColor;
  bool get isFontFamily => _isFontFamily;
  PageController get fontFamilyController => _fontFamilyController;
  TextEditingController get textController => _textController;

  set text(String text) {
    _text = text;
    notifyListeners();
  }

  set textColor(int color) {
    if (_backGroundColor == Colors.white && color == 0) {
      _textColor = 1;
      notifyListeners();
    } else if (_backGroundColor == Colors.black && color == 1) {
      _textColor = 0;
      notifyListeners();
    } else {
      _textColor = color;
      notifyListeners();
    }
  }

  set textSize(double size) {
    _textSize = size;
    notifyListeners();
  }

  set fontFamilyIndex(int fontIndex) {
    _fontFamilyIndex = fontIndex;
    notifyListeners();
  }

  set isFontFamily(bool isFamily) {
    _isFontFamily = isFamily;
    notifyListeners();
  }

  set fontFamilyController(PageController controller) {
    _fontFamilyController = controller;
    notifyListeners();
  }

  set textController(TextEditingController textController) {
    _textController = textController;
    notifyListeners();
  }

  set backGroundColor(Color backGround) {
    _backGroundColor = backGround;
    notifyListeners();
  }

  set textAlign(TextAlign align) {
    _textAlign = align;
    notifyListeners();
  }

  onBackGroundChange() {
    if (_currentColorBackground < _textColorBackGround.length - 1) {
      _currentColorBackground += 1;
      _backGroundColor = _textColorBackGround[_currentColorBackground];
      notifyListeners();
    } else {
      _currentColorBackground = 0;
      _backGroundColor = _textColorBackGround[_currentColorBackground];
      notifyListeners();
    }
  }

  onAlignmentChange() {
    if (_currentAlign < _texAlignment.length - 1) {
      _currentAlign += 1;
      _textAlign = _texAlignment[_currentAlign];
      notifyListeners();
    } else {
      _currentAlign = 0;
      _textAlign = _texAlignment[_currentAlign];
      notifyListeners();
    }
  }

  setDefaults() {
    _text = '';
    _textController.text = '';
    _textColor = 0;
    _textSize = 20.0;
    _fontFamilyIndex = 0;
    _textAlign = TextAlign.center;
    _backGroundColor = Colors.transparent;
    _fontFamilyController = PageController(viewportFraction: .125);
    _isFontFamily = true;
  }

  disposeController() {
    _textController.dispose();
    _fontFamilyController.dispose();
  }
}
