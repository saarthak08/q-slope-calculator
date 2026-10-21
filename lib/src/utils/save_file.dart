import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:universal_html/html.dart' as html;
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';

Future<String?> saveFile(
  List<int> bytes,
  String fileName, [
  BuildContext? context,
  String? dialogTitle,
]) async {
  final title =
      dialogTitle ??
      (context != null
          ? AppLocalizations.of(context).selectDirectoryToSaveFile
          : 'Select directory to save file');
  if (kIsWeb) {
    _saveFileInWeb(bytes, fileName);
    return fileName;
  }

  try {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: Uint8List.fromList(bytes),
      dialogTitle: title,
    );
    if (uri != null) {
      return uri.isScheme('file')
          ? uri.toFilePath()
          : (uri.path.isNotEmpty ? uri.path : uri.toString());
    }
    return null;
  } catch (_) {
    if (Platform.isWindows) {
      return _saveFileInWindows(bytes, fileName, title);
    }
    return null;
  }
}

Future<void> _saveFileInWeb(List<int> bytes, String fileName) async {
  html.AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',
    )
    ..setAttribute('download', fileName)
    ..click();
}

Future<String?> _saveFileInWindows(
  List<int> bytes,
  String fileName,
  String dialogTitle,
) async {
  String? directory = await FilePicker.getDirectoryPath(
    dialogTitle: dialogTitle,
  );
  if (directory != null && directory.isNotEmpty) {
    final fullPath = p.join(directory, fileName);
    File(fullPath).writeAsBytesSync(bytes);
    return fullPath;
  }
  return null;
}
