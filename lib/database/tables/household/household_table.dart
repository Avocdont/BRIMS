import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/household/building_type_table.dart';
import 'package:brims/database/tables/household/household_type_table.dart';
import 'package:brims/database/tables/household/ownership_type_table.dart';
import 'package:brims/database/tables/profiling/address_table.dart';
import 'package:drift/drift.dart';

class Households extends Table {
  IntColumn get household_id => integer().autoIncrement()();
  TextColumn get head => text().nullable()();
  IntColumn get address_id =>
      integer().nullable().references(
        Addresses,
        #address_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get household_type_id =>
      integer().nullable().references(
        HouseholdTypes,
        #household_type_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get building_type_id =>
      integer().nullable().references(
        BuildingTypes,
        #building_type_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get ownership_type_id =>
      integer().nullable().references(
        OwnershipTypes,
        #ownership_type_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get household_members_num => integer().nullable()();
  BoolColumn get female_mortality => boolean().nullable()();
  BoolColumn get child_mortality => boolean().nullable()();
  DateTimeColumn get registration_date => dateTime().nullable()();
  TextColumn get registration_status => textEnum<RegistrationStatus>()();
}
