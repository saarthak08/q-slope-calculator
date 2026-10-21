import 'dart:convert';

class OFactor {
  OFactorCalculationType? oFactorCalculationType;

  /// [ROMANA_ADJUSTMENT_FACTOR]
  double? f1;
  double? f2;
  double? f3;

  // TREND OF THE INTERSECTION LINE IN CASE OF THE WEDGE
  double? alphaI;

  // DISCONTINUITY DIP DIRECTION
  double? alphaJ;

  // SLOPE DIP DIRECTION
  double? alphaS;

  // PLUNGE OF THE INTERSECTION LINE
  double? betaI;

  // DIP OF THE DISCONTINUITY
  double? betaJ;

  // DIP OF THE SLOPE
  double? betaS;

  // TYPE OF FAILURE
  OFactorTypeOfFailure? oFactorTypeOfFailure;

  int? indexOfFirstJoint;

  int? indexOfSecondJoint;

  double? oFactorForFirstJoint;

  double? oFactorForSecondJoint;

  double? ratingForF1;

  double? ratingForF2;

  double? ratingForF3;

  OFactorRomanaValueType? oFactorRomanaValueType;

  OFactor({
    this.oFactorCalculationType,
    this.f1,
    this.f2,
    this.f3,
    this.alphaI,
    this.alphaJ,
    this.alphaS,
    this.betaI,
    this.betaJ,
    this.betaS,
    this.indexOfFirstJoint,
    this.indexOfSecondJoint,
    this.oFactorForFirstJoint,
    this.oFactorForSecondJoint,
    this.oFactorTypeOfFailure,
    this.ratingForF1,
    this.ratingForF2,
    this.ratingForF3,
    this.oFactorRomanaValueType,
  });

  OFactor copyWith({
    double? oFactor,
    OFactorCalculationType? oFactorCalculationType,
    double? f1,
    double? f2,
    double? f3,
    double? alphaI,
    double? alphaJ,
    double? alphaS,
    double? betaI,
    double? betaJ,
    double? betaS,
    int? indexOfFirstJoint,
    int? indexOfSecondJoint,
    double? oFactorForFirstJoint,
    double? oFactorForSecondJoint,
    double? ratingForF1,
    double? ratingForF2,
    double? ratingForF3,
    OFactorTypeOfFailure? oFactorTypeOfFailure,
    OFactorRomanaValueType? oFactorRomanaValueType,
  }) {
    return OFactor(
      oFactorCalculationType:
          oFactorCalculationType ?? this.oFactorCalculationType,
      f1: f1 ?? this.f1,
      f2: f2 ?? this.f2,
      f3: f3 ?? this.f3,
      alphaI: alphaI ?? this.alphaI,
      alphaJ: alphaJ ?? this.alphaJ,
      alphaS: alphaS ?? this.alphaS,
      betaI: betaI ?? this.betaI,
      betaJ: betaJ ?? this.betaJ,
      betaS: betaS ?? this.betaS,
      ratingForF1: ratingForF1 ?? this.ratingForF1,
      ratingForF2: ratingForF2 ?? this.ratingForF2,
      ratingForF3: ratingForF3 ?? this.ratingForF3,
      indexOfFirstJoint: indexOfFirstJoint ?? this.indexOfFirstJoint,
      indexOfSecondJoint: indexOfSecondJoint ?? this.indexOfSecondJoint,
      oFactorForFirstJoint: oFactorForFirstJoint ?? this.oFactorForFirstJoint,
      oFactorForSecondJoint:
          oFactorForSecondJoint ?? this.oFactorForSecondJoint,
      oFactorTypeOfFailure: oFactorTypeOfFailure ?? this.oFactorTypeOfFailure,
      oFactorRomanaValueType:
          oFactorRomanaValueType ?? this.oFactorRomanaValueType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'oFactorCalculationType': oFactorCalculationType?.name,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'ratingForF1': ratingForF1,
      'ratingForF2': ratingForF2,
      'ratingForF3': ratingForF3,
      'alphaI': alphaI,
      'alphaJ': alphaJ,
      'alphaS': alphaS,
      'betaI': betaI,
      'betaJ': betaJ,
      'betaS': betaS,
      'indexOfFirstJoint': indexOfFirstJoint,
      'indexOfSecondJoint': indexOfSecondJoint,
      'oFactorForFirstJoint': oFactorForFirstJoint,
      'oFactorForSecondJoint': oFactorForSecondJoint,
      'oFactorTypeOfFailure': oFactorTypeOfFailure?.name,
      'oFactorRomanaValueType': oFactorRomanaValueType?.name,
    };
  }

