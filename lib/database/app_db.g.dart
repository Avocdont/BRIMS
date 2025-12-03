// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $ReligionsTable extends Religions
    with TableInfo<$ReligionsTable, ReligionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReligionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _religion_idMeta = const VerificationMeta(
    'religion_id',
  );
  @override
  late final GeneratedColumn<int> religion_id = GeneratedColumn<int>(
    'religion_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [religion_id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'religions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReligionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('religion_id')) {
      context.handle(
        _religion_idMeta,
        religion_id.isAcceptableOrUnknown(
          data['religion_id']!,
          _religion_idMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {religion_id};
  @override
  ReligionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReligionData(
      religion_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}religion_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
    );
  }

  @override
  $ReligionsTable createAlias(String alias) {
    return $ReligionsTable(attachedDatabase, alias);
  }
}

class ReligionData extends DataClass implements Insertable<ReligionData> {
  final int religion_id;
  final String name;
  const ReligionData({required this.religion_id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['religion_id'] = Variable<int>(religion_id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ReligionsCompanion toCompanion(bool nullToAbsent) {
    return ReligionsCompanion(
      religion_id: Value(religion_id),
      name: Value(name),
    );
  }

  factory ReligionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReligionData(
      religion_id: serializer.fromJson<int>(json['religion_id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'religion_id': serializer.toJson<int>(religion_id),
      'name': serializer.toJson<String>(name),
    };
  }

  ReligionData copyWith({int? religion_id, String? name}) => ReligionData(
    religion_id: religion_id ?? this.religion_id,
    name: name ?? this.name,
  );
  ReligionData copyWithCompanion(ReligionsCompanion data) {
    return ReligionData(
      religion_id:
          data.religion_id.present ? data.religion_id.value : this.religion_id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReligionData(')
          ..write('religion_id: $religion_id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(religion_id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReligionData &&
          other.religion_id == this.religion_id &&
          other.name == this.name);
}

class ReligionsCompanion extends UpdateCompanion<ReligionData> {
  final Value<int> religion_id;
  final Value<String> name;
  const ReligionsCompanion({
    this.religion_id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ReligionsCompanion.insert({
    this.religion_id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ReligionData> custom({
    Expression<int>? religion_id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (religion_id != null) 'religion_id': religion_id,
      if (name != null) 'name': name,
    });
  }

  ReligionsCompanion copyWith({Value<int>? religion_id, Value<String>? name}) {
    return ReligionsCompanion(
      religion_id: religion_id ?? this.religion_id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (religion_id.present) {
      map['religion_id'] = Variable<int>(religion_id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReligionsCompanion(')
          ..write('religion_id: $religion_id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $NationalitiesTable extends Nationalities
    with TableInfo<$NationalitiesTable, NationalityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NationalitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nationality_idMeta = const VerificationMeta(
    'nationality_id',
  );
  @override
  late final GeneratedColumn<int> nationality_id = GeneratedColumn<int>(
    'nationality_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [nationality_id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nationalities';
  @override
  VerificationContext validateIntegrity(
    Insertable<NationalityData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('nationality_id')) {
      context.handle(
        _nationality_idMeta,
        nationality_id.isAcceptableOrUnknown(
          data['nationality_id']!,
          _nationality_idMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {nationality_id};
  @override
  NationalityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NationalityData(
      nationality_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}nationality_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
    );
  }

  @override
  $NationalitiesTable createAlias(String alias) {
    return $NationalitiesTable(attachedDatabase, alias);
  }
}

class NationalityData extends DataClass implements Insertable<NationalityData> {
  final int nationality_id;
  final String name;
  const NationalityData({required this.nationality_id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['nationality_id'] = Variable<int>(nationality_id);
    map['name'] = Variable<String>(name);
    return map;
  }

  NationalitiesCompanion toCompanion(bool nullToAbsent) {
    return NationalitiesCompanion(
      nationality_id: Value(nationality_id),
      name: Value(name),
    );
  }

  factory NationalityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NationalityData(
      nationality_id: serializer.fromJson<int>(json['nationality_id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nationality_id': serializer.toJson<int>(nationality_id),
      'name': serializer.toJson<String>(name),
    };
  }

  NationalityData copyWith({int? nationality_id, String? name}) =>
      NationalityData(
        nationality_id: nationality_id ?? this.nationality_id,
        name: name ?? this.name,
      );
  NationalityData copyWithCompanion(NationalitiesCompanion data) {
    return NationalityData(
      nationality_id:
          data.nationality_id.present
              ? data.nationality_id.value
              : this.nationality_id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NationalityData(')
          ..write('nationality_id: $nationality_id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(nationality_id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NationalityData &&
          other.nationality_id == this.nationality_id &&
          other.name == this.name);
}

class NationalitiesCompanion extends UpdateCompanion<NationalityData> {
  final Value<int> nationality_id;
  final Value<String> name;
  const NationalitiesCompanion({
    this.nationality_id = const Value.absent(),
    this.name = const Value.absent(),
  });
  NationalitiesCompanion.insert({
    this.nationality_id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<NationalityData> custom({
    Expression<int>? nationality_id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (nationality_id != null) 'nationality_id': nationality_id,
      if (name != null) 'name': name,
    });
  }

  NationalitiesCompanion copyWith({
    Value<int>? nationality_id,
    Value<String>? name,
  }) {
    return NationalitiesCompanion(
      nationality_id: nationality_id ?? this.nationality_id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nationality_id.present) {
      map['nationality_id'] = Variable<int>(nationality_id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NationalitiesCompanion(')
          ..write('nationality_id: $nationality_id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $EthnicitiesTable extends Ethnicities
    with TableInfo<$EthnicitiesTable, EthnicityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EthnicitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ethnicity_idMeta = const VerificationMeta(
    'ethnicity_id',
  );
  @override
  late final GeneratedColumn<int> ethnicity_id = GeneratedColumn<int>(
    'ethnicity_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ethnicity_id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ethnicities';
  @override
  VerificationContext validateIntegrity(
    Insertable<EthnicityData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ethnicity_id')) {
      context.handle(
        _ethnicity_idMeta,
        ethnicity_id.isAcceptableOrUnknown(
          data['ethnicity_id']!,
          _ethnicity_idMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ethnicity_id};
  @override
  EthnicityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EthnicityData(
      ethnicity_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}ethnicity_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
    );
  }

  @override
  $EthnicitiesTable createAlias(String alias) {
    return $EthnicitiesTable(attachedDatabase, alias);
  }
}

class EthnicityData extends DataClass implements Insertable<EthnicityData> {
  final int ethnicity_id;
  final String name;
  const EthnicityData({required this.ethnicity_id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ethnicity_id'] = Variable<int>(ethnicity_id);
    map['name'] = Variable<String>(name);
    return map;
  }

  EthnicitiesCompanion toCompanion(bool nullToAbsent) {
    return EthnicitiesCompanion(
      ethnicity_id: Value(ethnicity_id),
      name: Value(name),
    );
  }

  factory EthnicityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EthnicityData(
      ethnicity_id: serializer.fromJson<int>(json['ethnicity_id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ethnicity_id': serializer.toJson<int>(ethnicity_id),
      'name': serializer.toJson<String>(name),
    };
  }

  EthnicityData copyWith({int? ethnicity_id, String? name}) => EthnicityData(
    ethnicity_id: ethnicity_id ?? this.ethnicity_id,
    name: name ?? this.name,
  );
  EthnicityData copyWithCompanion(EthnicitiesCompanion data) {
    return EthnicityData(
      ethnicity_id:
          data.ethnicity_id.present
              ? data.ethnicity_id.value
              : this.ethnicity_id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EthnicityData(')
          ..write('ethnicity_id: $ethnicity_id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ethnicity_id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EthnicityData &&
          other.ethnicity_id == this.ethnicity_id &&
          other.name == this.name);
}

class EthnicitiesCompanion extends UpdateCompanion<EthnicityData> {
  final Value<int> ethnicity_id;
  final Value<String> name;
  const EthnicitiesCompanion({
    this.ethnicity_id = const Value.absent(),
    this.name = const Value.absent(),
  });
  EthnicitiesCompanion.insert({
    this.ethnicity_id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<EthnicityData> custom({
    Expression<int>? ethnicity_id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (ethnicity_id != null) 'ethnicity_id': ethnicity_id,
      if (name != null) 'name': name,
    });
  }

  EthnicitiesCompanion copyWith({
    Value<int>? ethnicity_id,
    Value<String>? name,
  }) {
    return EthnicitiesCompanion(
      ethnicity_id: ethnicity_id ?? this.ethnicity_id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ethnicity_id.present) {
      map['ethnicity_id'] = Variable<int>(ethnicity_id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EthnicitiesCompanion(')
          ..write('ethnicity_id: $ethnicity_id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $BloodTypesTable extends BloodTypes
    with TableInfo<$BloodTypesTable, BloodTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _blood_type_idMeta = const VerificationMeta(
    'blood_type_id',
  );
  @override
  late final GeneratedColumn<int> blood_type_id = GeneratedColumn<int>(
    'blood_type_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [blood_type_id, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('blood_type_id')) {
      context.handle(
        _blood_type_idMeta,
        blood_type_id.isAcceptableOrUnknown(
          data['blood_type_id']!,
          _blood_type_idMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {blood_type_id};
  @override
  BloodTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodTypeData(
      blood_type_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}blood_type_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
    );
  }

  @override
  $BloodTypesTable createAlias(String alias) {
    return $BloodTypesTable(attachedDatabase, alias);
  }
}

class BloodTypeData extends DataClass implements Insertable<BloodTypeData> {
  final int blood_type_id;
  final String type;
  const BloodTypeData({required this.blood_type_id, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['blood_type_id'] = Variable<int>(blood_type_id);
    map['type'] = Variable<String>(type);
    return map;
  }

  BloodTypesCompanion toCompanion(bool nullToAbsent) {
    return BloodTypesCompanion(
      blood_type_id: Value(blood_type_id),
      type: Value(type),
    );
  }

  factory BloodTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodTypeData(
      blood_type_id: serializer.fromJson<int>(json['blood_type_id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'blood_type_id': serializer.toJson<int>(blood_type_id),
      'type': serializer.toJson<String>(type),
    };
  }

  BloodTypeData copyWith({int? blood_type_id, String? type}) => BloodTypeData(
    blood_type_id: blood_type_id ?? this.blood_type_id,
    type: type ?? this.type,
  );
  BloodTypeData copyWithCompanion(BloodTypesCompanion data) {
    return BloodTypeData(
      blood_type_id:
          data.blood_type_id.present
              ? data.blood_type_id.value
              : this.blood_type_id,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodTypeData(')
          ..write('blood_type_id: $blood_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(blood_type_id, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodTypeData &&
          other.blood_type_id == this.blood_type_id &&
          other.type == this.type);
}

class BloodTypesCompanion extends UpdateCompanion<BloodTypeData> {
  final Value<int> blood_type_id;
  final Value<String> type;
  const BloodTypesCompanion({
    this.blood_type_id = const Value.absent(),
    this.type = const Value.absent(),
  });
  BloodTypesCompanion.insert({
    this.blood_type_id = const Value.absent(),
    required String type,
  }) : type = Value(type);
  static Insertable<BloodTypeData> custom({
    Expression<int>? blood_type_id,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (blood_type_id != null) 'blood_type_id': blood_type_id,
      if (type != null) 'type': type,
    });
  }

  BloodTypesCompanion copyWith({
    Value<int>? blood_type_id,
    Value<String>? type,
  }) {
    return BloodTypesCompanion(
      blood_type_id: blood_type_id ?? this.blood_type_id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (blood_type_id.present) {
      map['blood_type_id'] = Variable<int>(blood_type_id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodTypesCompanion(')
          ..write('blood_type_id: $blood_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $AddressesTable extends Addresses
    with TableInfo<$AddressesTable, AddressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _address_idMeta = const VerificationMeta(
    'address_id',
  );
  @override
  late final GeneratedColumn<int> address_id = GeneratedColumn<int>(
    'address_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brgyMeta = const VerificationMeta('brgy');
  @override
  late final GeneratedColumn<String> brgy = GeneratedColumn<String>(
    'brgy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockMeta = const VerificationMeta('block');
  @override
  late final GeneratedColumn<int> block = GeneratedColumn<int>(
    'block',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lotMeta = const VerificationMeta('lot');
  @override
  late final GeneratedColumn<int> lot = GeneratedColumn<int>(
    'lot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    address_id,
    brgy,
    zone,
    street,
    block,
    lot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'addresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<AddressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('address_id')) {
      context.handle(
        _address_idMeta,
        address_id.isAcceptableOrUnknown(data['address_id']!, _address_idMeta),
      );
    }
    if (data.containsKey('brgy')) {
      context.handle(
        _brgyMeta,
        brgy.isAcceptableOrUnknown(data['brgy']!, _brgyMeta),
      );
    } else if (isInserting) {
      context.missing(_brgyMeta);
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneMeta);
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    } else if (isInserting) {
      context.missing(_streetMeta);
    }
    if (data.containsKey('block')) {
      context.handle(
        _blockMeta,
        block.isAcceptableOrUnknown(data['block']!, _blockMeta),
      );
    } else if (isInserting) {
      context.missing(_blockMeta);
    }
    if (data.containsKey('lot')) {
      context.handle(
        _lotMeta,
        lot.isAcceptableOrUnknown(data['lot']!, _lotMeta),
      );
    } else if (isInserting) {
      context.missing(_lotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {address_id};
  @override
  AddressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AddressData(
      address_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}address_id'],
          )!,
      brgy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}brgy'],
          )!,
      zone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}zone'],
          )!,
      street:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}street'],
          )!,
      block:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}block'],
          )!,
      lot:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}lot'],
          )!,
    );
  }

  @override
  $AddressesTable createAlias(String alias) {
    return $AddressesTable(attachedDatabase, alias);
  }
}

class AddressData extends DataClass implements Insertable<AddressData> {
  final int address_id;
  final String brgy;
  final String zone;
  final String street;
  final int block;
  final int lot;
  const AddressData({
    required this.address_id,
    required this.brgy,
    required this.zone,
    required this.street,
    required this.block,
    required this.lot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['address_id'] = Variable<int>(address_id);
    map['brgy'] = Variable<String>(brgy);
    map['zone'] = Variable<String>(zone);
    map['street'] = Variable<String>(street);
    map['block'] = Variable<int>(block);
    map['lot'] = Variable<int>(lot);
    return map;
  }

  AddressesCompanion toCompanion(bool nullToAbsent) {
    return AddressesCompanion(
      address_id: Value(address_id),
      brgy: Value(brgy),
      zone: Value(zone),
      street: Value(street),
      block: Value(block),
      lot: Value(lot),
    );
  }

  factory AddressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AddressData(
      address_id: serializer.fromJson<int>(json['address_id']),
      brgy: serializer.fromJson<String>(json['brgy']),
      zone: serializer.fromJson<String>(json['zone']),
      street: serializer.fromJson<String>(json['street']),
      block: serializer.fromJson<int>(json['block']),
      lot: serializer.fromJson<int>(json['lot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'address_id': serializer.toJson<int>(address_id),
      'brgy': serializer.toJson<String>(brgy),
      'zone': serializer.toJson<String>(zone),
      'street': serializer.toJson<String>(street),
      'block': serializer.toJson<int>(block),
      'lot': serializer.toJson<int>(lot),
    };
  }

  AddressData copyWith({
    int? address_id,
    String? brgy,
    String? zone,
    String? street,
    int? block,
    int? lot,
  }) => AddressData(
    address_id: address_id ?? this.address_id,
    brgy: brgy ?? this.brgy,
    zone: zone ?? this.zone,
    street: street ?? this.street,
    block: block ?? this.block,
    lot: lot ?? this.lot,
  );
  AddressData copyWithCompanion(AddressesCompanion data) {
    return AddressData(
      address_id:
          data.address_id.present ? data.address_id.value : this.address_id,
      brgy: data.brgy.present ? data.brgy.value : this.brgy,
      zone: data.zone.present ? data.zone.value : this.zone,
      street: data.street.present ? data.street.value : this.street,
      block: data.block.present ? data.block.value : this.block,
      lot: data.lot.present ? data.lot.value : this.lot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AddressData(')
          ..write('address_id: $address_id, ')
          ..write('brgy: $brgy, ')
          ..write('zone: $zone, ')
          ..write('street: $street, ')
          ..write('block: $block, ')
          ..write('lot: $lot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(address_id, brgy, zone, street, block, lot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressData &&
          other.address_id == this.address_id &&
          other.brgy == this.brgy &&
          other.zone == this.zone &&
          other.street == this.street &&
          other.block == this.block &&
          other.lot == this.lot);
}

class AddressesCompanion extends UpdateCompanion<AddressData> {
  final Value<int> address_id;
  final Value<String> brgy;
  final Value<String> zone;
  final Value<String> street;
  final Value<int> block;
  final Value<int> lot;
  const AddressesCompanion({
    this.address_id = const Value.absent(),
    this.brgy = const Value.absent(),
    this.zone = const Value.absent(),
    this.street = const Value.absent(),
    this.block = const Value.absent(),
    this.lot = const Value.absent(),
  });
  AddressesCompanion.insert({
    this.address_id = const Value.absent(),
    required String brgy,
    required String zone,
    required String street,
    required int block,
    required int lot,
  }) : brgy = Value(brgy),
       zone = Value(zone),
       street = Value(street),
       block = Value(block),
       lot = Value(lot);
  static Insertable<AddressData> custom({
    Expression<int>? address_id,
    Expression<String>? brgy,
    Expression<String>? zone,
    Expression<String>? street,
    Expression<int>? block,
    Expression<int>? lot,
  }) {
    return RawValuesInsertable({
      if (address_id != null) 'address_id': address_id,
      if (brgy != null) 'brgy': brgy,
      if (zone != null) 'zone': zone,
      if (street != null) 'street': street,
      if (block != null) 'block': block,
      if (lot != null) 'lot': lot,
    });
  }

  AddressesCompanion copyWith({
    Value<int>? address_id,
    Value<String>? brgy,
    Value<String>? zone,
    Value<String>? street,
    Value<int>? block,
    Value<int>? lot,
  }) {
    return AddressesCompanion(
      address_id: address_id ?? this.address_id,
      brgy: brgy ?? this.brgy,
      zone: zone ?? this.zone,
      street: street ?? this.street,
      block: block ?? this.block,
      lot: lot ?? this.lot,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (address_id.present) {
      map['address_id'] = Variable<int>(address_id.value);
    }
    if (brgy.present) {
      map['brgy'] = Variable<String>(brgy.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (block.present) {
      map['block'] = Variable<int>(block.value);
    }
    if (lot.present) {
      map['lot'] = Variable<int>(lot.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddressesCompanion(')
          ..write('address_id: $address_id, ')
          ..write('brgy: $brgy, ')
          ..write('zone: $zone, ')
          ..write('street: $street, ')
          ..write('block: $block, ')
          ..write('lot: $lot')
          ..write(')'))
        .toString();
  }
}

class $HouseholdTypesTable extends HouseholdTypes
    with TableInfo<$HouseholdTypesTable, HouseholdTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _household_type_idMeta = const VerificationMeta(
    'household_type_id',
  );
  @override
  late final GeneratedColumn<int> household_type_id = GeneratedColumn<int>(
    'household_type_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [household_type_id, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<HouseholdTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('household_type_id')) {
      context.handle(
        _household_type_idMeta,
        household_type_id.isAcceptableOrUnknown(
          data['household_type_id']!,
          _household_type_idMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {household_type_id};
  @override
  HouseholdTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdTypeData(
      household_type_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}household_type_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
    );
  }

  @override
  $HouseholdTypesTable createAlias(String alias) {
    return $HouseholdTypesTable(attachedDatabase, alias);
  }
}

class HouseholdTypeData extends DataClass
    implements Insertable<HouseholdTypeData> {
  final int household_type_id;
  final String type;
  const HouseholdTypeData({
    required this.household_type_id,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['household_type_id'] = Variable<int>(household_type_id);
    map['type'] = Variable<String>(type);
    return map;
  }

  HouseholdTypesCompanion toCompanion(bool nullToAbsent) {
    return HouseholdTypesCompanion(
      household_type_id: Value(household_type_id),
      type: Value(type),
    );
  }

  factory HouseholdTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdTypeData(
      household_type_id: serializer.fromJson<int>(json['household_type_id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'household_type_id': serializer.toJson<int>(household_type_id),
      'type': serializer.toJson<String>(type),
    };
  }

  HouseholdTypeData copyWith({int? household_type_id, String? type}) =>
      HouseholdTypeData(
        household_type_id: household_type_id ?? this.household_type_id,
        type: type ?? this.type,
      );
  HouseholdTypeData copyWithCompanion(HouseholdTypesCompanion data) {
    return HouseholdTypeData(
      household_type_id:
          data.household_type_id.present
              ? data.household_type_id.value
              : this.household_type_id,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdTypeData(')
          ..write('household_type_id: $household_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(household_type_id, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdTypeData &&
          other.household_type_id == this.household_type_id &&
          other.type == this.type);
}

class HouseholdTypesCompanion extends UpdateCompanion<HouseholdTypeData> {
  final Value<int> household_type_id;
  final Value<String> type;
  const HouseholdTypesCompanion({
    this.household_type_id = const Value.absent(),
    this.type = const Value.absent(),
  });
  HouseholdTypesCompanion.insert({
    this.household_type_id = const Value.absent(),
    required String type,
  }) : type = Value(type);
  static Insertable<HouseholdTypeData> custom({
    Expression<int>? household_type_id,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (household_type_id != null) 'household_type_id': household_type_id,
      if (type != null) 'type': type,
    });
  }

  HouseholdTypesCompanion copyWith({
    Value<int>? household_type_id,
    Value<String>? type,
  }) {
    return HouseholdTypesCompanion(
      household_type_id: household_type_id ?? this.household_type_id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (household_type_id.present) {
      map['household_type_id'] = Variable<int>(household_type_id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdTypesCompanion(')
          ..write('household_type_id: $household_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $BuildingTypesTable extends BuildingTypes
    with TableInfo<$BuildingTypesTable, BuildingTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuildingTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _building_type_idMeta = const VerificationMeta(
    'building_type_id',
  );
  @override
  late final GeneratedColumn<int> building_type_id = GeneratedColumn<int>(
    'building_type_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [building_type_id, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'building_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<BuildingTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('building_type_id')) {
      context.handle(
        _building_type_idMeta,
        building_type_id.isAcceptableOrUnknown(
          data['building_type_id']!,
          _building_type_idMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {building_type_id};
  @override
  BuildingTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuildingTypeData(
      building_type_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}building_type_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
    );
  }

  @override
  $BuildingTypesTable createAlias(String alias) {
    return $BuildingTypesTable(attachedDatabase, alias);
  }
}

class BuildingTypeData extends DataClass
    implements Insertable<BuildingTypeData> {
  final int building_type_id;
  final String type;
  const BuildingTypeData({required this.building_type_id, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['building_type_id'] = Variable<int>(building_type_id);
    map['type'] = Variable<String>(type);
    return map;
  }

  BuildingTypesCompanion toCompanion(bool nullToAbsent) {
    return BuildingTypesCompanion(
      building_type_id: Value(building_type_id),
      type: Value(type),
    );
  }

  factory BuildingTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuildingTypeData(
      building_type_id: serializer.fromJson<int>(json['building_type_id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'building_type_id': serializer.toJson<int>(building_type_id),
      'type': serializer.toJson<String>(type),
    };
  }

  BuildingTypeData copyWith({int? building_type_id, String? type}) =>
      BuildingTypeData(
        building_type_id: building_type_id ?? this.building_type_id,
        type: type ?? this.type,
      );
  BuildingTypeData copyWithCompanion(BuildingTypesCompanion data) {
    return BuildingTypeData(
      building_type_id:
          data.building_type_id.present
              ? data.building_type_id.value
              : this.building_type_id,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BuildingTypeData(')
          ..write('building_type_id: $building_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(building_type_id, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuildingTypeData &&
          other.building_type_id == this.building_type_id &&
          other.type == this.type);
}

class BuildingTypesCompanion extends UpdateCompanion<BuildingTypeData> {
  final Value<int> building_type_id;
  final Value<String> type;
  const BuildingTypesCompanion({
    this.building_type_id = const Value.absent(),
    this.type = const Value.absent(),
  });
  BuildingTypesCompanion.insert({
    this.building_type_id = const Value.absent(),
    required String type,
  }) : type = Value(type);
  static Insertable<BuildingTypeData> custom({
    Expression<int>? building_type_id,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (building_type_id != null) 'building_type_id': building_type_id,
      if (type != null) 'type': type,
    });
  }

  BuildingTypesCompanion copyWith({
    Value<int>? building_type_id,
    Value<String>? type,
  }) {
    return BuildingTypesCompanion(
      building_type_id: building_type_id ?? this.building_type_id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (building_type_id.present) {
      map['building_type_id'] = Variable<int>(building_type_id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuildingTypesCompanion(')
          ..write('building_type_id: $building_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $OwnershipTypesTable extends OwnershipTypes
    with TableInfo<$OwnershipTypesTable, OwnershipTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnershipTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownership_type_idMeta = const VerificationMeta(
    'ownership_type_id',
  );
  @override
  late final GeneratedColumn<int> ownership_type_id = GeneratedColumn<int>(
    'ownership_type_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ownership_type_id, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ownership_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnershipTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ownership_type_id')) {
      context.handle(
        _ownership_type_idMeta,
        ownership_type_id.isAcceptableOrUnknown(
          data['ownership_type_id']!,
          _ownership_type_idMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownership_type_id};
  @override
  OwnershipTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnershipTypeData(
      ownership_type_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}ownership_type_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
    );
  }

  @override
  $OwnershipTypesTable createAlias(String alias) {
    return $OwnershipTypesTable(attachedDatabase, alias);
  }
}

class OwnershipTypeData extends DataClass
    implements Insertable<OwnershipTypeData> {
  final int ownership_type_id;
  final String type;
  const OwnershipTypeData({
    required this.ownership_type_id,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ownership_type_id'] = Variable<int>(ownership_type_id);
    map['type'] = Variable<String>(type);
    return map;
  }

  OwnershipTypesCompanion toCompanion(bool nullToAbsent) {
    return OwnershipTypesCompanion(
      ownership_type_id: Value(ownership_type_id),
      type: Value(type),
    );
  }

  factory OwnershipTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnershipTypeData(
      ownership_type_id: serializer.fromJson<int>(json['ownership_type_id']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownership_type_id': serializer.toJson<int>(ownership_type_id),
      'type': serializer.toJson<String>(type),
    };
  }

  OwnershipTypeData copyWith({int? ownership_type_id, String? type}) =>
      OwnershipTypeData(
        ownership_type_id: ownership_type_id ?? this.ownership_type_id,
        type: type ?? this.type,
      );
  OwnershipTypeData copyWithCompanion(OwnershipTypesCompanion data) {
    return OwnershipTypeData(
      ownership_type_id:
          data.ownership_type_id.present
              ? data.ownership_type_id.value
              : this.ownership_type_id,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnershipTypeData(')
          ..write('ownership_type_id: $ownership_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ownership_type_id, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnershipTypeData &&
          other.ownership_type_id == this.ownership_type_id &&
          other.type == this.type);
}

class OwnershipTypesCompanion extends UpdateCompanion<OwnershipTypeData> {
  final Value<int> ownership_type_id;
  final Value<String> type;
  const OwnershipTypesCompanion({
    this.ownership_type_id = const Value.absent(),
    this.type = const Value.absent(),
  });
  OwnershipTypesCompanion.insert({
    this.ownership_type_id = const Value.absent(),
    required String type,
  }) : type = Value(type);
  static Insertable<OwnershipTypeData> custom({
    Expression<int>? ownership_type_id,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (ownership_type_id != null) 'ownership_type_id': ownership_type_id,
      if (type != null) 'type': type,
    });
  }

  OwnershipTypesCompanion copyWith({
    Value<int>? ownership_type_id,
    Value<String>? type,
  }) {
    return OwnershipTypesCompanion(
      ownership_type_id: ownership_type_id ?? this.ownership_type_id,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownership_type_id.present) {
      map['ownership_type_id'] = Variable<int>(ownership_type_id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnershipTypesCompanion(')
          ..write('ownership_type_id: $ownership_type_id, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, HouseholdData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _household_idMeta = const VerificationMeta(
    'household_id',
  );
  @override
  late final GeneratedColumn<int> household_id = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _headMeta = const VerificationMeta('head');
  @override
  late final GeneratedColumn<String> head = GeneratedColumn<String>(
    'head',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _address_idMeta = const VerificationMeta(
    'address_id',
  );
  @override
  late final GeneratedColumn<int> address_id = GeneratedColumn<int>(
    'address_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES addresses (address_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _household_type_idMeta = const VerificationMeta(
    'household_type_id',
  );
  @override
  late final GeneratedColumn<int> household_type_id = GeneratedColumn<int>(
    'household_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES household_types (household_type_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _building_type_idMeta = const VerificationMeta(
    'building_type_id',
  );
  @override
  late final GeneratedColumn<int> building_type_id = GeneratedColumn<int>(
    'building_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES building_types (building_type_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _ownership_type_idMeta = const VerificationMeta(
    'ownership_type_id',
  );
  @override
  late final GeneratedColumn<int> ownership_type_id = GeneratedColumn<int>(
    'ownership_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ownership_types (ownership_type_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _household_members_numMeta =
      const VerificationMeta('household_members_num');
  @override
  late final GeneratedColumn<int> household_members_num = GeneratedColumn<int>(
    'household_members_num',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _female_mortalityMeta = const VerificationMeta(
    'female_mortality',
  );
  @override
  late final GeneratedColumn<bool> female_mortality = GeneratedColumn<bool>(
    'female_mortality',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("female_mortality" IN (0, 1))',
    ),
  );
  static const VerificationMeta _child_mortalityMeta = const VerificationMeta(
    'child_mortality',
  );
  @override
  late final GeneratedColumn<bool> child_mortality = GeneratedColumn<bool>(
    'child_mortality',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("child_mortality" IN (0, 1))',
    ),
  );
  static const VerificationMeta _registration_dateMeta = const VerificationMeta(
    'registration_date',
  );
  @override
  late final GeneratedColumn<DateTime> registration_date =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<RegistrationStatus, String>
  registration_status = GeneratedColumn<String>(
    'registration_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RegistrationStatus>(
    $HouseholdsTable.$converterregistration_status,
  );
  @override
  List<GeneratedColumn> get $columns => [
    household_id,
    head,
    address_id,
    household_type_id,
    building_type_id,
    ownership_type_id,
    household_members_num,
    female_mortality,
    child_mortality,
    registration_date,
    registration_status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(
    Insertable<HouseholdData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('household_id')) {
      context.handle(
        _household_idMeta,
        household_id.isAcceptableOrUnknown(
          data['household_id']!,
          _household_idMeta,
        ),
      );
    }
    if (data.containsKey('head')) {
      context.handle(
        _headMeta,
        head.isAcceptableOrUnknown(data['head']!, _headMeta),
      );
    }
    if (data.containsKey('address_id')) {
      context.handle(
        _address_idMeta,
        address_id.isAcceptableOrUnknown(data['address_id']!, _address_idMeta),
      );
    }
    if (data.containsKey('household_type_id')) {
      context.handle(
        _household_type_idMeta,
        household_type_id.isAcceptableOrUnknown(
          data['household_type_id']!,
          _household_type_idMeta,
        ),
      );
    }
    if (data.containsKey('building_type_id')) {
      context.handle(
        _building_type_idMeta,
        building_type_id.isAcceptableOrUnknown(
          data['building_type_id']!,
          _building_type_idMeta,
        ),
      );
    }
    if (data.containsKey('ownership_type_id')) {
      context.handle(
        _ownership_type_idMeta,
        ownership_type_id.isAcceptableOrUnknown(
          data['ownership_type_id']!,
          _ownership_type_idMeta,
        ),
      );
    }
    if (data.containsKey('household_members_num')) {
      context.handle(
        _household_members_numMeta,
        household_members_num.isAcceptableOrUnknown(
          data['household_members_num']!,
          _household_members_numMeta,
        ),
      );
    }
    if (data.containsKey('female_mortality')) {
      context.handle(
        _female_mortalityMeta,
        female_mortality.isAcceptableOrUnknown(
          data['female_mortality']!,
          _female_mortalityMeta,
        ),
      );
    }
    if (data.containsKey('child_mortality')) {
      context.handle(
        _child_mortalityMeta,
        child_mortality.isAcceptableOrUnknown(
          data['child_mortality']!,
          _child_mortalityMeta,
        ),
      );
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registration_dateMeta,
        registration_date.isAcceptableOrUnknown(
          data['registration_date']!,
          _registration_dateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {household_id};
  @override
  HouseholdData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdData(
      household_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}household_id'],
          )!,
      head: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}head'],
      ),
      address_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}address_id'],
      ),
      household_type_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_type_id'],
      ),
      building_type_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}building_type_id'],
      ),
      ownership_type_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ownership_type_id'],
      ),
      household_members_num: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_members_num'],
      ),
      female_mortality: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}female_mortality'],
      ),
      child_mortality: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}child_mortality'],
      ),
      registration_date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      ),
      registration_status: $HouseholdsTable.$converterregistration_status
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}registration_status'],
            )!,
          ),
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RegistrationStatus, String, String>
  $converterregistration_status = const EnumNameConverter<RegistrationStatus>(
    RegistrationStatus.values,
  );
}

class HouseholdData extends DataClass implements Insertable<HouseholdData> {
  final int household_id;
  final String? head;
  final int? address_id;
  final int? household_type_id;
  final int? building_type_id;
  final int? ownership_type_id;
  final int? household_members_num;
  final bool? female_mortality;
  final bool? child_mortality;
  final DateTime? registration_date;
  final RegistrationStatus registration_status;
  const HouseholdData({
    required this.household_id,
    this.head,
    this.address_id,
    this.household_type_id,
    this.building_type_id,
    this.ownership_type_id,
    this.household_members_num,
    this.female_mortality,
    this.child_mortality,
    this.registration_date,
    required this.registration_status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['household_id'] = Variable<int>(household_id);
    if (!nullToAbsent || head != null) {
      map['head'] = Variable<String>(head);
    }
    if (!nullToAbsent || address_id != null) {
      map['address_id'] = Variable<int>(address_id);
    }
    if (!nullToAbsent || household_type_id != null) {
      map['household_type_id'] = Variable<int>(household_type_id);
    }
    if (!nullToAbsent || building_type_id != null) {
      map['building_type_id'] = Variable<int>(building_type_id);
    }
    if (!nullToAbsent || ownership_type_id != null) {
      map['ownership_type_id'] = Variable<int>(ownership_type_id);
    }
    if (!nullToAbsent || household_members_num != null) {
      map['household_members_num'] = Variable<int>(household_members_num);
    }
    if (!nullToAbsent || female_mortality != null) {
      map['female_mortality'] = Variable<bool>(female_mortality);
    }
    if (!nullToAbsent || child_mortality != null) {
      map['child_mortality'] = Variable<bool>(child_mortality);
    }
    if (!nullToAbsent || registration_date != null) {
      map['registration_date'] = Variable<DateTime>(registration_date);
    }
    {
      map['registration_status'] = Variable<String>(
        $HouseholdsTable.$converterregistration_status.toSql(
          registration_status,
        ),
      );
    }
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      household_id: Value(household_id),
      head: head == null && nullToAbsent ? const Value.absent() : Value(head),
      address_id:
          address_id == null && nullToAbsent
              ? const Value.absent()
              : Value(address_id),
      household_type_id:
          household_type_id == null && nullToAbsent
              ? const Value.absent()
              : Value(household_type_id),
      building_type_id:
          building_type_id == null && nullToAbsent
              ? const Value.absent()
              : Value(building_type_id),
      ownership_type_id:
          ownership_type_id == null && nullToAbsent
              ? const Value.absent()
              : Value(ownership_type_id),
      household_members_num:
          household_members_num == null && nullToAbsent
              ? const Value.absent()
              : Value(household_members_num),
      female_mortality:
          female_mortality == null && nullToAbsent
              ? const Value.absent()
              : Value(female_mortality),
      child_mortality:
          child_mortality == null && nullToAbsent
              ? const Value.absent()
              : Value(child_mortality),
      registration_date:
          registration_date == null && nullToAbsent
              ? const Value.absent()
              : Value(registration_date),
      registration_status: Value(registration_status),
    );
  }

  factory HouseholdData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdData(
      household_id: serializer.fromJson<int>(json['household_id']),
      head: serializer.fromJson<String?>(json['head']),
      address_id: serializer.fromJson<int?>(json['address_id']),
      household_type_id: serializer.fromJson<int?>(json['household_type_id']),
      building_type_id: serializer.fromJson<int?>(json['building_type_id']),
      ownership_type_id: serializer.fromJson<int?>(json['ownership_type_id']),
      household_members_num: serializer.fromJson<int?>(
        json['household_members_num'],
      ),
      female_mortality: serializer.fromJson<bool?>(json['female_mortality']),
      child_mortality: serializer.fromJson<bool?>(json['child_mortality']),
      registration_date: serializer.fromJson<DateTime?>(
        json['registration_date'],
      ),
      registration_status: $HouseholdsTable.$converterregistration_status
          .fromJson(serializer.fromJson<String>(json['registration_status'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'household_id': serializer.toJson<int>(household_id),
      'head': serializer.toJson<String?>(head),
      'address_id': serializer.toJson<int?>(address_id),
      'household_type_id': serializer.toJson<int?>(household_type_id),
      'building_type_id': serializer.toJson<int?>(building_type_id),
      'ownership_type_id': serializer.toJson<int?>(ownership_type_id),
      'household_members_num': serializer.toJson<int?>(household_members_num),
      'female_mortality': serializer.toJson<bool?>(female_mortality),
      'child_mortality': serializer.toJson<bool?>(child_mortality),
      'registration_date': serializer.toJson<DateTime?>(registration_date),
      'registration_status': serializer.toJson<String>(
        $HouseholdsTable.$converterregistration_status.toJson(
          registration_status,
        ),
      ),
    };
  }

  HouseholdData copyWith({
    int? household_id,
    Value<String?> head = const Value.absent(),
    Value<int?> address_id = const Value.absent(),
    Value<int?> household_type_id = const Value.absent(),
    Value<int?> building_type_id = const Value.absent(),
    Value<int?> ownership_type_id = const Value.absent(),
    Value<int?> household_members_num = const Value.absent(),
    Value<bool?> female_mortality = const Value.absent(),
    Value<bool?> child_mortality = const Value.absent(),
    Value<DateTime?> registration_date = const Value.absent(),
    RegistrationStatus? registration_status,
  }) => HouseholdData(
    household_id: household_id ?? this.household_id,
    head: head.present ? head.value : this.head,
    address_id: address_id.present ? address_id.value : this.address_id,
    household_type_id:
        household_type_id.present
            ? household_type_id.value
            : this.household_type_id,
    building_type_id:
        building_type_id.present
            ? building_type_id.value
            : this.building_type_id,
    ownership_type_id:
        ownership_type_id.present
            ? ownership_type_id.value
            : this.ownership_type_id,
    household_members_num:
        household_members_num.present
            ? household_members_num.value
            : this.household_members_num,
    female_mortality:
        female_mortality.present
            ? female_mortality.value
            : this.female_mortality,
    child_mortality:
        child_mortality.present ? child_mortality.value : this.child_mortality,
    registration_date:
        registration_date.present
            ? registration_date.value
            : this.registration_date,
    registration_status: registration_status ?? this.registration_status,
  );
  HouseholdData copyWithCompanion(HouseholdsCompanion data) {
    return HouseholdData(
      household_id:
          data.household_id.present
              ? data.household_id.value
              : this.household_id,
      head: data.head.present ? data.head.value : this.head,
      address_id:
          data.address_id.present ? data.address_id.value : this.address_id,
      household_type_id:
          data.household_type_id.present
              ? data.household_type_id.value
              : this.household_type_id,
      building_type_id:
          data.building_type_id.present
              ? data.building_type_id.value
              : this.building_type_id,
      ownership_type_id:
          data.ownership_type_id.present
              ? data.ownership_type_id.value
              : this.ownership_type_id,
      household_members_num:
          data.household_members_num.present
              ? data.household_members_num.value
              : this.household_members_num,
      female_mortality:
          data.female_mortality.present
              ? data.female_mortality.value
              : this.female_mortality,
      child_mortality:
          data.child_mortality.present
              ? data.child_mortality.value
              : this.child_mortality,
      registration_date:
          data.registration_date.present
              ? data.registration_date.value
              : this.registration_date,
      registration_status:
          data.registration_status.present
              ? data.registration_status.value
              : this.registration_status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdData(')
          ..write('household_id: $household_id, ')
          ..write('head: $head, ')
          ..write('address_id: $address_id, ')
          ..write('household_type_id: $household_type_id, ')
          ..write('building_type_id: $building_type_id, ')
          ..write('ownership_type_id: $ownership_type_id, ')
          ..write('household_members_num: $household_members_num, ')
          ..write('female_mortality: $female_mortality, ')
          ..write('child_mortality: $child_mortality, ')
          ..write('registration_date: $registration_date, ')
          ..write('registration_status: $registration_status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    household_id,
    head,
    address_id,
    household_type_id,
    building_type_id,
    ownership_type_id,
    household_members_num,
    female_mortality,
    child_mortality,
    registration_date,
    registration_status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdData &&
          other.household_id == this.household_id &&
          other.head == this.head &&
          other.address_id == this.address_id &&
          other.household_type_id == this.household_type_id &&
          other.building_type_id == this.building_type_id &&
          other.ownership_type_id == this.ownership_type_id &&
          other.household_members_num == this.household_members_num &&
          other.female_mortality == this.female_mortality &&
          other.child_mortality == this.child_mortality &&
          other.registration_date == this.registration_date &&
          other.registration_status == this.registration_status);
}

class HouseholdsCompanion extends UpdateCompanion<HouseholdData> {
  final Value<int> household_id;
  final Value<String?> head;
  final Value<int?> address_id;
  final Value<int?> household_type_id;
  final Value<int?> building_type_id;
  final Value<int?> ownership_type_id;
  final Value<int?> household_members_num;
  final Value<bool?> female_mortality;
  final Value<bool?> child_mortality;
  final Value<DateTime?> registration_date;
  final Value<RegistrationStatus> registration_status;
  const HouseholdsCompanion({
    this.household_id = const Value.absent(),
    this.head = const Value.absent(),
    this.address_id = const Value.absent(),
    this.household_type_id = const Value.absent(),
    this.building_type_id = const Value.absent(),
    this.ownership_type_id = const Value.absent(),
    this.household_members_num = const Value.absent(),
    this.female_mortality = const Value.absent(),
    this.child_mortality = const Value.absent(),
    this.registration_date = const Value.absent(),
    this.registration_status = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    this.household_id = const Value.absent(),
    this.head = const Value.absent(),
    this.address_id = const Value.absent(),
    this.household_type_id = const Value.absent(),
    this.building_type_id = const Value.absent(),
    this.ownership_type_id = const Value.absent(),
    this.household_members_num = const Value.absent(),
    this.female_mortality = const Value.absent(),
    this.child_mortality = const Value.absent(),
    this.registration_date = const Value.absent(),
    required RegistrationStatus registration_status,
  }) : registration_status = Value(registration_status);
  static Insertable<HouseholdData> custom({
    Expression<int>? household_id,
    Expression<String>? head,
    Expression<int>? address_id,
    Expression<int>? household_type_id,
    Expression<int>? building_type_id,
    Expression<int>? ownership_type_id,
    Expression<int>? household_members_num,
    Expression<bool>? female_mortality,
    Expression<bool>? child_mortality,
    Expression<DateTime>? registration_date,
    Expression<String>? registration_status,
  }) {
    return RawValuesInsertable({
      if (household_id != null) 'household_id': household_id,
      if (head != null) 'head': head,
      if (address_id != null) 'address_id': address_id,
      if (household_type_id != null) 'household_type_id': household_type_id,
      if (building_type_id != null) 'building_type_id': building_type_id,
      if (ownership_type_id != null) 'ownership_type_id': ownership_type_id,
      if (household_members_num != null)
        'household_members_num': household_members_num,
      if (female_mortality != null) 'female_mortality': female_mortality,
      if (child_mortality != null) 'child_mortality': child_mortality,
      if (registration_date != null) 'registration_date': registration_date,
      if (registration_status != null)
        'registration_status': registration_status,
    });
  }

  HouseholdsCompanion copyWith({
    Value<int>? household_id,
    Value<String?>? head,
    Value<int?>? address_id,
    Value<int?>? household_type_id,
    Value<int?>? building_type_id,
    Value<int?>? ownership_type_id,
    Value<int?>? household_members_num,
    Value<bool?>? female_mortality,
    Value<bool?>? child_mortality,
    Value<DateTime?>? registration_date,
    Value<RegistrationStatus>? registration_status,
  }) {
    return HouseholdsCompanion(
      household_id: household_id ?? this.household_id,
      head: head ?? this.head,
      address_id: address_id ?? this.address_id,
      household_type_id: household_type_id ?? this.household_type_id,
      building_type_id: building_type_id ?? this.building_type_id,
      ownership_type_id: ownership_type_id ?? this.ownership_type_id,
      household_members_num:
          household_members_num ?? this.household_members_num,
      female_mortality: female_mortality ?? this.female_mortality,
      child_mortality: child_mortality ?? this.child_mortality,
      registration_date: registration_date ?? this.registration_date,
      registration_status: registration_status ?? this.registration_status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (household_id.present) {
      map['household_id'] = Variable<int>(household_id.value);
    }
    if (head.present) {
      map['head'] = Variable<String>(head.value);
    }
    if (address_id.present) {
      map['address_id'] = Variable<int>(address_id.value);
    }
    if (household_type_id.present) {
      map['household_type_id'] = Variable<int>(household_type_id.value);
    }
    if (building_type_id.present) {
      map['building_type_id'] = Variable<int>(building_type_id.value);
    }
    if (ownership_type_id.present) {
      map['ownership_type_id'] = Variable<int>(ownership_type_id.value);
    }
    if (household_members_num.present) {
      map['household_members_num'] = Variable<int>(household_members_num.value);
    }
    if (female_mortality.present) {
      map['female_mortality'] = Variable<bool>(female_mortality.value);
    }
    if (child_mortality.present) {
      map['child_mortality'] = Variable<bool>(child_mortality.value);
    }
    if (registration_date.present) {
      map['registration_date'] = Variable<DateTime>(registration_date.value);
    }
    if (registration_status.present) {
      map['registration_status'] = Variable<String>(
        $HouseholdsTable.$converterregistration_status.toSql(
          registration_status.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('household_id: $household_id, ')
          ..write('head: $head, ')
          ..write('address_id: $address_id, ')
          ..write('household_type_id: $household_type_id, ')
          ..write('building_type_id: $building_type_id, ')
          ..write('ownership_type_id: $ownership_type_id, ')
          ..write('household_members_num: $household_members_num, ')
          ..write('female_mortality: $female_mortality, ')
          ..write('child_mortality: $child_mortality, ')
          ..write('registration_date: $registration_date, ')
          ..write('registration_status: $registration_status')
          ..write(')'))
        .toString();
  }
}

class $MonthlyIncomesTable extends MonthlyIncomes
    with TableInfo<$MonthlyIncomesTable, MonthlyIncomeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyIncomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _monthly_income_idMeta = const VerificationMeta(
    'monthly_income_id',
  );
  @override
  late final GeneratedColumn<int> monthly_income_id = GeneratedColumn<int>(
    'monthly_income_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<String> range = GeneratedColumn<String>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [monthly_income_id, range];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyIncomeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('monthly_income_id')) {
      context.handle(
        _monthly_income_idMeta,
        monthly_income_id.isAcceptableOrUnknown(
          data['monthly_income_id']!,
          _monthly_income_idMeta,
        ),
      );
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {monthly_income_id};
  @override
  MonthlyIncomeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyIncomeData(
      monthly_income_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}monthly_income_id'],
          )!,
      range:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}range'],
          )!,
    );
  }

  @override
  $MonthlyIncomesTable createAlias(String alias) {
    return $MonthlyIncomesTable(attachedDatabase, alias);
  }
}

class MonthlyIncomeData extends DataClass
    implements Insertable<MonthlyIncomeData> {
  final int monthly_income_id;
  final String range;
  const MonthlyIncomeData({
    required this.monthly_income_id,
    required this.range,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['monthly_income_id'] = Variable<int>(monthly_income_id);
    map['range'] = Variable<String>(range);
    return map;
  }

  MonthlyIncomesCompanion toCompanion(bool nullToAbsent) {
    return MonthlyIncomesCompanion(
      monthly_income_id: Value(monthly_income_id),
      range: Value(range),
    );
  }

  factory MonthlyIncomeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyIncomeData(
      monthly_income_id: serializer.fromJson<int>(json['monthly_income_id']),
      range: serializer.fromJson<String>(json['range']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'monthly_income_id': serializer.toJson<int>(monthly_income_id),
      'range': serializer.toJson<String>(range),
    };
  }

  MonthlyIncomeData copyWith({int? monthly_income_id, String? range}) =>
      MonthlyIncomeData(
        monthly_income_id: monthly_income_id ?? this.monthly_income_id,
        range: range ?? this.range,
      );
  MonthlyIncomeData copyWithCompanion(MonthlyIncomesCompanion data) {
    return MonthlyIncomeData(
      monthly_income_id:
          data.monthly_income_id.present
              ? data.monthly_income_id.value
              : this.monthly_income_id,
      range: data.range.present ? data.range.value : this.range,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyIncomeData(')
          ..write('monthly_income_id: $monthly_income_id, ')
          ..write('range: $range')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(monthly_income_id, range);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyIncomeData &&
          other.monthly_income_id == this.monthly_income_id &&
          other.range == this.range);
}

class MonthlyIncomesCompanion extends UpdateCompanion<MonthlyIncomeData> {
  final Value<int> monthly_income_id;
  final Value<String> range;
  const MonthlyIncomesCompanion({
    this.monthly_income_id = const Value.absent(),
    this.range = const Value.absent(),
  });
  MonthlyIncomesCompanion.insert({
    this.monthly_income_id = const Value.absent(),
    required String range,
  }) : range = Value(range);
  static Insertable<MonthlyIncomeData> custom({
    Expression<int>? monthly_income_id,
    Expression<String>? range,
  }) {
    return RawValuesInsertable({
      if (monthly_income_id != null) 'monthly_income_id': monthly_income_id,
      if (range != null) 'range': range,
    });
  }

  MonthlyIncomesCompanion copyWith({
    Value<int>? monthly_income_id,
    Value<String>? range,
  }) {
    return MonthlyIncomesCompanion(
      monthly_income_id: monthly_income_id ?? this.monthly_income_id,
      range: range ?? this.range,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (monthly_income_id.present) {
      map['monthly_income_id'] = Variable<int>(monthly_income_id.value);
    }
    if (range.present) {
      map['range'] = Variable<String>(range.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyIncomesCompanion(')
          ..write('monthly_income_id: $monthly_income_id, ')
          ..write('range: $range')
          ..write(')'))
        .toString();
  }
}

class $DailyIncomesTable extends DailyIncomes
    with TableInfo<$DailyIncomesTable, DailyIncomeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyIncomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _daily_income_idMeta = const VerificationMeta(
    'daily_income_id',
  );
  @override
  late final GeneratedColumn<int> daily_income_id = GeneratedColumn<int>(
    'daily_income_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<String> range = GeneratedColumn<String>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [daily_income_id, range];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyIncomeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('daily_income_id')) {
      context.handle(
        _daily_income_idMeta,
        daily_income_id.isAcceptableOrUnknown(
          data['daily_income_id']!,
          _daily_income_idMeta,
        ),
      );
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {daily_income_id};
  @override
  DailyIncomeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyIncomeData(
      daily_income_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}daily_income_id'],
          )!,
      range:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}range'],
          )!,
    );
  }

  @override
  $DailyIncomesTable createAlias(String alias) {
    return $DailyIncomesTable(attachedDatabase, alias);
  }
}

class DailyIncomeData extends DataClass implements Insertable<DailyIncomeData> {
  final int daily_income_id;
  final String range;
  const DailyIncomeData({required this.daily_income_id, required this.range});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['daily_income_id'] = Variable<int>(daily_income_id);
    map['range'] = Variable<String>(range);
    return map;
  }

  DailyIncomesCompanion toCompanion(bool nullToAbsent) {
    return DailyIncomesCompanion(
      daily_income_id: Value(daily_income_id),
      range: Value(range),
    );
  }

  factory DailyIncomeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyIncomeData(
      daily_income_id: serializer.fromJson<int>(json['daily_income_id']),
      range: serializer.fromJson<String>(json['range']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'daily_income_id': serializer.toJson<int>(daily_income_id),
      'range': serializer.toJson<String>(range),
    };
  }

  DailyIncomeData copyWith({int? daily_income_id, String? range}) =>
      DailyIncomeData(
        daily_income_id: daily_income_id ?? this.daily_income_id,
        range: range ?? this.range,
      );
  DailyIncomeData copyWithCompanion(DailyIncomesCompanion data) {
    return DailyIncomeData(
      daily_income_id:
          data.daily_income_id.present
              ? data.daily_income_id.value
              : this.daily_income_id,
      range: data.range.present ? data.range.value : this.range,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyIncomeData(')
          ..write('daily_income_id: $daily_income_id, ')
          ..write('range: $range')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(daily_income_id, range);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyIncomeData &&
          other.daily_income_id == this.daily_income_id &&
          other.range == this.range);
}

class DailyIncomesCompanion extends UpdateCompanion<DailyIncomeData> {
  final Value<int> daily_income_id;
  final Value<String> range;
  const DailyIncomesCompanion({
    this.daily_income_id = const Value.absent(),
    this.range = const Value.absent(),
  });
  DailyIncomesCompanion.insert({
    this.daily_income_id = const Value.absent(),
    required String range,
  }) : range = Value(range);
  static Insertable<DailyIncomeData> custom({
    Expression<int>? daily_income_id,
    Expression<String>? range,
  }) {
    return RawValuesInsertable({
      if (daily_income_id != null) 'daily_income_id': daily_income_id,
      if (range != null) 'range': range,
    });
  }

  DailyIncomesCompanion copyWith({
    Value<int>? daily_income_id,
    Value<String>? range,
  }) {
    return DailyIncomesCompanion(
      daily_income_id: daily_income_id ?? this.daily_income_id,
      range: range ?? this.range,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (daily_income_id.present) {
      map['daily_income_id'] = Variable<int>(daily_income_id.value);
    }
    if (range.present) {
      map['range'] = Variable<String>(range.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyIncomesCompanion(')
          ..write('daily_income_id: $daily_income_id, ')
          ..write('range: $range')
          ..write(')'))
        .toString();
  }
}

class $EducationTable extends Education
    with TableInfo<$EducationTable, EducationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EducationTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _education_idMeta = const VerificationMeta(
    'education_id',
  );
  @override
  late final GeneratedColumn<int> education_id = GeneratedColumn<int>(
    'education_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [education_id, level];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'education';
  @override
  VerificationContext validateIntegrity(
    Insertable<EducationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('education_id')) {
      context.handle(
        _education_idMeta,
        education_id.isAcceptableOrUnknown(
          data['education_id']!,
          _education_idMeta,
        ),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {education_id};
  @override
  EducationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EducationData(
      education_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}education_id'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}level'],
          )!,
    );
  }

  @override
  $EducationTable createAlias(String alias) {
    return $EducationTable(attachedDatabase, alias);
  }
}

class EducationData extends DataClass implements Insertable<EducationData> {
  final int education_id;
  final String level;
  const EducationData({required this.education_id, required this.level});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['education_id'] = Variable<int>(education_id);
    map['level'] = Variable<String>(level);
    return map;
  }

  EducationCompanion toCompanion(bool nullToAbsent) {
    return EducationCompanion(
      education_id: Value(education_id),
      level: Value(level),
    );
  }

  factory EducationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EducationData(
      education_id: serializer.fromJson<int>(json['education_id']),
      level: serializer.fromJson<String>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'education_id': serializer.toJson<int>(education_id),
      'level': serializer.toJson<String>(level),
    };
  }

  EducationData copyWith({int? education_id, String? level}) => EducationData(
    education_id: education_id ?? this.education_id,
    level: level ?? this.level,
  );
  EducationData copyWithCompanion(EducationCompanion data) {
    return EducationData(
      education_id:
          data.education_id.present
              ? data.education_id.value
              : this.education_id,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EducationData(')
          ..write('education_id: $education_id, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(education_id, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EducationData &&
          other.education_id == this.education_id &&
          other.level == this.level);
}

class EducationCompanion extends UpdateCompanion<EducationData> {
  final Value<int> education_id;
  final Value<String> level;
  const EducationCompanion({
    this.education_id = const Value.absent(),
    this.level = const Value.absent(),
  });
  EducationCompanion.insert({
    this.education_id = const Value.absent(),
    required String level,
  }) : level = Value(level);
  static Insertable<EducationData> custom({
    Expression<int>? education_id,
    Expression<String>? level,
  }) {
    return RawValuesInsertable({
      if (education_id != null) 'education_id': education_id,
      if (level != null) 'level': level,
    });
  }

  EducationCompanion copyWith({
    Value<int>? education_id,
    Value<String>? level,
  }) {
    return EducationCompanion(
      education_id: education_id ?? this.education_id,
      level: level ?? this.level,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (education_id.present) {
      map['education_id'] = Variable<int>(education_id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EducationCompanion(')
          ..write('education_id: $education_id, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, PersonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _person_idMeta = const VerificationMeta(
    'person_id',
  );
  @override
  late final GeneratedColumn<int> person_id = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _last_nameMeta = const VerificationMeta(
    'last_name',
  );
  @override
  late final GeneratedColumn<String> last_name = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _first_nameMeta = const VerificationMeta(
    'first_name',
  );
  @override
  late final GeneratedColumn<String> first_name = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _middle_nameMeta = const VerificationMeta(
    'middle_name',
  );
  @override
  late final GeneratedColumn<String> middle_name = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suffixMeta = const VerificationMeta('suffix');
  @override
  late final GeneratedColumn<String> suffix = GeneratedColumn<String>(
    'suffix',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Sex?, String> sex =
      GeneratedColumn<String>(
        'sex',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Sex?>($PersonsTable.$convertersexn);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birth_dateMeta = const VerificationMeta(
    'birth_date',
  );
  @override
  late final GeneratedColumn<DateTime> birth_date = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birth_placeMeta = const VerificationMeta(
    'birth_place',
  );
  @override
  late final GeneratedColumn<String> birth_place = GeneratedColumn<String>(
    'birth_place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CivilStatus?, String>
  civil_status = GeneratedColumn<String>(
    'civil_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<CivilStatus?>($PersonsTable.$convertercivil_statusn);
  static const VerificationMeta _religion_idMeta = const VerificationMeta(
    'religion_id',
  );
  @override
  late final GeneratedColumn<int> religion_id = GeneratedColumn<int>(
    'religion_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES religions (religion_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nationality_idMeta = const VerificationMeta(
    'nationality_id',
  );
  @override
  late final GeneratedColumn<int> nationality_id = GeneratedColumn<int>(
    'nationality_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nationalities (nationality_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _ethnicity_idMeta = const VerificationMeta(
    'ethnicity_id',
  );
  @override
  late final GeneratedColumn<int> ethnicity_id = GeneratedColumn<int>(
    'ethnicity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ethnicities (ethnicity_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _blood_type_idMeta = const VerificationMeta(
    'blood_type_id',
  );
  @override
  late final GeneratedColumn<int> blood_type_id = GeneratedColumn<int>(
    'blood_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blood_types (blood_type_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _household_idMeta = const VerificationMeta(
    'household_id',
  );
  @override
  late final GeneratedColumn<int> household_id = GeneratedColumn<int>(
    'household_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES households (household_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _address_idMeta = const VerificationMeta(
    'address_id',
  );
  @override
  late final GeneratedColumn<int> address_id = GeneratedColumn<int>(
    'address_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES addresses (address_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _registration_placeMeta =
      const VerificationMeta('registration_place');
  @override
  late final GeneratedColumn<String> registration_place =
      GeneratedColumn<String>(
        'registration_place',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Residency?, String> residency =
      GeneratedColumn<String>(
        'residency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Residency?>($PersonsTable.$converterresidencyn);
  static const VerificationMeta _years_of_residencyMeta =
      const VerificationMeta('years_of_residency');
  @override
  late final GeneratedColumn<int> years_of_residency = GeneratedColumn<int>(
    'years_of_residency',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Transient?, String>
  transient_type = GeneratedColumn<String>(
    'transient_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Transient?>($PersonsTable.$convertertransient_typen);
  static const VerificationMeta _monthly_income_idMeta = const VerificationMeta(
    'monthly_income_id',
  );
  @override
  late final GeneratedColumn<int> monthly_income_id = GeneratedColumn<int>(
    'monthly_income_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES monthly_incomes (monthly_income_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _daily_income_idMeta = const VerificationMeta(
    'daily_income_id',
  );
  @override
  late final GeneratedColumn<int> daily_income_id = GeneratedColumn<int>(
    'daily_income_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_incomes (daily_income_id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SoloParent?, String> solo_parent =
      GeneratedColumn<String>(
        'solo_parent',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SoloParent?>($PersonsTable.$convertersolo_parentn);
  static const VerificationMeta _ofwMeta = const VerificationMeta('ofw');
  @override
  late final GeneratedColumn<bool> ofw = GeneratedColumn<bool>(
    'ofw',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ofw" IN (0, 1))',
    ),
  );
  static const VerificationMeta _literateMeta = const VerificationMeta(
    'literate',
  );
  @override
  late final GeneratedColumn<bool> literate = GeneratedColumn<bool>(
    'literate',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("literate" IN (0, 1))',
    ),
  );
  static const VerificationMeta _pwdMeta = const VerificationMeta('pwd');
  @override
  late final GeneratedColumn<bool> pwd = GeneratedColumn<bool>(
    'pwd',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pwd" IN (0, 1))',
    ),
  );
  static const VerificationMeta _registered_voterMeta = const VerificationMeta(
    'registered_voter',
  );
  @override
  late final GeneratedColumn<bool> registered_voter = GeneratedColumn<bool>(
    'registered_voter',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("registered_voter" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CurrentlyEnrolled?, String>
  currently_enrolled = GeneratedColumn<String>(
    'currently_enrolled',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<CurrentlyEnrolled?>(
    $PersonsTable.$convertercurrently_enrolledn,
  );
  static const VerificationMeta _education_idMeta = const VerificationMeta(
    'education_id',
  );
  @override
  late final GeneratedColumn<int> education_id = GeneratedColumn<int>(
    'education_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES education (education_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _deceasedMeta = const VerificationMeta(
    'deceased',
  );
  @override
  late final GeneratedColumn<bool> deceased = GeneratedColumn<bool>(
    'deceased',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deceased" IN (0, 1))',
    ),
  );
  static const VerificationMeta _death_dateMeta = const VerificationMeta(
    'death_date',
  );
  @override
  late final GeneratedColumn<DateTime> death_date = GeneratedColumn<DateTime>(
    'death_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registration_dateMeta = const VerificationMeta(
    'registration_date',
  );
  @override
  late final GeneratedColumn<DateTime> registration_date =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<RegistrationStatus, String>
  registration_status = GeneratedColumn<String>(
    'registration_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RegistrationStatus>(
    $PersonsTable.$converterregistration_status,
  );
  @override
  List<GeneratedColumn> get $columns => [
    person_id,
    last_name,
    first_name,
    middle_name,
    suffix,
    sex,
    age,
    birth_date,
    birth_place,
    civil_status,
    religion_id,
    nationality_id,
    ethnicity_id,
    blood_type_id,
    household_id,
    address_id,
    registration_place,
    residency,
    years_of_residency,
    transient_type,
    monthly_income_id,
    daily_income_id,
    solo_parent,
    ofw,
    literate,
    pwd,
    registered_voter,
    currently_enrolled,
    education_id,
    deceased,
    death_date,
    registration_date,
    registration_status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('person_id')) {
      context.handle(
        _person_idMeta,
        person_id.isAcceptableOrUnknown(data['person_id']!, _person_idMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _last_nameMeta,
        last_name.isAcceptableOrUnknown(data['last_name']!, _last_nameMeta),
      );
    } else if (isInserting) {
      context.missing(_last_nameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _first_nameMeta,
        first_name.isAcceptableOrUnknown(data['first_name']!, _first_nameMeta),
      );
    } else if (isInserting) {
      context.missing(_first_nameMeta);
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middle_nameMeta,
        middle_name.isAcceptableOrUnknown(
          data['middle_name']!,
          _middle_nameMeta,
        ),
      );
    }
    if (data.containsKey('suffix')) {
      context.handle(
        _suffixMeta,
        suffix.isAcceptableOrUnknown(data['suffix']!, _suffixMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birth_dateMeta,
        birth_date.isAcceptableOrUnknown(data['birth_date']!, _birth_dateMeta),
      );
    }
    if (data.containsKey('birth_place')) {
      context.handle(
        _birth_placeMeta,
        birth_place.isAcceptableOrUnknown(
          data['birth_place']!,
          _birth_placeMeta,
        ),
      );
    }
    if (data.containsKey('religion_id')) {
      context.handle(
        _religion_idMeta,
        religion_id.isAcceptableOrUnknown(
          data['religion_id']!,
          _religion_idMeta,
        ),
      );
    }
    if (data.containsKey('nationality_id')) {
      context.handle(
        _nationality_idMeta,
        nationality_id.isAcceptableOrUnknown(
          data['nationality_id']!,
          _nationality_idMeta,
        ),
      );
    }
    if (data.containsKey('ethnicity_id')) {
      context.handle(
        _ethnicity_idMeta,
        ethnicity_id.isAcceptableOrUnknown(
          data['ethnicity_id']!,
          _ethnicity_idMeta,
        ),
      );
    }
    if (data.containsKey('blood_type_id')) {
      context.handle(
        _blood_type_idMeta,
        blood_type_id.isAcceptableOrUnknown(
          data['blood_type_id']!,
          _blood_type_idMeta,
        ),
      );
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _household_idMeta,
        household_id.isAcceptableOrUnknown(
          data['household_id']!,
          _household_idMeta,
        ),
      );
    }
    if (data.containsKey('address_id')) {
      context.handle(
        _address_idMeta,
        address_id.isAcceptableOrUnknown(data['address_id']!, _address_idMeta),
      );
    }
    if (data.containsKey('registration_place')) {
      context.handle(
        _registration_placeMeta,
        registration_place.isAcceptableOrUnknown(
          data['registration_place']!,
          _registration_placeMeta,
        ),
      );
    }
    if (data.containsKey('years_of_residency')) {
      context.handle(
        _years_of_residencyMeta,
        years_of_residency.isAcceptableOrUnknown(
          data['years_of_residency']!,
          _years_of_residencyMeta,
        ),
      );
    }
    if (data.containsKey('monthly_income_id')) {
      context.handle(
        _monthly_income_idMeta,
        monthly_income_id.isAcceptableOrUnknown(
          data['monthly_income_id']!,
          _monthly_income_idMeta,
        ),
      );
    }
    if (data.containsKey('daily_income_id')) {
      context.handle(
        _daily_income_idMeta,
        daily_income_id.isAcceptableOrUnknown(
          data['daily_income_id']!,
          _daily_income_idMeta,
        ),
      );
    }
    if (data.containsKey('ofw')) {
      context.handle(
        _ofwMeta,
        ofw.isAcceptableOrUnknown(data['ofw']!, _ofwMeta),
      );
    }
    if (data.containsKey('literate')) {
      context.handle(
        _literateMeta,
        literate.isAcceptableOrUnknown(data['literate']!, _literateMeta),
      );
    }
    if (data.containsKey('pwd')) {
      context.handle(
        _pwdMeta,
        pwd.isAcceptableOrUnknown(data['pwd']!, _pwdMeta),
      );
    }
    if (data.containsKey('registered_voter')) {
      context.handle(
        _registered_voterMeta,
        registered_voter.isAcceptableOrUnknown(
          data['registered_voter']!,
          _registered_voterMeta,
        ),
      );
    }
    if (data.containsKey('education_id')) {
      context.handle(
        _education_idMeta,
        education_id.isAcceptableOrUnknown(
          data['education_id']!,
          _education_idMeta,
        ),
      );
    }
    if (data.containsKey('deceased')) {
      context.handle(
        _deceasedMeta,
        deceased.isAcceptableOrUnknown(data['deceased']!, _deceasedMeta),
      );
    }
    if (data.containsKey('death_date')) {
      context.handle(
        _death_dateMeta,
        death_date.isAcceptableOrUnknown(data['death_date']!, _death_dateMeta),
      );
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registration_dateMeta,
        registration_date.isAcceptableOrUnknown(
          data['registration_date']!,
          _registration_dateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {person_id};
  @override
  PersonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonData(
      person_id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}person_id'],
          )!,
      last_name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_name'],
          )!,
      first_name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}first_name'],
          )!,
      middle_name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      ),
      suffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suffix'],
      ),
      sex: $PersonsTable.$convertersexn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        ),
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      birth_date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      birth_place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_place'],
      ),
      civil_status: $PersonsTable.$convertercivil_statusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}civil_status'],
        ),
      ),
      religion_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}religion_id'],
      ),
      nationality_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nationality_id'],
      ),
      ethnicity_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ethnicity_id'],
      ),
      blood_type_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}blood_type_id'],
      ),
      household_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_id'],
      ),
      address_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}address_id'],
      ),
      registration_place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_place'],
      ),
      residency: $PersonsTable.$converterresidencyn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}residency'],
        ),
      ),
      years_of_residency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}years_of_residency'],
      ),
      transient_type: $PersonsTable.$convertertransient_typen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}transient_type'],
        ),
      ),
      monthly_income_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_income_id'],
      ),
      daily_income_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_income_id'],
      ),
      solo_parent: $PersonsTable.$convertersolo_parentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}solo_parent'],
        ),
      ),
      ofw: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ofw'],
      ),
      literate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}literate'],
      ),
      pwd: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pwd'],
      ),
      registered_voter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}registered_voter'],
      ),
      currently_enrolled: $PersonsTable.$convertercurrently_enrolledn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}currently_enrolled'],
        ),
      ),
      education_id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}education_id'],
      ),
      deceased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deceased'],
      ),
      death_date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}death_date'],
      ),
      registration_date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      ),
      registration_status: $PersonsTable.$converterregistration_status.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}registration_status'],
        )!,
      ),
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Sex, String, String> $convertersex =
      const EnumNameConverter<Sex>(Sex.values);
  static JsonTypeConverter2<Sex?, String?, String?> $convertersexn =
      JsonTypeConverter2.asNullable($convertersex);
  static JsonTypeConverter2<CivilStatus, String, String>
  $convertercivil_status = const EnumNameConverter<CivilStatus>(
    CivilStatus.values,
  );
  static JsonTypeConverter2<CivilStatus?, String?, String?>
  $convertercivil_statusn = JsonTypeConverter2.asNullable(
    $convertercivil_status,
  );
  static JsonTypeConverter2<Residency, String, String> $converterresidency =
      const EnumNameConverter<Residency>(Residency.values);
  static JsonTypeConverter2<Residency?, String?, String?> $converterresidencyn =
      JsonTypeConverter2.asNullable($converterresidency);
  static JsonTypeConverter2<Transient, String, String>
  $convertertransient_type = const EnumNameConverter<Transient>(
    Transient.values,
  );
  static JsonTypeConverter2<Transient?, String?, String?>
  $convertertransient_typen = JsonTypeConverter2.asNullable(
    $convertertransient_type,
  );
  static JsonTypeConverter2<SoloParent, String, String> $convertersolo_parent =
      const EnumNameConverter<SoloParent>(SoloParent.values);
  static JsonTypeConverter2<SoloParent?, String?, String?>
  $convertersolo_parentn = JsonTypeConverter2.asNullable($convertersolo_parent);
  static JsonTypeConverter2<CurrentlyEnrolled, String, String>
  $convertercurrently_enrolled = const EnumNameConverter<CurrentlyEnrolled>(
    CurrentlyEnrolled.values,
  );
  static JsonTypeConverter2<CurrentlyEnrolled?, String?, String?>
  $convertercurrently_enrolledn = JsonTypeConverter2.asNullable(
    $convertercurrently_enrolled,
  );
  static JsonTypeConverter2<RegistrationStatus, String, String>
  $converterregistration_status = const EnumNameConverter<RegistrationStatus>(
    RegistrationStatus.values,
  );
}

class PersonData extends DataClass implements Insertable<PersonData> {
  final int person_id;
  final String last_name;
  final String first_name;
  final String? middle_name;
  final String? suffix;
  final Sex? sex;
  final int? age;
  final DateTime? birth_date;
  final String? birth_place;
  final CivilStatus? civil_status;
  final int? religion_id;
  final int? nationality_id;
  final int? ethnicity_id;
  final int? blood_type_id;
  final int? household_id;
  final int? address_id;
  final String? registration_place;
  final Residency? residency;
  final int? years_of_residency;
  final Transient? transient_type;
  final int? monthly_income_id;
  final int? daily_income_id;
  final SoloParent? solo_parent;
  final bool? ofw;
  final bool? literate;
  final bool? pwd;
  final bool? registered_voter;
  final CurrentlyEnrolled? currently_enrolled;
  final int? education_id;
  final bool? deceased;
  final DateTime? death_date;
  final DateTime? registration_date;
  final RegistrationStatus registration_status;
  const PersonData({
    required this.person_id,
    required this.last_name,
    required this.first_name,
    this.middle_name,
    this.suffix,
    this.sex,
    this.age,
    this.birth_date,
    this.birth_place,
    this.civil_status,
    this.religion_id,
    this.nationality_id,
    this.ethnicity_id,
    this.blood_type_id,
    this.household_id,
    this.address_id,
    this.registration_place,
    this.residency,
    this.years_of_residency,
    this.transient_type,
    this.monthly_income_id,
    this.daily_income_id,
    this.solo_parent,
    this.ofw,
    this.literate,
    this.pwd,
    this.registered_voter,
    this.currently_enrolled,
    this.education_id,
    this.deceased,
    this.death_date,
    this.registration_date,
    required this.registration_status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['person_id'] = Variable<int>(person_id);
    map['last_name'] = Variable<String>(last_name);
    map['first_name'] = Variable<String>(first_name);
    if (!nullToAbsent || middle_name != null) {
      map['middle_name'] = Variable<String>(middle_name);
    }
    if (!nullToAbsent || suffix != null) {
      map['suffix'] = Variable<String>(suffix);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>($PersonsTable.$convertersexn.toSql(sex));
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || birth_date != null) {
      map['birth_date'] = Variable<DateTime>(birth_date);
    }
    if (!nullToAbsent || birth_place != null) {
      map['birth_place'] = Variable<String>(birth_place);
    }
    if (!nullToAbsent || civil_status != null) {
      map['civil_status'] = Variable<String>(
        $PersonsTable.$convertercivil_statusn.toSql(civil_status),
      );
    }
    if (!nullToAbsent || religion_id != null) {
      map['religion_id'] = Variable<int>(religion_id);
    }
    if (!nullToAbsent || nationality_id != null) {
      map['nationality_id'] = Variable<int>(nationality_id);
    }
    if (!nullToAbsent || ethnicity_id != null) {
      map['ethnicity_id'] = Variable<int>(ethnicity_id);
    }
    if (!nullToAbsent || blood_type_id != null) {
      map['blood_type_id'] = Variable<int>(blood_type_id);
    }
    if (!nullToAbsent || household_id != null) {
      map['household_id'] = Variable<int>(household_id);
    }
    if (!nullToAbsent || address_id != null) {
      map['address_id'] = Variable<int>(address_id);
    }
    if (!nullToAbsent || registration_place != null) {
      map['registration_place'] = Variable<String>(registration_place);
    }
    if (!nullToAbsent || residency != null) {
      map['residency'] = Variable<String>(
        $PersonsTable.$converterresidencyn.toSql(residency),
      );
    }
    if (!nullToAbsent || years_of_residency != null) {
      map['years_of_residency'] = Variable<int>(years_of_residency);
    }
    if (!nullToAbsent || transient_type != null) {
      map['transient_type'] = Variable<String>(
        $PersonsTable.$convertertransient_typen.toSql(transient_type),
      );
    }
    if (!nullToAbsent || monthly_income_id != null) {
      map['monthly_income_id'] = Variable<int>(monthly_income_id);
    }
    if (!nullToAbsent || daily_income_id != null) {
      map['daily_income_id'] = Variable<int>(daily_income_id);
    }
    if (!nullToAbsent || solo_parent != null) {
      map['solo_parent'] = Variable<String>(
        $PersonsTable.$convertersolo_parentn.toSql(solo_parent),
      );
    }
    if (!nullToAbsent || ofw != null) {
      map['ofw'] = Variable<bool>(ofw);
    }
    if (!nullToAbsent || literate != null) {
      map['literate'] = Variable<bool>(literate);
    }
    if (!nullToAbsent || pwd != null) {
      map['pwd'] = Variable<bool>(pwd);
    }
    if (!nullToAbsent || registered_voter != null) {
      map['registered_voter'] = Variable<bool>(registered_voter);
    }
    if (!nullToAbsent || currently_enrolled != null) {
      map['currently_enrolled'] = Variable<String>(
        $PersonsTable.$convertercurrently_enrolledn.toSql(currently_enrolled),
      );
    }
    if (!nullToAbsent || education_id != null) {
      map['education_id'] = Variable<int>(education_id);
    }
    if (!nullToAbsent || deceased != null) {
      map['deceased'] = Variable<bool>(deceased);
    }
    if (!nullToAbsent || death_date != null) {
      map['death_date'] = Variable<DateTime>(death_date);
    }
    if (!nullToAbsent || registration_date != null) {
      map['registration_date'] = Variable<DateTime>(registration_date);
    }
    {
      map['registration_status'] = Variable<String>(
        $PersonsTable.$converterregistration_status.toSql(registration_status),
      );
    }
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      person_id: Value(person_id),
      last_name: Value(last_name),
      first_name: Value(first_name),
      middle_name:
          middle_name == null && nullToAbsent
              ? const Value.absent()
              : Value(middle_name),
      suffix:
          suffix == null && nullToAbsent ? const Value.absent() : Value(suffix),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      birth_date:
          birth_date == null && nullToAbsent
              ? const Value.absent()
              : Value(birth_date),
      birth_place:
          birth_place == null && nullToAbsent
              ? const Value.absent()
              : Value(birth_place),
      civil_status:
          civil_status == null && nullToAbsent
              ? const Value.absent()
              : Value(civil_status),
      religion_id:
          religion_id == null && nullToAbsent
              ? const Value.absent()
              : Value(religion_id),
      nationality_id:
          nationality_id == null && nullToAbsent
              ? const Value.absent()
              : Value(nationality_id),
      ethnicity_id:
          ethnicity_id == null && nullToAbsent
              ? const Value.absent()
              : Value(ethnicity_id),
      blood_type_id:
          blood_type_id == null && nullToAbsent
              ? const Value.absent()
              : Value(blood_type_id),
      household_id:
          household_id == null && nullToAbsent
              ? const Value.absent()
              : Value(household_id),
      address_id:
          address_id == null && nullToAbsent
              ? const Value.absent()
              : Value(address_id),
      registration_place:
          registration_place == null && nullToAbsent
              ? const Value.absent()
              : Value(registration_place),
      residency:
          residency == null && nullToAbsent
              ? const Value.absent()
              : Value(residency),
      years_of_residency:
          years_of_residency == null && nullToAbsent
              ? const Value.absent()
              : Value(years_of_residency),
      transient_type:
          transient_type == null && nullToAbsent
              ? const Value.absent()
              : Value(transient_type),
      monthly_income_id:
          monthly_income_id == null && nullToAbsent
              ? const Value.absent()
              : Value(monthly_income_id),
      daily_income_id:
          daily_income_id == null && nullToAbsent
              ? const Value.absent()
              : Value(daily_income_id),
      solo_parent:
          solo_parent == null && nullToAbsent
              ? const Value.absent()
              : Value(solo_parent),
      ofw: ofw == null && nullToAbsent ? const Value.absent() : Value(ofw),
      literate:
          literate == null && nullToAbsent
              ? const Value.absent()
              : Value(literate),
      pwd: pwd == null && nullToAbsent ? const Value.absent() : Value(pwd),
      registered_voter:
          registered_voter == null && nullToAbsent
              ? const Value.absent()
              : Value(registered_voter),
      currently_enrolled:
          currently_enrolled == null && nullToAbsent
              ? const Value.absent()
              : Value(currently_enrolled),
      education_id:
          education_id == null && nullToAbsent
              ? const Value.absent()
              : Value(education_id),
      deceased:
          deceased == null && nullToAbsent
              ? const Value.absent()
              : Value(deceased),
      death_date:
          death_date == null && nullToAbsent
              ? const Value.absent()
              : Value(death_date),
      registration_date:
          registration_date == null && nullToAbsent
              ? const Value.absent()
              : Value(registration_date),
      registration_status: Value(registration_status),
    );
  }

  factory PersonData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonData(
      person_id: serializer.fromJson<int>(json['person_id']),
      last_name: serializer.fromJson<String>(json['last_name']),
      first_name: serializer.fromJson<String>(json['first_name']),
      middle_name: serializer.fromJson<String?>(json['middle_name']),
      suffix: serializer.fromJson<String?>(json['suffix']),
      sex: $PersonsTable.$convertersexn.fromJson(
        serializer.fromJson<String?>(json['sex']),
      ),
      age: serializer.fromJson<int?>(json['age']),
      birth_date: serializer.fromJson<DateTime?>(json['birth_date']),
      birth_place: serializer.fromJson<String?>(json['birth_place']),
      civil_status: $PersonsTable.$convertercivil_statusn.fromJson(
        serializer.fromJson<String?>(json['civil_status']),
      ),
      religion_id: serializer.fromJson<int?>(json['religion_id']),
      nationality_id: serializer.fromJson<int?>(json['nationality_id']),
      ethnicity_id: serializer.fromJson<int?>(json['ethnicity_id']),
      blood_type_id: serializer.fromJson<int?>(json['blood_type_id']),
      household_id: serializer.fromJson<int?>(json['household_id']),
      address_id: serializer.fromJson<int?>(json['address_id']),
      registration_place: serializer.fromJson<String?>(
        json['registration_place'],
      ),
      residency: $PersonsTable.$converterresidencyn.fromJson(
        serializer.fromJson<String?>(json['residency']),
      ),
      years_of_residency: serializer.fromJson<int?>(json['years_of_residency']),
      transient_type: $PersonsTable.$convertertransient_typen.fromJson(
        serializer.fromJson<String?>(json['transient_type']),
      ),
      monthly_income_id: serializer.fromJson<int?>(json['monthly_income_id']),
      daily_income_id: serializer.fromJson<int?>(json['daily_income_id']),
      solo_parent: $PersonsTable.$convertersolo_parentn.fromJson(
        serializer.fromJson<String?>(json['solo_parent']),
      ),
      ofw: serializer.fromJson<bool?>(json['ofw']),
      literate: serializer.fromJson<bool?>(json['literate']),
      pwd: serializer.fromJson<bool?>(json['pwd']),
      registered_voter: serializer.fromJson<bool?>(json['registered_voter']),
      currently_enrolled: $PersonsTable.$convertercurrently_enrolledn.fromJson(
        serializer.fromJson<String?>(json['currently_enrolled']),
      ),
      education_id: serializer.fromJson<int?>(json['education_id']),
      deceased: serializer.fromJson<bool?>(json['deceased']),
      death_date: serializer.fromJson<DateTime?>(json['death_date']),
      registration_date: serializer.fromJson<DateTime?>(
        json['registration_date'],
      ),
      registration_status: $PersonsTable.$converterregistration_status.fromJson(
        serializer.fromJson<String>(json['registration_status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'person_id': serializer.toJson<int>(person_id),
      'last_name': serializer.toJson<String>(last_name),
      'first_name': serializer.toJson<String>(first_name),
      'middle_name': serializer.toJson<String?>(middle_name),
      'suffix': serializer.toJson<String?>(suffix),
      'sex': serializer.toJson<String?>(
        $PersonsTable.$convertersexn.toJson(sex),
      ),
      'age': serializer.toJson<int?>(age),
      'birth_date': serializer.toJson<DateTime?>(birth_date),
      'birth_place': serializer.toJson<String?>(birth_place),
      'civil_status': serializer.toJson<String?>(
        $PersonsTable.$convertercivil_statusn.toJson(civil_status),
      ),
      'religion_id': serializer.toJson<int?>(religion_id),
      'nationality_id': serializer.toJson<int?>(nationality_id),
      'ethnicity_id': serializer.toJson<int?>(ethnicity_id),
      'blood_type_id': serializer.toJson<int?>(blood_type_id),
      'household_id': serializer.toJson<int?>(household_id),
      'address_id': serializer.toJson<int?>(address_id),
      'registration_place': serializer.toJson<String?>(registration_place),
      'residency': serializer.toJson<String?>(
        $PersonsTable.$converterresidencyn.toJson(residency),
      ),
      'years_of_residency': serializer.toJson<int?>(years_of_residency),
      'transient_type': serializer.toJson<String?>(
        $PersonsTable.$convertertransient_typen.toJson(transient_type),
      ),
      'monthly_income_id': serializer.toJson<int?>(monthly_income_id),
      'daily_income_id': serializer.toJson<int?>(daily_income_id),
      'solo_parent': serializer.toJson<String?>(
        $PersonsTable.$convertersolo_parentn.toJson(solo_parent),
      ),
      'ofw': serializer.toJson<bool?>(ofw),
      'literate': serializer.toJson<bool?>(literate),
      'pwd': serializer.toJson<bool?>(pwd),
      'registered_voter': serializer.toJson<bool?>(registered_voter),
      'currently_enrolled': serializer.toJson<String?>(
        $PersonsTable.$convertercurrently_enrolledn.toJson(currently_enrolled),
      ),
      'education_id': serializer.toJson<int?>(education_id),
      'deceased': serializer.toJson<bool?>(deceased),
      'death_date': serializer.toJson<DateTime?>(death_date),
      'registration_date': serializer.toJson<DateTime?>(registration_date),
      'registration_status': serializer.toJson<String>(
        $PersonsTable.$converterregistration_status.toJson(registration_status),
      ),
    };
  }

  PersonData copyWith({
    int? person_id,
    String? last_name,
    String? first_name,
    Value<String?> middle_name = const Value.absent(),
    Value<String?> suffix = const Value.absent(),
    Value<Sex?> sex = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<DateTime?> birth_date = const Value.absent(),
    Value<String?> birth_place = const Value.absent(),
    Value<CivilStatus?> civil_status = const Value.absent(),
    Value<int?> religion_id = const Value.absent(),
    Value<int?> nationality_id = const Value.absent(),
    Value<int?> ethnicity_id = const Value.absent(),
    Value<int?> blood_type_id = const Value.absent(),
    Value<int?> household_id = const Value.absent(),
    Value<int?> address_id = const Value.absent(),
    Value<String?> registration_place = const Value.absent(),
    Value<Residency?> residency = const Value.absent(),
    Value<int?> years_of_residency = const Value.absent(),
    Value<Transient?> transient_type = const Value.absent(),
    Value<int?> monthly_income_id = const Value.absent(),
    Value<int?> daily_income_id = const Value.absent(),
    Value<SoloParent?> solo_parent = const Value.absent(),
    Value<bool?> ofw = const Value.absent(),
    Value<bool?> literate = const Value.absent(),
    Value<bool?> pwd = const Value.absent(),
    Value<bool?> registered_voter = const Value.absent(),
    Value<CurrentlyEnrolled?> currently_enrolled = const Value.absent(),
    Value<int?> education_id = const Value.absent(),
    Value<bool?> deceased = const Value.absent(),
    Value<DateTime?> death_date = const Value.absent(),
    Value<DateTime?> registration_date = const Value.absent(),
    RegistrationStatus? registration_status,
  }) => PersonData(
    person_id: person_id ?? this.person_id,
    last_name: last_name ?? this.last_name,
    first_name: first_name ?? this.first_name,
    middle_name: middle_name.present ? middle_name.value : this.middle_name,
    suffix: suffix.present ? suffix.value : this.suffix,
    sex: sex.present ? sex.value : this.sex,
    age: age.present ? age.value : this.age,
    birth_date: birth_date.present ? birth_date.value : this.birth_date,
    birth_place: birth_place.present ? birth_place.value : this.birth_place,
    civil_status: civil_status.present ? civil_status.value : this.civil_status,
    religion_id: religion_id.present ? religion_id.value : this.religion_id,
    nationality_id:
        nationality_id.present ? nationality_id.value : this.nationality_id,
    ethnicity_id: ethnicity_id.present ? ethnicity_id.value : this.ethnicity_id,
    blood_type_id:
        blood_type_id.present ? blood_type_id.value : this.blood_type_id,
    household_id: household_id.present ? household_id.value : this.household_id,
    address_id: address_id.present ? address_id.value : this.address_id,
    registration_place:
        registration_place.present
            ? registration_place.value
            : this.registration_place,
    residency: residency.present ? residency.value : this.residency,
    years_of_residency:
        years_of_residency.present
            ? years_of_residency.value
            : this.years_of_residency,
    transient_type:
        transient_type.present ? transient_type.value : this.transient_type,
    monthly_income_id:
        monthly_income_id.present
            ? monthly_income_id.value
            : this.monthly_income_id,
    daily_income_id:
        daily_income_id.present ? daily_income_id.value : this.daily_income_id,
    solo_parent: solo_parent.present ? solo_parent.value : this.solo_parent,
    ofw: ofw.present ? ofw.value : this.ofw,
    literate: literate.present ? literate.value : this.literate,
    pwd: pwd.present ? pwd.value : this.pwd,
    registered_voter:
        registered_voter.present
            ? registered_voter.value
            : this.registered_voter,
    currently_enrolled:
        currently_enrolled.present
            ? currently_enrolled.value
            : this.currently_enrolled,
    education_id: education_id.present ? education_id.value : this.education_id,
    deceased: deceased.present ? deceased.value : this.deceased,
    death_date: death_date.present ? death_date.value : this.death_date,
    registration_date:
        registration_date.present
            ? registration_date.value
            : this.registration_date,
    registration_status: registration_status ?? this.registration_status,
  );
  PersonData copyWithCompanion(PersonsCompanion data) {
    return PersonData(
      person_id: data.person_id.present ? data.person_id.value : this.person_id,
      last_name: data.last_name.present ? data.last_name.value : this.last_name,
      first_name:
          data.first_name.present ? data.first_name.value : this.first_name,
      middle_name:
          data.middle_name.present ? data.middle_name.value : this.middle_name,
      suffix: data.suffix.present ? data.suffix.value : this.suffix,
      sex: data.sex.present ? data.sex.value : this.sex,
      age: data.age.present ? data.age.value : this.age,
      birth_date:
          data.birth_date.present ? data.birth_date.value : this.birth_date,
      birth_place:
          data.birth_place.present ? data.birth_place.value : this.birth_place,
      civil_status:
          data.civil_status.present
              ? data.civil_status.value
              : this.civil_status,
      religion_id:
          data.religion_id.present ? data.religion_id.value : this.religion_id,
      nationality_id:
          data.nationality_id.present
              ? data.nationality_id.value
              : this.nationality_id,
      ethnicity_id:
          data.ethnicity_id.present
              ? data.ethnicity_id.value
              : this.ethnicity_id,
      blood_type_id:
          data.blood_type_id.present
              ? data.blood_type_id.value
              : this.blood_type_id,
      household_id:
          data.household_id.present
              ? data.household_id.value
              : this.household_id,
      address_id:
          data.address_id.present ? data.address_id.value : this.address_id,
      registration_place:
          data.registration_place.present
              ? data.registration_place.value
              : this.registration_place,
      residency: data.residency.present ? data.residency.value : this.residency,
      years_of_residency:
          data.years_of_residency.present
              ? data.years_of_residency.value
              : this.years_of_residency,
      transient_type:
          data.transient_type.present
              ? data.transient_type.value
              : this.transient_type,
      monthly_income_id:
          data.monthly_income_id.present
              ? data.monthly_income_id.value
              : this.monthly_income_id,
      daily_income_id:
          data.daily_income_id.present
              ? data.daily_income_id.value
              : this.daily_income_id,
      solo_parent:
          data.solo_parent.present ? data.solo_parent.value : this.solo_parent,
      ofw: data.ofw.present ? data.ofw.value : this.ofw,
      literate: data.literate.present ? data.literate.value : this.literate,
      pwd: data.pwd.present ? data.pwd.value : this.pwd,
      registered_voter:
          data.registered_voter.present
              ? data.registered_voter.value
              : this.registered_voter,
      currently_enrolled:
          data.currently_enrolled.present
              ? data.currently_enrolled.value
              : this.currently_enrolled,
      education_id:
          data.education_id.present
              ? data.education_id.value
              : this.education_id,
      deceased: data.deceased.present ? data.deceased.value : this.deceased,
      death_date:
          data.death_date.present ? data.death_date.value : this.death_date,
      registration_date:
          data.registration_date.present
              ? data.registration_date.value
              : this.registration_date,
      registration_status:
          data.registration_status.present
              ? data.registration_status.value
              : this.registration_status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonData(')
          ..write('person_id: $person_id, ')
          ..write('last_name: $last_name, ')
          ..write('first_name: $first_name, ')
          ..write('middle_name: $middle_name, ')
          ..write('suffix: $suffix, ')
          ..write('sex: $sex, ')
          ..write('age: $age, ')
          ..write('birth_date: $birth_date, ')
          ..write('birth_place: $birth_place, ')
          ..write('civil_status: $civil_status, ')
          ..write('religion_id: $religion_id, ')
          ..write('nationality_id: $nationality_id, ')
          ..write('ethnicity_id: $ethnicity_id, ')
          ..write('blood_type_id: $blood_type_id, ')
          ..write('household_id: $household_id, ')
          ..write('address_id: $address_id, ')
          ..write('registration_place: $registration_place, ')
          ..write('residency: $residency, ')
          ..write('years_of_residency: $years_of_residency, ')
          ..write('transient_type: $transient_type, ')
          ..write('monthly_income_id: $monthly_income_id, ')
          ..write('daily_income_id: $daily_income_id, ')
          ..write('solo_parent: $solo_parent, ')
          ..write('ofw: $ofw, ')
          ..write('literate: $literate, ')
          ..write('pwd: $pwd, ')
          ..write('registered_voter: $registered_voter, ')
          ..write('currently_enrolled: $currently_enrolled, ')
          ..write('education_id: $education_id, ')
          ..write('deceased: $deceased, ')
          ..write('death_date: $death_date, ')
          ..write('registration_date: $registration_date, ')
          ..write('registration_status: $registration_status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    person_id,
    last_name,
    first_name,
    middle_name,
    suffix,
    sex,
    age,
    birth_date,
    birth_place,
    civil_status,
    religion_id,
    nationality_id,
    ethnicity_id,
    blood_type_id,
    household_id,
    address_id,
    registration_place,
    residency,
    years_of_residency,
    transient_type,
    monthly_income_id,
    daily_income_id,
    solo_parent,
    ofw,
    literate,
    pwd,
    registered_voter,
    currently_enrolled,
    education_id,
    deceased,
    death_date,
    registration_date,
    registration_status,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonData &&
          other.person_id == this.person_id &&
          other.last_name == this.last_name &&
          other.first_name == this.first_name &&
          other.middle_name == this.middle_name &&
          other.suffix == this.suffix &&
          other.sex == this.sex &&
          other.age == this.age &&
          other.birth_date == this.birth_date &&
          other.birth_place == this.birth_place &&
          other.civil_status == this.civil_status &&
          other.religion_id == this.religion_id &&
          other.nationality_id == this.nationality_id &&
          other.ethnicity_id == this.ethnicity_id &&
          other.blood_type_id == this.blood_type_id &&
          other.household_id == this.household_id &&
          other.address_id == this.address_id &&
          other.registration_place == this.registration_place &&
          other.residency == this.residency &&
          other.years_of_residency == this.years_of_residency &&
          other.transient_type == this.transient_type &&
          other.monthly_income_id == this.monthly_income_id &&
          other.daily_income_id == this.daily_income_id &&
          other.solo_parent == this.solo_parent &&
          other.ofw == this.ofw &&
          other.literate == this.literate &&
          other.pwd == this.pwd &&
          other.registered_voter == this.registered_voter &&
          other.currently_enrolled == this.currently_enrolled &&
          other.education_id == this.education_id &&
          other.deceased == this.deceased &&
          other.death_date == this.death_date &&
          other.registration_date == this.registration_date &&
          other.registration_status == this.registration_status);
}

class PersonsCompanion extends UpdateCompanion<PersonData> {
  final Value<int> person_id;
  final Value<String> last_name;
  final Value<String> first_name;
  final Value<String?> middle_name;
  final Value<String?> suffix;
  final Value<Sex?> sex;
  final Value<int?> age;
  final Value<DateTime?> birth_date;
  final Value<String?> birth_place;
  final Value<CivilStatus?> civil_status;
  final Value<int?> religion_id;
  final Value<int?> nationality_id;
  final Value<int?> ethnicity_id;
  final Value<int?> blood_type_id;
  final Value<int?> household_id;
  final Value<int?> address_id;
  final Value<String?> registration_place;
  final Value<Residency?> residency;
  final Value<int?> years_of_residency;
  final Value<Transient?> transient_type;
  final Value<int?> monthly_income_id;
  final Value<int?> daily_income_id;
  final Value<SoloParent?> solo_parent;
  final Value<bool?> ofw;
  final Value<bool?> literate;
  final Value<bool?> pwd;
  final Value<bool?> registered_voter;
  final Value<CurrentlyEnrolled?> currently_enrolled;
  final Value<int?> education_id;
  final Value<bool?> deceased;
  final Value<DateTime?> death_date;
  final Value<DateTime?> registration_date;
  final Value<RegistrationStatus> registration_status;
  const PersonsCompanion({
    this.person_id = const Value.absent(),
    this.last_name = const Value.absent(),
    this.first_name = const Value.absent(),
    this.middle_name = const Value.absent(),
    this.suffix = const Value.absent(),
    this.sex = const Value.absent(),
    this.age = const Value.absent(),
    this.birth_date = const Value.absent(),
    this.birth_place = const Value.absent(),
    this.civil_status = const Value.absent(),
    this.religion_id = const Value.absent(),
    this.nationality_id = const Value.absent(),
    this.ethnicity_id = const Value.absent(),
    this.blood_type_id = const Value.absent(),
    this.household_id = const Value.absent(),
    this.address_id = const Value.absent(),
    this.registration_place = const Value.absent(),
    this.residency = const Value.absent(),
    this.years_of_residency = const Value.absent(),
    this.transient_type = const Value.absent(),
    this.monthly_income_id = const Value.absent(),
    this.daily_income_id = const Value.absent(),
    this.solo_parent = const Value.absent(),
    this.ofw = const Value.absent(),
    this.literate = const Value.absent(),
    this.pwd = const Value.absent(),
    this.registered_voter = const Value.absent(),
    this.currently_enrolled = const Value.absent(),
    this.education_id = const Value.absent(),
    this.deceased = const Value.absent(),
    this.death_date = const Value.absent(),
    this.registration_date = const Value.absent(),
    this.registration_status = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.person_id = const Value.absent(),
    required String last_name,
    required String first_name,
    this.middle_name = const Value.absent(),
    this.suffix = const Value.absent(),
    this.sex = const Value.absent(),
    this.age = const Value.absent(),
    this.birth_date = const Value.absent(),
    this.birth_place = const Value.absent(),
    this.civil_status = const Value.absent(),
    this.religion_id = const Value.absent(),
    this.nationality_id = const Value.absent(),
    this.ethnicity_id = const Value.absent(),
    this.blood_type_id = const Value.absent(),
    this.household_id = const Value.absent(),
    this.address_id = const Value.absent(),
    this.registration_place = const Value.absent(),
    this.residency = const Value.absent(),
    this.years_of_residency = const Value.absent(),
    this.transient_type = const Value.absent(),
    this.monthly_income_id = const Value.absent(),
    this.daily_income_id = const Value.absent(),
    this.solo_parent = const Value.absent(),
    this.ofw = const Value.absent(),
    this.literate = const Value.absent(),
    this.pwd = const Value.absent(),
    this.registered_voter = const Value.absent(),
    this.currently_enrolled = const Value.absent(),
    this.education_id = const Value.absent(),
    this.deceased = const Value.absent(),
    this.death_date = const Value.absent(),
    this.registration_date = const Value.absent(),
    required RegistrationStatus registration_status,
  }) : last_name = Value(last_name),
       first_name = Value(first_name),
       registration_status = Value(registration_status);
  static Insertable<PersonData> custom({
    Expression<int>? person_id,
    Expression<String>? last_name,
    Expression<String>? first_name,
    Expression<String>? middle_name,
    Expression<String>? suffix,
    Expression<String>? sex,
    Expression<int>? age,
    Expression<DateTime>? birth_date,
    Expression<String>? birth_place,
    Expression<String>? civil_status,
    Expression<int>? religion_id,
    Expression<int>? nationality_id,
    Expression<int>? ethnicity_id,
    Expression<int>? blood_type_id,
    Expression<int>? household_id,
    Expression<int>? address_id,
    Expression<String>? registration_place,
    Expression<String>? residency,
    Expression<int>? years_of_residency,
    Expression<String>? transient_type,
    Expression<int>? monthly_income_id,
    Expression<int>? daily_income_id,
    Expression<String>? solo_parent,
    Expression<bool>? ofw,
    Expression<bool>? literate,
    Expression<bool>? pwd,
    Expression<bool>? registered_voter,
    Expression<String>? currently_enrolled,
    Expression<int>? education_id,
    Expression<bool>? deceased,
    Expression<DateTime>? death_date,
    Expression<DateTime>? registration_date,
    Expression<String>? registration_status,
  }) {
    return RawValuesInsertable({
      if (person_id != null) 'person_id': person_id,
      if (last_name != null) 'last_name': last_name,
      if (first_name != null) 'first_name': first_name,
      if (middle_name != null) 'middle_name': middle_name,
      if (suffix != null) 'suffix': suffix,
      if (sex != null) 'sex': sex,
      if (age != null) 'age': age,
      if (birth_date != null) 'birth_date': birth_date,
      if (birth_place != null) 'birth_place': birth_place,
      if (civil_status != null) 'civil_status': civil_status,
      if (religion_id != null) 'religion_id': religion_id,
      if (nationality_id != null) 'nationality_id': nationality_id,
      if (ethnicity_id != null) 'ethnicity_id': ethnicity_id,
      if (blood_type_id != null) 'blood_type_id': blood_type_id,
      if (household_id != null) 'household_id': household_id,
      if (address_id != null) 'address_id': address_id,
      if (registration_place != null) 'registration_place': registration_place,
      if (residency != null) 'residency': residency,
      if (years_of_residency != null) 'years_of_residency': years_of_residency,
      if (transient_type != null) 'transient_type': transient_type,
      if (monthly_income_id != null) 'monthly_income_id': monthly_income_id,
      if (daily_income_id != null) 'daily_income_id': daily_income_id,
      if (solo_parent != null) 'solo_parent': solo_parent,
      if (ofw != null) 'ofw': ofw,
      if (literate != null) 'literate': literate,
      if (pwd != null) 'pwd': pwd,
      if (registered_voter != null) 'registered_voter': registered_voter,
      if (currently_enrolled != null) 'currently_enrolled': currently_enrolled,
      if (education_id != null) 'education_id': education_id,
      if (deceased != null) 'deceased': deceased,
      if (death_date != null) 'death_date': death_date,
      if (registration_date != null) 'registration_date': registration_date,
      if (registration_status != null)
        'registration_status': registration_status,
    });
  }

  PersonsCompanion copyWith({
    Value<int>? person_id,
    Value<String>? last_name,
    Value<String>? first_name,
    Value<String?>? middle_name,
    Value<String?>? suffix,
    Value<Sex?>? sex,
    Value<int?>? age,
    Value<DateTime?>? birth_date,
    Value<String?>? birth_place,
    Value<CivilStatus?>? civil_status,
    Value<int?>? religion_id,
    Value<int?>? nationality_id,
    Value<int?>? ethnicity_id,
    Value<int?>? blood_type_id,
    Value<int?>? household_id,
    Value<int?>? address_id,
    Value<String?>? registration_place,
    Value<Residency?>? residency,
    Value<int?>? years_of_residency,
    Value<Transient?>? transient_type,
    Value<int?>? monthly_income_id,
    Value<int?>? daily_income_id,
    Value<SoloParent?>? solo_parent,
    Value<bool?>? ofw,
    Value<bool?>? literate,
    Value<bool?>? pwd,
    Value<bool?>? registered_voter,
    Value<CurrentlyEnrolled?>? currently_enrolled,
    Value<int?>? education_id,
    Value<bool?>? deceased,
    Value<DateTime?>? death_date,
    Value<DateTime?>? registration_date,
    Value<RegistrationStatus>? registration_status,
  }) {
    return PersonsCompanion(
      person_id: person_id ?? this.person_id,
      last_name: last_name ?? this.last_name,
      first_name: first_name ?? this.first_name,
      middle_name: middle_name ?? this.middle_name,
      suffix: suffix ?? this.suffix,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      birth_date: birth_date ?? this.birth_date,
      birth_place: birth_place ?? this.birth_place,
      civil_status: civil_status ?? this.civil_status,
      religion_id: religion_id ?? this.religion_id,
      nationality_id: nationality_id ?? this.nationality_id,
      ethnicity_id: ethnicity_id ?? this.ethnicity_id,
      blood_type_id: blood_type_id ?? this.blood_type_id,
      household_id: household_id ?? this.household_id,
      address_id: address_id ?? this.address_id,
      registration_place: registration_place ?? this.registration_place,
      residency: residency ?? this.residency,
      years_of_residency: years_of_residency ?? this.years_of_residency,
      transient_type: transient_type ?? this.transient_type,
      monthly_income_id: monthly_income_id ?? this.monthly_income_id,
      daily_income_id: daily_income_id ?? this.daily_income_id,
      solo_parent: solo_parent ?? this.solo_parent,
      ofw: ofw ?? this.ofw,
      literate: literate ?? this.literate,
      pwd: pwd ?? this.pwd,
      registered_voter: registered_voter ?? this.registered_voter,
      currently_enrolled: currently_enrolled ?? this.currently_enrolled,
      education_id: education_id ?? this.education_id,
      deceased: deceased ?? this.deceased,
      death_date: death_date ?? this.death_date,
      registration_date: registration_date ?? this.registration_date,
      registration_status: registration_status ?? this.registration_status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (person_id.present) {
      map['person_id'] = Variable<int>(person_id.value);
    }
    if (last_name.present) {
      map['last_name'] = Variable<String>(last_name.value);
    }
    if (first_name.present) {
      map['first_name'] = Variable<String>(first_name.value);
    }
    if (middle_name.present) {
      map['middle_name'] = Variable<String>(middle_name.value);
    }
    if (suffix.present) {
      map['suffix'] = Variable<String>(suffix.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(
        $PersonsTable.$convertersexn.toSql(sex.value),
      );
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (birth_date.present) {
      map['birth_date'] = Variable<DateTime>(birth_date.value);
    }
    if (birth_place.present) {
      map['birth_place'] = Variable<String>(birth_place.value);
    }
    if (civil_status.present) {
      map['civil_status'] = Variable<String>(
        $PersonsTable.$convertercivil_statusn.toSql(civil_status.value),
      );
    }
    if (religion_id.present) {
      map['religion_id'] = Variable<int>(religion_id.value);
    }
    if (nationality_id.present) {
      map['nationality_id'] = Variable<int>(nationality_id.value);
    }
    if (ethnicity_id.present) {
      map['ethnicity_id'] = Variable<int>(ethnicity_id.value);
    }
    if (blood_type_id.present) {
      map['blood_type_id'] = Variable<int>(blood_type_id.value);
    }
    if (household_id.present) {
      map['household_id'] = Variable<int>(household_id.value);
    }
    if (address_id.present) {
      map['address_id'] = Variable<int>(address_id.value);
    }
    if (registration_place.present) {
      map['registration_place'] = Variable<String>(registration_place.value);
    }
    if (residency.present) {
      map['residency'] = Variable<String>(
        $PersonsTable.$converterresidencyn.toSql(residency.value),
      );
    }
    if (years_of_residency.present) {
      map['years_of_residency'] = Variable<int>(years_of_residency.value);
    }
    if (transient_type.present) {
      map['transient_type'] = Variable<String>(
        $PersonsTable.$convertertransient_typen.toSql(transient_type.value),
      );
    }
    if (monthly_income_id.present) {
      map['monthly_income_id'] = Variable<int>(monthly_income_id.value);
    }
    if (daily_income_id.present) {
      map['daily_income_id'] = Variable<int>(daily_income_id.value);
    }
    if (solo_parent.present) {
      map['solo_parent'] = Variable<String>(
        $PersonsTable.$convertersolo_parentn.toSql(solo_parent.value),
      );
    }
    if (ofw.present) {
      map['ofw'] = Variable<bool>(ofw.value);
    }
    if (literate.present) {
      map['literate'] = Variable<bool>(literate.value);
    }
    if (pwd.present) {
      map['pwd'] = Variable<bool>(pwd.value);
    }
    if (registered_voter.present) {
      map['registered_voter'] = Variable<bool>(registered_voter.value);
    }
    if (currently_enrolled.present) {
      map['currently_enrolled'] = Variable<String>(
        $PersonsTable.$convertercurrently_enrolledn.toSql(
          currently_enrolled.value,
        ),
      );
    }
    if (education_id.present) {
      map['education_id'] = Variable<int>(education_id.value);
    }
    if (deceased.present) {
      map['deceased'] = Variable<bool>(deceased.value);
    }
    if (death_date.present) {
      map['death_date'] = Variable<DateTime>(death_date.value);
    }
    if (registration_date.present) {
      map['registration_date'] = Variable<DateTime>(registration_date.value);
    }
    if (registration_status.present) {
      map['registration_status'] = Variable<String>(
        $PersonsTable.$converterregistration_status.toSql(
          registration_status.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('person_id: $person_id, ')
          ..write('last_name: $last_name, ')
          ..write('first_name: $first_name, ')
          ..write('middle_name: $middle_name, ')
          ..write('suffix: $suffix, ')
          ..write('sex: $sex, ')
          ..write('age: $age, ')
          ..write('birth_date: $birth_date, ')
          ..write('birth_place: $birth_place, ')
          ..write('civil_status: $civil_status, ')
          ..write('religion_id: $religion_id, ')
          ..write('nationality_id: $nationality_id, ')
          ..write('ethnicity_id: $ethnicity_id, ')
          ..write('blood_type_id: $blood_type_id, ')
          ..write('household_id: $household_id, ')
          ..write('address_id: $address_id, ')
          ..write('registration_place: $registration_place, ')
          ..write('residency: $residency, ')
          ..write('years_of_residency: $years_of_residency, ')
          ..write('transient_type: $transient_type, ')
          ..write('monthly_income_id: $monthly_income_id, ')
          ..write('daily_income_id: $daily_income_id, ')
          ..write('solo_parent: $solo_parent, ')
          ..write('ofw: $ofw, ')
          ..write('literate: $literate, ')
          ..write('pwd: $pwd, ')
          ..write('registered_voter: $registered_voter, ')
          ..write('currently_enrolled: $currently_enrolled, ')
          ..write('education_id: $education_id, ')
          ..write('deceased: $deceased, ')
          ..write('death_date: $death_date, ')
          ..write('registration_date: $registration_date, ')
          ..write('registration_status: $registration_status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReligionsTable religions = $ReligionsTable(this);
  late final $NationalitiesTable nationalities = $NationalitiesTable(this);
  late final $EthnicitiesTable ethnicities = $EthnicitiesTable(this);
  late final $BloodTypesTable bloodTypes = $BloodTypesTable(this);
  late final $AddressesTable addresses = $AddressesTable(this);
  late final $HouseholdTypesTable householdTypes = $HouseholdTypesTable(this);
  late final $BuildingTypesTable buildingTypes = $BuildingTypesTable(this);
  late final $OwnershipTypesTable ownershipTypes = $OwnershipTypesTable(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $MonthlyIncomesTable monthlyIncomes = $MonthlyIncomesTable(this);
  late final $DailyIncomesTable dailyIncomes = $DailyIncomesTable(this);
  late final $EducationTable education = $EducationTable(this);
  late final $PersonsTable persons = $PersonsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    religions,
    nationalities,
    ethnicities,
    bloodTypes,
    addresses,
    householdTypes,
    buildingTypes,
    ownershipTypes,
    households,
    monthlyIncomes,
    dailyIncomes,
    education,
    persons,
  ];
}

typedef $$ReligionsTableCreateCompanionBuilder =
    ReligionsCompanion Function({Value<int> religion_id, required String name});
typedef $$ReligionsTableUpdateCompanionBuilder =
    ReligionsCompanion Function({Value<int> religion_id, Value<String> name});

final class $$ReligionsTableReferences
    extends BaseReferences<_$AppDatabase, $ReligionsTable, ReligionData> {
  $$ReligionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.religions.religion_id,
      db.persons.religion_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.religion_id.religion_id.sqlEquals(
        $_itemColumn<int>('religion_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReligionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReligionsTable> {
  $$ReligionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get religion_id => $composableBuilder(
    column: $table.religion_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.religion_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.religion_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReligionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReligionsTable> {
  $$ReligionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get religion_id => $composableBuilder(
    column: $table.religion_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReligionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReligionsTable> {
  $$ReligionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get religion_id => $composableBuilder(
    column: $table.religion_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.religion_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.religion_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReligionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReligionsTable,
          ReligionData,
          $$ReligionsTableFilterComposer,
          $$ReligionsTableOrderingComposer,
          $$ReligionsTableAnnotationComposer,
          $$ReligionsTableCreateCompanionBuilder,
          $$ReligionsTableUpdateCompanionBuilder,
          (ReligionData, $$ReligionsTableReferences),
          ReligionData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$ReligionsTableTableManager(_$AppDatabase db, $ReligionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ReligionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ReligionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ReligionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> religion_id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ReligionsCompanion(religion_id: religion_id, name: name),
          createCompanionCallback:
              ({
                Value<int> religion_id = const Value.absent(),
                required String name,
              }) => ReligionsCompanion.insert(
                religion_id: religion_id,
                name: name,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ReligionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      ReligionData,
                      $ReligionsTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$ReligionsTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ReligionsTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.religion_id == item.religion_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ReligionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReligionsTable,
      ReligionData,
      $$ReligionsTableFilterComposer,
      $$ReligionsTableOrderingComposer,
      $$ReligionsTableAnnotationComposer,
      $$ReligionsTableCreateCompanionBuilder,
      $$ReligionsTableUpdateCompanionBuilder,
      (ReligionData, $$ReligionsTableReferences),
      ReligionData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$NationalitiesTableCreateCompanionBuilder =
    NationalitiesCompanion Function({
      Value<int> nationality_id,
      required String name,
    });
typedef $$NationalitiesTableUpdateCompanionBuilder =
    NationalitiesCompanion Function({
      Value<int> nationality_id,
      Value<String> name,
    });

final class $$NationalitiesTableReferences
    extends
        BaseReferences<_$AppDatabase, $NationalitiesTable, NationalityData> {
  $$NationalitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.nationalities.nationality_id,
      db.persons.nationality_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.nationality_id.nationality_id.sqlEquals(
        $_itemColumn<int>('nationality_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NationalitiesTableFilterComposer
    extends Composer<_$AppDatabase, $NationalitiesTable> {
  $$NationalitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get nationality_id => $composableBuilder(
    column: $table.nationality_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationality_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.nationality_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NationalitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $NationalitiesTable> {
  $$NationalitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get nationality_id => $composableBuilder(
    column: $table.nationality_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NationalitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NationalitiesTable> {
  $$NationalitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get nationality_id => $composableBuilder(
    column: $table.nationality_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationality_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.nationality_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NationalitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NationalitiesTable,
          NationalityData,
          $$NationalitiesTableFilterComposer,
          $$NationalitiesTableOrderingComposer,
          $$NationalitiesTableAnnotationComposer,
          $$NationalitiesTableCreateCompanionBuilder,
          $$NationalitiesTableUpdateCompanionBuilder,
          (NationalityData, $$NationalitiesTableReferences),
          NationalityData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$NationalitiesTableTableManager(_$AppDatabase db, $NationalitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NationalitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$NationalitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$NationalitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> nationality_id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => NationalitiesCompanion(
                nationality_id: nationality_id,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> nationality_id = const Value.absent(),
                required String name,
              }) => NationalitiesCompanion.insert(
                nationality_id: nationality_id,
                name: name,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$NationalitiesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      NationalityData,
                      $NationalitiesTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$NationalitiesTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$NationalitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.nationality_id == item.nationality_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NationalitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NationalitiesTable,
      NationalityData,
      $$NationalitiesTableFilterComposer,
      $$NationalitiesTableOrderingComposer,
      $$NationalitiesTableAnnotationComposer,
      $$NationalitiesTableCreateCompanionBuilder,
      $$NationalitiesTableUpdateCompanionBuilder,
      (NationalityData, $$NationalitiesTableReferences),
      NationalityData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$EthnicitiesTableCreateCompanionBuilder =
    EthnicitiesCompanion Function({
      Value<int> ethnicity_id,
      required String name,
    });
typedef $$EthnicitiesTableUpdateCompanionBuilder =
    EthnicitiesCompanion Function({
      Value<int> ethnicity_id,
      Value<String> name,
    });

final class $$EthnicitiesTableReferences
    extends BaseReferences<_$AppDatabase, $EthnicitiesTable, EthnicityData> {
  $$EthnicitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.ethnicities.ethnicity_id,
      db.persons.ethnicity_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.ethnicity_id.ethnicity_id.sqlEquals(
        $_itemColumn<int>('ethnicity_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EthnicitiesTableFilterComposer
    extends Composer<_$AppDatabase, $EthnicitiesTable> {
  $$EthnicitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ethnicity_id => $composableBuilder(
    column: $table.ethnicity_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ethnicity_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.ethnicity_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EthnicitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $EthnicitiesTable> {
  $$EthnicitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ethnicity_id => $composableBuilder(
    column: $table.ethnicity_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EthnicitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EthnicitiesTable> {
  $$EthnicitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ethnicity_id => $composableBuilder(
    column: $table.ethnicity_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ethnicity_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.ethnicity_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EthnicitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EthnicitiesTable,
          EthnicityData,
          $$EthnicitiesTableFilterComposer,
          $$EthnicitiesTableOrderingComposer,
          $$EthnicitiesTableAnnotationComposer,
          $$EthnicitiesTableCreateCompanionBuilder,
          $$EthnicitiesTableUpdateCompanionBuilder,
          (EthnicityData, $$EthnicitiesTableReferences),
          EthnicityData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$EthnicitiesTableTableManager(_$AppDatabase db, $EthnicitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EthnicitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EthnicitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$EthnicitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ethnicity_id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) =>
                  EthnicitiesCompanion(ethnicity_id: ethnicity_id, name: name),
          createCompanionCallback:
              ({
                Value<int> ethnicity_id = const Value.absent(),
                required String name,
              }) => EthnicitiesCompanion.insert(
                ethnicity_id: ethnicity_id,
                name: name,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EthnicitiesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      EthnicityData,
                      $EthnicitiesTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$EthnicitiesTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EthnicitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.ethnicity_id == item.ethnicity_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EthnicitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EthnicitiesTable,
      EthnicityData,
      $$EthnicitiesTableFilterComposer,
      $$EthnicitiesTableOrderingComposer,
      $$EthnicitiesTableAnnotationComposer,
      $$EthnicitiesTableCreateCompanionBuilder,
      $$EthnicitiesTableUpdateCompanionBuilder,
      (EthnicityData, $$EthnicitiesTableReferences),
      EthnicityData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$BloodTypesTableCreateCompanionBuilder =
    BloodTypesCompanion Function({
      Value<int> blood_type_id,
      required String type,
    });
typedef $$BloodTypesTableUpdateCompanionBuilder =
    BloodTypesCompanion Function({
      Value<int> blood_type_id,
      Value<String> type,
    });

final class $$BloodTypesTableReferences
    extends BaseReferences<_$AppDatabase, $BloodTypesTable, BloodTypeData> {
  $$BloodTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.bloodTypes.blood_type_id,
      db.persons.blood_type_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.blood_type_id.blood_type_id.sqlEquals(
        $_itemColumn<int>('blood_type_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BloodTypesTableFilterComposer
    extends Composer<_$AppDatabase, $BloodTypesTable> {
  $$BloodTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get blood_type_id => $composableBuilder(
    column: $table.blood_type_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blood_type_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.blood_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BloodTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodTypesTable> {
  $$BloodTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get blood_type_id => $composableBuilder(
    column: $table.blood_type_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BloodTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodTypesTable> {
  $$BloodTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get blood_type_id => $composableBuilder(
    column: $table.blood_type_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blood_type_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.blood_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BloodTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodTypesTable,
          BloodTypeData,
          $$BloodTypesTableFilterComposer,
          $$BloodTypesTableOrderingComposer,
          $$BloodTypesTableAnnotationComposer,
          $$BloodTypesTableCreateCompanionBuilder,
          $$BloodTypesTableUpdateCompanionBuilder,
          (BloodTypeData, $$BloodTypesTableReferences),
          BloodTypeData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$BloodTypesTableTableManager(_$AppDatabase db, $BloodTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BloodTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$BloodTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BloodTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> blood_type_id = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) =>
                  BloodTypesCompanion(blood_type_id: blood_type_id, type: type),
          createCompanionCallback:
              ({
                Value<int> blood_type_id = const Value.absent(),
                required String type,
              }) => BloodTypesCompanion.insert(
                blood_type_id: blood_type_id,
                type: type,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$BloodTypesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      BloodTypeData,
                      $BloodTypesTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$BloodTypesTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$BloodTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.blood_type_id == item.blood_type_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BloodTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodTypesTable,
      BloodTypeData,
      $$BloodTypesTableFilterComposer,
      $$BloodTypesTableOrderingComposer,
      $$BloodTypesTableAnnotationComposer,
      $$BloodTypesTableCreateCompanionBuilder,
      $$BloodTypesTableUpdateCompanionBuilder,
      (BloodTypeData, $$BloodTypesTableReferences),
      BloodTypeData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$AddressesTableCreateCompanionBuilder =
    AddressesCompanion Function({
      Value<int> address_id,
      required String brgy,
      required String zone,
      required String street,
      required int block,
      required int lot,
    });
typedef $$AddressesTableUpdateCompanionBuilder =
    AddressesCompanion Function({
      Value<int> address_id,
      Value<String> brgy,
      Value<String> zone,
      Value<String> street,
      Value<int> block,
      Value<int> lot,
    });

final class $$AddressesTableReferences
    extends BaseReferences<_$AppDatabase, $AddressesTable, AddressData> {
  $$AddressesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HouseholdsTable, List<HouseholdData>>
  _householdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.households,
    aliasName: $_aliasNameGenerator(
      db.addresses.address_id,
      db.households.address_id,
    ),
  );

  $$HouseholdsTableProcessedTableManager get householdsRefs {
    final manager = $$HouseholdsTableTableManager($_db, $_db.households).filter(
      (f) =>
          f.address_id.address_id.sqlEquals($_itemColumn<int>('address_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_householdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.addresses.address_id,
      db.persons.address_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) =>
          f.address_id.address_id.sqlEquals($_itemColumn<int>('address_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AddressesTableFilterComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get address_id => $composableBuilder(
    column: $table.address_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brgy => $composableBuilder(
    column: $table.brgy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get block => $composableBuilder(
    column: $table.block,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> householdsRefs(
    Expression<bool> Function($$HouseholdsTableFilterComposer f) f,
  ) {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AddressesTableOrderingComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get address_id => $composableBuilder(
    column: $table.address_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brgy => $composableBuilder(
    column: $table.brgy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get block => $composableBuilder(
    column: $table.block,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AddressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get address_id => $composableBuilder(
    column: $table.address_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brgy =>
      $composableBuilder(column: $table.brgy, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<int> get block =>
      $composableBuilder(column: $table.block, builder: (column) => column);

  GeneratedColumn<int> get lot =>
      $composableBuilder(column: $table.lot, builder: (column) => column);

  Expression<T> householdsRefs<T extends Object>(
    Expression<T> Function($$HouseholdsTableAnnotationComposer a) f,
  ) {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AddressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AddressesTable,
          AddressData,
          $$AddressesTableFilterComposer,
          $$AddressesTableOrderingComposer,
          $$AddressesTableAnnotationComposer,
          $$AddressesTableCreateCompanionBuilder,
          $$AddressesTableUpdateCompanionBuilder,
          (AddressData, $$AddressesTableReferences),
          AddressData,
          PrefetchHooks Function({bool householdsRefs, bool personsRefs})
        > {
  $$AddressesTableTableManager(_$AppDatabase db, $AddressesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AddressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AddressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AddressesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> address_id = const Value.absent(),
                Value<String> brgy = const Value.absent(),
                Value<String> zone = const Value.absent(),
                Value<String> street = const Value.absent(),
                Value<int> block = const Value.absent(),
                Value<int> lot = const Value.absent(),
              }) => AddressesCompanion(
                address_id: address_id,
                brgy: brgy,
                zone: zone,
                street: street,
                block: block,
                lot: lot,
              ),
          createCompanionCallback:
              ({
                Value<int> address_id = const Value.absent(),
                required String brgy,
                required String zone,
                required String street,
                required int block,
                required int lot,
              }) => AddressesCompanion.insert(
                address_id: address_id,
                brgy: brgy,
                zone: zone,
                street: street,
                block: block,
                lot: lot,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AddressesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            householdsRefs = false,
            personsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (householdsRefs) db.households,
                if (personsRefs) db.persons,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdsRefs)
                    await $_getPrefetchedData<
                      AddressData,
                      $AddressesTable,
                      HouseholdData
                    >(
                      currentTable: table,
                      referencedTable: $$AddressesTableReferences
                          ._householdsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AddressesTableReferences(
                                db,
                                table,
                                p0,
                              ).householdsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.address_id == item.address_id,
                          ),
                      typedResults: items,
                    ),
                  if (personsRefs)
                    await $_getPrefetchedData<
                      AddressData,
                      $AddressesTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$AddressesTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AddressesTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.address_id == item.address_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AddressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AddressesTable,
      AddressData,
      $$AddressesTableFilterComposer,
      $$AddressesTableOrderingComposer,
      $$AddressesTableAnnotationComposer,
      $$AddressesTableCreateCompanionBuilder,
      $$AddressesTableUpdateCompanionBuilder,
      (AddressData, $$AddressesTableReferences),
      AddressData,
      PrefetchHooks Function({bool householdsRefs, bool personsRefs})
    >;
typedef $$HouseholdTypesTableCreateCompanionBuilder =
    HouseholdTypesCompanion Function({
      Value<int> household_type_id,
      required String type,
    });
typedef $$HouseholdTypesTableUpdateCompanionBuilder =
    HouseholdTypesCompanion Function({
      Value<int> household_type_id,
      Value<String> type,
    });

final class $$HouseholdTypesTableReferences
    extends
        BaseReferences<_$AppDatabase, $HouseholdTypesTable, HouseholdTypeData> {
  $$HouseholdTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$HouseholdsTable, List<HouseholdData>>
  _householdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.households,
    aliasName: $_aliasNameGenerator(
      db.householdTypes.household_type_id,
      db.households.household_type_id,
    ),
  );

  $$HouseholdsTableProcessedTableManager get householdsRefs {
    final manager = $$HouseholdsTableTableManager($_db, $_db.households).filter(
      (f) => f.household_type_id.household_type_id.sqlEquals(
        $_itemColumn<int>('household_type_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_householdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HouseholdTypesTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdTypesTable> {
  $$HouseholdTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get household_type_id => $composableBuilder(
    column: $table.household_type_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> householdsRefs(
    Expression<bool> Function($$HouseholdsTableFilterComposer f) f,
  ) {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_type_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.household_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HouseholdTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdTypesTable> {
  $$HouseholdTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get household_type_id => $composableBuilder(
    column: $table.household_type_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HouseholdTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdTypesTable> {
  $$HouseholdTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get household_type_id => $composableBuilder(
    column: $table.household_type_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  Expression<T> householdsRefs<T extends Object>(
    Expression<T> Function($$HouseholdsTableAnnotationComposer a) f,
  ) {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_type_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.household_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HouseholdTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HouseholdTypesTable,
          HouseholdTypeData,
          $$HouseholdTypesTableFilterComposer,
          $$HouseholdTypesTableOrderingComposer,
          $$HouseholdTypesTableAnnotationComposer,
          $$HouseholdTypesTableCreateCompanionBuilder,
          $$HouseholdTypesTableUpdateCompanionBuilder,
          (HouseholdTypeData, $$HouseholdTypesTableReferences),
          HouseholdTypeData,
          PrefetchHooks Function({bool householdsRefs})
        > {
  $$HouseholdTypesTableTableManager(
    _$AppDatabase db,
    $HouseholdTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HouseholdTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$HouseholdTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$HouseholdTypesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> household_type_id = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => HouseholdTypesCompanion(
                household_type_id: household_type_id,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> household_type_id = const Value.absent(),
                required String type,
              }) => HouseholdTypesCompanion.insert(
                household_type_id: household_type_id,
                type: type,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$HouseholdTypesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({householdsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (householdsRefs) db.households],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdsRefs)
                    await $_getPrefetchedData<
                      HouseholdTypeData,
                      $HouseholdTypesTable,
                      HouseholdData
                    >(
                      currentTable: table,
                      referencedTable: $$HouseholdTypesTableReferences
                          ._householdsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$HouseholdTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).householdsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) =>
                                e.household_type_id == item.household_type_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HouseholdTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HouseholdTypesTable,
      HouseholdTypeData,
      $$HouseholdTypesTableFilterComposer,
      $$HouseholdTypesTableOrderingComposer,
      $$HouseholdTypesTableAnnotationComposer,
      $$HouseholdTypesTableCreateCompanionBuilder,
      $$HouseholdTypesTableUpdateCompanionBuilder,
      (HouseholdTypeData, $$HouseholdTypesTableReferences),
      HouseholdTypeData,
      PrefetchHooks Function({bool householdsRefs})
    >;
typedef $$BuildingTypesTableCreateCompanionBuilder =
    BuildingTypesCompanion Function({
      Value<int> building_type_id,
      required String type,
    });
typedef $$BuildingTypesTableUpdateCompanionBuilder =
    BuildingTypesCompanion Function({
      Value<int> building_type_id,
      Value<String> type,
    });

final class $$BuildingTypesTableReferences
    extends
        BaseReferences<_$AppDatabase, $BuildingTypesTable, BuildingTypeData> {
  $$BuildingTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$HouseholdsTable, List<HouseholdData>>
  _householdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.households,
    aliasName: $_aliasNameGenerator(
      db.buildingTypes.building_type_id,
      db.households.building_type_id,
    ),
  );

  $$HouseholdsTableProcessedTableManager get householdsRefs {
    final manager = $$HouseholdsTableTableManager($_db, $_db.households).filter(
      (f) => f.building_type_id.building_type_id.sqlEquals(
        $_itemColumn<int>('building_type_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_householdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BuildingTypesTableFilterComposer
    extends Composer<_$AppDatabase, $BuildingTypesTable> {
  $$BuildingTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get building_type_id => $composableBuilder(
    column: $table.building_type_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> householdsRefs(
    Expression<bool> Function($$HouseholdsTableFilterComposer f) f,
  ) {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.building_type_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.building_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuildingTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $BuildingTypesTable> {
  $$BuildingTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get building_type_id => $composableBuilder(
    column: $table.building_type_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BuildingTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuildingTypesTable> {
  $$BuildingTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get building_type_id => $composableBuilder(
    column: $table.building_type_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  Expression<T> householdsRefs<T extends Object>(
    Expression<T> Function($$HouseholdsTableAnnotationComposer a) f,
  ) {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.building_type_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.building_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuildingTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BuildingTypesTable,
          BuildingTypeData,
          $$BuildingTypesTableFilterComposer,
          $$BuildingTypesTableOrderingComposer,
          $$BuildingTypesTableAnnotationComposer,
          $$BuildingTypesTableCreateCompanionBuilder,
          $$BuildingTypesTableUpdateCompanionBuilder,
          (BuildingTypeData, $$BuildingTypesTableReferences),
          BuildingTypeData,
          PrefetchHooks Function({bool householdsRefs})
        > {
  $$BuildingTypesTableTableManager(_$AppDatabase db, $BuildingTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BuildingTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$BuildingTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BuildingTypesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> building_type_id = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => BuildingTypesCompanion(
                building_type_id: building_type_id,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> building_type_id = const Value.absent(),
                required String type,
              }) => BuildingTypesCompanion.insert(
                building_type_id: building_type_id,
                type: type,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$BuildingTypesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({householdsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (householdsRefs) db.households],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdsRefs)
                    await $_getPrefetchedData<
                      BuildingTypeData,
                      $BuildingTypesTable,
                      HouseholdData
                    >(
                      currentTable: table,
                      referencedTable: $$BuildingTypesTableReferences
                          ._householdsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$BuildingTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).householdsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.building_type_id == item.building_type_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BuildingTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BuildingTypesTable,
      BuildingTypeData,
      $$BuildingTypesTableFilterComposer,
      $$BuildingTypesTableOrderingComposer,
      $$BuildingTypesTableAnnotationComposer,
      $$BuildingTypesTableCreateCompanionBuilder,
      $$BuildingTypesTableUpdateCompanionBuilder,
      (BuildingTypeData, $$BuildingTypesTableReferences),
      BuildingTypeData,
      PrefetchHooks Function({bool householdsRefs})
    >;
typedef $$OwnershipTypesTableCreateCompanionBuilder =
    OwnershipTypesCompanion Function({
      Value<int> ownership_type_id,
      required String type,
    });
typedef $$OwnershipTypesTableUpdateCompanionBuilder =
    OwnershipTypesCompanion Function({
      Value<int> ownership_type_id,
      Value<String> type,
    });

final class $$OwnershipTypesTableReferences
    extends
        BaseReferences<_$AppDatabase, $OwnershipTypesTable, OwnershipTypeData> {
  $$OwnershipTypesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$HouseholdsTable, List<HouseholdData>>
  _householdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.households,
    aliasName: $_aliasNameGenerator(
      db.ownershipTypes.ownership_type_id,
      db.households.ownership_type_id,
    ),
  );

  $$HouseholdsTableProcessedTableManager get householdsRefs {
    final manager = $$HouseholdsTableTableManager($_db, $_db.households).filter(
      (f) => f.ownership_type_id.ownership_type_id.sqlEquals(
        $_itemColumn<int>('ownership_type_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_householdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OwnershipTypesTableFilterComposer
    extends Composer<_$AppDatabase, $OwnershipTypesTable> {
  $$OwnershipTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ownership_type_id => $composableBuilder(
    column: $table.ownership_type_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> householdsRefs(
    Expression<bool> Function($$HouseholdsTableFilterComposer f) f,
  ) {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownership_type_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.ownership_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OwnershipTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnershipTypesTable> {
  $$OwnershipTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ownership_type_id => $composableBuilder(
    column: $table.ownership_type_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnershipTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnershipTypesTable> {
  $$OwnershipTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ownership_type_id => $composableBuilder(
    column: $table.ownership_type_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  Expression<T> householdsRefs<T extends Object>(
    Expression<T> Function($$HouseholdsTableAnnotationComposer a) f,
  ) {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownership_type_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.ownership_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OwnershipTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnershipTypesTable,
          OwnershipTypeData,
          $$OwnershipTypesTableFilterComposer,
          $$OwnershipTypesTableOrderingComposer,
          $$OwnershipTypesTableAnnotationComposer,
          $$OwnershipTypesTableCreateCompanionBuilder,
          $$OwnershipTypesTableUpdateCompanionBuilder,
          (OwnershipTypeData, $$OwnershipTypesTableReferences),
          OwnershipTypeData,
          PrefetchHooks Function({bool householdsRefs})
        > {
  $$OwnershipTypesTableTableManager(
    _$AppDatabase db,
    $OwnershipTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$OwnershipTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$OwnershipTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$OwnershipTypesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ownership_type_id = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => OwnershipTypesCompanion(
                ownership_type_id: ownership_type_id,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> ownership_type_id = const Value.absent(),
                required String type,
              }) => OwnershipTypesCompanion.insert(
                ownership_type_id: ownership_type_id,
                type: type,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$OwnershipTypesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({householdsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (householdsRefs) db.households],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdsRefs)
                    await $_getPrefetchedData<
                      OwnershipTypeData,
                      $OwnershipTypesTable,
                      HouseholdData
                    >(
                      currentTable: table,
                      referencedTable: $$OwnershipTypesTableReferences
                          ._householdsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$OwnershipTypesTableReferences(
                                db,
                                table,
                                p0,
                              ).householdsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) =>
                                e.ownership_type_id == item.ownership_type_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OwnershipTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnershipTypesTable,
      OwnershipTypeData,
      $$OwnershipTypesTableFilterComposer,
      $$OwnershipTypesTableOrderingComposer,
      $$OwnershipTypesTableAnnotationComposer,
      $$OwnershipTypesTableCreateCompanionBuilder,
      $$OwnershipTypesTableUpdateCompanionBuilder,
      (OwnershipTypeData, $$OwnershipTypesTableReferences),
      OwnershipTypeData,
      PrefetchHooks Function({bool householdsRefs})
    >;
typedef $$HouseholdsTableCreateCompanionBuilder =
    HouseholdsCompanion Function({
      Value<int> household_id,
      Value<String?> head,
      Value<int?> address_id,
      Value<int?> household_type_id,
      Value<int?> building_type_id,
      Value<int?> ownership_type_id,
      Value<int?> household_members_num,
      Value<bool?> female_mortality,
      Value<bool?> child_mortality,
      Value<DateTime?> registration_date,
      required RegistrationStatus registration_status,
    });
typedef $$HouseholdsTableUpdateCompanionBuilder =
    HouseholdsCompanion Function({
      Value<int> household_id,
      Value<String?> head,
      Value<int?> address_id,
      Value<int?> household_type_id,
      Value<int?> building_type_id,
      Value<int?> ownership_type_id,
      Value<int?> household_members_num,
      Value<bool?> female_mortality,
      Value<bool?> child_mortality,
      Value<DateTime?> registration_date,
      Value<RegistrationStatus> registration_status,
    });

final class $$HouseholdsTableReferences
    extends BaseReferences<_$AppDatabase, $HouseholdsTable, HouseholdData> {
  $$HouseholdsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AddressesTable _address_idTable(_$AppDatabase db) =>
      db.addresses.createAlias(
        $_aliasNameGenerator(db.households.address_id, db.addresses.address_id),
      );

  $$AddressesTableProcessedTableManager? get address_id {
    final $_column = $_itemColumn<int>('address_id');
    if ($_column == null) return null;
    final manager = $$AddressesTableTableManager(
      $_db,
      $_db.addresses,
    ).filter((f) => f.address_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_address_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HouseholdTypesTable _household_type_idTable(_$AppDatabase db) =>
      db.householdTypes.createAlias(
        $_aliasNameGenerator(
          db.households.household_type_id,
          db.householdTypes.household_type_id,
        ),
      );

  $$HouseholdTypesTableProcessedTableManager? get household_type_id {
    final $_column = $_itemColumn<int>('household_type_id');
    if ($_column == null) return null;
    final manager = $$HouseholdTypesTableTableManager(
      $_db,
      $_db.householdTypes,
    ).filter((f) => f.household_type_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_household_type_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BuildingTypesTable _building_type_idTable(_$AppDatabase db) =>
      db.buildingTypes.createAlias(
        $_aliasNameGenerator(
          db.households.building_type_id,
          db.buildingTypes.building_type_id,
        ),
      );

  $$BuildingTypesTableProcessedTableManager? get building_type_id {
    final $_column = $_itemColumn<int>('building_type_id');
    if ($_column == null) return null;
    final manager = $$BuildingTypesTableTableManager(
      $_db,
      $_db.buildingTypes,
    ).filter((f) => f.building_type_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_building_type_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OwnershipTypesTable _ownership_type_idTable(_$AppDatabase db) =>
      db.ownershipTypes.createAlias(
        $_aliasNameGenerator(
          db.households.ownership_type_id,
          db.ownershipTypes.ownership_type_id,
        ),
      );

  $$OwnershipTypesTableProcessedTableManager? get ownership_type_id {
    final $_column = $_itemColumn<int>('ownership_type_id');
    if ($_column == null) return null;
    final manager = $$OwnershipTypesTableTableManager(
      $_db,
      $_db.ownershipTypes,
    ).filter((f) => f.ownership_type_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownership_type_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.households.household_id,
      db.persons.household_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.household_id.household_id.sqlEquals(
        $_itemColumn<int>('household_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get household_id => $composableBuilder(
    column: $table.household_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get head => $composableBuilder(
    column: $table.head,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get household_members_num => $composableBuilder(
    column: $table.household_members_num,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get female_mortality => $composableBuilder(
    column: $table.female_mortality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get child_mortality => $composableBuilder(
    column: $table.child_mortality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registration_date => $composableBuilder(
    column: $table.registration_date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RegistrationStatus, RegistrationStatus, String>
  get registration_status => $composableBuilder(
    column: $table.registration_status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$AddressesTableFilterComposer get address_id {
    final $$AddressesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableFilterComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HouseholdTypesTableFilterComposer get household_type_id {
    final $$HouseholdTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_type_id,
      referencedTable: $db.householdTypes,
      getReferencedColumn: (t) => t.household_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdTypesTableFilterComposer(
            $db: $db,
            $table: $db.householdTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BuildingTypesTableFilterComposer get building_type_id {
    final $$BuildingTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.building_type_id,
      referencedTable: $db.buildingTypes,
      getReferencedColumn: (t) => t.building_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingTypesTableFilterComposer(
            $db: $db,
            $table: $db.buildingTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnershipTypesTableFilterComposer get ownership_type_id {
    final $$OwnershipTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownership_type_id,
      referencedTable: $db.ownershipTypes,
      getReferencedColumn: (t) => t.ownership_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnershipTypesTableFilterComposer(
            $db: $db,
            $table: $db.ownershipTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.household_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get household_id => $composableBuilder(
    column: $table.household_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get head => $composableBuilder(
    column: $table.head,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get household_members_num => $composableBuilder(
    column: $table.household_members_num,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get female_mortality => $composableBuilder(
    column: $table.female_mortality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get child_mortality => $composableBuilder(
    column: $table.child_mortality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registration_date => $composableBuilder(
    column: $table.registration_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registration_status => $composableBuilder(
    column: $table.registration_status,
    builder: (column) => ColumnOrderings(column),
  );

  $$AddressesTableOrderingComposer get address_id {
    final $$AddressesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableOrderingComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HouseholdTypesTableOrderingComposer get household_type_id {
    final $$HouseholdTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_type_id,
      referencedTable: $db.householdTypes,
      getReferencedColumn: (t) => t.household_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdTypesTableOrderingComposer(
            $db: $db,
            $table: $db.householdTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BuildingTypesTableOrderingComposer get building_type_id {
    final $$BuildingTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.building_type_id,
      referencedTable: $db.buildingTypes,
      getReferencedColumn: (t) => t.building_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingTypesTableOrderingComposer(
            $db: $db,
            $table: $db.buildingTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnershipTypesTableOrderingComposer get ownership_type_id {
    final $$OwnershipTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownership_type_id,
      referencedTable: $db.ownershipTypes,
      getReferencedColumn: (t) => t.ownership_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnershipTypesTableOrderingComposer(
            $db: $db,
            $table: $db.ownershipTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get household_id => $composableBuilder(
    column: $table.household_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get head =>
      $composableBuilder(column: $table.head, builder: (column) => column);

  GeneratedColumn<int> get household_members_num => $composableBuilder(
    column: $table.household_members_num,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get female_mortality => $composableBuilder(
    column: $table.female_mortality,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get child_mortality => $composableBuilder(
    column: $table.child_mortality,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registration_date => $composableBuilder(
    column: $table.registration_date,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RegistrationStatus, String>
  get registration_status => $composableBuilder(
    column: $table.registration_status,
    builder: (column) => column,
  );

  $$AddressesTableAnnotationComposer get address_id {
    final $$AddressesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableAnnotationComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HouseholdTypesTableAnnotationComposer get household_type_id {
    final $$HouseholdTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_type_id,
      referencedTable: $db.householdTypes,
      getReferencedColumn: (t) => t.household_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.householdTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BuildingTypesTableAnnotationComposer get building_type_id {
    final $$BuildingTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.building_type_id,
      referencedTable: $db.buildingTypes,
      getReferencedColumn: (t) => t.building_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuildingTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.buildingTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnershipTypesTableAnnotationComposer get ownership_type_id {
    final $$OwnershipTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownership_type_id,
      referencedTable: $db.ownershipTypes,
      getReferencedColumn: (t) => t.ownership_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnershipTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.ownershipTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.household_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HouseholdsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HouseholdsTable,
          HouseholdData,
          $$HouseholdsTableFilterComposer,
          $$HouseholdsTableOrderingComposer,
          $$HouseholdsTableAnnotationComposer,
          $$HouseholdsTableCreateCompanionBuilder,
          $$HouseholdsTableUpdateCompanionBuilder,
          (HouseholdData, $$HouseholdsTableReferences),
          HouseholdData,
          PrefetchHooks Function({
            bool address_id,
            bool household_type_id,
            bool building_type_id,
            bool ownership_type_id,
            bool personsRefs,
          })
        > {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> household_id = const Value.absent(),
                Value<String?> head = const Value.absent(),
                Value<int?> address_id = const Value.absent(),
                Value<int?> household_type_id = const Value.absent(),
                Value<int?> building_type_id = const Value.absent(),
                Value<int?> ownership_type_id = const Value.absent(),
                Value<int?> household_members_num = const Value.absent(),
                Value<bool?> female_mortality = const Value.absent(),
                Value<bool?> child_mortality = const Value.absent(),
                Value<DateTime?> registration_date = const Value.absent(),
                Value<RegistrationStatus> registration_status =
                    const Value.absent(),
              }) => HouseholdsCompanion(
                household_id: household_id,
                head: head,
                address_id: address_id,
                household_type_id: household_type_id,
                building_type_id: building_type_id,
                ownership_type_id: ownership_type_id,
                household_members_num: household_members_num,
                female_mortality: female_mortality,
                child_mortality: child_mortality,
                registration_date: registration_date,
                registration_status: registration_status,
              ),
          createCompanionCallback:
              ({
                Value<int> household_id = const Value.absent(),
                Value<String?> head = const Value.absent(),
                Value<int?> address_id = const Value.absent(),
                Value<int?> household_type_id = const Value.absent(),
                Value<int?> building_type_id = const Value.absent(),
                Value<int?> ownership_type_id = const Value.absent(),
                Value<int?> household_members_num = const Value.absent(),
                Value<bool?> female_mortality = const Value.absent(),
                Value<bool?> child_mortality = const Value.absent(),
                Value<DateTime?> registration_date = const Value.absent(),
                required RegistrationStatus registration_status,
              }) => HouseholdsCompanion.insert(
                household_id: household_id,
                head: head,
                address_id: address_id,
                household_type_id: household_type_id,
                building_type_id: building_type_id,
                ownership_type_id: ownership_type_id,
                household_members_num: household_members_num,
                female_mortality: female_mortality,
                child_mortality: child_mortality,
                registration_date: registration_date,
                registration_status: registration_status,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$HouseholdsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            address_id = false,
            household_type_id = false,
            building_type_id = false,
            ownership_type_id = false,
            personsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (address_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.address_id,
                            referencedTable: $$HouseholdsTableReferences
                                ._address_idTable(db),
                            referencedColumn:
                                $$HouseholdsTableReferences
                                    ._address_idTable(db)
                                    .address_id,
                          )
                          as T;
                }
                if (household_type_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.household_type_id,
                            referencedTable: $$HouseholdsTableReferences
                                ._household_type_idTable(db),
                            referencedColumn:
                                $$HouseholdsTableReferences
                                    ._household_type_idTable(db)
                                    .household_type_id,
                          )
                          as T;
                }
                if (building_type_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.building_type_id,
                            referencedTable: $$HouseholdsTableReferences
                                ._building_type_idTable(db),
                            referencedColumn:
                                $$HouseholdsTableReferences
                                    ._building_type_idTable(db)
                                    .building_type_id,
                          )
                          as T;
                }
                if (ownership_type_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownership_type_id,
                            referencedTable: $$HouseholdsTableReferences
                                ._ownership_type_idTable(db),
                            referencedColumn:
                                $$HouseholdsTableReferences
                                    ._ownership_type_idTable(db)
                                    .ownership_type_id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      HouseholdData,
                      $HouseholdsTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$HouseholdsTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$HouseholdsTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.household_id == item.household_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HouseholdsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HouseholdsTable,
      HouseholdData,
      $$HouseholdsTableFilterComposer,
      $$HouseholdsTableOrderingComposer,
      $$HouseholdsTableAnnotationComposer,
      $$HouseholdsTableCreateCompanionBuilder,
      $$HouseholdsTableUpdateCompanionBuilder,
      (HouseholdData, $$HouseholdsTableReferences),
      HouseholdData,
      PrefetchHooks Function({
        bool address_id,
        bool household_type_id,
        bool building_type_id,
        bool ownership_type_id,
        bool personsRefs,
      })
    >;
typedef $$MonthlyIncomesTableCreateCompanionBuilder =
    MonthlyIncomesCompanion Function({
      Value<int> monthly_income_id,
      required String range,
    });
typedef $$MonthlyIncomesTableUpdateCompanionBuilder =
    MonthlyIncomesCompanion Function({
      Value<int> monthly_income_id,
      Value<String> range,
    });

final class $$MonthlyIncomesTableReferences
    extends
        BaseReferences<_$AppDatabase, $MonthlyIncomesTable, MonthlyIncomeData> {
  $$MonthlyIncomesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.monthlyIncomes.monthly_income_id,
      db.persons.monthly_income_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.monthly_income_id.monthly_income_id.sqlEquals(
        $_itemColumn<int>('monthly_income_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MonthlyIncomesTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyIncomesTable> {
  $$MonthlyIncomesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get monthly_income_id => $composableBuilder(
    column: $table.monthly_income_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthly_income_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.monthly_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyIncomesTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyIncomesTable> {
  $$MonthlyIncomesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get monthly_income_id => $composableBuilder(
    column: $table.monthly_income_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyIncomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyIncomesTable> {
  $$MonthlyIncomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get monthly_income_id => $composableBuilder(
    column: $table.monthly_income_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthly_income_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.monthly_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthlyIncomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyIncomesTable,
          MonthlyIncomeData,
          $$MonthlyIncomesTableFilterComposer,
          $$MonthlyIncomesTableOrderingComposer,
          $$MonthlyIncomesTableAnnotationComposer,
          $$MonthlyIncomesTableCreateCompanionBuilder,
          $$MonthlyIncomesTableUpdateCompanionBuilder,
          (MonthlyIncomeData, $$MonthlyIncomesTableReferences),
          MonthlyIncomeData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$MonthlyIncomesTableTableManager(
    _$AppDatabase db,
    $MonthlyIncomesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MonthlyIncomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$MonthlyIncomesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MonthlyIncomesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> monthly_income_id = const Value.absent(),
                Value<String> range = const Value.absent(),
              }) => MonthlyIncomesCompanion(
                monthly_income_id: monthly_income_id,
                range: range,
              ),
          createCompanionCallback:
              ({
                Value<int> monthly_income_id = const Value.absent(),
                required String range,
              }) => MonthlyIncomesCompanion.insert(
                monthly_income_id: monthly_income_id,
                range: range,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$MonthlyIncomesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      MonthlyIncomeData,
                      $MonthlyIncomesTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$MonthlyIncomesTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MonthlyIncomesTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) =>
                                e.monthly_income_id == item.monthly_income_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MonthlyIncomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyIncomesTable,
      MonthlyIncomeData,
      $$MonthlyIncomesTableFilterComposer,
      $$MonthlyIncomesTableOrderingComposer,
      $$MonthlyIncomesTableAnnotationComposer,
      $$MonthlyIncomesTableCreateCompanionBuilder,
      $$MonthlyIncomesTableUpdateCompanionBuilder,
      (MonthlyIncomeData, $$MonthlyIncomesTableReferences),
      MonthlyIncomeData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$DailyIncomesTableCreateCompanionBuilder =
    DailyIncomesCompanion Function({
      Value<int> daily_income_id,
      required String range,
    });
typedef $$DailyIncomesTableUpdateCompanionBuilder =
    DailyIncomesCompanion Function({
      Value<int> daily_income_id,
      Value<String> range,
    });

final class $$DailyIncomesTableReferences
    extends BaseReferences<_$AppDatabase, $DailyIncomesTable, DailyIncomeData> {
  $$DailyIncomesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.dailyIncomes.daily_income_id,
      db.persons.daily_income_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.daily_income_id.daily_income_id.sqlEquals(
        $_itemColumn<int>('daily_income_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyIncomesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyIncomesTable> {
  $$DailyIncomesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get daily_income_id => $composableBuilder(
    column: $table.daily_income_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daily_income_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.daily_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyIncomesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyIncomesTable> {
  $$DailyIncomesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get daily_income_id => $composableBuilder(
    column: $table.daily_income_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyIncomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyIncomesTable> {
  $$DailyIncomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get daily_income_id => $composableBuilder(
    column: $table.daily_income_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daily_income_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.daily_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyIncomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyIncomesTable,
          DailyIncomeData,
          $$DailyIncomesTableFilterComposer,
          $$DailyIncomesTableOrderingComposer,
          $$DailyIncomesTableAnnotationComposer,
          $$DailyIncomesTableCreateCompanionBuilder,
          $$DailyIncomesTableUpdateCompanionBuilder,
          (DailyIncomeData, $$DailyIncomesTableReferences),
          DailyIncomeData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$DailyIncomesTableTableManager(_$AppDatabase db, $DailyIncomesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DailyIncomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DailyIncomesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$DailyIncomesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> daily_income_id = const Value.absent(),
                Value<String> range = const Value.absent(),
              }) => DailyIncomesCompanion(
                daily_income_id: daily_income_id,
                range: range,
              ),
          createCompanionCallback:
              ({
                Value<int> daily_income_id = const Value.absent(),
                required String range,
              }) => DailyIncomesCompanion.insert(
                daily_income_id: daily_income_id,
                range: range,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$DailyIncomesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      DailyIncomeData,
                      $DailyIncomesTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$DailyIncomesTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$DailyIncomesTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.daily_income_id == item.daily_income_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DailyIncomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyIncomesTable,
      DailyIncomeData,
      $$DailyIncomesTableFilterComposer,
      $$DailyIncomesTableOrderingComposer,
      $$DailyIncomesTableAnnotationComposer,
      $$DailyIncomesTableCreateCompanionBuilder,
      $$DailyIncomesTableUpdateCompanionBuilder,
      (DailyIncomeData, $$DailyIncomesTableReferences),
      DailyIncomeData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$EducationTableCreateCompanionBuilder =
    EducationCompanion Function({
      Value<int> education_id,
      required String level,
    });
typedef $$EducationTableUpdateCompanionBuilder =
    EducationCompanion Function({Value<int> education_id, Value<String> level});

final class $$EducationTableReferences
    extends BaseReferences<_$AppDatabase, $EducationTable, EducationData> {
  $$EducationTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonsTable, List<PersonData>> _personsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.persons,
    aliasName: $_aliasNameGenerator(
      db.education.education_id,
      db.persons.education_id,
    ),
  );

  $$PersonsTableProcessedTableManager get personsRefs {
    final manager = $$PersonsTableTableManager($_db, $_db.persons).filter(
      (f) => f.education_id.education_id.sqlEquals(
        $_itemColumn<int>('education_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_personsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EducationTableFilterComposer
    extends Composer<_$AppDatabase, $EducationTable> {
  $$EducationTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get education_id => $composableBuilder(
    column: $table.education_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personsRefs(
    Expression<bool> Function($$PersonsTableFilterComposer f) f,
  ) {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.education_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.education_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableFilterComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EducationTableOrderingComposer
    extends Composer<_$AppDatabase, $EducationTable> {
  $$EducationTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get education_id => $composableBuilder(
    column: $table.education_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EducationTableAnnotationComposer
    extends Composer<_$AppDatabase, $EducationTable> {
  $$EducationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get education_id => $composableBuilder(
    column: $table.education_id,
    builder: (column) => column,
  );

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  Expression<T> personsRefs<T extends Object>(
    Expression<T> Function($$PersonsTableAnnotationComposer a) f,
  ) {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.education_id,
      referencedTable: $db.persons,
      getReferencedColumn: (t) => t.education_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonsTableAnnotationComposer(
            $db: $db,
            $table: $db.persons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EducationTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EducationTable,
          EducationData,
          $$EducationTableFilterComposer,
          $$EducationTableOrderingComposer,
          $$EducationTableAnnotationComposer,
          $$EducationTableCreateCompanionBuilder,
          $$EducationTableUpdateCompanionBuilder,
          (EducationData, $$EducationTableReferences),
          EducationData,
          PrefetchHooks Function({bool personsRefs})
        > {
  $$EducationTableTableManager(_$AppDatabase db, $EducationTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EducationTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EducationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EducationTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> education_id = const Value.absent(),
                Value<String> level = const Value.absent(),
              }) =>
                  EducationCompanion(education_id: education_id, level: level),
          createCompanionCallback:
              ({
                Value<int> education_id = const Value.absent(),
                required String level,
              }) => EducationCompanion.insert(
                education_id: education_id,
                level: level,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EducationTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({personsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personsRefs) db.persons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personsRefs)
                    await $_getPrefetchedData<
                      EducationData,
                      $EducationTable,
                      PersonData
                    >(
                      currentTable: table,
                      referencedTable: $$EducationTableReferences
                          ._personsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EducationTableReferences(
                                db,
                                table,
                                p0,
                              ).personsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.education_id == item.education_id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EducationTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EducationTable,
      EducationData,
      $$EducationTableFilterComposer,
      $$EducationTableOrderingComposer,
      $$EducationTableAnnotationComposer,
      $$EducationTableCreateCompanionBuilder,
      $$EducationTableUpdateCompanionBuilder,
      (EducationData, $$EducationTableReferences),
      EducationData,
      PrefetchHooks Function({bool personsRefs})
    >;
typedef $$PersonsTableCreateCompanionBuilder =
    PersonsCompanion Function({
      Value<int> person_id,
      required String last_name,
      required String first_name,
      Value<String?> middle_name,
      Value<String?> suffix,
      Value<Sex?> sex,
      Value<int?> age,
      Value<DateTime?> birth_date,
      Value<String?> birth_place,
      Value<CivilStatus?> civil_status,
      Value<int?> religion_id,
      Value<int?> nationality_id,
      Value<int?> ethnicity_id,
      Value<int?> blood_type_id,
      Value<int?> household_id,
      Value<int?> address_id,
      Value<String?> registration_place,
      Value<Residency?> residency,
      Value<int?> years_of_residency,
      Value<Transient?> transient_type,
      Value<int?> monthly_income_id,
      Value<int?> daily_income_id,
      Value<SoloParent?> solo_parent,
      Value<bool?> ofw,
      Value<bool?> literate,
      Value<bool?> pwd,
      Value<bool?> registered_voter,
      Value<CurrentlyEnrolled?> currently_enrolled,
      Value<int?> education_id,
      Value<bool?> deceased,
      Value<DateTime?> death_date,
      Value<DateTime?> registration_date,
      required RegistrationStatus registration_status,
    });
typedef $$PersonsTableUpdateCompanionBuilder =
    PersonsCompanion Function({
      Value<int> person_id,
      Value<String> last_name,
      Value<String> first_name,
      Value<String?> middle_name,
      Value<String?> suffix,
      Value<Sex?> sex,
      Value<int?> age,
      Value<DateTime?> birth_date,
      Value<String?> birth_place,
      Value<CivilStatus?> civil_status,
      Value<int?> religion_id,
      Value<int?> nationality_id,
      Value<int?> ethnicity_id,
      Value<int?> blood_type_id,
      Value<int?> household_id,
      Value<int?> address_id,
      Value<String?> registration_place,
      Value<Residency?> residency,
      Value<int?> years_of_residency,
      Value<Transient?> transient_type,
      Value<int?> monthly_income_id,
      Value<int?> daily_income_id,
      Value<SoloParent?> solo_parent,
      Value<bool?> ofw,
      Value<bool?> literate,
      Value<bool?> pwd,
      Value<bool?> registered_voter,
      Value<CurrentlyEnrolled?> currently_enrolled,
      Value<int?> education_id,
      Value<bool?> deceased,
      Value<DateTime?> death_date,
      Value<DateTime?> registration_date,
      Value<RegistrationStatus> registration_status,
    });

final class $$PersonsTableReferences
    extends BaseReferences<_$AppDatabase, $PersonsTable, PersonData> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReligionsTable _religion_idTable(_$AppDatabase db) =>
      db.religions.createAlias(
        $_aliasNameGenerator(db.persons.religion_id, db.religions.religion_id),
      );

  $$ReligionsTableProcessedTableManager? get religion_id {
    final $_column = $_itemColumn<int>('religion_id');
    if ($_column == null) return null;
    final manager = $$ReligionsTableTableManager(
      $_db,
      $_db.religions,
    ).filter((f) => f.religion_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_religion_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $NationalitiesTable _nationality_idTable(_$AppDatabase db) =>
      db.nationalities.createAlias(
        $_aliasNameGenerator(
          db.persons.nationality_id,
          db.nationalities.nationality_id,
        ),
      );

  $$NationalitiesTableProcessedTableManager? get nationality_id {
    final $_column = $_itemColumn<int>('nationality_id');
    if ($_column == null) return null;
    final manager = $$NationalitiesTableTableManager(
      $_db,
      $_db.nationalities,
    ).filter((f) => f.nationality_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nationality_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EthnicitiesTable _ethnicity_idTable(_$AppDatabase db) =>
      db.ethnicities.createAlias(
        $_aliasNameGenerator(
          db.persons.ethnicity_id,
          db.ethnicities.ethnicity_id,
        ),
      );

  $$EthnicitiesTableProcessedTableManager? get ethnicity_id {
    final $_column = $_itemColumn<int>('ethnicity_id');
    if ($_column == null) return null;
    final manager = $$EthnicitiesTableTableManager(
      $_db,
      $_db.ethnicities,
    ).filter((f) => f.ethnicity_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ethnicity_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BloodTypesTable _blood_type_idTable(_$AppDatabase db) =>
      db.bloodTypes.createAlias(
        $_aliasNameGenerator(
          db.persons.blood_type_id,
          db.bloodTypes.blood_type_id,
        ),
      );

  $$BloodTypesTableProcessedTableManager? get blood_type_id {
    final $_column = $_itemColumn<int>('blood_type_id');
    if ($_column == null) return null;
    final manager = $$BloodTypesTableTableManager(
      $_db,
      $_db.bloodTypes,
    ).filter((f) => f.blood_type_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blood_type_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HouseholdsTable _household_idTable(_$AppDatabase db) =>
      db.households.createAlias(
        $_aliasNameGenerator(
          db.persons.household_id,
          db.households.household_id,
        ),
      );

  $$HouseholdsTableProcessedTableManager? get household_id {
    final $_column = $_itemColumn<int>('household_id');
    if ($_column == null) return null;
    final manager = $$HouseholdsTableTableManager(
      $_db,
      $_db.households,
    ).filter((f) => f.household_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_household_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AddressesTable _address_idTable(_$AppDatabase db) =>
      db.addresses.createAlias(
        $_aliasNameGenerator(db.persons.address_id, db.addresses.address_id),
      );

  $$AddressesTableProcessedTableManager? get address_id {
    final $_column = $_itemColumn<int>('address_id');
    if ($_column == null) return null;
    final manager = $$AddressesTableTableManager(
      $_db,
      $_db.addresses,
    ).filter((f) => f.address_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_address_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MonthlyIncomesTable _monthly_income_idTable(_$AppDatabase db) =>
      db.monthlyIncomes.createAlias(
        $_aliasNameGenerator(
          db.persons.monthly_income_id,
          db.monthlyIncomes.monthly_income_id,
        ),
      );

  $$MonthlyIncomesTableProcessedTableManager? get monthly_income_id {
    final $_column = $_itemColumn<int>('monthly_income_id');
    if ($_column == null) return null;
    final manager = $$MonthlyIncomesTableTableManager(
      $_db,
      $_db.monthlyIncomes,
    ).filter((f) => f.monthly_income_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_monthly_income_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DailyIncomesTable _daily_income_idTable(_$AppDatabase db) =>
      db.dailyIncomes.createAlias(
        $_aliasNameGenerator(
          db.persons.daily_income_id,
          db.dailyIncomes.daily_income_id,
        ),
      );

  $$DailyIncomesTableProcessedTableManager? get daily_income_id {
    final $_column = $_itemColumn<int>('daily_income_id');
    if ($_column == null) return null;
    final manager = $$DailyIncomesTableTableManager(
      $_db,
      $_db.dailyIncomes,
    ).filter((f) => f.daily_income_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_daily_income_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EducationTable _education_idTable(_$AppDatabase db) =>
      db.education.createAlias(
        $_aliasNameGenerator(
          db.persons.education_id,
          db.education.education_id,
        ),
      );

  $$EducationTableProcessedTableManager? get education_id {
    final $_column = $_itemColumn<int>('education_id');
    if ($_column == null) return null;
    final manager = $$EducationTableTableManager(
      $_db,
      $_db.education,
    ).filter((f) => f.education_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_education_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get person_id => $composableBuilder(
    column: $table.person_id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last_name => $composableBuilder(
    column: $table.last_name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get first_name => $composableBuilder(
    column: $table.first_name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middle_name => $composableBuilder(
    column: $table.middle_name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Sex?, Sex, String> get sex =>
      $composableBuilder(
        column: $table.sex,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birth_date => $composableBuilder(
    column: $table.birth_date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birth_place => $composableBuilder(
    column: $table.birth_place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CivilStatus?, CivilStatus, String>
  get civil_status => $composableBuilder(
    column: $table.civil_status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get registration_place => $composableBuilder(
    column: $table.registration_place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Residency?, Residency, String> get residency =>
      $composableBuilder(
        column: $table.residency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get years_of_residency => $composableBuilder(
    column: $table.years_of_residency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Transient?, Transient, String>
  get transient_type => $composableBuilder(
    column: $table.transient_type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SoloParent?, SoloParent, String>
  get solo_parent => $composableBuilder(
    column: $table.solo_parent,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get ofw => $composableBuilder(
    column: $table.ofw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get literate => $composableBuilder(
    column: $table.literate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pwd => $composableBuilder(
    column: $table.pwd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get registered_voter => $composableBuilder(
    column: $table.registered_voter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CurrentlyEnrolled?, CurrentlyEnrolled, String>
  get currently_enrolled => $composableBuilder(
    column: $table.currently_enrolled,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get deceased => $composableBuilder(
    column: $table.deceased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get death_date => $composableBuilder(
    column: $table.death_date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registration_date => $composableBuilder(
    column: $table.registration_date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RegistrationStatus, RegistrationStatus, String>
  get registration_status => $composableBuilder(
    column: $table.registration_status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ReligionsTableFilterComposer get religion_id {
    final $$ReligionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.religion_id,
      referencedTable: $db.religions,
      getReferencedColumn: (t) => t.religion_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReligionsTableFilterComposer(
            $db: $db,
            $table: $db.religions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NationalitiesTableFilterComposer get nationality_id {
    final $$NationalitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationality_id,
      referencedTable: $db.nationalities,
      getReferencedColumn: (t) => t.nationality_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationalitiesTableFilterComposer(
            $db: $db,
            $table: $db.nationalities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EthnicitiesTableFilterComposer get ethnicity_id {
    final $$EthnicitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ethnicity_id,
      referencedTable: $db.ethnicities,
      getReferencedColumn: (t) => t.ethnicity_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EthnicitiesTableFilterComposer(
            $db: $db,
            $table: $db.ethnicities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BloodTypesTableFilterComposer get blood_type_id {
    final $$BloodTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blood_type_id,
      referencedTable: $db.bloodTypes,
      getReferencedColumn: (t) => t.blood_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloodTypesTableFilterComposer(
            $db: $db,
            $table: $db.bloodTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HouseholdsTableFilterComposer get household_id {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.household_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AddressesTableFilterComposer get address_id {
    final $$AddressesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableFilterComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MonthlyIncomesTableFilterComposer get monthly_income_id {
    final $$MonthlyIncomesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthly_income_id,
      referencedTable: $db.monthlyIncomes,
      getReferencedColumn: (t) => t.monthly_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyIncomesTableFilterComposer(
            $db: $db,
            $table: $db.monthlyIncomes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DailyIncomesTableFilterComposer get daily_income_id {
    final $$DailyIncomesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daily_income_id,
      referencedTable: $db.dailyIncomes,
      getReferencedColumn: (t) => t.daily_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyIncomesTableFilterComposer(
            $db: $db,
            $table: $db.dailyIncomes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EducationTableFilterComposer get education_id {
    final $$EducationTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.education_id,
      referencedTable: $db.education,
      getReferencedColumn: (t) => t.education_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EducationTableFilterComposer(
            $db: $db,
            $table: $db.education,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get person_id => $composableBuilder(
    column: $table.person_id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last_name => $composableBuilder(
    column: $table.last_name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get first_name => $composableBuilder(
    column: $table.first_name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middle_name => $composableBuilder(
    column: $table.middle_name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birth_date => $composableBuilder(
    column: $table.birth_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birth_place => $composableBuilder(
    column: $table.birth_place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get civil_status => $composableBuilder(
    column: $table.civil_status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registration_place => $composableBuilder(
    column: $table.registration_place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get residency => $composableBuilder(
    column: $table.residency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get years_of_residency => $composableBuilder(
    column: $table.years_of_residency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transient_type => $composableBuilder(
    column: $table.transient_type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get solo_parent => $composableBuilder(
    column: $table.solo_parent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ofw => $composableBuilder(
    column: $table.ofw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get literate => $composableBuilder(
    column: $table.literate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pwd => $composableBuilder(
    column: $table.pwd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get registered_voter => $composableBuilder(
    column: $table.registered_voter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currently_enrolled => $composableBuilder(
    column: $table.currently_enrolled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deceased => $composableBuilder(
    column: $table.deceased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get death_date => $composableBuilder(
    column: $table.death_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registration_date => $composableBuilder(
    column: $table.registration_date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registration_status => $composableBuilder(
    column: $table.registration_status,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReligionsTableOrderingComposer get religion_id {
    final $$ReligionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.religion_id,
      referencedTable: $db.religions,
      getReferencedColumn: (t) => t.religion_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReligionsTableOrderingComposer(
            $db: $db,
            $table: $db.religions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NationalitiesTableOrderingComposer get nationality_id {
    final $$NationalitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationality_id,
      referencedTable: $db.nationalities,
      getReferencedColumn: (t) => t.nationality_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationalitiesTableOrderingComposer(
            $db: $db,
            $table: $db.nationalities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EthnicitiesTableOrderingComposer get ethnicity_id {
    final $$EthnicitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ethnicity_id,
      referencedTable: $db.ethnicities,
      getReferencedColumn: (t) => t.ethnicity_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EthnicitiesTableOrderingComposer(
            $db: $db,
            $table: $db.ethnicities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BloodTypesTableOrderingComposer get blood_type_id {
    final $$BloodTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blood_type_id,
      referencedTable: $db.bloodTypes,
      getReferencedColumn: (t) => t.blood_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloodTypesTableOrderingComposer(
            $db: $db,
            $table: $db.bloodTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HouseholdsTableOrderingComposer get household_id {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.household_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableOrderingComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AddressesTableOrderingComposer get address_id {
    final $$AddressesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableOrderingComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MonthlyIncomesTableOrderingComposer get monthly_income_id {
    final $$MonthlyIncomesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthly_income_id,
      referencedTable: $db.monthlyIncomes,
      getReferencedColumn: (t) => t.monthly_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyIncomesTableOrderingComposer(
            $db: $db,
            $table: $db.monthlyIncomes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DailyIncomesTableOrderingComposer get daily_income_id {
    final $$DailyIncomesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daily_income_id,
      referencedTable: $db.dailyIncomes,
      getReferencedColumn: (t) => t.daily_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyIncomesTableOrderingComposer(
            $db: $db,
            $table: $db.dailyIncomes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EducationTableOrderingComposer get education_id {
    final $$EducationTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.education_id,
      referencedTable: $db.education,
      getReferencedColumn: (t) => t.education_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EducationTableOrderingComposer(
            $db: $db,
            $table: $db.education,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get person_id =>
      $composableBuilder(column: $table.person_id, builder: (column) => column);

  GeneratedColumn<String> get last_name =>
      $composableBuilder(column: $table.last_name, builder: (column) => column);

  GeneratedColumn<String> get first_name => $composableBuilder(
    column: $table.first_name,
    builder: (column) => column,
  );

  GeneratedColumn<String> get middle_name => $composableBuilder(
    column: $table.middle_name,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suffix =>
      $composableBuilder(column: $table.suffix, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Sex?, String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<DateTime> get birth_date => $composableBuilder(
    column: $table.birth_date,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birth_place => $composableBuilder(
    column: $table.birth_place,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CivilStatus?, String> get civil_status =>
      $composableBuilder(
        column: $table.civil_status,
        builder: (column) => column,
      );

  GeneratedColumn<String> get registration_place => $composableBuilder(
    column: $table.registration_place,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Residency?, String> get residency =>
      $composableBuilder(column: $table.residency, builder: (column) => column);

  GeneratedColumn<int> get years_of_residency => $composableBuilder(
    column: $table.years_of_residency,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Transient?, String> get transient_type =>
      $composableBuilder(
        column: $table.transient_type,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SoloParent?, String> get solo_parent =>
      $composableBuilder(
        column: $table.solo_parent,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get ofw =>
      $composableBuilder(column: $table.ofw, builder: (column) => column);

  GeneratedColumn<bool> get literate =>
      $composableBuilder(column: $table.literate, builder: (column) => column);

  GeneratedColumn<bool> get pwd =>
      $composableBuilder(column: $table.pwd, builder: (column) => column);

  GeneratedColumn<bool> get registered_voter => $composableBuilder(
    column: $table.registered_voter,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CurrentlyEnrolled?, String>
  get currently_enrolled => $composableBuilder(
    column: $table.currently_enrolled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deceased =>
      $composableBuilder(column: $table.deceased, builder: (column) => column);

  GeneratedColumn<DateTime> get death_date => $composableBuilder(
    column: $table.death_date,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registration_date => $composableBuilder(
    column: $table.registration_date,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RegistrationStatus, String>
  get registration_status => $composableBuilder(
    column: $table.registration_status,
    builder: (column) => column,
  );

  $$ReligionsTableAnnotationComposer get religion_id {
    final $$ReligionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.religion_id,
      referencedTable: $db.religions,
      getReferencedColumn: (t) => t.religion_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReligionsTableAnnotationComposer(
            $db: $db,
            $table: $db.religions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$NationalitiesTableAnnotationComposer get nationality_id {
    final $$NationalitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nationality_id,
      referencedTable: $db.nationalities,
      getReferencedColumn: (t) => t.nationality_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NationalitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.nationalities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EthnicitiesTableAnnotationComposer get ethnicity_id {
    final $$EthnicitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ethnicity_id,
      referencedTable: $db.ethnicities,
      getReferencedColumn: (t) => t.ethnicity_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EthnicitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.ethnicities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BloodTypesTableAnnotationComposer get blood_type_id {
    final $$BloodTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blood_type_id,
      referencedTable: $db.bloodTypes,
      getReferencedColumn: (t) => t.blood_type_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BloodTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.bloodTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HouseholdsTableAnnotationComposer get household_id {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.household_id,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.household_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HouseholdsTableAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AddressesTableAnnotationComposer get address_id {
    final $$AddressesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address_id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableAnnotationComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MonthlyIncomesTableAnnotationComposer get monthly_income_id {
    final $$MonthlyIncomesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthly_income_id,
      referencedTable: $db.monthlyIncomes,
      getReferencedColumn: (t) => t.monthly_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthlyIncomesTableAnnotationComposer(
            $db: $db,
            $table: $db.monthlyIncomes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DailyIncomesTableAnnotationComposer get daily_income_id {
    final $$DailyIncomesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.daily_income_id,
      referencedTable: $db.dailyIncomes,
      getReferencedColumn: (t) => t.daily_income_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyIncomesTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyIncomes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EducationTableAnnotationComposer get education_id {
    final $$EducationTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.education_id,
      referencedTable: $db.education,
      getReferencedColumn: (t) => t.education_id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EducationTableAnnotationComposer(
            $db: $db,
            $table: $db.education,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonsTable,
          PersonData,
          $$PersonsTableFilterComposer,
          $$PersonsTableOrderingComposer,
          $$PersonsTableAnnotationComposer,
          $$PersonsTableCreateCompanionBuilder,
          $$PersonsTableUpdateCompanionBuilder,
          (PersonData, $$PersonsTableReferences),
          PersonData,
          PrefetchHooks Function({
            bool religion_id,
            bool nationality_id,
            bool ethnicity_id,
            bool blood_type_id,
            bool household_id,
            bool address_id,
            bool monthly_income_id,
            bool daily_income_id,
            bool education_id,
          })
        > {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> person_id = const Value.absent(),
                Value<String> last_name = const Value.absent(),
                Value<String> first_name = const Value.absent(),
                Value<String?> middle_name = const Value.absent(),
                Value<String?> suffix = const Value.absent(),
                Value<Sex?> sex = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<DateTime?> birth_date = const Value.absent(),
                Value<String?> birth_place = const Value.absent(),
                Value<CivilStatus?> civil_status = const Value.absent(),
                Value<int?> religion_id = const Value.absent(),
                Value<int?> nationality_id = const Value.absent(),
                Value<int?> ethnicity_id = const Value.absent(),
                Value<int?> blood_type_id = const Value.absent(),
                Value<int?> household_id = const Value.absent(),
                Value<int?> address_id = const Value.absent(),
                Value<String?> registration_place = const Value.absent(),
                Value<Residency?> residency = const Value.absent(),
                Value<int?> years_of_residency = const Value.absent(),
                Value<Transient?> transient_type = const Value.absent(),
                Value<int?> monthly_income_id = const Value.absent(),
                Value<int?> daily_income_id = const Value.absent(),
                Value<SoloParent?> solo_parent = const Value.absent(),
                Value<bool?> ofw = const Value.absent(),
                Value<bool?> literate = const Value.absent(),
                Value<bool?> pwd = const Value.absent(),
                Value<bool?> registered_voter = const Value.absent(),
                Value<CurrentlyEnrolled?> currently_enrolled =
                    const Value.absent(),
                Value<int?> education_id = const Value.absent(),
                Value<bool?> deceased = const Value.absent(),
                Value<DateTime?> death_date = const Value.absent(),
                Value<DateTime?> registration_date = const Value.absent(),
                Value<RegistrationStatus> registration_status =
                    const Value.absent(),
              }) => PersonsCompanion(
                person_id: person_id,
                last_name: last_name,
                first_name: first_name,
                middle_name: middle_name,
                suffix: suffix,
                sex: sex,
                age: age,
                birth_date: birth_date,
                birth_place: birth_place,
                civil_status: civil_status,
                religion_id: religion_id,
                nationality_id: nationality_id,
                ethnicity_id: ethnicity_id,
                blood_type_id: blood_type_id,
                household_id: household_id,
                address_id: address_id,
                registration_place: registration_place,
                residency: residency,
                years_of_residency: years_of_residency,
                transient_type: transient_type,
                monthly_income_id: monthly_income_id,
                daily_income_id: daily_income_id,
                solo_parent: solo_parent,
                ofw: ofw,
                literate: literate,
                pwd: pwd,
                registered_voter: registered_voter,
                currently_enrolled: currently_enrolled,
                education_id: education_id,
                deceased: deceased,
                death_date: death_date,
                registration_date: registration_date,
                registration_status: registration_status,
              ),
          createCompanionCallback:
              ({
                Value<int> person_id = const Value.absent(),
                required String last_name,
                required String first_name,
                Value<String?> middle_name = const Value.absent(),
                Value<String?> suffix = const Value.absent(),
                Value<Sex?> sex = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<DateTime?> birth_date = const Value.absent(),
                Value<String?> birth_place = const Value.absent(),
                Value<CivilStatus?> civil_status = const Value.absent(),
                Value<int?> religion_id = const Value.absent(),
                Value<int?> nationality_id = const Value.absent(),
                Value<int?> ethnicity_id = const Value.absent(),
                Value<int?> blood_type_id = const Value.absent(),
                Value<int?> household_id = const Value.absent(),
                Value<int?> address_id = const Value.absent(),
                Value<String?> registration_place = const Value.absent(),
                Value<Residency?> residency = const Value.absent(),
                Value<int?> years_of_residency = const Value.absent(),
                Value<Transient?> transient_type = const Value.absent(),
                Value<int?> monthly_income_id = const Value.absent(),
                Value<int?> daily_income_id = const Value.absent(),
                Value<SoloParent?> solo_parent = const Value.absent(),
                Value<bool?> ofw = const Value.absent(),
                Value<bool?> literate = const Value.absent(),
                Value<bool?> pwd = const Value.absent(),
                Value<bool?> registered_voter = const Value.absent(),
                Value<CurrentlyEnrolled?> currently_enrolled =
                    const Value.absent(),
                Value<int?> education_id = const Value.absent(),
                Value<bool?> deceased = const Value.absent(),
                Value<DateTime?> death_date = const Value.absent(),
                Value<DateTime?> registration_date = const Value.absent(),
                required RegistrationStatus registration_status,
              }) => PersonsCompanion.insert(
                person_id: person_id,
                last_name: last_name,
                first_name: first_name,
                middle_name: middle_name,
                suffix: suffix,
                sex: sex,
                age: age,
                birth_date: birth_date,
                birth_place: birth_place,
                civil_status: civil_status,
                religion_id: religion_id,
                nationality_id: nationality_id,
                ethnicity_id: ethnicity_id,
                blood_type_id: blood_type_id,
                household_id: household_id,
                address_id: address_id,
                registration_place: registration_place,
                residency: residency,
                years_of_residency: years_of_residency,
                transient_type: transient_type,
                monthly_income_id: monthly_income_id,
                daily_income_id: daily_income_id,
                solo_parent: solo_parent,
                ofw: ofw,
                literate: literate,
                pwd: pwd,
                registered_voter: registered_voter,
                currently_enrolled: currently_enrolled,
                education_id: education_id,
                deceased: deceased,
                death_date: death_date,
                registration_date: registration_date,
                registration_status: registration_status,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PersonsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            religion_id = false,
            nationality_id = false,
            ethnicity_id = false,
            blood_type_id = false,
            household_id = false,
            address_id = false,
            monthly_income_id = false,
            daily_income_id = false,
            education_id = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (religion_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.religion_id,
                            referencedTable: $$PersonsTableReferences
                                ._religion_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._religion_idTable(db)
                                    .religion_id,
                          )
                          as T;
                }
                if (nationality_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.nationality_id,
                            referencedTable: $$PersonsTableReferences
                                ._nationality_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._nationality_idTable(db)
                                    .nationality_id,
                          )
                          as T;
                }
                if (ethnicity_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ethnicity_id,
                            referencedTable: $$PersonsTableReferences
                                ._ethnicity_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._ethnicity_idTable(db)
                                    .ethnicity_id,
                          )
                          as T;
                }
                if (blood_type_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.blood_type_id,
                            referencedTable: $$PersonsTableReferences
                                ._blood_type_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._blood_type_idTable(db)
                                    .blood_type_id,
                          )
                          as T;
                }
                if (household_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.household_id,
                            referencedTable: $$PersonsTableReferences
                                ._household_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._household_idTable(db)
                                    .household_id,
                          )
                          as T;
                }
                if (address_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.address_id,
                            referencedTable: $$PersonsTableReferences
                                ._address_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._address_idTable(db)
                                    .address_id,
                          )
                          as T;
                }
                if (monthly_income_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.monthly_income_id,
                            referencedTable: $$PersonsTableReferences
                                ._monthly_income_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._monthly_income_idTable(db)
                                    .monthly_income_id,
                          )
                          as T;
                }
                if (daily_income_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.daily_income_id,
                            referencedTable: $$PersonsTableReferences
                                ._daily_income_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._daily_income_idTable(db)
                                    .daily_income_id,
                          )
                          as T;
                }
                if (education_id) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.education_id,
                            referencedTable: $$PersonsTableReferences
                                ._education_idTable(db),
                            referencedColumn:
                                $$PersonsTableReferences
                                    ._education_idTable(db)
                                    .education_id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PersonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonsTable,
      PersonData,
      $$PersonsTableFilterComposer,
      $$PersonsTableOrderingComposer,
      $$PersonsTableAnnotationComposer,
      $$PersonsTableCreateCompanionBuilder,
      $$PersonsTableUpdateCompanionBuilder,
      (PersonData, $$PersonsTableReferences),
      PersonData,
      PrefetchHooks Function({
        bool religion_id,
        bool nationality_id,
        bool ethnicity_id,
        bool blood_type_id,
        bool household_id,
        bool address_id,
        bool monthly_income_id,
        bool daily_income_id,
        bool education_id,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReligionsTableTableManager get religions =>
      $$ReligionsTableTableManager(_db, _db.religions);
  $$NationalitiesTableTableManager get nationalities =>
      $$NationalitiesTableTableManager(_db, _db.nationalities);
  $$EthnicitiesTableTableManager get ethnicities =>
      $$EthnicitiesTableTableManager(_db, _db.ethnicities);
  $$BloodTypesTableTableManager get bloodTypes =>
      $$BloodTypesTableTableManager(_db, _db.bloodTypes);
  $$AddressesTableTableManager get addresses =>
      $$AddressesTableTableManager(_db, _db.addresses);
  $$HouseholdTypesTableTableManager get householdTypes =>
      $$HouseholdTypesTableTableManager(_db, _db.householdTypes);
  $$BuildingTypesTableTableManager get buildingTypes =>
      $$BuildingTypesTableTableManager(_db, _db.buildingTypes);
  $$OwnershipTypesTableTableManager get ownershipTypes =>
      $$OwnershipTypesTableTableManager(_db, _db.ownershipTypes);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$MonthlyIncomesTableTableManager get monthlyIncomes =>
      $$MonthlyIncomesTableTableManager(_db, _db.monthlyIncomes);
  $$DailyIncomesTableTableManager get dailyIncomes =>
      $$DailyIncomesTableTableManager(_db, _db.dailyIncomes);
  $$EducationTableTableManager get education =>
      $$EducationTableTableManager(_db, _db.education);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
}
