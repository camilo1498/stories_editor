import 'package:flutter/material.dart';
import 'package:stories_editor/src/presentation/utils/constants/colors.dart';
import 'package:stories_editor/src/presentation/utils/constants/font_family.dart';
import 'package:stories_editor/src/presentation/utils/constants/gradients.dart';

class ControlNotifier extends ChangeNotifier{

  String _giphyKey = ''; /// is required add your giphy API KEY
  String get giphyKey => _giphyKey;
  set giphyKey(String key){
    _giphyKey = key;
    notifyListeners();
  }

  int _gradientIndex = 0; /// current gradient index
  int get gradientIndex => _gradientIndex; /// get current gradient index
  set gradientIndex(int index){ /// set new current gradient index
    _gradientIndex = index;
    notifyListeners();
  }

  bool _isTextEditing = false; /// is text editor open
  bool get isTextEditing => _isTextEditing; /// get bool if is text editing
  set isTextEditing(bool val){ /// set bool if is text editing
    _isTextEditing = val;
    notifyListeners();
  }

  bool _isPainting = false; /// is painter sketcher open
  bool get isPainting => _isPainting;
  set isPainting(bool painting){
    _isPainting = painting;
    notifyListeners();
  }

  List<String>? _fontList = fontFamilyList; /// here you can define your own font family list
  List<String>? get fontList => _fontList;
  set fontList(List<String>? fonts){
    _fontList = fonts;
    notifyListeners();
  }

  bool _isCustomFontList = false; /// if you add your custom list is required to specify your app package
  bool get isCustomFontList => _isCustomFontList;
  set isCustomFontList(bool key){
    _isCustomFontList = key;
    notifyListeners();
  }

  List<List<Color>>? _gradientColors = gradientBackgroundColors; /// here you can define your own background gradients
  List<List<Color>>? get gradientColors => _gradientColors;
  set gradientColors(List<List<Color>>? color) {
    _gradientColors = color;
    notifyListeners();
  }

  Widget? _middleBottomWidget; /// you can add a custom widget on the bottom
  Widget? get middleBottomWidget => _middleBottomWidget;
  set middleBottomWidget(Widget? widget) {
    _middleBottomWidget = widget;
    notifyListeners();
  }

  Future<bool>? _exitDialogWidget; /// you can create you own exit window
  Future<bool>? get exitDialogWidget => _exitDialogWidget;
  set exitDialogWidget(Future<bool>? widget) {
    _exitDialogWidget = widget;
    notifyListeners();
  }

  List<Color>? _colorList = defaultColors; /// you can add your own color palette list
  List<Color>? get colorList => _colorList;
  set colorList(List<Color>? value) {
    _colorList = value;
    notifyListeners();
  }

  /// get image path
  String _mediaPath = '';
  String get mediaPath => _mediaPath;
  set mediaPath(String media){
    _mediaPath = media;
    notifyListeners();
  }

}
