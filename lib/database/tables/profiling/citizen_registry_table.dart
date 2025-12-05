import 'package:brims/database/tables/lookups/profiling_lookup_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:drift/drift.dart';

@DataClassName('VoterRegistryData')
class VoterRegistries extends Table {
  IntColumn get voter_registry_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get place_of_vote_registry => text()();
}

@DataClassName('RegisteredSeniorData')
class RegisteredSeniors extends Table {
  IntColumn get registered_senior_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
}

@DataClassName('DisabilityData')
class Disabilities extends Table {
  IntColumn get disability_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get type => text().nullable()();
}

@DataClassName('EnrolledData')
class Enrolled extends Table {
  IntColumn get enrolled_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get school => text()();
  IntColumn get education_id =>
      integer().references(
        Education,
        #education_id,
        onDelete: KeyAction.cascade,
      )();
}

@DataClassName('CTCRecordData')
class CTCRecords extends Table {
  IntColumn get ctc_record_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get issue_num => integer()();
  TextColumn get place_of_issue => text().nullable()();
  DateTimeColumn get date_of_issue => dateTime().nullable()();
}
