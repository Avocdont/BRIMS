import 'package:drift/drift.dart';

class BloodTypes extends Table {
  IntColumn get blood_type_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
