import 'package:drift/drift.dart';

@DataClassName('HouseholdTypeData')
class HouseholdTypes extends Table {
  IntColumn get household_type_id => integer().autoIncrement()();
  TextColumn get type => text()();
}

@DataClassName('BuildingTypeData')
class BuildingTypes extends Table {
  IntColumn get building_type_id => integer().autoIncrement()();
  TextColumn get type => text()();
}

@DataClassName('OwnershipTypeData')
class OwnershipTypes extends Table {
  IntColumn get ownership_type_id => integer().autoIncrement()();
  TextColumn get type => text()();
}
