import 'package:drift/drift.dart';

@DataClassName('MonthlyIncomeData')
class MonthlyIncomes extends Table {
  IntColumn get monthly_income_id => integer().autoIncrement()();
  TextColumn get range => text()();
}
