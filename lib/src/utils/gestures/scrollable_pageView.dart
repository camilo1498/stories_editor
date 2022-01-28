import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/custom_scrollController_provider.dart';

class ScrollablePageView extends StatefulWidget {
  Widget child;
  final bool scrollPhysics;
  ScrollablePageView({
    Key? key,
    required this.child,
    required this.scrollPhysics
}) : super(key: key);
  @override
  _ScrollablePageViewState createState() => _ScrollablePageViewState();
}

class _ScrollablePageViewState extends State<ScrollablePageView> {
  PageController? _pageController;
  ScrollController? _listScrollController;
  ScrollController? _activeScrollController;
  Drag? _drag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {

    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    var _scrollProvider = Provider.of<CustomScrollControllerProvider>(context,listen: false);
    if (_listScrollController!.hasClients) {
      final RenderBox renderBox = _listScrollController!.position.context.storageContext.findRenderObject() as RenderBox;
      if (renderBox.paintBounds.shift(renderBox.localToGlobal(Offset.zero)).contains(details.globalPosition)) {
        _activeScrollController = _listScrollController;
        _drag = _activeScrollController!.position.drag(details, _disposeDrag);

        _scrollProvider.pageController = _pageController!;
        _scrollProvider.gridController = _listScrollController!;
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController!.position.drag(details, _disposeDrag);
    _scrollProvider.drag = _drag;
    _scrollProvider.activeScrollController = _activeScrollController!;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    var _scrollProvider = Provider.of<CustomScrollControllerProvider>(context,listen: false);
    if (_activeScrollController == _listScrollController
        && details.primaryDelta! > 0
        && _activeScrollController!.position.pixels == _activeScrollController!.position.minScrollExtent) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController!.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition
          ),
          _disposeDrag
      );
      _scrollProvider.drag = _drag;
      _scrollProvider.activeScrollController = _activeScrollController!;
      _scrollProvider.pageController = _pageController!;
      _scrollProvider.gridController = _listScrollController!;
    }
    _drag?.update(details);
    _scrollProvider.drag = _drag;

  }

  void _handleDragEnd(DragEndDetails details) {
    var _scrollProvider = Provider.of<CustomScrollControllerProvider>(context,listen: false);
    _drag?.end(details);
    _scrollProvider.drag = _drag;
  }

  void _handleDragCancel() {
    var _scrollProvider = Provider.of<CustomScrollControllerProvider>(context,listen: false);
    _drag?.cancel();
    _scrollProvider.drag = _drag;
  }

  void _disposeDrag() {
    var _scrollProvider = Provider.of<CustomScrollControllerProvider>(context,listen: false);
    _drag = null;
    _scrollProvider.drag = _drag;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<CustomScrollControllerProvider>(context, listen: false).gridController = _listScrollController!;
      Provider.of<CustomScrollControllerProvider>(context, listen: false).pageController = _pageController!;
    });
    return RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
                  (VerticalDragGestureRecognizer instance) {
                    if(widget.scrollPhysics){
                      instance
                        ..onStart = _handleDragStart
                        ..onUpdate = _handleDragUpdate
                        ..onEnd = _handleDragEnd
                        ..onCancel = _handleDragCancel;
                    }else{
                      instance
                        ..onStart = null
                        ..onUpdate = null
                        ..onEnd = null
                        ..onCancel = null;
                    }
              }
          )
        },
        behavior: HitTestBehavior.opaque,
        child: widget.child
    );
  }
}
