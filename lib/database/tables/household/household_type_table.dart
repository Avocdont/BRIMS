import 'package:drift/drift.dart';

@DataClassName('HouseholdTypeData')
class HouseholdTypes extends Table {
  IntColumn get household_type_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
