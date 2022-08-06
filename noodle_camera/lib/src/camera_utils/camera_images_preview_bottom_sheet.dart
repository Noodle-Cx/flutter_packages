import 'dart:io';
import 'package:flutter/material.dart';
import 'camera_image_full_screen_preview.dart';

class CameraImagesPreviewBottomSheet extends StatefulWidget {
  const CameraImagesPreviewBottomSheet({
    Key? key,
    required this.images,
    this.label,
  }) : super(key: key);

  final List<File> images;
  final String? label;

  static void show({
    required BuildContext context,
    required List<File> images,
    String? label,
  }) {
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CameraImagesPreviewBottomSheet(
        images: images,
        label: label,
      ),
    );
  }

  @override
  _CameraImagesPreviewBottomSheetState createState() =>
      _CameraImagesPreviewBottomSheetState();
}

class _CameraImagesPreviewBottomSheetState
    extends State<CameraImagesPreviewBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.only(top: 18.5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text(widget.label ?? ''),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(24),
              children: widget.images.map((e) => _buildImageItem(e)).toList(),
            ),
          )
          // GridView(gridDelegate: gridDelegate)
        ],
      ),
    );
  }

  Widget _buildImageItem(File image) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => _showPreview(image),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future _showPreview(File image) async {
    final deleteImage = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (c) => CameraImageFullScreenPreview(image: image),
      ),
    );
    if (deleteImage == true) {
      widget.images.remove(image);
      setState(() {});
    }
  }
}
