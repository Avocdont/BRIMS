import 'package:drift/drift.dart';

class Ethnicities extends Table {
  IntColumn get ethnicity_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
