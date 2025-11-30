import 'package:drift/drift.dart';

class MonthlyIncomes extends Table {
  IntColumn get monthly_income_id => integer().autoIncrement()();
  TextColumn get range => text()();
}
