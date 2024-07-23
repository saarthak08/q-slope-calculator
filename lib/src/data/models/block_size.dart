import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';

part 'block_size.g.dart';

@Embedded()
class BlockSize {
  /// [USING_Jv]
  int? numberOfJoints;
  int? numberOfRandomSets;
  List<int>? jointSpacingInMeters;
  double? areaInSquareMeters;
  double? jointVolume;

  /// [USING_DIRECT_METHOD]
  double? sumOfCorePieces;
  double? totalDrillRun;

  @Enumerated(EnumType.name)
  RqdCalculationType? rqdCalculationType;
  double rqd;

  BlockSize({
    this.numberOfJoints,
    this.numberOfRandomSets,
    this.jointSpacingInMeters,
    this.areaInSquareMeters,
    this.jointVolume,
    this.sumOfCorePieces,
    this.totalDrillRun,
    this.rqdCalculationType,
    this.rqd = 0,
  });

  BlockSize copyWith({
    int? numberOfJoints,
    int? numberOfRandomSets,
    List<int>? jointSpacingInMeters,
    double? areaInSquareMeters,
    double? jointVolume,
    double? sumOfCorePieces,
    double? totalDrillRun,
    RqdCalculationType? rqdCalculationType,
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
      rqd: rqd ?? this.rqd,
    );
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
      'rqd': rqd,
    };
  }

  factory BlockSize.fromMap(Map<String, dynamic> map) {
    return BlockSize(
      numberOfJoints:
          map['numberOfJoints'] != null ? map['numberOfJoints'] as int : null,
      numberOfRandomSets: map['numberOfRandomSets'] != null
          ? map['numberOfRandomSets'] as int
          : null,
      jointSpacingInMeters: map['jointSpacingInMeters'] != null
          ? List<int>.from((map['jointSpacingInMeters'] as List<int>))
          : null,
      areaInSquareMeters: map['areaInSquareMeters'] != null
          ? map['areaInSquareMeters'] as double
          : null,
      jointVolume:
          map['jointVolume'] != null ? map['jointVolume'] as double : null,
      sumOfCorePieces: map['sumOfCorePieces'] != null
          ? map['sumOfCorePieces'] as double
          : null,
      totalDrillRun:
          map['totalDrillRun'] != null ? map['totalDrillRun'] as double : null,
      rqdCalculationType: map['rqdCalculationType'] != null
          ? map['rqdCalculationType'] == RqdCalculationType.directMethod.name
              ? RqdCalculationType.directMethod
              : RqdCalculationType.jv
          : null,
      rqd: map['rqd'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockSize.fromJson(String source) =>
      BlockSize.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlockSize(numberOfJoints: $numberOfJoints, numberOfRandomSets: $numberOfRandomSets, jointSpacingInMeters: $jointSpacingInMeters, areaInSquareMeters: $areaInSquareMeters, jointVolume: $jointVolume, sumOfCorePieces: $sumOfCorePieces, totalDrillRun: $totalDrillRun, rqdCalculationType: $rqdCalculationType, rqd: $rqd)';
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
        rqd.hashCode;
  }
}

enum RqdCalculationType {
  jv,
  directMethod;
}
