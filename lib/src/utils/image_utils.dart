import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static final ImagePicker _imagePicker = ImagePicker();
  static int _fileCounter = 0;

  /// Captures an image from the camera or picks one or more images from the gallery.
  /// Persists each image into the application storage so it remains accessible permanently.
  /// Falls back gracefully to FilePicker if ImagePicker is unsupported on the platform.
  static Future<List<String>> captureOrPickImages({
    required bool fromCamera,
  }) async {
    try {
      if (fromCamera) {
        final image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          final bytes = await image.readAsBytes();
          final path = await persistImage(
            bytes: bytes,
            sourcePath: image.path,
            fileName: image.name,
          );
          return [path];
        }
        return [];
      } else {
        List<XFile> images = [];
        bool fallbackToFilePicker = false;
        try {
          images = await _imagePicker.pickMultiImage(
            maxWidth: 1920,
            maxHeight: 1080,
            imageQuality: 85,
          );
        } catch (e) {
          debugPrint('ImagePicker.pickMultiImage error, trying FilePicker: $e');
          fallbackToFilePicker = true;
        }

        if (images.isNotEmpty) {
          final List<String> paths = [];
          for (final img in images) {
            final bytes = await img.readAsBytes();
            final path = await persistImage(
              bytes: bytes,
              sourcePath: img.path,
              fileName: img.name,
            );
            paths.add(path);
          }
          return paths;
        }

        // Fallback via FilePicker if image_picker was not supported or failed
        if (fallbackToFilePicker) {
          final result = await FilePicker.pickFiles(type: FileType.image);
          if (result.isNotEmpty) {
            final List<String> paths = [];
            for (final file in result) {
              final bytes = await file.readAsBytes();
              final path = await persistImage(
                bytes: bytes,
                sourcePath: file.path,
                fileName: file.name,
              );
              paths.add(path);
            }
            return paths;
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
    return [];
  }

  /// Backward-compatible single-image picker.
  static Future<String?> captureOrPickImage({required bool fromCamera}) async {
    final images = await captureOrPickImages(fromCamera: fromCamera);
    return images.isNotEmpty ? images.first : null;
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
      'img_${DateTime.now().millisecondsSinceEpoch}_${_fileCounter++}.$ext',
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
