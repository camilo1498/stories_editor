import 'package:flutter/material.dart';
import 'package:stories_editor/src/constants/colors.dart';
import 'package:stories_editor/src/constants/font_family.dart';
import 'package:stories_editor/src/constants/gradients.dart';

class ControlVariableProvider extends ChangeNotifier{
  /// app control
  bool _isTextEditing = false;
  int _gradientIndex = 0;
  bool _isPainting = false;
  /// package required params
  String _giphyKey = ''; /// is required add your giphy API KEY

  /// package not required params
  List<String>? _fontList = fontFamilyList; /// here you can define your own font family list
  String? _fontPackage = null; /// if you add your custom list is required to specify your app package
  List<List<Color>>? _gradientColors = gradientBackgroundColors; /// here you can define your own background gradients
  Widget? _middleBottomWidget; /// you can add a custom widget on the bottom
  Future<bool>? _exitDialogWidget; /// you can create you own exit window
  List<Color>? _colorList = defaultColors; /// you can add your own color palette list


  bool get isTextEditing => _isTextEditing;
  int get gradientIndex => _gradientIndex;
  bool get isPainting => _isPainting;
  String get giphyKey => _giphyKey;
  List<List<Color>>? get gradientColors => _gradientColors;
  Widget? get middleBottomWidget => _middleBottomWidget;
  Future<bool>? get exitDialogWidget => _exitDialogWidget;
  List<Color>? get colorList => _colorList;
  List<String>? get fontList => _fontList;
  String? get fontPackage => _fontPackage;

  set isTextEditing(bool isEditing){
    _isTextEditing = isEditing;
    notifyListeners();
  }

  set gradientIndex(int index){
    _gradientIndex = index;
    notifyListeners();
  }

  set isPainting(bool painting){
    _isPainting = painting;
    notifyListeners();
  }

  set giphyKey(String key){
    _giphyKey = key;
    notifyListeners();
  }

  set fontList(List<String>? fonts){
    _fontList = fonts;
    notifyListeners();
  }

  set fontPackage(String? package) {
    _fontPackage = package;
    notifyListeners();
  }

  set gradientColors(List<List<Color>>? color) {
    _gradientColors = color;
    notifyListeners();
  }

  set middleBottomWidget(Widget? widget) {
    _middleBottomWidget = widget;
    notifyListeners();
  }

  set exitDialogWidget(Future<bool>? widget) {
    _exitDialogWidget = widget;
    notifyListeners();
  }

  set colorList(List<Color>? value) {
    _colorList = value;
    notifyListeners();
  }

  setDefaults(){
    _isTextEditing = false;
    _gradientIndex = 0;
    _isPainting = false;
    _giphyKey = '';
    _fontList = fontFamilyList;
    _fontPackage = null;
    _gradientColors = gradientBackgroundColors;
    _middleBottomWidget;
    _exitDialogWidget;
    _colorList = defaultColors;
  }

}