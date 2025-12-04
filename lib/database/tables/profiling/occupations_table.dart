import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:drift/drift.dart';

@DataClassName('OccupationData')
class Occupations extends Table {
  IntColumn get occupation_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get occupation => text()();
  TextColumn get occupation_type => textEnum<OccupationType>().nullable()();
  TextColumn get occupation_status => textEnum<OccupationStatus>().nullable()();
  TextColumn get place => text().nullable()();
}
