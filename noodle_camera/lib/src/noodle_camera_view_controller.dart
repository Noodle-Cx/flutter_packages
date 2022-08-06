import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart';
import 'camera_utils/camera_manager.dart';
import 'camera_utils/camera_mode.dart';
import 'camera_utils/camera_utils.dart';
import 'noodle_camera_view.dart';

enum _CameraState {
  loading,
  error,
  ready,
}

mixin CameraViewController on State<NoodleCameraView> {
  CameraController? cameraController;
  _CameraState _cameraMlVisionState = _CameraState.loading;
  CameraError _cameraError = CameraError.unknown;
  bool _isStreaming = false;
  XFile? lastImage;
  List<File> images = [];
  bool _alreadyCheckingImage = false;

  late InputImageRotation _rotation;
  late CameraLensDirection _lensDirection;
  late CameraManager cameraManager;

  late BarcodeScanner detector;

  @override
  void didUpdateWidget(covariant NoodleCameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _alreadyCheckingImage = false;
    setOrientation(widget.deviceOrientation);
  }

  @override
  void initState() {
    super.initState();
    cameraManager = CameraManager();
    detector = GoogleMlKit.vision.barcodeScanner();
    _lensDirection = widget.cameraLensDirection;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _disposeController();
    super.dispose();
  }

  void setOrientation(DeviceOrientation deviceOrientation) {
    SystemChrome.setPreferredOrientations([deviceOrientation]);
    if (deviceOrientation == DeviceOrientation.portraitUp ||
        deviceOrientation == DeviceOrientation.portraitDown) {
      deviceOrientation = DeviceOrientation.portraitUp;
    } else {
      deviceOrientation = deviceOrientation;
    }

    cameraController?.lockCaptureOrientation(deviceOrientation);
  }

  Future<dynamic> takePicture() async {
    try {
      cameraController?.setFlashMode(FlashMode.off);
      XFile? xFile = await cameraController?.takePicture();
      if (xFile != null) {
        if (_lensDirection == CameraLensDirection.front) {
          final imageBytes = await xFile.readAsBytes();
          final originalImage = decodeImage(imageBytes);
          if (originalImage != null) {
            final fixedImage = flipHorizontal(originalImage);
            final file = File(xFile.path);

            final fixedFile = await file.writeAsBytes(
              encodeJpg(fixedImage),
              flush: true,
            );

            xFile = XFile(fixedFile.path);
          }
        }
      }
      setState(() {
        lastImage = xFile;
        widget.brightness?.add(
            lastImage != null ? Theme.of(context).brightness : Brightness.dark);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void toggleCamera() {
    if (_lensDirection == CameraLensDirection.front) {
      setState(() {
        _lensDirection = CameraLensDirection.back;
      });
    } else {
      setState(() {
        _lensDirection = CameraLensDirection.front;
      });
    }
  }

  void _start() {
    if (widget.cameraMode == CameraMode.scan) {
      cameraController?.startImageStream(_processImage);
      setState(() {
        _isStreaming = true;
      });
    }
  }

  Future _disposeController() async {
    if (widget.cameraMode == CameraMode.scan) {
      if (cameraController?.value.isStreamingImages == true && mounted) {
        await cameraController?.stopImageStream().catchError((dynamic e) {});
      }
      _isStreaming = false;
    }
    cameraController?.dispose();
  }

  Future<bool> initialize(List<CameraDescription> cameras) async {
    final description = await getCamera(cameras, _lensDirection);
    if (description == null) {
      _cameraMlVisionState = _CameraState.error;
      _cameraError = CameraError.noCameraAvailable;
      return false;
    }

    if (cameraController == null ||
        cameraController?.description.lensDirection != _lensDirection) {
      cameraController = CameraController(
        description,
        widget.cameraMode == CameraMode.picture
            ? ResolutionPreset.max
            : ResolutionPreset.high,
        enableAudio: false,
      )..initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _cameraMlVisionState = _CameraState.ready;
          });
          _start();
          setOrientation(widget.deviceOrientation);
        });
    }

    _rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    if (!_alreadyCheckingImage && mounted) {
      _alreadyCheckingImage = true;
      try {
        final result =
            await detect<String>(cameraImage, _detectorRun, _rotation);
        if (result.isNotEmpty) {
          if (widget.validator != null) {
            if (widget.validator?.call(result) == true) {
              widget.onScanResult?.call(result);
            } else {
              _alreadyCheckingImage = false;
            }
          } else {
            widget.onScanResult?.call(result);
          }
        } else {
          _alreadyCheckingImage = false;
        }
      } catch (ex, stack) {
        _alreadyCheckingImage = false;
        debugPrint('$ex, $stack');
      }
    }
  }

  Future<String> _detectorRun(InputImage image) async {
    final result = await detector.processImage(image);
    if (result.isNotEmpty) {
      final value = result[0].rawValue ?? '';
      try {
        final Map<String, dynamic> jsonValue = jsonDecode(value);
        if (!jsonValue.containsKey('errorCode')) {
          return value;
        }
      } catch (_) {
        return value;
      }
    }
    return '';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<CameraError>('_cameraError', _cameraError));
    properties.add(EnumProperty<_CameraState>(
        '_cameraMlVisionState', _cameraMlVisionState));
    properties.add(DiagnosticsProperty<bool>('_isStreaming', _isStreaming));
  }
}
