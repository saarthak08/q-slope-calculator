import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Captures an image from the camera or picks one from the gallery.
  /// Persists the image into the application storage so it remains accessible permanently.
  /// Falls back gracefully to FilePicker if ImagePicker is unsupported on the platform.
  static Future<String?> captureOrPickImage({required bool fromCamera}) async {
    try {
      XFile? image;
      if (fromCamera) {
        image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
      } else {
        try {
          image = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 1920,
            maxHeight: 1080,
            imageQuality: 85,
          );
        } catch (_) {
          // Fallback to FilePicker
        }
      }

      if (image != null) {
        final bytes = await image.readAsBytes();
        return await persistImage(
          bytes: bytes,
          sourcePath: image.path,
          fileName: image.name,
        );
      }

      // Fallback via FilePicker if not from camera
      if (!fromCamera) {
        final result = await FilePicker.pickFiles(type: FileType.image);
        if (result.isNotEmpty) {
          final file = result.first;
          final bytes = await file.readAsBytes();
          return await persistImage(
            bytes: bytes,
            sourcePath: file.path,
            fileName: file.name,
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }

  /// Saves image bytes or file to persistent local storage or base64 data URI for Web
  static Future<String> persistImage({
    Uint8List? bytes,
    String? sourcePath,
    required String fileName,
  }) async {
    if (kIsWeb) {
      if (bytes != null) {
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }
      return sourcePath ?? '';
    }

    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'outcrop_images'));
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
    }

    final ext =
        p.extension(fileName).isNotEmpty
            ? p.extension(fileName).replaceFirst('.', '')
            : 'jpg';
    final targetPath = p.join(
      imagesDir.path,
      'img_${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    final targetFile = File(targetPath);

    if (bytes != null) {
      await targetFile.writeAsBytes(bytes);
    } else if (sourcePath != null && File(sourcePath).existsSync()) {
      await File(sourcePath).copy(targetPath);
    }

    return targetFile.path;
  }
}
