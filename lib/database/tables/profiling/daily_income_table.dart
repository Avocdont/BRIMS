import 'package:drift/drift.dart';

@DataClassName('DailyIncomeData')
class DailyIncomes extends Table {
  IntColumn get daily_income_id => integer().autoIncrement()();
  TextColumn get range => text()();
}
