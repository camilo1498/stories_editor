import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/constants/painting_type.dart';
import 'package:stories_editor/src/models/painting_model.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/widgets/painting/sketcher.dart';
import 'package:stories_editor/src/widgets/selector/color_selector.dart';
import 'package:stories_editor/src/widgets/selector/size_slider_selector.dart';
import 'package:stories_editor/src/widgets/tools/top_painting_tools.dart';



class Painting extends StatefulWidget {
  const Painting({Key? key}) : super(key: key);

  @override
  State<Painting> createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<PaintingProvider>(context, listen: false)
        ..linesStreamController =  StreamController<List<PaintingModel>>.broadcast()
        ..currentLineStreamController = StreamController<PaintingModel>.broadcast();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    /// instance of painting model
    PaintingModel? line;

    /// on gestures start
    void _onPanStart(DragStartDetails details, PaintingProvider paintingProvider, ControlVariableProvider controlProvider) {
      var _size = MediaQuery.of(context).size;
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.globalPosition);
      final point = Point(offset.dx, offset.dy-33);
      final points = [point];

      /// validate allow pan area
      if(point.y >= 4 && point.y <= _size.height- 132){
        line = PaintingModel(
            points,
            paintingProvider.lineWidth,
            1,
            1,
            false,
            controlProvider.colorList![paintingProvider.lineColor],
            1,
            true,
            paintingProvider.paintingType
        );
      }
    }

    /// on gestures update
    void _onPanUpdate(DragUpdateDetails details, PaintingProvider paintingProvider, ControlVariableProvider controlProvider) {
      var _size = MediaQuery.of(context).size;
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.globalPosition);
      final point = Point(offset.dx, offset.dy-33);
      final points = [...line!.points, point];

      /// validate allow pan area
      if(point.y >= 6 && point.y <= _size.height- 140){
        line = PaintingModel(
            points,
            paintingProvider.lineWidth,
            1,
            1,
            false,
            controlProvider.colorList![paintingProvider.lineColor],
            1,
            true,
            paintingProvider.paintingType
        );
        paintingProvider.currentLineStreamController.add(line!);
      }
    }

    /// on gestures end
    void _onPanEnd(DragEndDetails details, PaintingProvider paintingProvider) {
      paintingProvider.lines = List.from(paintingProvider.lines)..add(line!);
      line = null;
      paintingProvider.linesStreamController.add(paintingProvider.lines );
    }

    /// paint current line
    Widget _renderCurrentLine(BuildContext context, PaintingProvider paintingProvider, ControlVariableProvider controlProvider) {
      return GestureDetector(
        onPanStart: (details){
          _onPanStart(details, paintingProvider,controlProvider);
        },
        onPanUpdate: (details){
          _onPanUpdate(details, paintingProvider, controlProvider);
        },
        onPanEnd: (details){
          _onPanEnd(details, paintingProvider);
        },
        child: RepaintBoundary(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 132,
                  child: StreamBuilder<PaintingModel>(
                      stream: paintingProvider.currentLineStreamController.stream,
                      builder: (context, snapshot) {
                        return CustomPaint(
                          painter: Sketcher(
                            lines: line == null ? [] : [line!],
                          ),
                        );
                      })),
            ),
          ),
        ),
      );
    }

    /// return Painting board
    return Consumer2<ControlVariableProvider, PaintingProvider>(
      builder: (context, controlProvider, paintingProvider, child){
        return WillPopScope(
          onWillPop: () async{
            controlProvider.isPainting = false;
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
             paintingProvider.closeConnection();
            });
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                /// render current line
                _renderCurrentLine(context, paintingProvider, controlProvider),

                /// select line width
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: SizeSliderWidget(),
                  ),
                ),

                /// top painting tools
                const SafeArea(
                    child: TopPaintingTools()
                ),

                /// color picker
                Visibility(
                  visible: paintingProvider.paintingType == PaintingType.ERASE ? false : true,
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 110),
                      child: ColorSelector(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

