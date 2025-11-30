import 'package:drift/drift.dart';

class DailyIncomes extends Table {
  IntColumn get daily_income_id => integer().autoIncrement()();
  TextColumn get range => text()();
}
