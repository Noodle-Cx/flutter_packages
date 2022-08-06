import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noodle_camera/src/camera_utils/noodle_camera_strings.dart';

import 'camera_utils/camera_mode.dart';
import 'masks/camera_mask.dart';
import 'noodle_camera_view.dart';

class NoodleCameraScanPage extends StatefulWidget {
  const NoodleCameraScanPage({
    Key? key,
    required this.title,
    this.cameraMask,
    this.enableChangeCamera = true,
    this.cameraLensDirection = CameraLensDirection.back,
    this.validator,
    this.deviceOrientation,
    this.noodleCameraStrings = const NoodleCameraStrings(),
  }) : super(key: key);

  static Future<String?> show({
    required BuildContext context,
    required String title,
    CameraMask? cameraMask,
    bool enableChangeCamera = true,
    String? instructions,
    CameraLensDirection cameraLensDirection = CameraLensDirection.back,
    bool Function(String)? validator,
    DeviceOrientation? deviceOrientation,
    NoodleCameraStrings noodleCameraStrings = const NoodleCameraStrings(),
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => NoodleCameraScanPage(
          title: title,
          cameraMask: cameraMask,
          enableChangeCamera: enableChangeCamera,
          cameraLensDirection: cameraLensDirection,
          validator: validator,
          deviceOrientation: deviceOrientation,
          noodleCameraStrings: noodleCameraStrings,
        ),
      ),
    );
  }

  final String title;
  final CameraMask? cameraMask;
  final bool enableChangeCamera;
  final CameraLensDirection cameraLensDirection;
  final bool Function(String)? validator;
  final DeviceOrientation? deviceOrientation;
  final NoodleCameraStrings noodleCameraStrings;

  @override
  _NoodleCameraScanPageState createState() => _NoodleCameraScanPageState();
}

class _NoodleCameraScanPageState extends State<NoodleCameraScanPage> {
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
        cameraMode: CameraMode.scan,
        enableChangeCamera: widget.enableChangeCamera,
        cameraLensDirection: widget.cameraLensDirection,
        cameraStrings: widget.noodleCameraStrings,
        deviceOrientation:
            widget.deviceOrientation ?? DeviceOrientation.portraitUp,
        validator: widget.validator,
        onScanResult: (data) {
          Navigator.of(context).pop(data);
        },
      ),
    );
  }
}
