import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:drift/drift.dart';

@DataClassName('BarangayInfoData')
class BarangayInfos extends Table {
  IntColumn get brgy_info_id => integer().autoIncrement()();
  TextColumn get brgy_name => text()();
  TextColumn get brgy_code => text().nullable()();
  IntColumn get population => integer().nullable()();
  RealColumn get land_area => real().nullable()();
}

@DataClassName('BarangayOfficialData')
class BarangayOfficials extends Table {
  IntColumn get brgy_official_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get brgy_position => textEnum<BarangayPositions>()();
  DateTimeColumn get start_date => dateTime().nullable()();
  DateTimeColumn get end_date => dateTime().nullable()();
  BoolColumn get is_current => boolean().nullable()();
}
