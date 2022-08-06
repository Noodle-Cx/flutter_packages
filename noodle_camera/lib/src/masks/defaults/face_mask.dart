import 'package:flutter/material.dart';
import 'package:noodle_camera/src/masks/camera_mask.dart';

class FaceMask extends StatelessWidget implements CameraMask {
  const FaceMask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.8),
            BlendMode.srcOut,
          ), // This one will create the magic
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(200, 300)),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
