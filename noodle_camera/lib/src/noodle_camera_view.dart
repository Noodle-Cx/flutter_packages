import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noodle_camera/src/camera_utils/noodle_camera_strings.dart';
import 'camera_utils/camera_images_preview_bottom_sheet.dart';
import 'camera_utils/camera_manager.dart';
import 'camera_utils/camera_mode.dart';
import 'camera_utils/gradient_outline_button.dart';
import 'masks/camera_mask.dart';
import 'noodle_camera_view_controller.dart';

class NoodleCameraView extends StatefulWidget {
  const NoodleCameraView({
    Key? key,
    this.cameraMode = CameraMode.picture,
    this.cameraMask,
    this.cameraLensDirection = CameraLensDirection.back,
    this.enableChangeCamera = true,
    this.onScanResult,
    this.validator,
    this.onPictureResult,
    this.deviceOrientation = DeviceOrientation.portraitUp,
    this.multiPictures = false,
    this.fadeOnAppbar = true,
    this.expandedPreview = true,
    this.brightness,
    this.cameraStrings = const NoodleCameraStrings(),
  }) : super(key: key);

  final CameraMode cameraMode;
  final CameraMask? cameraMask;
  final CameraLensDirection cameraLensDirection;
  final bool enableChangeCamera;
  final Function(String)? onScanResult;
  final bool Function(String)? validator;
  final Function(List<File>)? onPictureResult;
  final DeviceOrientation deviceOrientation;
  final bool multiPictures;
  final bool fadeOnAppbar;
  final Sink<Brightness>? brightness;
  final bool expandedPreview;
  final NoodleCameraStrings cameraStrings;

  @override
  _NoodleCameraViewState createState() => _NoodleCameraViewState();
}

class _NoodleCameraViewState extends State<NoodleCameraView>
    with CameraViewController, WidgetsBindingObserver {
  Color get tertiary => const Color.fromRGBO(73, 76, 162, 1);
  Color get pink => const Color(0xFFEC486A);
  Color get teal => const Color.fromRGBO(113, 217, 228, 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    if (lastImage != null) {
      setState(() {
        lastImage = null;
        widget.brightness?.add(
            lastImage != null ? Theme.of(context).brightness : Brightness.dark);
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: FutureBuilder<CameraState>(
          initialData: CameraState.loading,
          future: cameraManager.startCameras(),
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case CameraState.success:
                return FutureBuilder<bool>(
                  future: initialize(cameraManager.getCameras()),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return _cameraPreview();
                    }

                    if (snapshot.data == false) {
                      return _errorLoadingCameras();
                    }

                    return const CircularProgressIndicator();
                  },
                );

              case CameraState.error:
                return _errorLoadingCameras();
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _errorLoadingCameras() {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                widget.cameraStrings.errorLoadCamera,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(widget.cameraStrings.ok),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreview() {
    return Material(
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Column(
              children: [
                _liveCamera(),
                _previewPicture(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Visibility _liveCamera() {
    return Visibility(
      visible: lastImage == null,
      child: Expanded(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Visibility(
                  visible: !widget.expandedPreview,
                  child: Expanded(child: Container()),
                ),
                Expanded(
                  flex: widget.expandedPreview ? 1 : 0,
                  child: SizedBox(
                    width: double.infinity,
                    child: CameraPreview(
                      cameraController!,
                    ),
                  ),
                ),
                Visibility(
                  visible: !widget.expandedPreview,
                  child: Expanded(child: Container()),
                ),
              ],
            ),
            widget.cameraMask ?? Container(),
            _actionButtons(),
            _fadeTop()
          ],
        ),
      ),
    );
  }

  Widget _previewPicture() {
    return Visibility(
      visible: lastImage != null,
      child: Expanded(
        child: Material(
          elevation: 0,
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cameraStrings.confirmPicture,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1
                                        ?.color ??
                                    Colors.black,
                                height: 1.33,
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(lastImage?.path ?? ''),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(
                              height: 252,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRect(
                    child: Container(
                      color: Theme.of(context).backgroundColor.withOpacity(0.6),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 24,
                            top: 16,
                            right: 24,
                            bottom: 56,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                child: Text(widget.cameraStrings.notRepeat),
                                onPressed: () {
                                  setState(() {
                                    lastImage = null;
                                    widget.brightness?.add(lastImage != null
                                        ? Theme.of(context).brightness
                                        : Brightness.dark);
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: Text(widget.cameraStrings.yesContinue),
                                onPressed: () {
                                  if (lastImage != null) {
                                    images.add(File(lastImage!.path));
                                    if (!widget.multiPictures) {
                                      widget.onPictureResult?.call(images);
                                    } else {
                                      setState(() {
                                        lastImage = null;
                                        widget.brightness?.add(lastImage != null
                                            ? Theme.of(context).brightness
                                            : Brightness.dark);
                                      });
                                    }
                                  } else {
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align _actionButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Visibility(
        visible: widget.cameraMode == CameraMode.picture,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _previewPicturesButton(),
                  ],
                ),
              ),
              _takePictureButton(),
              Expanded(
                child: Row(
                  children: [
                    _changeCameraButton(),
                    _confirmImagesButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewPicturesButton() {
    return Visibility(
      visible: widget.multiPictures && images.isNotEmpty,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () {
          CameraImagesPreviewBottomSheet.show(
            context: context,
            images: images,
            label: widget.cameraStrings.images,
          );
        },
        child: Stack(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(top: 6, right: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  images.isNotEmpty ? images.last : File(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  images.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _changeCameraButton() {
    return Expanded(
      child: Visibility(
        visible: widget.enableChangeCamera,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 0,
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: toggleCamera,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.cameraswitch_outlined,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmImagesButton() {
    return Visibility(
      visible: widget.multiPictures && images.isNotEmpty,
      child: GestureDetector(
        onTap: () {
          widget.onPictureResult?.call(images);
        },
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _takePictureButton() {
    return GradientOutlineButton(
      onPressed: takePicture,
      strokeWidth: 3,
      radius: 50,
      gradient: LinearGradient(
        colors: [teal, tertiary, pink],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  Positioned _fadeTop() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: widget.fadeOnAppbar,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
