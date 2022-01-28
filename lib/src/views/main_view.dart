import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/constants/item_type.dart';
import 'package:stories_editor/src/models/editable_items.dart';
import 'package:stories_editor/src/models/painting_model.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/custom_scrollController_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/gradientProvider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:stories_editor/src/utils/gestures/scrollable_pageView.dart';
import 'package:stories_editor/src/utils/modal_sheets/modal_sheets.dart';
import 'package:stories_editor/src/views/gallery_picker.dart';
import 'package:stories_editor/src/widgets/draggable_items/delete_item.dart';
import 'package:stories_editor/src/widgets/draggable_items/draggable_widget.dart';
import 'package:stories_editor/src/widgets/painting/sketcher.dart';
import 'package:stories_editor/src/widgets/tools/bottom_tools.dart';
import 'package:stories_editor/src/widgets/tools/top_tools.dart';


class MainView extends StatefulWidget {
  final PickerDataProvider? provider;
  final giphyKey;
  List<String>? fontList;
  String? fontPackage;
  List<List<Color>>? gradientColors;
  Widget? middleBottomWidget;
  Function(String)? onDone;
  List<Color>? colorList;

  MainView({
    Key? key,
    required this.provider,
    required this.giphyKey,
    this.middleBottomWidget,
    this.colorList,
    this.fontPackage,
    this.fontList,
    this.gradientColors,
    required this.onDone
  }) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  /// content container key
  final GlobalKey contentKey = GlobalKey();
  ///Editable item
  EditableItem? _activeItem;

  /// Gesture Detector listen changes
  Offset _initPos = const Offset(0, 0);
  Offset _currentPos = const Offset(0, 0);
  double _currentScale = 1;
  double _currentRotation = 0;

  /// delete position
  bool _isDeletePosition = false;
  bool _inAction = false;


  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var _control = Provider.of<ControlVariableProvider>(context, listen: false);

