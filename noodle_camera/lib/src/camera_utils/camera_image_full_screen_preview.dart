import 'dart:io';

import 'package:flutter/material.dart';

class CameraImageFullScreenPreview extends StatelessWidget {
  const CameraImageFullScreenPreview({Key? key, required this.image})
      : super(key: key);

  final File image;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Image.file(image),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(color: Colors.white),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
