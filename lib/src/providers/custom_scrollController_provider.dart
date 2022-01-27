import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollControllerProvider extends ChangeNotifier{
  ScrollController _gridController = ScrollController();
  PageController _pageController = PageController();
  ScrollController _activeScrollController = ScrollController();
  Drag? _drag;

  set gridController(ScrollController value){
    _gridController = value;
    notifyListeners();
  }

  set activeScrollController(ScrollController value){
    _activeScrollController = value;
    notifyListeners();
  }

  set pageController (PageController value){
    _pageController = value;
    notifyListeners();
  }

  set drag (Drag? value){
    _drag = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;
  ScrollController get gridController => _gridController;
  ScrollController get activeScrollController => _activeScrollController;
  Drag? get drag => _drag;

  void disposeController(){
    _pageController.dispose();
    _gridController.dispose();
    _activeScrollController.dispose();
  }
}