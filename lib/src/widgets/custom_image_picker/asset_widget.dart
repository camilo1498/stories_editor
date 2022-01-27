import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

typedef AssetWidgetBuilder = Widget Function(
  BuildContext context,
  AssetEntity asset,
  int thumbSize,
);

class AssetWidget extends StatelessWidget {
  final AssetEntity asset;
  final int thumbSize;

  const AssetWidget({
    Key? key,
    required this.asset,
    this.thumbSize = 500,
  }) : super(key: key);

  static AssetWidget buildWidget(
      BuildContext context, AssetEntity asset, int thumbSize) {
    return AssetWidget(
      asset: asset,
      thumbSize: thumbSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color1 = const Color(0xFFFFFFFF);
    Color color2 = const Color(0xFFFFFFFF);
    return Stack(
      alignment: Alignment.center,
      children: [
        /// background gradient from image
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color1,
                  color2
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
          ) ,
        ),       Image(
          image: AssetEntityThumbImage(
            entity: asset,
            width: thumbSize,
            height: thumbSize,
          ),
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}



class AssetEntityThumbImage extends ImageProvider<AssetEntityThumbImage> {
  final AssetEntity entity;
  final int width;
  final int height;
  final double scale;

  AssetEntityThumbImage({
    required this.entity,
    int? width,
    int? height,
    this.scale = 1.0,
  })  : width = width ?? entity.width,
        height = height ?? entity.height;

  @override
  ImageStreamCompleter load(AssetEntityThumbImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(
      AssetEntityThumbImage key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await entity.thumbDataWithSize(width, height);
    return decode(bytes!);
  }

  @override
  Future<AssetEntityThumbImage> obtainKey(
      ImageConfiguration configuration) async {
    return this;
  }

  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! AssetEntityThumbImage) {
      return false;
    }
    final AssetEntityThumbImage o = other;
    return (o.entity == entity &&
        o.scale == scale &&
        o.width == width &&
        o.height == height);
  }

  @override
  int get hashCode => hashValues(entity, scale, width, height);
}
