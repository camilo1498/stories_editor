import 'package:flutter/material.dart';
import 'package:stories_editor/src/presentation/utils/constants/render_state.dart';
import 'package:stories_editor/src/presentation/utils/constants/render_type.dart';

class RenderingNotifier extends ChangeNotifier {
  RenderState _renderState = RenderState.none;
  RenderState get renderState => _renderState;
  set renderState(RenderState state) {
    _renderState = state;
    notifyListeners();
  }

  RenderType _renderType = RenderType.video;
  RenderType get renderType => _renderType;
  set renderType(RenderType type) {
    _renderType = type;
    notifyListeners();
  }

  int _recordingDuration = 10;
  int get recordingDuration => _recordingDuration;
  set recordingDuration(int time) {
    _recordingDuration = time;
    notifyListeners();
  }

  int _totalFrames = 0;
  int get totalFrames => _totalFrames;
  set totalFrames(int time) {
    _totalFrames = time;
    notifyListeners();
  }

  int _currentFrames = 0;
  int get currentFrames => _currentFrames;
  set currentFrames(int time) {
    _currentFrames = time;
    notifyListeners();
  }
}