  factory OFactor.fromMap(Map<String, dynamic> map) {
    return OFactor(
      oFactorCalculationType:
          map['oFactorCalculationType'] != null
              ? (map['oFactorCalculationType'] ==
                          OFactorCalculationType.romanaAdjacentFactor.name ||
                      map['oFactorCalculationType'] ==
                          OFactorCalculationType.romanaAdjacentFactor)
                  ? OFactorCalculationType.romanaAdjacentFactor
                  : OFactorCalculationType.value
              : null,
      oFactorRomanaValueType:
          map['oFactorRomanaValueType'] != null
              ? (map['oFactorRomanaValueType'] ==
                          OFactorRomanaValueType.value.name ||
                      map['oFactorRomanaValueType'] ==
                          OFactorRomanaValueType.value)
                  ? OFactorRomanaValueType.value
                  : OFactorRomanaValueType.calculation
              : null,
      f1: (map['f1'] as num?)?.toDouble(),
      f2: (map['f2'] as num?)?.toDouble(),
      f3: (map['f3'] as num?)?.toDouble(),
      alphaI: (map['alphaI'] as num?)?.toDouble(),
      alphaJ: (map['alphaJ'] as num?)?.toDouble(),
      alphaS: (map['alphaS'] as num?)?.toDouble(),
      betaI: (map['betaI'] as num?)?.toDouble(),
      betaJ: (map['betaJ'] as num?)?.toDouble(),
      betaS: (map['betaS'] as num?)?.toDouble(),
      ratingForF1: (map['ratingForF1'] as num?)?.toDouble(),
      ratingForF2: (map['ratingForF2'] as num?)?.toDouble(),
      ratingForF3: (map['ratingForF3'] as num?)?.toDouble(),
      indexOfFirstJoint: (map['indexOfFirstJoint'] as num?)?.toInt(),
      indexOfSecondJoint: (map['indexOfSecondJoint'] as num?)?.toInt(),
      oFactorForFirstJoint:
          map['oFactorForFirstJoint'] != null
              ? (map['oFactorForFirstJoint'] as num).toDouble()
              : (map['oFactor'] != null
                  ? (map['oFactor'] as num).toDouble()
                  : null),
      oFactorForSecondJoint:
          map['oFactorForSecondJoint'] != null
              ? (map['oFactorForSecondJoint'] as num).toDouble()
              : null,
      oFactorTypeOfFailure:
          map['oFactorTypeOfFailure'] != null
              ? (map['oFactorTypeOfFailure'] ==
                          OFactorTypeOfFailure.planar.name ||
                      map['oFactorTypeOfFailure'] ==
                          OFactorTypeOfFailure.planar)
                  ? OFactorTypeOfFailure.planar
                  : (map['oFactorTypeOfFailure'] ==
                          OFactorTypeOfFailure.toppling.name ||
                      map['oFactorTypeOfFailure'] ==
                          OFactorTypeOfFailure.toppling)
                  ? OFactorTypeOfFailure.toppling
                  : OFactorTypeOfFailure.wedge
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OFactor.fromJson(String source) =>
      OFactor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OFactor(ratingForF1: $ratingForF1, ratingForF2: $ratingForF2, ratingForF3: $ratingForF3, indexOfFirstJoint: $indexOfFirstJoint, indexOfSecondJoint: $indexOfSecondJoint, oFactorForFirstJoint: $oFactorForFirstJoint, oFactorForSecondJoint: $oFactorForSecondJoint, oFactorCalculationType: ${oFactorCalculationType?.name},  f1: $f1, f2: $f2, f3: $f3, alphaI: $alphaI, alphaJ: $alphaJ, alphaS: $alphaS, betaI: $betaI, betaJ: $betaJ, betaS: $betaS), oFactorTypeOfFailure: ${oFactorTypeOfFailure?.name}, oFactorRomanaValueType: ${oFactorRomanaValueType?.name}';
  }

  @override
  bool operator ==(covariant OFactor other) {
    if (identical(this, other)) return true;

    return other.oFactorCalculationType == oFactorCalculationType &&
        other.f1 == f1 &&
        other.f2 == f2 &&
        other.f3 == f3 &&
        other.ratingForF1 == ratingForF1 &&
        other.ratingForF2 == ratingForF2 &&
        other.ratingForF3 == ratingForF3 &&
        other.alphaI == alphaI &&
        other.alphaJ == alphaJ &&
        other.alphaS == alphaS &&
        other.betaI == betaI &&
        other.betaJ == betaJ &&
        other.betaS == betaS &&
        other.indexOfFirstJoint == indexOfFirstJoint &&
        other.indexOfSecondJoint == indexOfSecondJoint &&
        other.oFactorForFirstJoint == oFactorForFirstJoint &&
        other.oFactorForSecondJoint == oFactorForSecondJoint &&
        other.oFactorTypeOfFailure == oFactorTypeOfFailure &&
        other.oFactorRomanaValueType == oFactorRomanaValueType;
  }

  @override
  int get hashCode {
    return oFactorCalculationType.hashCode ^
        f1.hashCode ^
        f2.hashCode ^
        f3.hashCode ^
        ratingForF1.hashCode ^
        ratingForF2.hashCode ^
        ratingForF3.hashCode ^
        alphaI.hashCode ^
        alphaJ.hashCode ^
        alphaS.hashCode ^
        betaI.hashCode ^
        betaJ.hashCode ^
        betaS.hashCode ^
        indexOfFirstJoint.hashCode ^
        indexOfSecondJoint.hashCode ^
        oFactorForFirstJoint.hashCode ^
        oFactorForSecondJoint.hashCode ^
        oFactorTypeOfFailure.hashCode ^
        oFactorRomanaValueType.hashCode;
  }
}

enum OFactorCalculationType { romanaAdjacentFactor, value }

enum OFactorTypeOfFailure { planar, wedge, toppling }

enum OFactorRomanaValueType { calculation, value }
