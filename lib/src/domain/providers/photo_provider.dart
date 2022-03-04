import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PickerDataProvider extends ChangeNotifier {
  AssetPathEntity? _current;

  AssetPathEntity? get currentPath => _current;

  set currentPath(AssetPathEntity? current) {
    if (_current != current) {
      _current = current;
      currentPathNotifier.value = current;
    }
  }

  final currentPathNotifier = ValueNotifier<AssetPathEntity?>(null);

  final pathListNotifier = ValueNotifier<List<AssetPathEntity>>([]);
  List<AssetPathEntity> pathList = [];

  /// order path
  static int _defaultSort(
    AssetPathEntity a,
    AssetPathEntity b,
  ) {
    if (a.isAll) {
      return -1;
    }
    if (b.isAll) {
      return 1;
    }
    return 0;
  }

  /// add images path list
  void resetPathList(
    List<AssetPathEntity> list, {
    int defaultIndex = 0,
    int Function(
      AssetPathEntity a,
      AssetPathEntity b,
    )
        sortBy = _defaultSort,
  }) {
    list.sort(sortBy);
    pathList.clear();
    pathList.addAll(list);
    currentPath = list[defaultIndex];
    pathListNotifier.value = pathList;
    notifyListeners();
  }

  /// save selected image path
  late List<File?> _imagePath = [];
  bool _isEmpty = true;
  List<File?> get imagePath => _imagePath;
  bool get isEmpty => _isEmpty;
  set isEmpty(bool empty) {
    _isEmpty = empty;
    notifyListeners();
  }

  set imagePath(List<File?> path) {
    _imagePath.clear();
    _imagePath = path;
    notifyListeners();
  }
}
