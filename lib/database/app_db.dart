import 'dart:io';
import 'package:brims/database/tables/household/household_table.dart';
import 'package:brims/database/tables/household/household_type_table.dart';
import 'package:brims/database/tables/household/building_type_table.dart';
import 'package:brims/database/tables/household/ownership_type_table.dart';
import 'package:brims/database/tables/profiling/address_table.dart';
import 'package:brims/database/tables/profiling/blood_type_table.dart';
import 'package:brims/database/tables/profiling/daily_income_table.dart';
import 'package:brims/database/tables/profiling/education_table.dart';
import 'package:brims/database/tables/profiling/ethnicity_table.dart';
import 'package:brims/database/tables/profiling/monthly_income_table.dart';
import 'package:brims/database/tables/profiling/nationality_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:brims/database/tables/profiling/religion_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:brims/database/tables/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'app_db.g.dart';

@DriftDatabase(
  tables: [
    Persons,
    Households,
    Addresses,
    Nationalities,
    Religions,
    BloodTypes,
    Ethnicities,
    Education,
    MonthlyIncomes,
    DailyIncomes,
    Households,
    HouseholdTypes,
    BuildingTypes,
    OwnershipTypes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Windows, Linux, macOS, Android, iOS — works everywhere
    final dir = await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.path, 'brims.db'));
    return NativeDatabase.createInBackground(file);
  });
}
