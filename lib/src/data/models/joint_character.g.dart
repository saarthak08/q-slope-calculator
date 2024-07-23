// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joint_character.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const JointCharacterSchema = Schema(
  name: r'JointCharacter',
  id: -5000744219619543048,
  properties: {
    r'hashCode': PropertySchema(
      id: 0,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'jointAlteration': PropertySchema(
      id: 1,
      name: r'jointAlteration',
      type: IsarType.double,
    ),
    r'jointRoughness': PropertySchema(
      id: 2,
      name: r'jointRoughness',
      type: IsarType.double,
    ),
    r'jointRoughnessQuotient': PropertySchema(
      id: 3,
      name: r'jointRoughnessQuotient',
      type: IsarType.double,
    ),
    r'jrCalculationType': PropertySchema(
      id: 4,
      name: r'jrCalculationType',
      type: IsarType.string,
      enumMap: _JointCharacterjrCalculationTypeEnumValueMap,
    ),
    r'js': PropertySchema(
      id: 5,
      name: r'js',
      type: IsarType.double,
    ),
    r'jw': PropertySchema(
      id: 6,
      name: r'jw',
      type: IsarType.double,
    )
  },
  estimateSize: _jointCharacterEstimateSize,
  serialize: _jointCharacterSerialize,
  deserialize: _jointCharacterDeserialize,
  deserializeProp: _jointCharacterDeserializeProp,
);

int _jointCharacterEstimateSize(
  JointCharacter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.jrCalculationType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _jointCharacterSerialize(
  JointCharacter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeDouble(offsets[1], object.jointAlteration);
  writer.writeDouble(offsets[2], object.jointRoughness);
  writer.writeDouble(offsets[3], object.jointRoughnessQuotient);
  writer.writeString(offsets[4], object.jrCalculationType?.name);
  writer.writeDouble(offsets[5], object.js);
  writer.writeDouble(offsets[6], object.jw);
}

JointCharacter _jointCharacterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JointCharacter(
    jointAlteration: reader.readDoubleOrNull(offsets[1]) ?? 0,
    jointRoughness: reader.readDoubleOrNull(offsets[2]) ?? 0,
    jointRoughnessQuotient: reader.readDoubleOrNull(offsets[3]),
    jrCalculationType: _JointCharacterjrCalculationTypeValueEnumMap[
        reader.readStringOrNull(offsets[4])],
    js: reader.readDoubleOrNull(offsets[5]),
    jw: reader.readDoubleOrNull(offsets[6]),
  );
  return object;
}

P _jointCharacterDeserializeProp<P>(
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
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (_JointCharacterjrCalculationTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _JointCharacterjrCalculationTypeEnumValueMap = {
  r'jrc': r'jrc',
  r'palmstorm': r'palmstorm',
  r'jr': r'jr',
};
const _JointCharacterjrCalculationTypeValueEnumMap = {
  r'jrc': JrCalculationType.jrc,
  r'palmstorm': JrCalculationType.palmstorm,
  r'jr': JrCalculationType.jr,
};

extension JointCharacterQueryFilter
    on QueryBuilder<JointCharacter, JointCharacter, QFilterCondition> {
  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
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

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
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

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
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

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointAlterationEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jointAlteration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointAlterationGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jointAlteration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointAlterationLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jointAlteration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointAlterationBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jointAlteration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jointRoughness',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jointRoughness',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jointRoughness',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jointRoughness',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessQuotientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jointRoughnessQuotient',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessQuotientIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jointRoughnessQuotient',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessQuotientEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jointRoughnessQuotient',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessQuotientGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jointRoughnessQuotient',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessQuotientLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jointRoughnessQuotient',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jointRoughnessQuotientBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jointRoughnessQuotient',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jrCalculationType',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jrCalculationType',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeEqualTo(
    JrCalculationType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jrCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeGreaterThan(
    JrCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jrCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeLessThan(
    JrCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jrCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeBetween(
    JrCalculationType? lower,
    JrCalculationType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jrCalculationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jrCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jrCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jrCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jrCalculationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jrCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jrCalculationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jrCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'js',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'js',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition> jsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'js',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'js',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'js',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition> jsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'js',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jwIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jw',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jwIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jw',
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition> jwEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jw',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jwGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jw',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition>
      jwLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jw',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JointCharacter, JointCharacter, QAfterFilterCondition> jwBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension JointCharacterQueryObject
    on QueryBuilder<JointCharacter, JointCharacter, QFilterCondition> {}
