import 'package:drift/drift.dart';

@DataClassName('RelationshipTypeData')
class RelationshipTypes extends Table {
  IntColumn get relationship_id => integer().autoIncrement()();
  TextColumn get relationship => text()();
}

@DataClassName('BuildingTypeData')
class BuildingTypes extends Table {
  IntColumn get building_type_id => integer().autoIncrement()();
  TextColumn get type => text()();
}
