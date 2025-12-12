import 'dart:io';
import 'package:brims/database/tables/farming/farming_table.dart';
import 'package:brims/database/tables/household/household_table.dart';
import 'package:brims/database/tables/household/household_visit_table.dart';
import 'package:brims/database/tables/lookups/farming_lookup_table.dart';
import 'package:brims/database/tables/lookups/medinfo_lookup_table.dart';
import 'package:brims/database/tables/lookups/question_lookup_table.dart';
import 'package:brims/database/tables/medical/medical_info_table.dart';
import 'package:brims/database/tables/profiling/address_table.dart';
import 'package:brims/database/tables/profiling/citizen_registry_table.dart';
import 'package:brims/database/tables/profiling/contact_info_table.dart';
import 'package:brims/database/tables/profiling/occupations_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:brims/database/tables/lookups/household_lookup_tables.dart';
import 'package:brims/database/tables/lookups/profiling_lookup_table.dart';
import 'package:brims/database/tables/profiling/transient_table.dart';
import 'package:brims/database/tables/barangay/barangay_table.dart';
import 'package:brims/database/tables/login credentials/login_table.dart';
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
    Occupations,
    Emails,
    PhoneNumbers,
    Gadgets,
    VoterRegistries,
    RegisteredSeniors,
    Disabilities,
    Enrolled,
    CTCRecords,
    BrgyHistories,
    BuildingTypes,
    MigrantTransients,
    HouseholdRelationships,
    RelationshipTypes,
    Services,
    PrimaryNeeds,
    FemaleMortalities,
    ChildMortalities,
    FutureResidencies,
    DeliveryPlaces,
    AssistedPersons,
    VisitReasons,
    FpSources,
    FpMethods,
    Fishing,
    Agriculture,
    Livestock,
    LivestockProducts,
    FishingProducts,
    AgriProducts,
    Questions,
    QuestionChoices,
    HouseholdResponses,
    FamilyPlanning,
    MaternalInformation,
    VisitedFacilities,
    HealthInsurances,
    NewbornInformation,
    BarangayInfos,
    BarangayOfficials,
    LoginCredentials,
    HouseholdVisits,
    HouseholdMembers,
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
