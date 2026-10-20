import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/data/common/app_error.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/save_file.dart';
import 'package:uuid/uuid.dart';

class CsvService {
  static String _escapeCsvValue(dynamic val) {
    if (val == null) return '';
    String str = val.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n')) {
      return '"${str.replaceAll('"', '""')}"';
    }
    return str;
  }

  static String generateCsvString(List<QSlope> qSlopes) {
    final buffer = StringBuffer();
    // Headers
    buffer.writeln(
      [
        'ID',
        'Location_ID',
        'Lithology',
        'RQD',
        'Jn',
        'Jr1',
        'Ja1',
        'Jr2',
        'Ja2',
        'OFactor1',
        'OFactor2',
        'FailureType',
        'OFactorMethod',
        'AlphaI',
        'AlphaJ',
        'AlphaS',
        'BetaI',
        'BetaJ',
        'BetaS',
        'F1',
        'F2',
        'F3',
        'Jwice',
        'SRF',
        'QSlope',
        'SlopeAngleByUser',
        'AllowableAngle',
        'SafetyMargin',
        'StabilityStatus',
        'CreatedAt',
      ].join(','),
    );

    for (var q in qSlopes) {
      final roughnessList = q.jointCharacter?.jointRoughness;
      final alterationList = q.jointCharacter?.jointAlteration;

      int idx1 = q.oFactor?.indexOfFirstJoint ?? 0;
      if (roughnessList != null &&
          (idx1 < 0 || idx1 >= roughnessList.length)) {
        idx1 = 0;
      }
      int? idx2 = q.oFactor?.indexOfSecondJoint;
      if (roughnessList != null &&
          idx2 != null &&
          (idx2 < 0 || idx2 >= roughnessList.length)) {
        idx2 = null;
      }

      final jr1 =
          (roughnessList != null && roughnessList.isNotEmpty)
              ? roughnessList[idx1]
              : null;
      final ja1 =
          (alterationList != null &&
                  alterationList.isNotEmpty &&
                  alterationList.length > idx1)
              ? alterationList[idx1]
              : null;
      final jr2 =
          (roughnessList != null &&
                  idx2 != null &&
                  roughnessList.length > idx2)
              ? roughnessList[idx2]
              : null;
      final ja2 =
          (alterationList != null &&
                  idx2 != null &&
                  alterationList.length > idx2)
              ? alterationList[idx2]
              : null;

      final allowableAngle =
          q.qSlope != null && q.qSlope! > 0
              ? calculateSlopeAngle(q.qSlope!).toStringAsFixed(2)
              : '';
      final margin = calculateSafetyMargin(q.qSlope, q.slopeAngleByUser);
      final marginStr = margin != null ? margin.toStringAsFixed(2) : '';
      final status = getSlopeStabilityStatus(q.qSlope, q.slopeAngleByUser);

      final row = [
        _escapeCsvValue(q.id),
        _escapeCsvValue(q.locationId),
        _escapeCsvValue(q.lithology),
        _escapeCsvValue(q.blockSize?.rqd),
        _escapeCsvValue(q.blockSize?.jointSetNumber),
        _escapeCsvValue(jr1),
        _escapeCsvValue(ja1),
        _escapeCsvValue(jr2),
        _escapeCsvValue(ja2),
        _escapeCsvValue(q.oFactor?.oFactorForFirstJoint),
        _escapeCsvValue(q.oFactor?.oFactorForSecondJoint),
        _escapeCsvValue(q.oFactor?.oFactorTypeOfFailure?.name),
        _escapeCsvValue(q.oFactor?.oFactorCalculationType?.name),
        _escapeCsvValue(q.oFactor?.alphaI),
        _escapeCsvValue(q.oFactor?.alphaJ),
        _escapeCsvValue(q.oFactor?.alphaS),
        _escapeCsvValue(q.oFactor?.betaI),
        _escapeCsvValue(q.oFactor?.betaJ),
        _escapeCsvValue(q.oFactor?.betaS),
        _escapeCsvValue(q.oFactor?.f1),
        _escapeCsvValue(q.oFactor?.f2),
        _escapeCsvValue(q.oFactor?.f3),
        _escapeCsvValue(
          q.externalFactors?.environmentalAndGeologicalConditionalNumber,
        ),
        _escapeCsvValue(q.activeStress?.srf),
        _escapeCsvValue(q.qSlope),
        _escapeCsvValue(q.slopeAngleByUser),
        _escapeCsvValue(allowableAngle),
        _escapeCsvValue(marginStr),
        _escapeCsvValue(status.name),
        _escapeCsvValue(q.createdAt?.toIso8601String()),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  static Future<String> exportCsv(
    List<QSlope> qSlopes,
    BuildContext context,
  ) async {
    final csvString = generateCsvString(qSlopes);
    final fileName = generateExportFileName(
      csvExportFilePrefix,
      csvFileExtension,
    );
    final bytes = utf8.encode(csvString);
    final result = await saveFile(bytes, fileName, context);
    if (result == null) {
      throw AppError(type: ErrorType.unexpected, message: "File saving failed");
    }
    return fileName;
  }

  static Future<List<QSlope>?> pickAndParseCsv() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
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
    return parseCsvContent(content);
  }

  static List<QSlope> parseCsvContent(String content) {
    final List<QSlope> list = [];
    final lines = LineSplitter.split(content).toList();
    if (lines.length <= 1) return list;

    // Header index mapping
    final headers = _parseCsvLine(lines.first).map((h) => h.trim().toLowerCase()).toList();
    final colMap = {for (int i = 0; i < headers.length; i++) headers[i]: i};

    const uuid = Uuid();

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final cols = _parseCsvLine(line);
      if (cols.isEmpty) continue;

      String getCol(String name, {String fallback = ''}) {
        final idx = colMap[name.toLowerCase()];
        if (idx != null && idx < cols.length) {
          return cols[idx].trim();
        }
        return fallback;
      }

      double? getDoubleCol(String name) {
        final val = getCol(name);
        return double.tryParse(val);
      }

      final id = getCol('id', fallback: uuid.v4());
      final locationId = getCol('location_id', fallback: getCol('locationid'));
      final lithology = getCol('lithology');
      final rqd = getDoubleCol('rqd');
      final jn = getDoubleCol('jn');
      final jr1 = getDoubleCol('jr1') ?? getDoubleCol('jr') ?? 1.0;
      final ja1 = getDoubleCol('ja1') ?? getDoubleCol('ja') ?? 1.0;
      final jr2 = getDoubleCol('jr2');
      final ja2 = getDoubleCol('ja2');
      final o1 = getDoubleCol('ofactor1') ?? getDoubleCol('ofactor') ?? 1.0;
      final o2 = getDoubleCol('ofactor2');
      final jwice = getDoubleCol('jwice') ?? 1.0;
      final srf = getDoubleCol('srf') ?? 1.0;
      final qSlopeVal = getDoubleCol('qslope');
      final slopeAngle = getDoubleCol('slopeanglebyuser') ?? getDoubleCol('slope_angle');
      final createdAtStr = getCol('createdat');
      final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();

      final List<double> jrList = [jr1];
      final List<double> jaList = [ja1];
      if (jr2 != null && ja2 != null) {
        jrList.add(jr2);
        jaList.add(ja2);
      }

      final failureTypeStr = getCol('failuretype', fallback: getCol('failure_type'));
      OFactorTypeOfFailure? failureType;
      if (failureTypeStr.isNotEmpty) {
        final lower = failureTypeStr.toLowerCase();
        if (lower == 'toppling') {
          failureType = OFactorTypeOfFailure.toppling;
        } else if (lower == 'wedge') {
          failureType = OFactorTypeOfFailure.wedge;
        } else if (lower == 'planar') {
          failureType = OFactorTypeOfFailure.planar;
        }
      }
      failureType ??= (jrList.length > 1 ? OFactorTypeOfFailure.wedge : OFactorTypeOfFailure.planar);

      final oFactorMethodStr = getCol('ofactormethod', fallback: getCol('o_factor_calculation_type'));
      final isRomana = oFactorMethodStr.toLowerCase().contains('romana');
      final oFactorCalculationType = isRomana
          ? OFactorCalculationType.romanaAdjacentFactor
          : OFactorCalculationType.value;

      final alphaI = getDoubleCol('alphai') ?? getDoubleCol('alpha_i');
      final alphaJ = getDoubleCol('alphaj') ?? getDoubleCol('alpha_j');
      final alphaS = getDoubleCol('alphas') ?? getDoubleCol('alpha_s');
      final betaI = getDoubleCol('betai') ?? getDoubleCol('beta_i');
      final betaJ = getDoubleCol('betaj') ?? getDoubleCol('beta_j');
      final betaS = getDoubleCol('betas') ?? getDoubleCol('beta_s');
      final f1 = getDoubleCol('f1');
      final f2 = getDoubleCol('f2');
      final f3 = getDoubleCol('f3');

      final qSlope = QSlope(
        id: id.isNotEmpty ? id : uuid.v4(),
        locationId: locationId.isNotEmpty ? locationId : null,
        lithology: lithology.isNotEmpty ? lithology : null,
        blockSize: BlockSize(
          rqd: rqd ?? 0,
          sumOfCorePieces: rqd ?? 0,
          totalDrillRun: 100.0,
          jointSetNumber: jn,
          numberOfJoints: jrList.length,
          numberOfRandomSets: 0,
          rqdCalculationType: RqdCalculationType.directMethod,
        ),
        jointCharacter: JointCharacter(
          jointRoughness: jrList,
          jointAlteration: jaList,
          jrCalculationType: JrCalculationType.jr,
        ),
        oFactor: OFactor(
          indexOfFirstJoint: 0,
          indexOfSecondJoint: failureType == OFactorTypeOfFailure.wedge ? 1 : null,
          oFactorForFirstJoint: o1,
          oFactorForSecondJoint: o2,
          oFactorCalculationType: oFactorCalculationType,
          oFactorTypeOfFailure: failureType,
          oFactorRomanaValueType: (alphaI != null || alphaJ != null || f1 != null)
              ? OFactorRomanaValueType.calculation
              : (isRomana ? OFactorRomanaValueType.value : null),
          alphaI: alphaI,
          alphaJ: alphaJ,
          alphaS: alphaS,
          betaI: betaI,
          betaJ: betaJ,
          betaS: betaS,
          f1: f1,
          f2: f2,
          f3: f3,
        ),
        externalFactors: ExternalFactors(
          environmentalAndGeologicalConditionalNumber: jwice,
          externalFactorsCalculationType: ExternalFactorsCalculationType.value,
        ),
        activeStress: ActiveStress(
          srf: srf,
          srfA: srf,
        ),
        qSlope: qSlopeVal,
        slopeAngleByUser: slopeAngle,
        createdAt: createdAt,
      );

      // If qSlope is not pre-calculated, calculate it
      qSlope.qSlope ??= calculateQSlope(qSlope);

      list.add(qSlope);
    }

    return list;
  }

  static List<String> _parseCsvLine(String line) {
    final List<String> cols = [];
    final StringBuffer cur = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          cur.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        cols.add(cur.toString());
        cur.clear();
      } else {
        cur.write(char);
      }
    }
    cols.add(cur.toString());
    return cols;
  }
}
