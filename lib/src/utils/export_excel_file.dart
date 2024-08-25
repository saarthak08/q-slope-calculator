import 'dart:io';

import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<String> exportExcelFile(List<QSlope> qSlopes) async {
  final Workbook workbook = Workbook();

  Worksheet worksheet = workbook.worksheets[0];
  final Style headerStyle = workbook.styles.add('headerStyle');
  headerStyle.bold = true;

  _setHeader(worksheet, headerStyle);

  final List<int> bytes = workbook.saveAsStream();
  final fileName =
      "q-slope-calculations_${DateTime.now().toIso8601String().replaceAll(":", "-").split(".")}.xlsx";
  await File(fileName).writeAsBytes(bytes);
  workbook.dispose();
  return fileName;
}

void _setHeader(Worksheet worksheet, Style headerStyle) {
  Range lithology = worksheet.getRangeByName("A1");
  lithology.setText("Lithology");
  lithology.cellStyle = headerStyle;
}
