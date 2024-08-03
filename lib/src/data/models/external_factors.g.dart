// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_factors.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ExternalFactorsSchema = Schema(
  name: r'ExternalFactors',
  id: -6959701405773263101,
  properties: {
    r'environmentalAndGeologicalConditionalNumber': PropertySchema(
      id: 0,
      name: r'environmentalAndGeologicalConditionalNumber',
      type: IsarType.double,
    ),
    r'externalFactorsEnvironmentConditions': PropertySchema(
      id: 1,
      name: r'externalFactorsEnvironmentConditions',
      type: IsarType.string,
      enumMap: _ExternalFactorsexternalFactorsEnvironmentConditionsEnumValueMap,
    ),
    r'externalFactorsStrengthOfRock': PropertySchema(
      id: 2,
      name: r'externalFactorsStrengthOfRock',
      type: IsarType.string,
      enumMap: _ExternalFactorsexternalFactorsStrengthOfRockEnumValueMap,
    ),
    r'externalFactorsStructureType': PropertySchema(
      id: 3,
      name: r'externalFactorsStructureType',
      type: IsarType.string,
      enumMap: _ExternalFactorsexternalFactorsStructureTypeEnumValueMap,
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    )
  },
  estimateSize: _externalFactorsEstimateSize,
  serialize: _externalFactorsSerialize,
  deserialize: _externalFactorsDeserialize,
  deserializeProp: _externalFactorsDeserializeProp,
);

int _externalFactorsEstimateSize(
  ExternalFactors object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.externalFactorsEnvironmentConditions;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.externalFactorsStrengthOfRock;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.externalFactorsStructureType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _externalFactorsSerialize(
  ExternalFactors object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(
      offsets[0], object.environmentalAndGeologicalConditionalNumber);
  writer.writeString(
      offsets[1], object.externalFactorsEnvironmentConditions?.name);
  writer.writeString(offsets[2], object.externalFactorsStrengthOfRock?.name);
  writer.writeString(offsets[3], object.externalFactorsStructureType?.name);
  writer.writeLong(offsets[4], object.hashCode);
}

ExternalFactors _externalFactorsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExternalFactors(
    environmentalAndGeologicalConditionalNumber:
        reader.readDoubleOrNull(offsets[0]) ?? 0,
    externalFactorsEnvironmentConditions:
        _ExternalFactorsexternalFactorsEnvironmentConditionsValueEnumMap[
            reader.readStringOrNull(offsets[1])],
    externalFactorsStrengthOfRock:
        _ExternalFactorsexternalFactorsStrengthOfRockValueEnumMap[
            reader.readStringOrNull(offsets[2])],
    externalFactorsStructureType:
        _ExternalFactorsexternalFactorsStructureTypeValueEnumMap[
            reader.readStringOrNull(offsets[3])],
  );
  return object;
}

P _externalFactorsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (_ExternalFactorsexternalFactorsEnvironmentConditionsValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 2:
      return (_ExternalFactorsexternalFactorsStrengthOfRockValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 3:
      return (_ExternalFactorsexternalFactorsStructureTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExternalFactorsexternalFactorsEnvironmentConditionsEnumValueMap = {
  r'desertEnvironment': r'desertEnvironment',
  r'wetEnvironment': r'wetEnvironment',
  r'tropicalStorms': r'tropicalStorms',
  r'iceWedging': r'iceWedging',
};
const _ExternalFactorsexternalFactorsEnvironmentConditionsValueEnumMap = {
  r'desertEnvironment': ExternalFactorsEnvironmentConditions.desertEnvironment,
  r'wetEnvironment': ExternalFactorsEnvironmentConditions.wetEnvironment,
  r'tropicalStorms': ExternalFactorsEnvironmentConditions.tropicalStorms,
  r'iceWedging': ExternalFactorsEnvironmentConditions.iceWedging,
};
const _ExternalFactorsexternalFactorsStrengthOfRockEnumValueMap = {
  r'competent': r'competent',
  r'incompetent': r'incompetent',
};
const _ExternalFactorsexternalFactorsStrengthOfRockValueEnumMap = {
  r'competent': ExternalFactorsStrengthOfRock.competent,
  r'incompetent': ExternalFactorsStrengthOfRock.incompetent,
};
const _ExternalFactorsexternalFactorsStructureTypeEnumValueMap = {
  r'stable': r'stable',
  r'unstable': r'unstable',
};
const _ExternalFactorsexternalFactorsStructureTypeValueEnumMap = {
  r'stable': ExternalFactorsStructureType.stable,
  r'unstable': ExternalFactorsStructureType.unstable,
};

extension ExternalFactorsQueryFilter
    on QueryBuilder<ExternalFactors, ExternalFactors, QFilterCondition> {
  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      environmentalAndGeologicalConditionalNumberEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'environmentalAndGeologicalConditionalNumber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      environmentalAndGeologicalConditionalNumberGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'environmentalAndGeologicalConditionalNumber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      environmentalAndGeologicalConditionalNumberLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'environmentalAndGeologicalConditionalNumber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      environmentalAndGeologicalConditionalNumberBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'environmentalAndGeologicalConditionalNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'externalFactorsEnvironmentConditions',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'externalFactorsEnvironmentConditions',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsEqualTo(
    ExternalFactorsEnvironmentConditions? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalFactorsEnvironmentConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsGreaterThan(
    ExternalFactorsEnvironmentConditions? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalFactorsEnvironmentConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsLessThan(
    ExternalFactorsEnvironmentConditions? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalFactorsEnvironmentConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsBetween(
    ExternalFactorsEnvironmentConditions? lower,
    ExternalFactorsEnvironmentConditions? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalFactorsEnvironmentConditions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalFactorsEnvironmentConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalFactorsEnvironmentConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalFactorsEnvironmentConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalFactorsEnvironmentConditions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalFactorsEnvironmentConditions',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsEnvironmentConditionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalFactorsEnvironmentConditions',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'externalFactorsStrengthOfRock',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'externalFactorsStrengthOfRock',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockEqualTo(
    ExternalFactorsStrengthOfRock? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalFactorsStrengthOfRock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockGreaterThan(
    ExternalFactorsStrengthOfRock? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalFactorsStrengthOfRock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockLessThan(
    ExternalFactorsStrengthOfRock? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalFactorsStrengthOfRock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockBetween(
    ExternalFactorsStrengthOfRock? lower,
    ExternalFactorsStrengthOfRock? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalFactorsStrengthOfRock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalFactorsStrengthOfRock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalFactorsStrengthOfRock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalFactorsStrengthOfRock',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalFactorsStrengthOfRock',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalFactorsStrengthOfRock',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStrengthOfRockIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalFactorsStrengthOfRock',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'externalFactorsStructureType',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'externalFactorsStructureType',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeEqualTo(
    ExternalFactorsStructureType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalFactorsStructureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeGreaterThan(
    ExternalFactorsStructureType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalFactorsStructureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeLessThan(
    ExternalFactorsStructureType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalFactorsStructureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeBetween(
    ExternalFactorsStructureType? lower,
    ExternalFactorsStructureType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalFactorsStructureType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalFactorsStructureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalFactorsStructureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalFactorsStructureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalFactorsStructureType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalFactorsStructureType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      externalFactorsStructureTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalFactorsStructureType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
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

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
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

  QueryBuilder<ExternalFactors, ExternalFactors, QAfterFilterCondition>
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
}

extension ExternalFactorsQueryObject
    on QueryBuilder<ExternalFactors, ExternalFactors, QFilterCondition> {}
