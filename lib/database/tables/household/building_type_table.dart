import 'package:drift/drift.dart';

class BuildingTypes extends Table {
  IntColumn get building_type_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
