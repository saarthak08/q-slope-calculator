import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/app_localizations.dart';
import 'package:universal_html/html.dart' as html;
import 'package:q_slope_calculator/generated/l10n/app_localizations.dart';

Future<String?> saveFile(
  List<int> bytes,
  String fileName,
  BuildContext context,
) async {
  if (kIsWeb) {
    _saveFileInWeb(bytes, fileName);
    return "";
  } else if (Platform.isWindows) {
    return _saveFileInWindows(bytes, fileName, context);
  } else {
    return FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: Uint8List.fromList(bytes),
      dialogTitle: AppLocalizations.of(context).selectDirectoryToSaveFile,
    );
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
  BuildContext context,
) async {
  String? directory = await FilePicker.platform.getDirectoryPath(
    lockParentWindow: true,
    dialogTitle: AppLocalizations.of(context).selectDirectoryToSaveFile,
  );
  if (directory != null) {
    File("$directory/$fileName").writeAsBytesSync(bytes);
  }
  return directory;
}
