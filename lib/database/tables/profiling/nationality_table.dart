import 'package:drift/drift.dart';

@DataClassName('NationalityData')
class Nationalities extends Table {
  IntColumn get nationality_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
