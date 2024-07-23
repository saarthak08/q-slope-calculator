// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'q_slope.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQSlopeCollection on Isar {
  IsarCollection<QSlope> get qSlopes => this.collection();
}

const QSlopeSchema = CollectionSchema(
  name: r'QSlope',
  id: -4090092846868812114,
  properties: {
    r'activeStress': PropertySchema(
      id: 0,
      name: r'activeStress',
      type: IsarType.object,
      target: r'ActiveStress',
    ),
    r'blockSize': PropertySchema(
      id: 1,
      name: r'blockSize',
      type: IsarType.object,
      target: r'BlockSize',
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'externalFactors': PropertySchema(
      id: 3,
      name: r'externalFactors',
      type: IsarType.object,
      target: r'ExternalFactors',
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'jointCharacter': PropertySchema(
      id: 5,
      name: r'jointCharacter',
      type: IsarType.object,
      target: r'JointCharacter',
    ),
    r'lithology': PropertySchema(
      id: 6,
      name: r'lithology',
      type: IsarType.string,
    ),
    r'locationId': PropertySchema(
      id: 7,
      name: r'locationId',
      type: IsarType.string,
    ),
    r'oFactor': PropertySchema(
      id: 8,
      name: r'oFactor',
      type: IsarType.object,
      target: r'OFactor',
    ),
    r'qSlope': PropertySchema(
      id: 9,
      name: r'qSlope',
      type: IsarType.double,
    )
  },
  estimateSize: _qSlopeEstimateSize,
  serialize: _qSlopeSerialize,
  deserialize: _qSlopeDeserialize,
  deserializeProp: _qSlopeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'BlockSize': BlockSizeSchema,
    r'JointCharacter': JointCharacterSchema,
    r'OFactor': OFactorSchema,
    r'ExternalFactors': ExternalFactorsSchema,
    r'ActiveStress': ActiveStressSchema
  },
  getId: _qSlopeGetId,
  getLinks: _qSlopeGetLinks,
  attach: _qSlopeAttach,
  version: '3.1.0+1',
);

int _qSlopeEstimateSize(
  QSlope object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      ActiveStressSchema.estimateSize(
          object.activeStress, allOffsets[ActiveStress]!, allOffsets);
  bytesCount += 3 +
      BlockSizeSchema.estimateSize(
          object.blockSize, allOffsets[BlockSize]!, allOffsets);
  bytesCount += 3 +
      ExternalFactorsSchema.estimateSize(
          object.externalFactors, allOffsets[ExternalFactors]!, allOffsets);
  bytesCount += 3 +
      JointCharacterSchema.estimateSize(
          object.jointCharacter, allOffsets[JointCharacter]!, allOffsets);
  bytesCount += 3 + object.lithology.length * 3;
  bytesCount += 3 + object.locationId.length * 3;
  bytesCount += 3 +
      OFactorSchema.estimateSize(
          object.oFactor, allOffsets[OFactor]!, allOffsets);
  return bytesCount;
}

void _qSlopeSerialize(
  QSlope object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<ActiveStress>(
    offsets[0],
    allOffsets,
    ActiveStressSchema.serialize,
    object.activeStress,
  );
  writer.writeObject<BlockSize>(
    offsets[1],
    allOffsets,
    BlockSizeSchema.serialize,
    object.blockSize,
  );
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeObject<ExternalFactors>(
    offsets[3],
    allOffsets,
    ExternalFactorsSchema.serialize,
    object.externalFactors,
  );
  writer.writeLong(offsets[4], object.hashCode);
  writer.writeObject<JointCharacter>(
    offsets[5],
    allOffsets,
    JointCharacterSchema.serialize,
    object.jointCharacter,
  );
  writer.writeString(offsets[6], object.lithology);
  writer.writeString(offsets[7], object.locationId);
  writer.writeObject<OFactor>(
    offsets[8],
    allOffsets,
    OFactorSchema.serialize,
    object.oFactor,
  );
  writer.writeDouble(offsets[9], object.qSlope);
}

QSlope _qSlopeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QSlope(
    activeStress: reader.readObjectOrNull<ActiveStress>(
          offsets[0],
          ActiveStressSchema.deserialize,
          allOffsets,
        ) ??
        ActiveStress(),
    blockSize: reader.readObjectOrNull<BlockSize>(
          offsets[1],
          BlockSizeSchema.deserialize,
          allOffsets,
        ) ??
        BlockSize(),
    createdAt: reader.readDateTime(offsets[2]),
    externalFactors: reader.readObjectOrNull<ExternalFactors>(
          offsets[3],
          ExternalFactorsSchema.deserialize,
          allOffsets,
        ) ??
        ExternalFactors(),
    id: id,
    jointCharacter: reader.readObjectOrNull<JointCharacter>(
          offsets[5],
          JointCharacterSchema.deserialize,
          allOffsets,
        ) ??
        JointCharacter(),
    lithology: reader.readString(offsets[6]),
    locationId: reader.readString(offsets[7]),
    oFactor: reader.readObjectOrNull<OFactor>(
          offsets[8],
          OFactorSchema.deserialize,
          allOffsets,
        ) ??
        OFactor(),
    qSlope: reader.readDouble(offsets[9]),
  );
  return object;
}

