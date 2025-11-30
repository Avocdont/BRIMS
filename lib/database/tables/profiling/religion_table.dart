import 'package:drift/drift.dart';

@DataClassName('ReligionData')
class Religions extends Table {
  IntColumn get religion_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
