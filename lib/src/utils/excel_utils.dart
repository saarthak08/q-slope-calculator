import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/save_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelUtils {
  static List<int> generateExcelBytes(
    List<QSlope> qSlopes, {
    Map<String, String>? customHeaders,
  }) {
    final Workbook workbook = Workbook();
    final Worksheet worksheet = workbook.worksheets[0];
    final Style headerStyle = workbook.styles.add('headerStyle');
    headerStyle.bold = true;

    _setHeader(worksheet, headerStyle, customHeaders);

    int index = 2;
    for (var qSlope in qSlopes) {
      worksheet.getRangeByName("A$index").setText(qSlope.locationId ?? '');
      worksheet.getRangeByName("B$index").setText(qSlope.lithology ?? '');
      worksheet.getRangeByName("C$index").setNumber(qSlope.blockSize?.rqd);
      worksheet
          .getRangeByName("D$index")
          .setNumber(qSlope.blockSize?.jointSetNumber);
      worksheet
          .getRangeByName("E$index")
          .setNumber(
            qSlope.jointCharacter?.jointRoughness != null &&
                    qSlope.jointCharacter!.jointRoughness!.isNotEmpty
                ? qSlope
                    .jointCharacter!
                    .jointRoughness![qSlope.oFactor?.indexOfFirstJoint ?? 0]
                : null,
          );
      worksheet
          .getRangeByName("F$index")
          .setNumber(
            qSlope.jointCharacter?.jointAlteration != null &&
                    qSlope.jointCharacter!.jointAlteration!.isNotEmpty
                ? qSlope
                    .jointCharacter!
                    .jointAlteration![qSlope.oFactor?.indexOfFirstJoint ?? 0]
                : null,
          );
      worksheet
          .getRangeByName("G$index")
          .setText(
            qSlope.oFactor?.indexOfSecondJoint != null &&
                    qSlope.jointCharacter?.jointRoughness != null &&
                    qSlope.oFactor!.indexOfSecondJoint! <
                        qSlope.jointCharacter!.jointRoughness!.length
                ? (qSlope.jointCharacter?.jointRoughness?[qSlope
                        .oFactor!
                        .indexOfSecondJoint!])
                    .toString()
                : "-",
          );
      worksheet
          .getRangeByName("H$index")
          .setText(
            qSlope.oFactor?.indexOfSecondJoint != null &&
                    qSlope.jointCharacter?.jointAlteration != null &&
                    qSlope.oFactor!.indexOfSecondJoint! <
                        qSlope.jointCharacter!.jointAlteration!.length
                ? (qSlope.jointCharacter?.jointAlteration?[qSlope
                        .oFactor!
                        .indexOfSecondJoint!])
                    .toString()
                : "-",
          );
      worksheet
          .getRangeByName("I$index")
          .setNumber(qSlope.oFactor?.oFactorForFirstJoint);
      worksheet
          .getRangeByName("J$index")
          .setText(
            qSlope.oFactor?.oFactorForSecondJoint != null &&
                    qSlope.oFactor?.oFactorForSecondJoint != 0
                ? (qSlope.oFactor?.oFactorForSecondJoint)?.toString()
                : "-",
          );
      worksheet
          .getRangeByName("K$index")
          .setNumber(
            qSlope.externalFactors?.environmentalAndGeologicalConditionalNumber,
          );
      worksheet.getRangeByName("L$index").setNumber(qSlope.activeStress?.srf);
      worksheet.getRangeByName("M$index").setNumber(qSlope.qSlope);

      index++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    return bytes;
  }

  static Future<String?> exportExcelFile(
    List<QSlope> qSlopes, {
    String? dialogTitle,
    Map<String, String>? customHeaders,
  }) async {
    final bytes = generateExcelBytes(qSlopes, customHeaders: customHeaders);
    final fileName = generateExportFileName(
      excelExportFilePrefix,
      excelFileExtension,
    );
    final String? result = await saveFile(bytes, fileName, null, dialogTitle);

    if (result == null || result.isEmpty) {
      return null;
    }

    return fileName;
  }

  static void _setHeader(
    Worksheet worksheet,
    Style headerStyle,
    Map<String, String>? customHeaders,
  ) {
    worksheet
        .getRangeByName("A1")
        .setText(customHeaders?['locationId'] ?? "Location Id");
    worksheet
        .getRangeByName("B1")
        .setText(customHeaders?['lithology'] ?? "Lithology");
    worksheet.getRangeByName("C1").setText(customHeaders?['rqd'] ?? "RQD");
    worksheet.getRangeByName("D1").setText(customHeaders?['jn'] ?? "Jn");
    worksheet.getRangeByName("E1").setText(customHeaders?['jr1'] ?? "Jr1");
    worksheet.getRangeByName("F1").setText(customHeaders?['ja1'] ?? "Ja1");
    worksheet.getRangeByName("G1").setText(customHeaders?['jr2'] ?? "Jr2");
    worksheet.getRangeByName("H1").setText(customHeaders?['ja2'] ?? "Ja2");
    worksheet
        .getRangeByName("I1")
        .setText(customHeaders?['ofactor1'] ?? "O-factor 1");
    worksheet
        .getRangeByName("J1")
        .setText(customHeaders?['ofactor2'] ?? "O-factor 2");
    worksheet.getRangeByName("K1").setText(customHeaders?['jwice'] ?? "Jwice");
    worksheet.getRangeByName("L1").setText(customHeaders?['srf'] ?? "SRF");
    worksheet
        .getRangeByName("M1")
        .setText(customHeaders?['qslope'] ?? "Q-slope");

    for (int i = 1; i <= 13; i++) {
      worksheet.getRangeByIndex(1, i).cellStyle = headerStyle;
    }
  }
}

// Backward compatibility function
Future<String?> exportExcelFile(List<QSlope> qSlopes, [dynamic context]) =>
    ExcelUtils.exportExcelFile(qSlopes);
