// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_stress.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ActiveStressSchema = Schema(
  name: r'ActiveStress',
  id: 7295631612545821992,
  properties: {
    r'hashCode': PropertySchema(
      id: 0,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'srf': PropertySchema(
      id: 1,
      name: r'srf',
      type: IsarType.double,
    ),
    r'srfA': PropertySchema(
      id: 2,
      name: r'srfA',
      type: IsarType.double,
    ),
    r'srfB': PropertySchema(
      id: 3,
      name: r'srfB',
      type: IsarType.double,
    ),
    r'srfC': PropertySchema(
      id: 4,
      name: r'srfC',
      type: IsarType.double,
    )
  },
  estimateSize: _activeStressEstimateSize,
  serialize: _activeStressSerialize,
  deserialize: _activeStressDeserialize,
  deserializeProp: _activeStressDeserializeProp,
);

int _activeStressEstimateSize(
  ActiveStress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _activeStressSerialize(
  ActiveStress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeDouble(offsets[1], object.srf);
  writer.writeDouble(offsets[2], object.srfA);
  writer.writeDouble(offsets[3], object.srfB);
  writer.writeDouble(offsets[4], object.srfC);
}

ActiveStress _activeStressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ActiveStress(
    srf: reader.readDoubleOrNull(offsets[1]) ?? 0,
    srfA: reader.readDoubleOrNull(offsets[2]) ?? 0,
    srfB: reader.readDoubleOrNull(offsets[3]) ?? 0,
    srfC: reader.readDoubleOrNull(offsets[4]) ?? 0,
  );
  return object;
}

P _activeStressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ActiveStressQueryFilter
    on QueryBuilder<ActiveStress, ActiveStress, QFilterCondition> {
  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      hashCodeGreaterThan(
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

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      hashCodeLessThan(
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

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      hashCodeBetween(
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

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'srf',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      srfGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'srf',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'srf',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'srf',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfAEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'srfA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      srfAGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'srfA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfALessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'srfA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfABetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'srfA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfBEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'srfB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      srfBGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'srfB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfBLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'srfB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfBBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'srfB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'srfC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition>
      srfCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'srfC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'srfC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ActiveStress, ActiveStress, QAfterFilterCondition> srfCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'srfC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ActiveStressQueryObject
    on QueryBuilder<ActiveStress, ActiveStress, QFilterCondition> {}
