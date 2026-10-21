import 'dart:convert';

class ExternalFactors {
  /// [J_WICE]
  double? environmentalAndGeologicalConditionalNumber;

  ExternalFactorsStructureType? externalFactorsStructureType;

  ExternalFactorsStrengthOfRock? externalFactorsStrengthOfRock;

  ExternalFactorsEnvironmentConditions? externalFactorsEnvironmentConditions;

  ExternalFactorsCalculationType? externalFactorsCalculationType;

  ExternalFactors({
    this.environmentalAndGeologicalConditionalNumber = 0,
    this.externalFactorsStructureType,
    this.externalFactorsStrengthOfRock,
    this.externalFactorsEnvironmentConditions,
    this.externalFactorsCalculationType,
  });

  ExternalFactors copyWith({
    double? environmentalAndGeologicalConditionalNumber,
    ExternalFactorsStructureType? externalFactorsStructureType,
    ExternalFactorsStrengthOfRock? externalFactorsStrengthOfRock,
    ExternalFactorsEnvironmentConditions? externalFactorsEnvironmentConditions,
    ExternalFactorsCalculationType? externalFactorsCalculationType,
  }) {
    return ExternalFactors(
      environmentalAndGeologicalConditionalNumber:
          environmentalAndGeologicalConditionalNumber ??
          this.environmentalAndGeologicalConditionalNumber,
      externalFactorsStructureType:
          externalFactorsStructureType ?? this.externalFactorsStructureType,
      externalFactorsStrengthOfRock:
          externalFactorsStrengthOfRock ?? this.externalFactorsStrengthOfRock,
      externalFactorsEnvironmentConditions:
          externalFactorsEnvironmentConditions ??
          this.externalFactorsEnvironmentConditions,
      externalFactorsCalculationType:
          externalFactorsCalculationType ?? this.externalFactorsCalculationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'environmentalAndGeologicalConditionalNumber':
          environmentalAndGeologicalConditionalNumber,
      'externalFactorsStructureType': externalFactorsStructureType?.name,
      'externalFactorsStrengthOfRock': externalFactorsStrengthOfRock?.name,
      'externalFactorsEnvironmentConditions':
          externalFactorsEnvironmentConditions?.name,
      'externalFactorsCalculationType': externalFactorsCalculationType?.name,
    };
  }

  factory ExternalFactors.fromMap(Map<String, dynamic> map) {
    return ExternalFactors(
      environmentalAndGeologicalConditionalNumber:
          (map['environmentalAndGeologicalConditionalNumber'] as num?)
              ?.toDouble(),
      externalFactorsStrengthOfRock:
          map['externalFactorsStrengthOfRock'] != null
              ? (map['externalFactorsStrengthOfRock'] ==
                          ExternalFactorsStrengthOfRock.competent.name ||
                      map['externalFactorsStrengthOfRock'] ==
                          ExternalFactorsStrengthOfRock.competent)
                  ? ExternalFactorsStrengthOfRock.competent
                  : ExternalFactorsStrengthOfRock.incompetent
              : null,
      externalFactorsStructureType:
          map['externalFactorsStructureType'] != null
              ? (map['externalFactorsStructureType'] ==
                          ExternalFactorsStructureType.stable.name ||
                      map['externalFactorsStructureType'] ==
                          ExternalFactorsStructureType.stable)
                  ? ExternalFactorsStructureType.stable
                  : ExternalFactorsStructureType.unstable
              : null,
      externalFactorsCalculationType:
          map['externalFactorsCalculationType'] != null
              ? (map['externalFactorsCalculationType'] ==
                          ExternalFactorsCalculationType.value.name ||
                      map['externalFactorsCalculationType'] ==
                          ExternalFactorsCalculationType.value)
                  ? ExternalFactorsCalculationType.value
                  : ExternalFactorsCalculationType.factors
              : null,
      externalFactorsEnvironmentConditions:
          map['externalFactorsEnvironmentConditions'] != null
              ? (map['externalFactorsEnvironmentConditions'] ==
                          ExternalFactorsEnvironmentConditions
                              .desertEnvironment
                              .name ||
                      map['externalFactorsEnvironmentConditions'] ==
                          ExternalFactorsEnvironmentConditions
                              .desertEnvironment)
                  ? ExternalFactorsEnvironmentConditions.desertEnvironment
                  : (map['externalFactorsEnvironmentConditions'] ==
                          ExternalFactorsEnvironmentConditions
                              .iceWedging
                              .name ||
                      map['externalFactorsEnvironmentConditions'] ==
                          ExternalFactorsEnvironmentConditions.iceWedging)
                  ? ExternalFactorsEnvironmentConditions.iceWedging
                  : (map['externalFactorsEnvironmentConditions'] ==
                          ExternalFactorsEnvironmentConditions
                              .tropicalStorms
                              .name ||
                      map['externalFactorsEnvironmentConditions'] ==
                          ExternalFactorsEnvironmentConditions.tropicalStorms)
                  ? ExternalFactorsEnvironmentConditions.tropicalStorms
                  : ExternalFactorsEnvironmentConditions.wetEnvironment
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExternalFactors.fromJson(String source) =>
      ExternalFactors.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ExternalFactors(externalFactorsCalculationType: $externalFactorsCalculationType, environmentalAndGeologicalConditionalNumber: $environmentalAndGeologicalConditionalNumber, externalFactorsStrengthOfRock: ${externalFactorsStrengthOfRock?.name}, externalFactorsStructureType: ${externalFactorsStructureType?.name}, externalFactorsEnvironmentConditions: ${externalFactorsEnvironmentConditions?.name})';

  @override
  bool operator ==(covariant ExternalFactors other) {
    if (identical(this, other)) return true;

    return other.environmentalAndGeologicalConditionalNumber ==
            environmentalAndGeologicalConditionalNumber &&
        other.externalFactorsStructureType == externalFactorsStructureType &&
        other.externalFactorsStrengthOfRock == externalFactorsStrengthOfRock &&
        other.externalFactorsEnvironmentConditions ==
            externalFactorsEnvironmentConditions &&
        other.externalFactorsCalculationType == externalFactorsCalculationType;
  }

  @override
  int get hashCode =>
      environmentalAndGeologicalConditionalNumber.hashCode ^
      externalFactorsStructureType.hashCode ^
      externalFactorsStrengthOfRock.hashCode ^
      externalFactorsEnvironmentConditions.hashCode ^
      externalFactorsCalculationType.hashCode;
}

enum ExternalFactorsStructureType { stable, unstable }

enum ExternalFactorsStrengthOfRock { competent, incompetent }

enum ExternalFactorsEnvironmentConditions {
  desertEnvironment,
  wetEnvironment,
  tropicalStorms,
  iceWedging,
}

enum ExternalFactorsCalculationType { value, factors }
