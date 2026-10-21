import 'dart:convert';
import 'package:flutter/foundation.dart';

class JointCharacter {
  /// [JR_USING_PALMSTROM]
  List<double>? jointWaviness;
  List<double>? jointSmoothness;

  JrCalculationType? jrCalculationType;

  List<double>? jointRoughness;
  List<double>? jointAlteration;

  JointCharacter({
    this.jointRoughness,
    this.jointWaviness,
    this.jointSmoothness,
    this.jrCalculationType,
    this.jointAlteration,
  });

  JointCharacter copyWith({
    List<double>? jointRoughness,
    List<double>? jointRoughnessQuotient,
    List<double>? jw,
    List<double>? js,
    JrCalculationType? jrCalculationType,
    List<double>? jointAlteration,
  }) {
    return JointCharacter(
      jointRoughness: jointRoughness ?? this.jointRoughness,
      jointWaviness: jw ?? jointWaviness,
      jointSmoothness: js ?? jointSmoothness,
      jrCalculationType: jrCalculationType ?? this.jrCalculationType,
      jointAlteration: jointAlteration ?? this.jointAlteration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jointRoughness': jointRoughness,
      'jw': jointWaviness,
      'js': jointSmoothness,
      'jrCalculationType': jrCalculationType?.name,
      'jointAlteration': jointAlteration,
    };
  }

  factory JointCharacter.fromMap(Map<String, dynamic> map) {
    return JointCharacter(
      jointRoughness:
          map['jointRoughness'] != null
              ? (map['jointRoughness'] is List
                  ? (map['jointRoughness'] as List)
                      .map((e) => (e as num).toDouble())
                      .toList()
                  : [(map['jointRoughness'] as num).toDouble()])
              : null,
      jointWaviness:
          map['jw'] != null
              ? (map['jw'] is List
                  ? (map['jw'] as List)
                      .map((e) => (e as num).toDouble())
                      .toList()
                  : [(map['jw'] as num).toDouble()])
              : null,
      jointSmoothness:
          map['js'] != null
              ? (map['js'] is List
                  ? (map['js'] as List)
                      .map((e) => (e as num).toDouble())
                      .toList()
                  : [(map['js'] as num).toDouble()])
              : null,
      jrCalculationType:
          map['jrCalculationType'] != null
              ? (map['jrCalculationType'] == JrCalculationType.jr.name ||
                      map['jrCalculationType'] == JrCalculationType.jr)
                  ? JrCalculationType.jr
                  : JrCalculationType.palmstorm
              : null,
      jointAlteration:
          map['jointAlteration'] != null
              ? (map['jointAlteration'] is List
                  ? (map['jointAlteration'] as List)
                      .map((e) => (e as num).toDouble())
                      .toList()
                  : [(map['jointAlteration'] as num).toDouble()])
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JointCharacter.fromJson(String source) =>
      JointCharacter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JointCharacter(jointRoughness: $jointRoughness, jw: $jointWaviness, js: $jointSmoothness, jrCalculationType: $jrCalculationType, jointAlteration: $jointAlteration)';
  }

  @override
  bool operator ==(covariant JointCharacter other) {
    if (identical(this, other)) return true;

    return listEquals(other.jointRoughness, jointRoughness) &&
        listEquals(other.jointWaviness, jointWaviness) &&
        listEquals(other.jointSmoothness, jointSmoothness) &&
        other.jrCalculationType == jrCalculationType &&
        listEquals(other.jointAlteration, jointAlteration);
  }

  @override
  int get hashCode {
    return Object.hashAll(jointRoughness ?? const []) ^
        Object.hashAll(jointWaviness ?? const []) ^
        Object.hashAll(jointSmoothness ?? const []) ^
        jrCalculationType.hashCode ^
        Object.hashAll(jointAlteration ?? const []);
  }
}

enum JrCalculationType { palmstorm, jr }
