library noodle_image;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoodleImage extends StatelessWidget {
  const NoodleImage(
    this.image, {
    Key? key,
    this.semanticLabel,
    this.height,
    this.width,
    this.color,
    this.scale,
    this.errorView,
    this.loadingView,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
  }) : super(key: key);

  final String image;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final double? scale;
  final String? semanticLabel;
  final Alignment alignment;
  final ImageRepeat repeat;
  final Widget? errorView;
  final Widget? loadingView;

  @override
  Widget build(BuildContext context) {
    if (image.contains('.svg')) {
      return _svgImage();
    }

    if (image.contains('data:image') && image.contains('base64')) {
      return _base64Image();
    }

    if (Uri.tryParse(image)?.isAbsolute ?? false) {
      return _networkImage();
    }

    return Image.asset(
      image,
      height: height,
      width: width,
      color: color,
      scale: scale,
      repeat: repeat,
      semanticLabel: semanticLabel,
      alignment: alignment,
      errorBuilder: errorView != null ? (c, e, s) => errorView! : null,
      fit: fit,
    );
  }

  Widget _networkImage() {
    return Image.network(
      image,
      height: height,
      width: width,
      color: color,
      fit: fit,
      scale: scale ?? 1,
      semanticLabel: semanticLabel,
      alignment: alignment,
      repeat: repeat,
      errorBuilder: errorView != null ? (c, e, s) => errorView! : null,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return loadingView ?? SizedBox(height: height, width: width);
      },
    );
  }

  Image _base64Image() {
    final base64 = image.split('base64,');
    final imageFile = base64Decode(base64[1]);
    return Image.memory(
      imageFile,
      height: height,
      width: width,
      color: color,
      scale: scale ?? 1,
      fit: fit,
      repeat: repeat,
      semanticLabel: semanticLabel,
      alignment: alignment,
      errorBuilder: errorView != null ? (c, e, s) => errorView! : null,
    );
  }

  Widget _svgImage() {
    if (Uri.tryParse(image)?.isAbsolute ?? false) {
      return SvgPicture.network(
        image,
        height: height,
        width: width,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        semanticsLabel: semanticLabel,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: loadingView != null ? (c) => loadingView! : null,
      );
    } else {
      return SvgPicture.asset(
        image,
        height: height,
        width: width,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        semanticsLabel: semanticLabel,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: loadingView != null ? (c) => loadingView! : null,
      );
    }
  }
}
