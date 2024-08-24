import 'dart:convert';

class OFactor {
  double? oFactor;

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

  OFactor(
      {this.oFactor = 0,
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
      this.oFactorTypeOfFailure});

  OFactor copyWith(
      {double? oFactor,
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
      OFactorTypeOfFailure? oFactorTypeOfFailure}) {
    return OFactor(
        oFactor: oFactor ?? this.oFactor,
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
        oFactorTypeOfFailure:
            oFactorTypeOfFailure ?? this.oFactorTypeOfFailure);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'oFactor': oFactor,
      'oFactorCalculationType': oFactorCalculationType?.name,
      'f1': f1,
      'f2': f2,
      'f3': f3,
      'alphaI': alphaI,
      'alphaJ': alphaJ,
      'alphaS': alphaS,
      'betaI': betaI,
      'betaJ': betaJ,
      'betaS': betaS,
      'oFactorTypeOfFailure': oFactorTypeOfFailure?.name
    };
  }

  factory OFactor.fromMap(Map<String, dynamic> map) {
    return OFactor(
        oFactor: map['oFactor'] as double,
        oFactorCalculationType: map['oFactorCalculationType'] != null
            ? map['oFactorCalculationType'] ==
                    OFactorCalculationType.romanaAdjacentFactor.name
                ? OFactorCalculationType.romanaAdjacentFactor
                : OFactorCalculationType.value
            : null,
        f1: map['f1'] != null ? map['f1'] as double : null,
        f2: map['f2'] != null ? map['f2'] as double : null,
        f3: map['f3'] != null ? map['f3'] as double : null,
        alphaI: map['alphaI'] != null ? map['alphaI'] as double : null,
        alphaJ: map['alphaJ'] != null ? map['alphaJ'] as double : null,
        alphaS: map['alphaS'] != null ? map['alphaS'] as double : null,
        betaI: map['betaI'] != null ? map['betaI'] as double : null,
        betaJ: map['betaJ'] != null ? map['betaJ'] as double : null,
        betaS: map['betaS'] != null ? map['betaS'] as double : null,
        oFactorTypeOfFailure: map['oFactorTypeOfFailure'] != null
            ? map['oFactorTypeOfFailure'] == OFactorTypeOfFailure.planar.name
                ? OFactorTypeOfFailure.planar
                : map['oFactorTypeOfFailure'] ==
                        OFactorTypeOfFailure.toppling.name
                    ? OFactorTypeOfFailure.toppling
                    : OFactorTypeOfFailure.wedge
            : null);
  }

  String toJson() => json.encode(toMap());

  factory OFactor.fromJson(String source) =>
      OFactor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OFactor(oFactor: $oFactor, oFactorCalculationType: ${oFactorCalculationType?.name},  f1: $f1, f2: $f2, f3: $f3, alphaI: $alphaI, alphaJ: $alphaJ, alphaS: $alphaS, betaI: $betaI, betaJ: $betaJ, betaS: $betaS), oFactorTypeOfFailure: ${oFactorTypeOfFailure?.name}';
  }

  @override
  bool operator ==(covariant OFactor other) {
    if (identical(this, other)) return true;

    return other.oFactor == oFactor &&
        other.oFactorCalculationType == oFactorCalculationType &&
        other.f1 == f1 &&
        other.f2 == f2 &&
        other.f3 == f3 &&
        other.alphaI == alphaI &&
        other.alphaJ == alphaJ &&
        other.alphaS == alphaS &&
        other.betaI == betaI &&
        other.betaJ == betaJ &&
        other.betaS == betaS &&
        other.oFactorTypeOfFailure == oFactorTypeOfFailure;
  }

  @override
  int get hashCode {
    return oFactor.hashCode ^
        oFactorCalculationType.hashCode ^
        f1.hashCode ^
        f2.hashCode ^
        f3.hashCode ^
        alphaI.hashCode ^
        alphaJ.hashCode ^
        alphaS.hashCode ^
        betaI.hashCode ^
        betaJ.hashCode ^
        betaS.hashCode ^
        oFactorTypeOfFailure.hashCode;
  }
}

enum OFactorCalculationType { romanaAdjacentFactor, value }

enum OFactorTypeOfFailure { planar, wedge, toppling }
