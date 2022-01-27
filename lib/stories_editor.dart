library stories_editor;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/custom_scrollController_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stories_editor/src/views/main_view.dart';
export 'package:stories_editor/src/providers/providers.dart';

class StoriesEditor extends StatefulWidget {
  /// giphy api key
  final giphyKey;
  /// editor custom font families
  List<String>? fontList;
  /// editor custom font families package
  String? fontPackage;
  /// editor custom color gradients
  List<List<Color>>? gradientColors;
  /// editos custom logo
  Widget? middleBottomWidget;
  /// on done
  Function(String)? onDone;
  /// editor custom color palette list
  List<Color>? colorList;

  StoriesEditor({
    Key? key,
    required this.giphyKey,
    this.middleBottomWidget,
    this.colorList,
    this.fontPackage,
    this.fontList,
    this.gradientColors,
    required this.onDone
  }) : super(key: key);

  @override
  _StoriesEditorState createState() => _StoriesEditorState();
}

class _StoriesEditorState extends State<StoriesEditor> {
  /// instance of pickerDataProvider
  PickerDataProvider imageProvider = PickerDataProvider();

  @override
  void initState() {
    Paint.enableDithering = true;
    WidgetsFlutterBinding.ensureInitialized();
    Provider.debugCheckInvalidValueType = null;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    // TODO: implement initState
    super.initState();
    _getPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    PhotoManager.clearFileCache();
  }

  _getPermission() async{
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      if(imageProvider.pathList.isEmpty){
        PhotoManager.getAssetPathList(
          /// load image only
            type: RequestType.image
        ).then((pathList){
          /// don't delete setState
          setState(() {
            imageProvider.resetPathList(pathList);
          });
        });
      }
    } else {
      /// if result is fail, you can call `PhotoManager.openSetting();`
      /// to open android/ios application's setting to get permission
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      onDone: widget.onDone,
      giphyKey: widget.giphyKey,
      provider: imageProvider,
      middleBottomWidget: widget.middleBottomWidget,
      gradientColors: widget.gradientColors,
      colorList: widget.colorList,
      fontList: widget.fontList,
      fontPackage: widget.fontPackage,
    );
  }
}
