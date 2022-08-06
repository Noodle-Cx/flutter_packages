import 'package:camera/camera.dart';

class CameraManager {
  factory CameraManager() {
    return _singleton;
  }

  CameraManager._internal();

  static final CameraManager _singleton = CameraManager._internal();

  List<CameraDescription> _cameras = [];

  List<CameraDescription> getCameras() {
    return _cameras;
  }

  Future<CameraState> startCameras({bool withLogs = false}) async {
    try {
      _cameras = await availableCameras();
      return CameraState.success;
    } on CameraException catch (e) {
      if (withLogs) {
        // ignore: avoid_print
        print(e.description);
      }
    } catch (e) {
      if (withLogs) {
        // ignore: avoid_print
        print(e.toString());
      }
    }
    return CameraState.error;
  }
}

enum CameraState {
  loading,
  success,
  error,
}
