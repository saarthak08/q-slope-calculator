import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/data/common/app_error.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/save_file.dart';

class JsonBackupService {
  static const int currentSchemaVersion = 1;

  static Future<String> exportJson(
    List<QSlope> qSlopes,
    BuildContext context,
  ) async {
    final Map<String, dynamic> exportPayload = {
      'schemaVersion': currentSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'itemCount': qSlopes.length,
      'data': qSlopes.map((item) => item.toMap()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportPayload);
    final fileName = generateExportFileName(
      jsonBackupFilePrefix,
      jsonFileExtension,
    );
    final bytes = utf8.encode(jsonString);

    final result = await saveFile(bytes, fileName, context);
    if (result == null) {
      throw AppError(type: ErrorType.unexpected, message: "File saving failed");
    }
    return fileName;
  }

  static Future<List<QSlope>?> pickAndParseJson() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (files.isEmpty) {
      return null;
    }

    final file = files.first;
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      return null;
    }

    final content = utf8.decode(bytes);
    final dynamic decoded = json.decode(content);

    final List<QSlope> items = [];
    if (decoded is List) {
      for (var item in decoded) {
        if (item is Map<String, dynamic>) {
          items.add(QSlope.fromMap(item));
        }
      }
    } else if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      final list = decoded['data'];
      if (list is List) {
        for (var item in list) {
          if (item is Map<String, dynamic>) {
            items.add(QSlope.fromMap(item));
          }
        }
      }
    } else if (decoded is Map<String, dynamic>) {
      // Single object
      items.add(QSlope.fromMap(decoded));
    }

    return items;
  }
}
