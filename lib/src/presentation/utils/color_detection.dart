import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ColorDetection {
  final GlobalKey? currentKey;
  final StreamController<Color>? stateController;
  final GlobalKey? paintKey;

  img.Image? photo;

  ColorDetection({
    required this.currentKey,
    required this.stateController,
    required this.paintKey,
  });

  Future<dynamic> searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await loadSnapshotBytes();
    }
    return _calculatePixel(globalPosition);
  }

  _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey!.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    //int pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    int pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    stateController!.add(Color(hex));
    return Color(hex);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary? boxPaint =
        paintKey!.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image capture = await boxPaint!.toImage();
    ByteData? imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes!);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    Uint8List values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
