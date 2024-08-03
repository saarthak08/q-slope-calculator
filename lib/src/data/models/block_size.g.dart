// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_size.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const BlockSizeSchema = Schema(
  name: r'BlockSize',
  id: -3630536685393909916,
  properties: {
    r'areaInSquareMeters': PropertySchema(
      id: 0,
      name: r'areaInSquareMeters',
      type: IsarType.double,
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'jointSpacingInMeters': PropertySchema(
      id: 2,
      name: r'jointSpacingInMeters',
      type: IsarType.doubleList,
    ),
    r'jointVolume': PropertySchema(
      id: 3,
      name: r'jointVolume',
      type: IsarType.double,
    ),
    r'numberOfJoints': PropertySchema(
      id: 4,
      name: r'numberOfJoints',
      type: IsarType.long,
    ),
    r'numberOfRandomSets': PropertySchema(
      id: 5,
      name: r'numberOfRandomSets',
      type: IsarType.long,
    ),
    r'rqd': PropertySchema(
      id: 6,
      name: r'rqd',
      type: IsarType.double,
    ),
    r'rqdByJvCalculationType': PropertySchema(
      id: 7,
      name: r'rqdByJvCalculationType',
      type: IsarType.string,
      enumMap: _BlockSizerqdByJvCalculationTypeEnumValueMap,
    ),
    r'rqdCalculationType': PropertySchema(
      id: 8,
      name: r'rqdCalculationType',
      type: IsarType.string,
      enumMap: _BlockSizerqdCalculationTypeEnumValueMap,
    ),
    r'sumOfCorePieces': PropertySchema(
      id: 9,
      name: r'sumOfCorePieces',
      type: IsarType.double,
    ),
    r'totalDrillRun': PropertySchema(
      id: 10,
      name: r'totalDrillRun',
      type: IsarType.double,
    )
  },
  estimateSize: _blockSizeEstimateSize,
  serialize: _blockSizeSerialize,
  deserialize: _blockSizeDeserialize,
  deserializeProp: _blockSizeDeserializeProp,
);

int _blockSizeEstimateSize(
  BlockSize object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.jointSpacingInMeters;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.rqdByJvCalculationType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.rqdCalculationType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _blockSizeSerialize(
  BlockSize object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.areaInSquareMeters);
  writer.writeLong(offsets[1], object.hashCode);
  writer.writeDoubleList(offsets[2], object.jointSpacingInMeters);
  writer.writeDouble(offsets[3], object.jointVolume);
  writer.writeLong(offsets[4], object.numberOfJoints);
  writer.writeLong(offsets[5], object.numberOfRandomSets);
  writer.writeDouble(offsets[6], object.rqd);
  writer.writeString(offsets[7], object.rqdByJvCalculationType?.name);
  writer.writeString(offsets[8], object.rqdCalculationType?.name);
  writer.writeDouble(offsets[9], object.sumOfCorePieces);
  writer.writeDouble(offsets[10], object.totalDrillRun);
}

BlockSize _blockSizeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BlockSize(
    areaInSquareMeters: reader.readDoubleOrNull(offsets[0]),
    jointSpacingInMeters: reader.readDoubleList(offsets[2]),
    jointVolume: reader.readDoubleOrNull(offsets[3]),
    numberOfJoints: reader.readLongOrNull(offsets[4]),
    numberOfRandomSets: reader.readLongOrNull(offsets[5]),
    rqd: reader.readDoubleOrNull(offsets[6]) ?? 0,
    rqdByJvCalculationType: _BlockSizerqdByJvCalculationTypeValueEnumMap[
        reader.readStringOrNull(offsets[7])],
    rqdCalculationType: _BlockSizerqdCalculationTypeValueEnumMap[
        reader.readStringOrNull(offsets[8])],
    sumOfCorePieces: reader.readDoubleOrNull(offsets[9]),
    totalDrillRun: reader.readDoubleOrNull(offsets[10]),
  );
  return object;
}

