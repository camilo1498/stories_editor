import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stories_editor/src/domain/providers/FfmpegProvider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/rendering_notifier.dart';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:stories_editor/src/presentation/utils/constants/render_state.dart';

class WidgetRecorderController extends ChangeNotifier {
  WidgetRecorderController() : _containerKey = GlobalKey();

  /// key of the content widget to render
  final GlobalKey _containerKey;

  /// frame callback
  final SchedulerBinding _binding = SchedulerBinding.instance!;

  /// save frames
  final List<ui.Image> _frames = [];

  /// start render
  void start(
      {required ControlNotifier controlNotifier,
      required RenderingNotifier renderingNotifier}) {
    controlNotifier.isRenderingWidget = true;
    renderingNotifier.renderState = RenderState.preparing;
    _binding.addPostFrameCallback(
      (timeStamp) {
        _postFrameCallback(timeStamp, controlNotifier, renderingNotifier);
      },
    );
    notifyListeners();
  }

  /// stop render
  void stop(
      {required ControlNotifier controlNotifier,
      required RenderingNotifier renderingNotifier}) {
    renderingNotifier.renderState = RenderState.preparing;
    controlNotifier.isRenderingWidget = false;
    notifyListeners();
  }

  /// add frame to list
  void _postFrameCallback(Duration timestamp, ControlNotifier controlNotifier,
      RenderingNotifier renderingNotifier) async {
    if (controlNotifier.isRenderingWidget == false) {
      return;
    } else {
      renderingNotifier.renderState = RenderState.frames;
      notifyListeners();
      try {
        final image = await _captureFrame();
        _frames.add(image!);
        renderingNotifier.totalFrames = _frames.length;
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
      _binding.addPostFrameCallback(
        (timeStamp) {
          _postFrameCallback(timeStamp, controlNotifier, renderingNotifier);
        },
      );
      notifyListeners();
    }
  }

  /// capture widget to render
  Future<ui.Image?> _captureFrame() async {
    final renderObject = _containerKey.currentContext?.findRenderObject();
    notifyListeners();
    if (renderObject is RenderRepaintBoundary) {
      final image = await renderObject.toImage(pixelRatio: 2);
      return image;
    } else {
      FlutterError.reportError(_noRenderObject());
    }
    return null;
  }

  /// error details
  FlutterErrorDetails _noRenderObject() {
    return FlutterErrorDetails(
      exception: Exception(
        '_containerKey.currentContext is null. '
        'Thus we can\'t create a screenshot',
      ),
      library: 'feedback',
      context: ErrorDescription(
        'Tried to find a context to use it to create a screenshot',
      ),
    );
  }

  /// export widget
  Future<Map<String, dynamic>> export(
      {required ControlNotifier controlNotifier,
      required RenderingNotifier renderingNotifier}) async {
    /// paths
    String dir;
    String imagePath;

    /// get application temp directory
    var tempDir = await getTemporaryDirectory();
    var tempDirPath = tempDir.path;
    dir = '$tempDirPath/stories_editor';
    final res = await Directory(dir).create(recursive: true);

    /// delete last directory
    Directory myDir = Directory(dir);
    myDir.deleteSync(recursive: true);

    /// create new directory
    myDir.create(recursive: true);
    renderingNotifier.renderState = RenderState.preparing;
    notifyListeners();

    /// iterate all frames
    for (int i = 0; i < _frames.length; i++) {
      /// convert frame to byte data png
      final val = await _frames[i].toByteData(format: ui.ImageByteFormat.png);

      /// convert frame to buffer list
      Uint8List pngBytes = val!.buffer.asUint8List();

      /// create temp path for every frame
      imagePath = '${myDir.path}/$i.png';

      /// create image frame in the temp directory
      File capturedFile = File(imagePath);
      await capturedFile.writeAsBytes(pngBytes);
      renderingNotifier.currentFrames = i;
    }

    /// clear frame list
    _frames.clear();
    renderingNotifier.renderState = RenderState.rendering;
    notifyListeners();

    /// render frames.png to video/gif
    var response = await FfmpegProvider()
        .mergeIntoVideo(renderType: renderingNotifier.renderType);

    /// return
    return response;
  }
}

class ScreenRecorder extends StatelessWidget {
  const ScreenRecorder({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  /// The child which should be recorded.
  final Widget child;

  /// This controller starts and stops the recording.
  final WidgetRecorderController controller;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller._containerKey,
      child: child,
    );
  }
}