P _qSlopeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<ActiveStress>(
            offset,
            ActiveStressSchema.deserialize,
            allOffsets,
          ) ??
          ActiveStress()) as P;
    case 1:
      return (reader.readObjectOrNull<BlockSize>(
            offset,
            BlockSizeSchema.deserialize,
            allOffsets,
          ) ??
          BlockSize()) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<ExternalFactors>(
            offset,
            ExternalFactorsSchema.deserialize,
            allOffsets,
          ) ??
          ExternalFactors()) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<JointCharacter>(
            offset,
            JointCharacterSchema.deserialize,
            allOffsets,
          ) ??
          JointCharacter()) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readObjectOrNull<OFactor>(
            offset,
            OFactorSchema.deserialize,
            allOffsets,
          ) ??
          OFactor()) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _qSlopeGetId(QSlope object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _qSlopeGetLinks(QSlope object) {
  return [];
}

void _qSlopeAttach(IsarCollection<dynamic> col, Id id, QSlope object) {
  object.id = id;
}

extension QSlopeQueryWhereSort on QueryBuilder<QSlope, QSlope, QWhere> {
  QueryBuilder<QSlope, QSlope, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QSlopeQueryWhere on QueryBuilder<QSlope, QSlope, QWhereClause> {
  QueryBuilder<QSlope, QSlope, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension QSlopeQueryFilter on QueryBuilder<QSlope, QSlope, QFilterCondition> {
  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> hashCodeGreaterThan(
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

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> hashCodeLessThan(
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

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lithology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lithology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lithology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lithology',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lithology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lithology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lithology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lithology',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lithology',
        value: '',
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> lithologyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lithology',
        value: '',
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationId',
        value: '',
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> locationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locationId',
        value: '',
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> qSlopeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qSlope',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> qSlopeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qSlope',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> qSlopeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qSlope',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> qSlopeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qSlope',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension QSlopeQueryObject on QueryBuilder<QSlope, QSlope, QFilterCondition> {
  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> activeStress(
      FilterQuery<ActiveStress> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'activeStress');
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> blockSize(
      FilterQuery<BlockSize> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'blockSize');
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> externalFactors(
      FilterQuery<ExternalFactors> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'externalFactors');
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> jointCharacter(
      FilterQuery<JointCharacter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'jointCharacter');
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterFilterCondition> oFactor(
      FilterQuery<OFactor> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'oFactor');
    });
  }
}

extension QSlopeQueryLinks on QueryBuilder<QSlope, QSlope, QFilterCondition> {}

extension QSlopeQuerySortBy on QueryBuilder<QSlope, QSlope, QSortBy> {
  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByLithology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lithology', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByLithologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lithology', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByQSlope() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qSlope', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> sortByQSlopeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qSlope', Sort.desc);
    });
  }
}

extension QSlopeQuerySortThenBy on QueryBuilder<QSlope, QSlope, QSortThenBy> {
  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByLithology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lithology', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByLithologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lithology', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.desc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByQSlope() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qSlope', Sort.asc);
    });
  }

  QueryBuilder<QSlope, QSlope, QAfterSortBy> thenByQSlopeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qSlope', Sort.desc);
    });
  }
}

extension QSlopeQueryWhereDistinct on QueryBuilder<QSlope, QSlope, QDistinct> {
  QueryBuilder<QSlope, QSlope, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<QSlope, QSlope, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<QSlope, QSlope, QDistinct> distinctByLithology(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lithology', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QSlope, QSlope, QDistinct> distinctByLocationId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QSlope, QSlope, QDistinct> distinctByQSlope() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qSlope');
    });
  }
}

extension QSlopeQueryProperty on QueryBuilder<QSlope, QSlope, QQueryProperty> {
  QueryBuilder<QSlope, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<QSlope, ActiveStress, QQueryOperations> activeStressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeStress');
    });
  }

  QueryBuilder<QSlope, BlockSize, QQueryOperations> blockSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockSize');
    });
  }

  QueryBuilder<QSlope, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<QSlope, ExternalFactors, QQueryOperations>
      externalFactorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalFactors');
    });
  }

  QueryBuilder<QSlope, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<QSlope, JointCharacter, QQueryOperations>
      jointCharacterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jointCharacter');
    });
  }

  QueryBuilder<QSlope, String, QQueryOperations> lithologyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lithology');
    });
  }

  QueryBuilder<QSlope, String, QQueryOperations> locationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationId');
    });
  }

  QueryBuilder<QSlope, OFactor, QQueryOperations> oFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'oFactor');
    });
  }

  QueryBuilder<QSlope, double, QQueryOperations> qSlopeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qSlope');
    });
  }
}