P _blockSizeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 7:
      return (_BlockSizerqdByJvCalculationTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 8:
      return (_BlockSizerqdCalculationTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BlockSizerqdByJvCalculationTypeEnumValueMap = {
  r'formulaWith2Point5Jv': r'formulaWith2Point5Jv',
  r'formulaWith3Point3Jv': r'formulaWith3Point3Jv',
};
const _BlockSizerqdByJvCalculationTypeValueEnumMap = {
  r'formulaWith2Point5Jv': RqdByJvCalculationType.formulaWith2Point5Jv,
  r'formulaWith3Point3Jv': RqdByJvCalculationType.formulaWith3Point3Jv,
};
const _BlockSizerqdCalculationTypeEnumValueMap = {
  r'jv': r'jv',
  r'directMethod': r'directMethod',
};
const _BlockSizerqdCalculationTypeValueEnumMap = {
  r'jv': RqdCalculationType.jv,
  r'directMethod': RqdCalculationType.directMethod,
};

extension BlockSizeQueryFilter
    on QueryBuilder<BlockSize, BlockSize, QFilterCondition> {
  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      areaInSquareMetersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaInSquareMeters',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      areaInSquareMetersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaInSquareMeters',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      areaInSquareMetersEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaInSquareMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      areaInSquareMetersGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'areaInSquareMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      areaInSquareMetersLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'areaInSquareMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      areaInSquareMetersBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'areaInSquareMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> hashCodeGreaterThan(
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

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> hashCodeLessThan(
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

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jointSpacingInMeters',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jointSpacingInMeters',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jointSpacingInMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jointSpacingInMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jointSpacingInMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jointSpacingInMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'jointSpacingInMeters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'jointSpacingInMeters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'jointSpacingInMeters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'jointSpacingInMeters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'jointSpacingInMeters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointSpacingInMetersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'jointSpacingInMeters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointVolumeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jointVolume',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointVolumeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jointVolume',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> jointVolumeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jointVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      jointVolumeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jointVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> jointVolumeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jointVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> jointVolumeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jointVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfJointsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfJoints',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfJointsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfJoints',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfJointsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfJoints',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfJointsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfJoints',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfJointsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfJoints',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfJointsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfJoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfRandomSetsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfRandomSets',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfRandomSetsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfRandomSets',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfRandomSetsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfRandomSets',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfRandomSetsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfRandomSets',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfRandomSetsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfRandomSets',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      numberOfRandomSetsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfRandomSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> rqdEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rqd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> rqdGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rqd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> rqdLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rqd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition> rqdBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rqd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rqdByJvCalculationType',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rqdByJvCalculationType',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeEqualTo(
    RqdByJvCalculationType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rqdByJvCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeGreaterThan(
    RqdByJvCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rqdByJvCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeLessThan(
    RqdByJvCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rqdByJvCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeBetween(
    RqdByJvCalculationType? lower,
    RqdByJvCalculationType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rqdByJvCalculationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rqdByJvCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rqdByJvCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rqdByJvCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rqdByJvCalculationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rqdByJvCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdByJvCalculationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rqdByJvCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rqdCalculationType',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rqdCalculationType',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeEqualTo(
    RqdCalculationType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rqdCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeGreaterThan(
    RqdCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rqdCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeLessThan(
    RqdCalculationType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rqdCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeBetween(
    RqdCalculationType? lower,
    RqdCalculationType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rqdCalculationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rqdCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rqdCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rqdCalculationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rqdCalculationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rqdCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      rqdCalculationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rqdCalculationType',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      sumOfCorePiecesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sumOfCorePieces',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      sumOfCorePiecesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sumOfCorePieces',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      sumOfCorePiecesEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sumOfCorePieces',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      sumOfCorePiecesGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sumOfCorePieces',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      sumOfCorePiecesLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sumOfCorePieces',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      sumOfCorePiecesBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sumOfCorePieces',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      totalDrillRunIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalDrillRun',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      totalDrillRunIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalDrillRun',
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      totalDrillRunEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDrillRun',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      totalDrillRunGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDrillRun',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      totalDrillRunLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDrillRun',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BlockSize, BlockSize, QAfterFilterCondition>
      totalDrillRunBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDrillRun',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BlockSizeQueryObject
    on QueryBuilder<BlockSize, BlockSize, QFilterCondition> {}
