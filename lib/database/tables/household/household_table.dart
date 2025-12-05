import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/lookups/household_lookup_tables.dart';
import 'package:brims/database/tables/profiling/address_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:drift/drift.dart';

@DataClassName('HouseholdData')
class Households extends Table {
  IntColumn get household_id => integer().autoIncrement()();
  TextColumn get head => text().nullable()();
  IntColumn get address_id =>
      integer().nullable().references(
        Addresses,
        #address_id,
        onDelete: KeyAction.restrict,
      )();
  TextColumn get household_type_id => textEnum<HouseholdTypes>().nullable()();
  IntColumn get building_type_id =>
      integer().nullable().references(
        BuildingTypes,
        #building_type_id,
        onDelete: KeyAction.restrict,
      )();
  TextColumn get ownership_type_id => textEnum<OwnershipTypes>().nullable()();
  IntColumn get household_members_num => integer().nullable()();
  BoolColumn get female_mortality => boolean().nullable()();
  BoolColumn get child_mortality => boolean().nullable()();
  DateTimeColumn get registration_date => dateTime().nullable()();
  TextColumn get registration_status => textEnum<RegistrationStatus>()();
}

@DataClassName('HouseholdMemberData')
class HouseholdMembers extends Table {
  IntColumn get household_member_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
}

@DataClassName('HouseholdRelationship')
class HouseholdRelationships extends Table {
  IntColumn get household_relationship_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get relationship_id =>
      integer().nullable().references(
        RelationshipTypes,
        #relationship_id,
        onDelete: KeyAction.restrict,
      )();
}

@DataClassName('ServiceData')
class Services extends Table {
  IntColumn get service_id => integer().autoIncrement()();
  TextColumn get service => text()();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get client_type_id => textEnum<ClientTypes>().nullable()();
  IntColumn get ave_client_num => integer().nullable()();
}

@DataClassName('PrimaryNeedData')
class PrimaryNeeds extends Table {
  IntColumn get primary_need_id => integer().autoIncrement()();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get need => text()();
  IntColumn get priority => integer()();
}

@DataClassName('FemaleMortalityData')
class FemaleMortalities extends Table {
  IntColumn get female_mortality_id => integer().autoIncrement()();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get age => integer().nullable()();
  TextColumn get death_cause => text().nullable()();
}

@DataClassName('ChildMortalityData')
class ChildMortalities extends Table {
  IntColumn get child_mortality_id => integer().autoIncrement()();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get age => integer().nullable()();
  TextColumn get sex => textEnum<Sex>().nullable()();
  TextColumn get death_cause => text().nullable()();
}

@DataClassName('FutureResidency')
class FutureResidencies extends Table {
  IntColumn get future_residency_id => integer().autoIncrement()();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get barangay => text().nullable()();
  TextColumn get municipality => text().nullable()();
}
