import 'package:drift/drift.dart';

class Education extends Table {
  IntColumn get education_id => integer().autoIncrement()();
  TextColumn get level => text()();
}
