import 'dart:io';

import 'package:file_picker/file_picker.dart';

class DocumentUtils {
  DocumentUtils._();
  static Future<File?> getFile(FileType type,
      {required List<String> allowedExtensions}) async {
    if (allowedExtensions.isNotEmpty) {
      final result = await FilePicker.platform
          .pickFiles(type: type, allowedExtensions: allowedExtensions);
      return filePickerResultToFile(result);
    } else {
      final result = await FilePicker.platform.pickFiles(type: type);
      return filePickerResultToFile(result);
    }
  }

  static File? filePickerResultToFile(FilePickerResult? result) {
    if (result?.files.isEmpty == true) {
      return null;
    }
    return File(result?.files.first.path ?? '');
  }
}
