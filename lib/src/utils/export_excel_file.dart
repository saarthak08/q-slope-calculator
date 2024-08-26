import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:q_slope_calculator/src/data/common/app_error.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<String> exportExcelFile(
    List<QSlope> qSlopes, BuildContext context) async {
  final Workbook workbook = Workbook();

  Worksheet worksheet = workbook.worksheets[0];
  final Style headerStyle = workbook.styles.add('headerStyle');
  headerStyle.bold = true;

  _setHeader(worksheet, headerStyle, context);

  int index = 2;
  for (var qSlope in qSlopes) {
    worksheet.getRangeByName("A$index").setText(qSlope.locationId);
    worksheet.getRangeByName("B$index").setText(qSlope.lithology);
    worksheet.getRangeByName("C$index").setNumber(qSlope.blockSize?.rqd);
    worksheet
        .getRangeByName("D$index")
        .setNumber(qSlope.blockSize?.jointSetNumber);
    worksheet.getRangeByName("E$index").setNumber(qSlope.jointCharacter
        ?.jointRoughness?[qSlope.oFactor?.indexOfFirstJoint ?? 0]);
    worksheet.getRangeByName("F$index").setNumber(qSlope.jointCharacter
        ?.jointAlteration?[qSlope.oFactor?.indexOfFirstJoint ?? 0]);
    worksheet.getRangeByName("G$index").setText(
        qSlope.oFactor?.indexOfSecondJoint != null
            ? (qSlope.jointCharacter
                ?.jointRoughness?[qSlope.oFactor!.indexOfSecondJoint!]
                .toString())
            : "-");
    worksheet.getRangeByName("H$index").setText(
        qSlope.oFactor?.indexOfSecondJoint != null
            ? (qSlope.jointCharacter
                ?.jointAlteration?[qSlope.oFactor!.indexOfSecondJoint!]
                .toString())
            : "-");
    worksheet
        .getRangeByName("I$index")
        .setNumber(qSlope.oFactor?.oFactorForFirstJoint);
    worksheet.getRangeByName("J$index").setText(
        qSlope.oFactor?.oFactorForSecondJoint != null &&
                qSlope.oFactor?.oFactorForSecondJoint != 0
            ? (qSlope.oFactor?.oFactorForSecondJoint)?.toString()
            : "-");
    worksheet.getRangeByName("K$index").setNumber(
        qSlope.externalFactors?.environmentalAndGeologicalConditionalNumber);
    worksheet.getRangeByName("L$index").setNumber(qSlope.activeStress?.srf);
    worksheet.getRangeByName("M$index").setNumber(qSlope.qSlope);

    index++;
  }

  final List<int> bytes = workbook.saveAsStream();
  final fileName =
      "q-slope-calculations_${DateTime.now().toIso8601String().replaceAll(":", "-")}.xlsx";
  String? result = await _saveFile(bytes, fileName);

  if (result == null) {
    throw AppError(type: ErrorType.unexpected, message: "File saving failed");
  }

  workbook.dispose();
  return fileName;
}

void _setHeader(Worksheet worksheet, Style headerStyle, BuildContext context) {
  Range locationId = worksheet.getRangeByName("A1");
  locationId.setText(AppLocalizations.of(context).locationIdTextInputTitle);
  locationId.cellStyle = headerStyle;

  Range lithology = worksheet.getRangeByName("B1");
  lithology.setText(AppLocalizations.of(context).lithologyTextInputTitle);
  lithology.cellStyle = headerStyle;

  Range rqd = worksheet.getRangeByName("C1");
  rqd.setText(AppLocalizations.of(context).rockQualityDesignationSymbol);
  rqd.cellStyle = headerStyle;

  Range jointSetNumber = worksheet.getRangeByName("D1");
  jointSetNumber.setText(AppLocalizations.of(context).jointSetNumberSymbol);
  jointSetNumber.cellStyle = headerStyle;

  Range jr1 = worksheet.getRangeByName("E1");
  jr1.setText("${AppLocalizations.of(context).jointRoughnessSymbol} 1");
  jr1.cellStyle = headerStyle;

  Range ja1 = worksheet.getRangeByName("F1");
  ja1.setText("${AppLocalizations.of(context).jointAlterationSymbol} 1");
  ja1.cellStyle = headerStyle;

  Range jr2 = worksheet.getRangeByName("G1");
  jr2.setText("${AppLocalizations.of(context).jointRoughnessSymbol} 2");
  jr2.cellStyle = headerStyle;

  Range ja2 = worksheet.getRangeByName("H1");
  ja2.setText("${AppLocalizations.of(context).jointAlterationSymbol} 2");
  ja2.cellStyle = headerStyle;

  Range of1 = worksheet.getRangeByName("I1");
  of1.setText("${AppLocalizations.of(context).oFactor} 1");
  of1.cellStyle = headerStyle;

  Range of2 = worksheet.getRangeByName("J1");
  of2.setText("${AppLocalizations.of(context).oFactor} 2");
  of2.cellStyle = headerStyle;

  Range jwice = worksheet.getRangeByName("K1");
  jwice.setText(AppLocalizations.of(context)
      .enviornmentalAndGeologicalConditionalNumberSymbol);
  jwice.cellStyle = headerStyle;

  Range srf = worksheet.getRangeByName("L1");
  srf.setText(AppLocalizations.of(context).stressReductionFactorSymbol);
  srf.cellStyle = headerStyle;

  Range qSlope = worksheet.getRangeByName("M1");
  qSlope.setText(AppLocalizations.of(context).qSlopeSymbol);
  qSlope.cellStyle = headerStyle;
}

Future<String?> _saveFile(List<int> bytes, String fileName) async {
  if (kIsWeb) {
    _saveFileInWeb(bytes, fileName);
    return "";
  } else {
    return FilePicker.platform
        .saveFile(fileName: fileName, bytes: Uint8List.fromList(bytes));
  }
}

Future<void> _saveFileInWeb(List<int> bytes, String fileName) async {
  html.AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    ..setAttribute('download', fileName)
    ..click();
}
