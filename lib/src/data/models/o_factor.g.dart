// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_factor.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const OFactorSchema = Schema(
  name: r'OFactor',
  id: -2382284641291778574,
  properties: {
    r'alphaI': PropertySchema(
      id: 0,
      name: r'alphaI',
      type: IsarType.double,
    ),
    r'alphaJ': PropertySchema(
      id: 1,
      name: r'alphaJ',
      type: IsarType.double,
    ),
    r'alphaS': PropertySchema(
      id: 2,
      name: r'alphaS',
      type: IsarType.double,
    ),
    r'betaI': PropertySchema(
      id: 3,
      name: r'betaI',
      type: IsarType.double,
    ),
    r'betaJ': PropertySchema(
      id: 4,
      name: r'betaJ',
      type: IsarType.double,
    ),
    r'betaS': PropertySchema(
      id: 5,
      name: r'betaS',
      type: IsarType.double,
    ),
    r'f1': PropertySchema(
      id: 6,
      name: r'f1',
      type: IsarType.double,
    ),
    r'f2': PropertySchema(
      id: 7,
      name: r'f2',
      type: IsarType.double,
    ),
    r'f3': PropertySchema(
      id: 8,
      name: r'f3',
      type: IsarType.double,
    ),
    r'hashCode': PropertySchema(
      id: 9,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'oFactor': PropertySchema(
      id: 10,
      name: r'oFactor',
      type: IsarType.double,
    ),
    r'oFactorCalculationType': PropertySchema(
      id: 11,
      name: r'oFactorCalculationType',
      type: IsarType.string,
      enumMap: _OFactoroFactorCalculationTypeEnumValueMap,
    ),
    r'oFactorTypeOfFailure': PropertySchema(
      id: 12,
      name: r'oFactorTypeOfFailure',
      type: IsarType.string,
      enumMap: _OFactoroFactorTypeOfFailureEnumValueMap,
    )
  },
  estimateSize: _oFactorEstimateSize,
  serialize: _oFactorSerialize,
  deserialize: _oFactorDeserialize,
  deserializeProp: _oFactorDeserializeProp,
);

int _oFactorEstimateSize(
  OFactor object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.oFactorCalculationType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.oFactorTypeOfFailure;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _oFactorSerialize(
  OFactor object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.alphaI);
  writer.writeDouble(offsets[1], object.alphaJ);
  writer.writeDouble(offsets[2], object.alphaS);
  writer.writeDouble(offsets[3], object.betaI);
  writer.writeDouble(offsets[4], object.betaJ);
  writer.writeDouble(offsets[5], object.betaS);
  writer.writeDouble(offsets[6], object.f1);
  writer.writeDouble(offsets[7], object.f2);
  writer.writeDouble(offsets[8], object.f3);
  writer.writeLong(offsets[9], object.hashCode);
  writer.writeDouble(offsets[10], object.oFactor);
  writer.writeString(offsets[11], object.oFactorCalculationType?.name);
  writer.writeString(offsets[12], object.oFactorTypeOfFailure?.name);
}

OFactor _oFactorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OFactor(
    alphaI: reader.readDoubleOrNull(offsets[0]),
    alphaJ: reader.readDoubleOrNull(offsets[1]),
    alphaS: reader.readDoubleOrNull(offsets[2]),
    betaI: reader.readDoubleOrNull(offsets[3]),
    betaJ: reader.readDoubleOrNull(offsets[4]),
    betaS: reader.readDoubleOrNull(offsets[5]),
    f1: reader.readDoubleOrNull(offsets[6]),
    f2: reader.readDoubleOrNull(offsets[7]),
    f3: reader.readDoubleOrNull(offsets[8]),
    oFactor: reader.readDoubleOrNull(offsets[10]) ?? 0,
    oFactorCalculationType: _OFactoroFactorCalculationTypeValueEnumMap[
        reader.readStringOrNull(offsets[11])],
    oFactorTypeOfFailure: _OFactoroFactorTypeOfFailureValueEnumMap[
        reader.readStringOrNull(offsets[12])],
  );
  return object;
}

