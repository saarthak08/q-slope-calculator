import 'dart:convert';

class ActiveStress {
  double? srfA;
  double? srfB;
  double? srfC;

  /// [MAX_AMONG_SRFA_SRFB_SRFC]
  double? srf;

  ActiveStress({
    this.srfA = 0,
    this.srfB = 0,
    this.srfC = 0,
    this.srf = 0,
  });

  ActiveStress copyWith({
    double? srfA,
    double? srfB,
    double? srfC,
    double? srf,
  }) {
    return ActiveStress(
      srfA: srfA ?? this.srfA,
      srfB: srfB ?? this.srfB,
      srfC: srfC ?? this.srfC,
      srf: srf ?? this.srf,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'srfA': srfA,
      'srfB': srfB,
      'srfC': srfC,
      'srf': srf,
    };
  }

  factory ActiveStress.fromMap(Map<String, dynamic> map) {
    return ActiveStress(
      srfA: map['srfA'] as double,
      srfB: map['srfB'] as double,
      srfC: map['srfC'] as double,
      srf: map['srf'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActiveStress.fromJson(String source) =>
      ActiveStress.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActiveStress(srfA: $srfA, srfB: $srfB, srfC: $srfC, srf: $srf)';
  }

  @override
  bool operator ==(covariant ActiveStress other) {
    if (identical(this, other)) return true;

    return other.srfA == srfA &&
        other.srfB == srfB &&
        other.srfC == srfC &&
        other.srf == srf;
  }

  @override
  int get hashCode {
    return srfA.hashCode ^ srfB.hashCode ^ srfC.hashCode ^ srf.hashCode;
  }
}
