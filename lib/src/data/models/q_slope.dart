import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';

part 'q_slope.g.dart';

@Collection()
class QSlope {
  Id id = Isar.autoIncrement;

  String locationId;

  String lithology;

  late BlockSize blockSize;

  late JointCharacter jointCharacter;

  late OFactor oFactor;

  late ExternalFactors externalFactors;

  late ActiveStress activeStress;

  late double qSlope;

  DateTime createdAt;

  QSlope({
    required this.id,
    required this.locationId,
    required this.lithology,
    required this.blockSize,
    required this.jointCharacter,
    required this.oFactor,
    required this.externalFactors,
    required this.activeStress,
    required this.qSlope,
    required this.createdAt,
  });

  QSlope copyWith({
    Id? id,
    String? locationId,
    String? lithology,
    BlockSize? blockSize,
    JointCharacter? jointCharacter,
    OFactor? oFactor,
    ExternalFactors? externalFactors,
    ActiveStress? activeStress,
    double? qSlope,
    DateTime? createdAt,
  }) {
    return QSlope(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      lithology: lithology ?? this.lithology,
      blockSize: blockSize ?? this.blockSize,
      jointCharacter: jointCharacter ?? this.jointCharacter,
      oFactor: oFactor ?? this.oFactor,
      externalFactors: externalFactors ?? this.externalFactors,
      activeStress: activeStress ?? this.activeStress,
      qSlope: qSlope ?? this.qSlope,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toInt(),
      'locationId': locationId,
      'lithology': lithology,
      'blockSize': blockSize.toMap(),
      'jointCharacter': jointCharacter.toMap(),
      'oFactor': oFactor.toMap(),
      'externalFactors': externalFactors.toMap(),
      'activeStress': activeStress.toMap(),
      'qSlope': qSlope.toDouble(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory QSlope.fromMap(Map<String, dynamic> map) {
    return QSlope(
      id: Id.parse(map['id']),
      locationId: map['locationId'] as String,
      lithology: map['lithology'] as String,
      blockSize: BlockSize.fromMap(map['blockSize'] as Map<String, dynamic>),
      jointCharacter:
          JointCharacter.fromMap(map['jointCharacter'] as Map<String, dynamic>),
      oFactor: OFactor.fromMap(map['oFactor'] as Map<String, dynamic>),
      externalFactors: ExternalFactors.fromMap(
          map['externalFactors'] as Map<String, dynamic>),
      activeStress:
          ActiveStress.fromMap(map['activeStress'] as Map<String, dynamic>),
      qSlope: double.parse(map['qSlope']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory QSlope.fromJson(String source) =>
      QSlope.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QSlope(id: $id, locationId: $locationId, lithology: $lithology, blockSize: $blockSize, jointCharacter: $jointCharacter, oFactor: $oFactor, externalFactors: $externalFactors, activeStress: $activeStress, qSlope: $qSlope, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant QSlope other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.locationId == locationId &&
        other.lithology == lithology &&
        other.blockSize == blockSize &&
        other.jointCharacter == jointCharacter &&
        other.oFactor == oFactor &&
        other.externalFactors == externalFactors &&
        other.activeStress == activeStress &&
        other.qSlope == qSlope &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        locationId.hashCode ^
        lithology.hashCode ^
        blockSize.hashCode ^
        jointCharacter.hashCode ^
        oFactor.hashCode ^
        externalFactors.hashCode ^
        activeStress.hashCode ^
        qSlope.hashCode ^
        createdAt.hashCode;
  }
}