P _oFactorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 11:
      return (_OFactoroFactorCalculationTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 12:
      return (_OFactoroFactorTypeOfFailureValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OFactoroFactorCalculationTypeEnumValueMap = {
  r'romanaAdjacentFactor': r'romanaAdjacentFactor',
  r'value': r'value',
};
const _OFactoroFactorCalculationTypeValueEnumMap = {
  r'romanaAdjacentFactor': OFactorCalculationType.romanaAdjacentFactor,
  r'value': OFactorCalculationType.value,
};
const _OFactoroFactorTypeOfFailureEnumValueMap = {
  r'planar': r'planar',
  r'wedge': r'wedge',
  r'toppling': r'toppling',
};
const _OFactoroFactorTypeOfFailureValueEnumMap = {
  r'planar': OFactorTypeOfFailure.planar,
  r'wedge': OFactorTypeOfFailure.wedge,
  r'toppling': OFactorTypeOfFailure.toppling,
};

extension OFactorQueryFilter
    on QueryBuilder<OFactor, OFactor, QFilterCondition> {
  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaIIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alphaI',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaIIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alphaI',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaIEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alphaI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaIGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alphaI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaILessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alphaI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaIBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alphaI',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaJIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alphaJ',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaJIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alphaJ',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaJEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alphaJ',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaJGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alphaJ',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaJLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alphaJ',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaJBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alphaJ',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaSIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alphaS',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaSIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alphaS',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaSEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alphaS',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaSGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alphaS',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaSLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alphaS',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> alphaSBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alphaS',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaIIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'betaI',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaIIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'betaI',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaIEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'betaI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaIGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'betaI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaILessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'betaI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaIBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'betaI',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaJIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'betaJ',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaJIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'betaJ',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaJEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'betaJ',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaJGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'betaJ',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaJLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'betaJ',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaJBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'betaJ',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaSIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'betaS',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaSIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'betaS',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaSEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'betaS',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaSGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'betaS',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaSLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'betaS',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> betaSBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'betaS',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f1IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'f1',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f1IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'f1',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f1EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'f1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f1GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'f1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f1LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'f1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f1Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'f1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'f2',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'f2',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f2EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'f2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f2GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'f2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f2LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'f2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f2Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'f2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f3IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'f3',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f3IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'f3',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f3EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'f3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f3GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'f3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f3LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'f3',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> f3Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'f3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> oFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> oFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'oFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> oFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'oFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition> oFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'oFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'oFactorCalculationType',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'oFactorCalculationType',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeEqualTo(
    OFactorCalculationType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oFactorCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeGreaterThan(
    OFactorCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'oFactorCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeLessThan(
    OFactorCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'oFactorCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeBetween(
    OFactorCalculationType? lower,
    OFactorCalculationType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'oFactorCalculationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'oFactorCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'oFactorCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'oFactorCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'oFactorCalculationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oFactorCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorCalculationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'oFactorCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'oFactorTypeOfFailure',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'oFactorTypeOfFailure',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureEqualTo(
    OFactorTypeOfFailure? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oFactorTypeOfFailure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureGreaterThan(
    OFactorTypeOfFailure? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'oFactorTypeOfFailure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureLessThan(
    OFactorTypeOfFailure? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'oFactorTypeOfFailure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureBetween(
    OFactorTypeOfFailure? lower,
    OFactorTypeOfFailure? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'oFactorTypeOfFailure',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'oFactorTypeOfFailure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'oFactorTypeOfFailure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'oFactorTypeOfFailure',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'oFactorTypeOfFailure',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oFactorTypeOfFailure',
        value: '',
      ));
    });
  }

  QueryBuilder<OFactor, OFactor, QAfterFilterCondition>
      oFactorTypeOfFailureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'oFactorTypeOfFailure',
        value: '',
      ));
    });
  }
}

extension OFactorQueryObject
    on QueryBuilder<OFactor, OFactor, QFilterCondition> {}
