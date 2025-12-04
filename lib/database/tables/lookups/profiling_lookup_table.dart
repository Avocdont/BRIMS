import 'package:drift/drift.dart';

@DataClassName('ReligionData')
class Religions extends Table {
  IntColumn get religion_id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('NationalityData')
class Nationalities extends Table {
  IntColumn get nationality_id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('EthnicityData')
class Ethnicities extends Table {
  IntColumn get ethnicity_id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('BloodTypeData')
class BloodTypes extends Table {
  IntColumn get blood_type_id => integer().autoIncrement()();
  TextColumn get type => text()();
}

@DataClassName('MonthlyIncomeData')
class MonthlyIncomes extends Table {
  IntColumn get monthly_income_id => integer().autoIncrement()();
  TextColumn get range => text()();
}

@DataClassName('DailyIncomeData')
class DailyIncomes extends Table {
  IntColumn get daily_income_id => integer().autoIncrement()();
  TextColumn get range => text()();
}

@DataClassName('EducationData')
class Education extends Table {
  IntColumn get education_id => integer().autoIncrement()();
  TextColumn get level => text()();
}
