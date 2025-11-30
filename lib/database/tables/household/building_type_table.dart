import 'package:drift/drift.dart';

@DataClassName('BuildingTypeData')
class BuildingTypes extends Table {
  IntColumn get building_type_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
