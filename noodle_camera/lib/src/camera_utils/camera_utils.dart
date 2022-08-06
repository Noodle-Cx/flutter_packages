import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

typedef HandleDetection<T> = Future<T> Function(InputImage image);
typedef ErrorWidgetBuilder = Widget Function(
    BuildContext context, CameraError error);

enum CameraError {
  unknown,
  cantInitializeCamera,
  androidVersionNotSupported,
  noCameraAvailable,
}

Future<CameraDescription?> getCamera(
  List<CameraDescription> cameras,
  CameraLensDirection dir,
) async {
  final camera = getFirstAvailableCamera(cameras, dir);
  return camera ?? (cameras.isEmpty ? null : cameras.first);
}

CameraDescription? getFirstAvailableCamera(
    List<CameraDescription> cameras, CameraLensDirection dir) {
  try {
    return cameras.firstWhere((camera) => camera.lensDirection == dir);
  } catch (e) {
    return null;
  }
}

Uint8List concatenatePlanes(List<Plane> planes) {
  final allBytes = WriteBuffer();
  for (var plane in planes) {
    allBytes.putUint8List(plane.bytes);
  }
  return allBytes.done().buffer.asUint8List();
}

InputImageData buildMetaData(
  CameraImage image,
  InputImageRotation rotation,
) {
  final inputImageFormat =
      InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21;

  final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

  final planeData = image.planes.map(
    (Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    },
  ).toList();

  return InputImageData(
    inputImageFormat: inputImageFormat,
    size: imageSize,
    imageRotation: rotation,
    planeData: planeData,
  );
}

Future<T> detect<T>(
  CameraImage image,
  HandleDetection<T> handleDetection,
  InputImageRotation rotation,
) async {
  return handleDetection(
    InputImage.fromBytes(
      bytes: concatenatePlanes(image.planes),
      inputImageData: buildMetaData(image, rotation),
    ),
  );
}

InputImageRotation rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 0:
      return InputImageRotation.rotation270deg;
    case 90:
      return InputImageRotation.rotation180deg;
    case 180:
      return InputImageRotation.rotation90deg;
    default:
      assert(rotation == 270);
      return InputImageRotation.rotation0deg;
  }
}
