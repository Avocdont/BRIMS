import 'package:brims/database/tables/enums.dart';
import 'package:drift/drift.dart';
import 'package:brims/database/tables/profiling/person_table.dart';

@DataClassName('MigrantTransientData')
class MigrantTransients extends Table {
  IntColumn get migrant_transient_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get type => textEnum<Transient>().nullable()();
  TextColumn get reason_of_leaving => text().nullable()();
  TextColumn get reason_of_transfer => text().nullable()();
  IntColumn get stay_duration => integer().nullable()();
}