      /// initialize control variable provider
      _control.giphyKey = widget.giphyKey;
      _control.middleBottomWidget = widget.middleBottomWidget;
      _control.fontPackage = widget.fontPackage;
      if(widget.gradientColors != null){_control.gradientColors = widget.gradientColors;}
      if(widget.fontList != null){_control.fontList = widget.fontList;}
      if(widget.colorList != null){_control.colorList = widget.colorList;}
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// screen size
    var _size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Consumer6<ControlVariableProvider, PickerDataProvider, DraggableWidgetProvider, CustomScrollControllerProvider, GradientProvider, PaintingProvider>(
        builder: (context, controlProvider, imageProvider, itemProvider, scrollProvider, colorProvider, paintingProvider, child){
          return WillPopScope(
            onWillPop: () => exitDialog(context: context, contentKey: contentKey),
            child: SafeArea(
              child: ScrollablePageView(
                  scrollPhysics: imageProvider.isEmpty && itemProvider.draggableWidget.isEmpty
                      && widget.provider!.pathList.isNotEmpty && !controlProvider.isPainting,
                  child: PageView(
                    controller: scrollProvider.pageController,
                    scrollDirection: Axis.vertical,
                    allowImplicitScrolling: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ///gradient container
                          /// this container will contain all widgets(image/texts/draws/sticker)
                          GestureDetector(
                            onScaleStart: _onScaleStart,
                            onScaleUpdate: _onScaleUpdate,
                            onTap: () => createText(
                                context: context,
                                controlProvider: controlProvider
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: RepaintBoundary(
                                key: contentKey,
                                child: AnimatedContainer(
                                  width: _size.width,
                                  height: _size.height - 132,
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: imageProvider.isEmpty ? LinearGradient(
                                        colors: controlProvider.gradientColors![controlProvider.gradientIndex],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ): LinearGradient(
                                        colors: [
                                          colorProvider.color1,
                                          colorProvider.color2
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                  ),
                                  child: GestureDetector(
                                    onScaleStart: _onScaleStart,
                                    onScaleUpdate: _onScaleUpdate,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        /// in this case photo view works as a main background container to manage
                                        /// the gestures of all movable items.
                                        PhotoView.customChild(child: Container(),
                                          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                                        ),

                                        ///list items
                                        ...itemProvider.draggableWidget.map((editableItem) => DraggableWidget(
                                          draggableWidget: editableItem,
                                          onPointerDown: (details) {
                                            _updateItemPosition(
                                              editableItem,
                                              details,
                                            );
                                          },
                                          onPointerUp: (details) {
                                            _deleteItemOnCoordinates(
                                              editableItem,
                                              details,
                                            );
                                          },
                                          onPointerMove: (details) {
                                            _deletePosition(
                                              editableItem,
                                              details,
                                            );
                                          },
                                        )),

                                        /// finger paint
                                        IgnorePointer(
                                          ignoring: true,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: RepaintBoundary(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height -132,
                                                  child: StreamBuilder<List<PaintingModel>>(
                                                    stream: paintingProvider.linesStreamController.stream,
                                                    builder: (context, snapshot) {
                                                      return CustomPaint(
                                                        painter: Sketcher(
                                                          lines:  paintingProvider.lines,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                          /// middle text
                          if(itemProvider.draggableWidget.isEmpty && !controlProvider.isTextEditing && paintingProvider.lines.isEmpty)
                            IgnorePointer(
                              ignoring: true,
                              child: Align(
                                alignment: const Alignment(0,-0.1),
                                child: Text(
                                    'Tap to type',
                                    style: TextStyle(
                                        fontFamily: controlProvider.fontList![0],
                                        package: controlProvider.fontPackage ?? 'stories_editor',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30,
                                        color: Colors.white.withOpacity(0.5),
                                        shadows: <Shadow>[
                                          Shadow(
                                              offset: const Offset(1.0, 1.0),
                                              blurRadius: 3.0,
                                              color: Colors.black45.withOpacity(0.3)
                                          )
                                        ]
                                    )
                                ),
                              ),
                            ),


                          /// top tools
                          Visibility(
                            visible: !controlProvider.isTextEditing && !controlProvider.isPainting,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: TopTools(contentKey: contentKey)
                            ),
                          ),

                          /// delete item when the item is in position
                          DeleteItem(
                            activeItem: _activeItem,
                            animationsDuration: const Duration(milliseconds: 300),
                            isDeletePosition: _isDeletePosition,
                          ),
                          /// bottom tools
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: BottomTools(
                                contentKey: contentKey,
                                provider: widget.provider,
                                onDone: (bytes){
                                  setState(() {
                                    widget.onDone!(bytes);
                                  });
                                },

                              )
                          ),
                        ],
                      ),
                      /// gallery widget
                      GalleryPicker(provider: widget.provider),
                    ],
                  )
              ),
            ),
          );
        },
      ),
    );

  }

  /// start item scale
  void _onScaleStart(ScaleStartDetails details) {
    if (_activeItem == null) {
      return;
    }
    _initPos = details.focalPoint;
    _currentPos = _activeItem!.position;
    _currentScale = _activeItem!.scale;
    _currentRotation = _activeItem!.rotation;
  }
  /// update item scale
  void _onScaleUpdate(ScaleUpdateDetails details) {

    var _size = MediaQuery.of(context).size;
    if (_activeItem == null) {
      return;
    }
    final delta = details.focalPoint - _initPos;

    final left = (delta.dx / _size.width) + _currentPos.dx;
    final top = (delta.dy / _size.height) + _currentPos.dy;
    setState(() {
      _activeItem!.position = Offset(left, top);
      _activeItem!.rotation = details.rotation + _currentRotation;
      _activeItem!.scale = details.scale * _currentScale;
    });
  }

  /// active delete widget with offset position
  void _deletePosition(EditableItem item, PointerMoveEvent details) {
    if (item.type == ItemType.TEXT && item.position.dy >= 0.265 && item.position.dx >= -0.122 && item.position.dx <= 0.122) {
      setState(() {
        _isDeletePosition = true;
        item.deletePosition = true;
      });
    } else if(item.type == ItemType.GIF && item.position.dy >= 0.21 && item.position.dx >= -0.25 && item.position.dx <= 0.25){
      setState(() {
        _isDeletePosition = true;
        item.deletePosition = true;
      });
    } else {
      setState(() {
        _isDeletePosition = false;
        item.deletePosition = false;
      });
    }
  }
  /// delete item widget with offset position
  void _deleteItemOnCoordinates(EditableItem item, PointerUpEvent details) {
    var _itemProvider = Provider.of<DraggableWidgetProvider>(context, listen: false)
        .draggableWidget;
    _inAction = false;
    if(item.type == ItemType.IMAGE){
    } else if(item.type == ItemType.TEXT && item.position.dy >= 0.265 && item.position.dx >= -0.122 && item.position.dx <= 0.122
        || item.type == ItemType.GIF && item.position.dy >= 0.21 && item.position.dx >= -0.25 && item.position.dx <= 0.25){
      setState(() {
        _itemProvider.removeAt(_itemProvider.indexOf(item));
        HapticFeedback.heavyImpact();
      });
    } else{
      setState(() {
        _activeItem = null;
      });
    }
    setState(() {
      _activeItem = null;
    });
  }

  /// update item position, scale, rotation
  void _updateItemPosition(EditableItem item, PointerDownEvent details) {
    if (_inAction) {
      return;
    }

    _inAction = true;
    _activeItem = item;
    _initPos = details.position;
    _currentPos = item.position;
    _currentScale = item.scale;
    _currentRotation = item.rotation;

    /// set vibrate
    HapticFeedback.lightImpact();

  }

}