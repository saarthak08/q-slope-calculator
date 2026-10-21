import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/save_file.dart';
import 'package:uuid/uuid.dart';

class CsvUtils {
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
        'SRF_A',
        'SRF_B',
        'SRF_C',
        'RQDMethod',
        'CorePiecesSum',
        'DrillRunLength',
        'PalmstromJointCount',
        'PalmstromRandomSets',
        'PalmstromArea',
        'PalmstromJointSpacings',
        'PalmstromWaviness',
        'PalmstromSmoothness',
        'QSlope',
        'SlopeAngleByUser',
        'AllowableSlopeAngle',
        'SafetyMargin',
        'StabilityStatus',
        'CreatedAt',
        'Latitude',
        'Longitude',
        'Elevation',
        'BenchHeight',
        'ImagePaths',
      ].join(','),
    );

    for (var q in qSlopes) {
      final double qVal = q.qSlope ?? calculateQSlope(q);
      final double allowableAngle = calculateSlopeAngle(qVal);
      final double? margin = calculateSafetyMargin(qVal, q.slopeAngleByUser);
      final SlopeStabilityStatus status = getSlopeStabilityStatus(
        qVal,
        q.slopeAngleByUser,
      );
      final String marginStr = margin != null ? margin.toStringAsFixed(1) : '';

      final List<String> row = [
        _escapeCsvValue(q.id),
        _escapeCsvValue(q.locationId),
        _escapeCsvValue(q.lithology),
        _escapeCsvValue(q.blockSize?.rqd),
        _escapeCsvValue(q.blockSize?.jointSetNumber),
        _escapeCsvValue(
          q.jointCharacter?.jointRoughness != null &&
                  q.jointCharacter!.jointRoughness!.isNotEmpty
              ? q.jointCharacter!.jointRoughness![0]
              : null,
        ),
        _escapeCsvValue(
          q.jointCharacter?.jointAlteration != null &&
                  q.jointCharacter!.jointAlteration!.isNotEmpty
              ? q.jointCharacter!.jointAlteration![0]
              : null,
        ),
        _escapeCsvValue(
          q.jointCharacter?.jointRoughness != null &&
                  q.jointCharacter!.jointRoughness!.length > 1
              ? q.jointCharacter!.jointRoughness![1]
              : null,
        ),
        _escapeCsvValue(
          q.jointCharacter?.jointAlteration != null &&
                  q.jointCharacter!.jointAlteration!.length > 1
              ? q.jointCharacter!.jointAlteration![1]
              : null,
        ),
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
        _escapeCsvValue(q.activeStress?.srfA),
        _escapeCsvValue(q.activeStress?.srfB),
        _escapeCsvValue(q.activeStress?.srfC),
        _escapeCsvValue(q.blockSize?.rqdCalculationType?.name),
        _escapeCsvValue(q.blockSize?.sumOfCorePieces),
        _escapeCsvValue(q.blockSize?.totalDrillRun),
        _escapeCsvValue(q.blockSize?.numberOfJoints),
        _escapeCsvValue(q.blockSize?.numberOfRandomSets),
        _escapeCsvValue(q.blockSize?.areaInSquareMeters),
        _escapeCsvValue(q.blockSize?.jointSpacingInMeters?.join(';')),
        _escapeCsvValue(q.jointCharacter?.jointWaviness?.join(';')),
        _escapeCsvValue(q.jointCharacter?.jointSmoothness?.join(';')),
        _escapeCsvValue(q.qSlope),
        _escapeCsvValue(q.slopeAngleByUser),
        _escapeCsvValue(allowableAngle),
        _escapeCsvValue(marginStr),
        _escapeCsvValue(status.name),
        _escapeCsvValue(q.createdAt?.toIso8601String()),
        _escapeCsvValue(q.latitude),
        _escapeCsvValue(q.longitude),
        _escapeCsvValue(q.elevation),
        _escapeCsvValue(q.benchHeight),
        _escapeCsvValue((q.imagePaths ?? q.photoPaths)?.join(';')),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  static Future<String?> exportCsv(
    List<QSlope> qSlopes, {
    String? dialogTitle,
  }) async {
    final csvString = generateCsvString(qSlopes);
    final fileName = generateExportFileName(
      csvExportFilePrefix,
      csvFileExtension,
    );
    final bytes = utf8.encode(csvString);
    final result = await saveFile(bytes, fileName, null, dialogTitle);
    if (result == null || result.isEmpty) {
      return null;
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
    final lines = const LineSplitter().convert(content);
    if (lines.length < 2) return list;

    final headerRow = _parseCsvLine(lines[0]);
    final Map<String, int> colMap = {};
    final Map<String, int> normalizedColMap = {};
    for (int i = 0; i < headerRow.length; i++) {
      final raw = headerRow[i].trim().toLowerCase();
      colMap[raw] = i;
      final normalized = raw.replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (normalized.isNotEmpty) {
        normalizedColMap[normalized] = i;
      }
    }

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final cols = _parseCsvLine(line);

      String? getVal(dynamic keys) {
        final List<String> keyList =
            keys is List<String> ? keys : [keys.toString()];
        for (final k in keyList) {
          final raw = k.trim().toLowerCase();
          final normalized = raw.replaceAll(RegExp(r'[^a-z0-9]'), '');
          int? idx = colMap[raw];
          idx ??= normalizedColMap[normalized];
          if (idx != null && idx < cols.length) {
            final v = cols[idx].trim();
            if (v.isEmpty ||
                v.toLowerCase() == 'null' ||
                v.toLowerCase() == 'none' ||
                v.toLowerCase() == 'nan' ||
                v == '-') {
              continue;
            }
            return v;
          }
        }
        return null;
      }

      double? getDouble(dynamic keys) {
        final v = getVal(keys);
        return v != null ? double.tryParse(v) : null;
      }

      int? getInt(dynamic keys) {
        final v = getVal(keys);
        return v != null ? int.tryParse(v) : null;
      }

      final id = getVal('id') ?? const Uuid().v4();
      final locationId = getVal(['location_id', 'locationid', 'location']);
      final lithology = getVal('lithology');
      final rqd = getDouble('rqd') ?? 0.0;
      final jn = getDouble(['jn', 'jointsetnumber', 'joint_set_number']) ?? 1.0;
      final jr1 =
          getDouble(['jr1', 'jr', 'jointroughness', 'joint_roughness']) ?? 1.0;
      final ja1 =
          getDouble(['ja1', 'ja', 'jointalteration', 'joint_alteration']) ??
          1.0;
      final jr2 = getDouble(['jr2', 'jr_2']);
      final ja2 = getDouble(['ja2', 'ja_2']);
      final o1 =
          getDouble(['ofactor1', 'ofactor', 'o_factor_1', 'o_factor']) ?? 1.0;
      final o2 = getDouble(['ofactor2', 'o_factor_2']);
      final failureTypeStr = getVal([
        'failuretype',
        'failure_type',
        'typeoffailure',
      ]);
      final ofactorMethodStr = getVal([
        'ofactormethod',
        'ofactor_method',
        'ofactorcalculationtype',
      ]);

      final alphaI = getDouble(['alphai', 'alpha_i']);
      final alphaJ = getDouble(['alphaj', 'alpha_j']);
      final alphaS = getDouble(['alphas', 'alpha_s']);
      final betaI = getDouble(['betai', 'beta_i']);
      final betaJ = getDouble(['betaj', 'beta_j']);
      final betaS = getDouble(['betas', 'beta_s']);
      final f1 = getDouble('f1');
      final f2 = getDouble('f2');
      final f3 = getDouble('f3');

      final jwice =
          getDouble(['jwice', 'j_wice', 'environmental_factors']) ?? 1.0;
      final rawSrf = getDouble([
        'srf',
        'stress_reduction_factor',
        'stressreductionfactor',
      ]);
      final srfA =
          getDouble(['srf_a', 'srfa', 'srf a', 'srf-a']) ?? rawSrf ?? 1.0;
      final srfB = getDouble(['srf_b', 'srfb', 'srf b', 'srf-b']);
      final srfC = getDouble(['srf_c', 'srfc', 'srf c', 'srf-c']);
      final double calculatedMaxSrf = [
        srfA,
        srfB ?? 0.0,
        srfC ?? 0.0,
      ].reduce((curr, next) => curr > next ? curr : next);
      final srf = rawSrf ?? (calculatedMaxSrf > 0 ? calculatedMaxSrf : 1.0);

      final rqdMethodStr = getVal('rqdmethod');
      final corePieces = getDouble('corepiecessum');
      final drillRun = getDouble('drillrunlength');
      final palmJointCount = getInt('palmstromjointcount') ?? 1;
      final palmRandomSets = getInt('palmstromrandomsets') ?? 0;
      final palmArea = getDouble('palmstromarea') ?? 1.0;
      final jointSpacingsStr = getVal('palmstromjointspacings');
      final wavinessStr = getVal('palmstromwaviness');
      final smoothnessStr = getVal('palmstromsmoothness');

      final qSlopeVal = getDouble('qslope');
      final actualAngle = getDouble('slopeanglebyuser');
      final createdAtStr = getVal('createdat');
      final latitude = getDouble('latitude');
      final longitude = getDouble('longitude');
      final elevation = getDouble('elevation');
      final benchHeight = getDouble('benchheight');
      final imagePathsStr = getVal('imagepaths') ?? getVal('photopaths');

      // Failure type enum parsing
      OFactorTypeOfFailure failureType = OFactorTypeOfFailure.planar;
      if (failureTypeStr != null) {
        for (var t in OFactorTypeOfFailure.values) {
          if (t.name.toLowerCase() == failureTypeStr.toLowerCase()) {
            failureType = t;
            break;
          }
        }
      }

      // OFactor calculation type enum parsing
      OFactorCalculationType oCalcType = OFactorCalculationType.value;
      if (ofactorMethodStr != null) {
        for (var t in OFactorCalculationType.values) {
          if (t.name.toLowerCase() == ofactorMethodStr.toLowerCase()) {
            oCalcType = t;
            break;
          }
        }
      }

      // RQD calculation type
      RqdCalculationType rqdCalcType = RqdCalculationType.directMethod;
      if (rqdMethodStr != null) {
        for (var t in RqdCalculationType.values) {
          if (t.name.toLowerCase() == rqdMethodStr.toLowerCase()) {
            rqdCalcType = t;
            break;
          }
        }
      }

      final List<double> jrList = [jr1];
      if (jr2 != null) jrList.add(jr2);
      final List<double> jaList = [ja1];
      if (ja2 != null) jaList.add(ja2);

      final List<double>? jointSpacings =
          jointSpacingsStr
              ?.split(';')
              .map((s) => double.tryParse(s.trim()))
              .whereType<double>()
              .toList();

      final List<double>? wavinessList =
          wavinessStr
              ?.split(';')
              .map((s) => double.tryParse(s.trim()))
              .whereType<double>()
              .toList();

      final List<double>? smoothnessList =
          smoothnessStr
              ?.split(';')
              .map((s) => double.tryParse(s.trim()))
              .whereType<double>()
              .toList();

      final List<String>? imagePaths =
          imagePathsStr
              ?.split(';')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();

      final qSlope = QSlope(
        id: id,
        locationId: locationId,
        lithology: lithology,
        blockSize: BlockSize(
          rqd: rqd,
          jointSetNumber: jn,
          numberOfJoints: palmJointCount,
          numberOfRandomSets: palmRandomSets,
          areaInSquareMeters: palmArea,
          sumOfCorePieces: corePieces ?? rqd,
          totalDrillRun: drillRun ?? 100.0,
          jointSpacingInMeters: jointSpacings,
          rqdCalculationType: rqdCalcType,
        ),
        jointCharacter: JointCharacter(
          jointRoughness: jrList,
          jointAlteration: jaList,
          jointWaviness: wavinessList,
          jointSmoothness: smoothnessList,
          jrCalculationType:
              (wavinessList != null && wavinessList.isNotEmpty)
                  ? JrCalculationType.palmstorm
                  : JrCalculationType.jr,
        ),
        oFactor: OFactor(
          oFactorForFirstJoint: o1,
          oFactorForSecondJoint: o2,
          indexOfFirstJoint: 0,
          indexOfSecondJoint: o2 != null ? 1 : null,
          oFactorTypeOfFailure: failureType,
          oFactorCalculationType: oCalcType,
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
          srfA: srfA,
          srfB: srfB,
          srfC: srfC,
        ),
        qSlope: qSlopeVal,
        slopeAngleByUser: actualAngle,
        createdAt:
            createdAtStr != null
                ? DateTime.tryParse(createdAtStr)
                : DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
        benchHeight: benchHeight,
        imagePaths: imagePaths,
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

// Backward compatibility alias
typedef CsvService = CsvUtils;
