import 'dart:convert';

class JointCharacter {
  /// [JR_USING_JRC]
  double? jointRoughnessQuotient;

  /// [JR_USING_JW_JS]
  double? jw;
  double? js;

  JrCalculationType? jrCalculationType;
  double jointRoughness;

  double jointAlteration;

  JointCharacter({
    this.jointRoughness = 0,
    this.jointRoughnessQuotient,
    this.jw,
    this.js,
    this.jrCalculationType,
    this.jointAlteration = 0,
  });

  JointCharacter copyWith({
    double? jointRoughness,
    double? jointRoughnessQuotient,
    double? jw,
    double? js,
    JrCalculationType? jrCalculationType,
    double? jointAlteration,
  }) {
    return JointCharacter(
      jointRoughness: jointRoughness ?? this.jointRoughness,
      jointRoughnessQuotient:
          jointRoughnessQuotient ?? this.jointRoughnessQuotient,
      jw: jw ?? this.jw,
      js: js ?? this.js,
      jrCalculationType: jrCalculationType ?? this.jrCalculationType,
      jointAlteration: jointAlteration ?? this.jointAlteration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jointRoughness': jointRoughness,
      'jointRoughnessQuotient': jointRoughnessQuotient,
      'jw': jw,
      'js': js,
      'jrCalculationType': jrCalculationType?.name,
      'jointAlteration': jointAlteration,
    };
  }

  factory JointCharacter.fromMap(Map<String, dynamic> map) {
    return JointCharacter(
      jointRoughness: map['jointRoughness'] as double,
      jointRoughnessQuotient: map['jointRoughnessQuotient'] != null
          ? map['jointRoughnessQuotient'] as double
          : null,
      jw: map['jw'] != null ? map['jw'] as double : null,
      js: map['js'] != null ? map['js'] as double : null,
      jrCalculationType: map['jrCalculationType'] != null
          ? map['jrCalculationType'] == JrCalculationType.jr.name
              ? JrCalculationType.jr
              : map['jrCalculationType'] == JrCalculationType.jrc.name
                  ? JrCalculationType.jrc
                  : JrCalculationType.palmstorm
          : null,
      jointAlteration: map['jointAlteration'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory JointCharacter.fromJson(String source) =>
      JointCharacter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JointCharacter(jointRoughness: $jointRoughness, jointRoughnessQuotient: $jointRoughnessQuotient, jw: $jw, js: $js, jrCalculationType: $jrCalculationType, jointAlteration: $jointAlteration)';
  }

  @override
  bool operator ==(covariant JointCharacter other) {
    if (identical(this, other)) return true;

    return other.jointRoughness == jointRoughness &&
        other.jointRoughnessQuotient == jointRoughnessQuotient &&
        other.jw == jw &&
        other.js == js &&
        other.jrCalculationType == jrCalculationType &&
        other.jointAlteration == jointAlteration;
  }

  @override
  int get hashCode {
    return jointRoughness.hashCode ^
        jointRoughnessQuotient.hashCode ^
        jw.hashCode ^
        js.hashCode ^
        jrCalculationType.hashCode ^
        jointAlteration.hashCode;
  }
}

enum JrCalculationType {
  jrc,
  palmstorm,
  jr;
}
