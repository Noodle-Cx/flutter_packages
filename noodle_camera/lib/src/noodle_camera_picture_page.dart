import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noodle_camera/src/camera_utils/noodle_camera_strings.dart';

import 'camera_utils/camera_mode.dart';
import 'masks/camera_mask.dart';
import 'noodle_camera_view.dart';

class NoodleCameraPicturePage extends StatefulWidget {
  const NoodleCameraPicturePage({
    Key? key,
    required this.title,
    this.cameraMask,
    this.multiPictures = false,
    this.enableChangeCamera = true,
    this.cameraLensDirection = CameraLensDirection.back,
    this.deviceOrientation,
    this.noodleCameraStrings = const NoodleCameraStrings(),
  }) : super(key: key);

  static Future<List<File>?> show({
    required BuildContext context,
    required String title,
    CameraMask? cameraMask,
    bool multiPictures = false,
    bool enableChangeCamera = true,
    CameraLensDirection cameraLensDirection = CameraLensDirection.back,
    DeviceOrientation? deviceOrientation,
    NoodleCameraStrings noodleCameraStrings = const NoodleCameraStrings(),
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => NoodleCameraPicturePage(
          title: title,
          cameraMask: cameraMask,
          multiPictures: multiPictures,
          enableChangeCamera: enableChangeCamera,
          cameraLensDirection: cameraLensDirection,
          deviceOrientation: deviceOrientation,
          noodleCameraStrings: noodleCameraStrings,
        ),
      ),
    );
  }

  final String title;
  final CameraMask? cameraMask;
  final bool multiPictures;
  final bool enableChangeCamera;
  final CameraLensDirection cameraLensDirection;
  final DeviceOrientation? deviceOrientation;
  final NoodleCameraStrings noodleCameraStrings;

  @override
  _NoodleCameraPicturePageState createState() =>
      _NoodleCameraPicturePageState();
}

class _NoodleCameraPicturePageState extends State<NoodleCameraPicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: NoodleCameraView(
        cameraMask: widget.cameraMask,
        cameraMode: CameraMode.picture,
        multiPictures: widget.multiPictures,
        enableChangeCamera: widget.enableChangeCamera,
        cameraLensDirection: widget.cameraLensDirection,
        cameraStrings: widget.noodleCameraStrings,
        deviceOrientation:
            widget.deviceOrientation ?? DeviceOrientation.portraitUp,
        onPictureResult: (images) {
          Navigator.of(context).pop(images);
        },
      ),
    );
  }
}
