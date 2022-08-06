import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'defaults/barcode_mask.dart';
import 'defaults/face_mask.dart';
import 'defaults/qr_code_mask.dart';

abstract class CameraMask extends Widget {
  const CameraMask({Key? key}) : super(key: key);
  const factory CameraMask.faceMask() = FaceMask;
  const factory CameraMask.qrCode({Widget? button}) = QrCodeMask;
  const factory CameraMask.barcode({Widget? button}) = BarcodeMask;
}
