import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/household/household_table.dart';
import 'package:drift/drift.dart';

@DataClassName('HouseholdVisitData')
class HouseholdVisits extends Table {
  IntColumn get household_visit_id => integer().autoIncrement()();
  IntColumn get household_id =>
      integer().references(
        Households,
        #household_id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get visit_num => integer().nullable()();
  TextColumn get brgy_position => textEnum<BarangayPositions>()();
  DateTimeColumn get visit_date => dateTime().nullable()();
}
