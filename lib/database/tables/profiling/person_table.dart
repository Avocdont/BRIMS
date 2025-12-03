import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/household/household_table.dart';
import 'package:brims/database/tables/profiling/address_table.dart';
import 'package:brims/database/tables/profiling/profiling_lookup_table.dart';
import 'package:drift/drift.dart';

@DataClassName('PersonData')
class Persons extends Table {
  IntColumn get person_id => integer().autoIncrement()();
  TextColumn get last_name => text()();
  TextColumn get first_name => text()();
  TextColumn get middle_name => text().nullable()();
  TextColumn get suffix => text().nullable()();
  TextColumn get sex => textEnum<Sex>().nullable()();
  IntColumn get age => integer().nullable()();
  DateTimeColumn get birth_date => dateTime().nullable()();
  TextColumn get birth_place => text().nullable()();
  TextColumn get civil_status => textEnum<CivilStatus>().nullable()();
  IntColumn get religion_id =>
      integer().nullable().references(
        Religions,
        #religion_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get nationality_id =>
      integer().nullable().references(
        Nationalities,
        #nationality_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get ethnicity_id =>
      integer().nullable().references(
        Ethnicities,
        #ethnicity_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get blood_type_id =>
      integer().nullable().references(
        BloodTypes,
        #blood_type_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get household_id =>
      integer().nullable().references(
        Households,
        #household_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get address_id =>
      integer().nullable().references(
        Addresses,
        #address_id,
        onDelete: KeyAction.restrict,
      )();
  TextColumn get registration_place => text().nullable()();
  TextColumn get residency => textEnum<Residency>().nullable()();
  IntColumn get years_of_residency => integer().nullable()();
  TextColumn get transient_type => textEnum<Transient>().nullable()();
  IntColumn get monthly_income_id =>
      integer().nullable().references(
        MonthlyIncomes,
        #monthly_income_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get daily_income_id =>
      integer().nullable().references(
        DailyIncomes,
        #daily_income_id,
        onDelete: KeyAction.restrict,
      )();
  TextColumn get solo_parent => textEnum<SoloParent>().nullable()();
  BoolColumn get ofw => boolean().nullable()();
  BoolColumn get literate => boolean().nullable()();
  BoolColumn get pwd => boolean().nullable()();
  BoolColumn get registered_voter => boolean().nullable()();
  TextColumn get currently_enrolled =>
      textEnum<CurrentlyEnrolled>().nullable()();
  IntColumn get education_id =>
      integer().nullable().references(
        Education,
        #education_id,
        onDelete: KeyAction.restrict,
      )();
  BoolColumn get deceased => boolean().nullable()();
  DateTimeColumn get death_date => dateTime().nullable()();
  DateTimeColumn get registration_date => dateTime().nullable()();
  TextColumn get registration_status => textEnum<RegistrationStatus>()();
}
