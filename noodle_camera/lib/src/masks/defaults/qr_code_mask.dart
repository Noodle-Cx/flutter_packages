import 'package:flutter/material.dart';
import '../camera_mask.dart';

class QrCodeMask extends StatelessWidget implements CameraMask {
  const QrCodeMask({
    Key? key,
    this.button,
  }) : super(key: key);

  final Widget? button;

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
                  height: 265,
                  margin: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                    bottom: 150,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 0,
          left: 0,
          child: SizedBox(
            height: 50,
            child: button ?? Container(),
          ),
        ),
      ],
    );
  }
}
