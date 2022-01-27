import 'package:flutter/cupertino.dart';

class GradientProvider extends ChangeNotifier{
  Color _color1 = const Color(0xFFFFFFFF);
  Color _color2 = const Color(0xFFFFFFFF);

  Color get color1 => _color1;
  Color get color2 => _color2;

  set color1(Color color){
    _color1 = color;
    notifyListeners();
  }
  set color2(Color color){
    _color2 = color;
    notifyListeners();
  }
}