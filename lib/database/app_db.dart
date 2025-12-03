import 'dart:io';
import 'package:brims/database/tables/household/household_table.dart';
import 'package:brims/database/tables/profiling/address_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:brims/database/tables/household/household_lookup_table.dart';
import 'package:brims/database/tables/profiling/profiling_lookup_table.dart';
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
    final dbDir = Directory(r'C:\BarangaySystemData');

    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    final file = File(path.join(dbDir.path, 'app.db'));

    return NativeDatabase.createInBackground(file);
  });
}
