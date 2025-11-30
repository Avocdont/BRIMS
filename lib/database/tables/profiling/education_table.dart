import 'package:drift/drift.dart';

@DataClassName('EducationData')
class Education extends Table {
  IntColumn get education_id => integer().autoIncrement()();
  TextColumn get level => text()();
}
