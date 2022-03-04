import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:ui' as ui;

class AssetPathCoverWidget extends StatelessWidget {
  final AssetPathEntity entity;
  final int thumbSize;
  final BoxFit fit;
  final int index;

  const AssetPathCoverWidget({
    required this.entity,
    this.thumbSize = 120,
    this.fit = BoxFit.cover,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: PathCoverImageProvider(
        entity,
        thumbSize: thumbSize,
        index: index,
      ),
      fit: fit,
      filterQuality: FilterQuality.high,
    );
  }
}

class PathCoverImageProvider extends ImageProvider<PathCoverImageProvider> {
  final AssetPathEntity entity;
  final double scale;
  final int thumbSize;
  final int index;

  const PathCoverImageProvider(
    this.entity, {
    this.scale = 1.0,
    this.thumbSize = 120,
    this.index = 0,
  });

  @override
  ImageStreamCompleter load(
      PathCoverImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(
      PathCoverImageProvider key, DecoderCallback decode) async {
    assert(key == this);

    final coverEntity =
        (await key.entity.getAssetListRange(start: index, end: index + 1))[0];

    final bytes = await coverEntity.thumbDataWithSize(thumbSize, thumbSize);

    return decode(bytes!);
  }

  @override
  Future<PathCoverImageProvider> obtainKey(
      ImageConfiguration configuration) async {
    return this;
  }

  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! PathCoverImageProvider) {
      return false;
    }
    final PathCoverImageProvider o = other;
    return o.entity == entity &&
        o.scale == scale &&
        o.thumbSize == thumbSize &&
        o.index == index;
  }

  @override
  int get hashCode => hashValues(entity, scale, thumbSize, index);
}
