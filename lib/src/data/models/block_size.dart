import 'dart:convert';
import 'package:collection/collection.dart';

class BlockSize {
  /// [USING_Jv]
  int? numberOfJoints;
  int? numberOfRandomSets;
  List<double>? jointSpacingInMeters;
  double? jointSetNumber;
  double? areaInSquareMeters;
  double? jointVolume;

  /// [USING_DIRECT_METHOD]
  double? sumOfCorePieces;
  double? totalDrillRun;

  RqdCalculationType? rqdCalculationType;

  RqdByJvCalculationType? rqdByJvCalculationType;

  double? rqd;

  BlockSize({
    this.numberOfJoints,
    this.numberOfRandomSets,
    this.jointSpacingInMeters,
    this.areaInSquareMeters,
    this.jointSetNumber,
    this.jointVolume,
    this.sumOfCorePieces,
    this.totalDrillRun,
    this.rqdCalculationType,
    this.rqdByJvCalculationType,
    this.rqd = 0,
  });

  BlockSize copyWith({
    int? numberOfJoints,
    int? numberOfRandomSets,
    List<double>? jointSpacingInMeters,
    double? areaInSquareMeters,
    double? jointVolume,
    double? sumOfCorePieces,
    double? totalDrillRun,
    double? jointSetNumber,
    RqdCalculationType? rqdCalculationType,
    RqdByJvCalculationType? rqdByJvCalculationType,
    double? rqd,
  }) {
    return BlockSize(
        numberOfJoints: numberOfJoints ?? this.numberOfJoints,
        numberOfRandomSets: numberOfRandomSets ?? this.numberOfRandomSets,
        jointSpacingInMeters: jointSpacingInMeters ?? this.jointSpacingInMeters,
        areaInSquareMeters: areaInSquareMeters ?? this.areaInSquareMeters,
        jointVolume: jointVolume ?? this.jointVolume,
        sumOfCorePieces: sumOfCorePieces ?? this.sumOfCorePieces,
        totalDrillRun: totalDrillRun ?? this.totalDrillRun,
        rqdCalculationType: rqdCalculationType ?? this.rqdCalculationType,
        rqdByJvCalculationType:
            rqdByJvCalculationType ?? this.rqdByJvCalculationType,
        rqd: rqd ?? this.rqd,
        jointSetNumber: jointSetNumber ?? this.jointSetNumber);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numberOfJoints': numberOfJoints,
      'numberOfRandomSets': numberOfRandomSets,
      'jointSpacingInMeters': jointSpacingInMeters,
      'areaInSquareMeters': areaInSquareMeters,
      'jointVolume': jointVolume,
      'sumOfCorePieces': sumOfCorePieces,
      'totalDrillRun': totalDrillRun,
      'rqdCalculationType': rqdCalculationType?.name,
      'rqdByJvCalculationType': rqdByJvCalculationType?.name,
      'rqd': rqd,
      'jointSetNumber': jointSetNumber
    };
  }

  factory BlockSize.fromMap(Map<String, dynamic> map) {
    return BlockSize(
        numberOfJoints:
            map['numberOfJoints'] != null ? map['numberOfJoints'] as int : null,
        numberOfRandomSets: map['numberOfRandomSets'] != null
            ? map['numberOfRandomSets'] as int?
            : null,
        jointSpacingInMeters: map['jointSpacingInMeters'] != null
            ? (map['jointSpacingInMeters'] as List).cast<double>()
            : null,
        areaInSquareMeters: map['areaInSquareMeters'] != null
            ? map['areaInSquareMeters'] as double?
            : null,
        jointVolume:
            map['jointVolume'] != null ? map['jointVolume'] as double : null,
        sumOfCorePieces: map['sumOfCorePieces'] != null
            ? map['sumOfCorePieces'] as double?
            : null,
        totalDrillRun: map['totalDrillRun'] != null
            ? map['totalDrillRun'] as double?
            : null,
        rqdCalculationType: map['rqdCalculationType'] != null
            ? map['rqdCalculationType'] == RqdCalculationType.directMethod.name
                ? RqdCalculationType.directMethod
                : RqdCalculationType.jv
            : null,
        rqd: map['rqd'] as double,
        jointSetNumber: map['jointSetNumber'] as double?,
        rqdByJvCalculationType: map['rqdByJvCalculationType'] != null
            ? map['rqdByJvCalculationType'] ==
                    RqdByJvCalculationType.formulaWith2Point5Jv.name
                ? RqdByJvCalculationType.formulaWith2Point5Jv
                : RqdByJvCalculationType.formulaWith3Point3Jv
            : null);
  }

  String toJson() => json.encode(toMap());

  factory BlockSize.fromJson(String source) =>
      BlockSize.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlockSize(numberOfJoints: $numberOfJoints, numberOfRandomSets: $numberOfRandomSets, jointSpacingInMeters: $jointSpacingInMeters, areaInSquareMeters: $areaInSquareMeters, jointVolume: $jointVolume, sumOfCorePieces: $sumOfCorePieces, totalDrillRun: $totalDrillRun, jointSetNumber: $jointSetNumber, rqdCalculationType: $rqdCalculationType, rqdByJvCalculationType: $rqdByJvCalculationType, rqd: $rqd)';
  }

  @override
  bool operator ==(covariant BlockSize other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.numberOfJoints == numberOfJoints &&
        other.numberOfRandomSets == numberOfRandomSets &&
        listEquals(other.jointSpacingInMeters, jointSpacingInMeters) &&
        other.areaInSquareMeters == areaInSquareMeters &&
        other.jointVolume == jointVolume &&
        other.sumOfCorePieces == sumOfCorePieces &&
        other.totalDrillRun == totalDrillRun &&
        other.rqdCalculationType == rqdCalculationType &&
        other.rqdByJvCalculationType == rqdByJvCalculationType &&
        other.jointSetNumber == jointSetNumber &&
        other.rqd == rqd;
  }

  @override
  int get hashCode {
    return numberOfJoints.hashCode ^
        numberOfRandomSets.hashCode ^
        jointSpacingInMeters.hashCode ^
        areaInSquareMeters.hashCode ^
        jointVolume.hashCode ^
        sumOfCorePieces.hashCode ^
        totalDrillRun.hashCode ^
        rqdCalculationType.hashCode ^
        rqdByJvCalculationType.hashCode ^
        jointSetNumber.hashCode ^
        rqd.hashCode;
  }
}

enum RqdCalculationType {
  jv,
  directMethod;
}

enum RqdByJvCalculationType { formulaWith2Point5Jv, formulaWith3Point3Jv }
