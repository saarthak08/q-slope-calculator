import 'dart:convert';

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
      jointRoughness: map['jointRoughness'] != null
          ? (map['jointRoughness'] as List).cast<double>()
          : null,
      jointWaviness:
          map['jw'] != null ? (map['jw'] as List).cast<double>() : null,
      jointSmoothness:
          map['js'] != null ? (map['js'] as List).cast<double>() : null,
      jrCalculationType: map['jrCalculationType'] != null
          ? map['jrCalculationType'] == JrCalculationType.jr.name
              ? JrCalculationType.jr
              : JrCalculationType.palmstorm
          : null,
      jointAlteration: map['jointAlteration'] != null
          ? (map['jointAlteration'] as List).cast<double>()
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

    return other.jointRoughness == jointRoughness &&
        other.jointWaviness == jointWaviness &&
        other.jointSmoothness == jointSmoothness &&
        other.jrCalculationType == jrCalculationType &&
        other.jointAlteration == jointAlteration;
  }

  @override
  int get hashCode {
    return jointRoughness.hashCode ^
        jointWaviness.hashCode ^
        jointSmoothness.hashCode ^
        jrCalculationType.hashCode ^
        jointAlteration.hashCode;
  }
}

enum JrCalculationType {
  palmstorm,
  jr;
}
