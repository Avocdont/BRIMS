import 'package:drift/drift.dart';
import 'package:brims/database/tables/profiling/person_table.dart';

@DataClassName('AddressData')
class Addresses extends Table {
  IntColumn get address_id => integer().autoIncrement()();
  TextColumn get zone => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get block => text().nullable()();
  TextColumn get lot => text().nullable()();
}

@DataClassName('BrgyHistoryData')
class BrgyHistories extends Table {
  IntColumn get disability_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  DateTimeColumn get start_date => dateTime().nullable()();
  DateTimeColumn get end_date => dateTime().nullable()();
  TextColumn get brgy => text()();
}
