import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:flutter/material.dart' hide RadioGroup;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

import 'package:brims/screens/main_page.dart';

// --- Import All Providers ---
// Profiling
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:brims/provider/profiling%20providers/profile_provider.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:brims/provider/profiling%20providers/citizen_registry_provider.dart';
import 'package:brims/provider/profiling%20providers/occupation_provider.dart';
import 'package:brims/provider/profiling%20providers/contact_info_provider.dart';
import 'package:brims/provider/profiling%20providers/transient_provider.dart';

// Household
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';

// Medical
import 'package:brims/provider/medical%20providers/medical_info_provider.dart';
import 'package:brims/provider/medical%20providers/medinfo_lookup_provider.dart';

// Farming & Others
import 'package:brims/provider/lookup%20providers/farming_lookup_provider.dart';
import 'package:brims/provider/lookup%20providers/question_lookup_provider.dart';

void main() async {
  setUp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- Profiling Providers ---
        ChangeNotifierProvider<PersonProvider>(create: (_) => PersonProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
        ChangeNotifierProvider<ProfileLookupProvider>(
            create: (_) => ProfileLookupProvider()),
        ChangeNotifierProvider<CitizenRegistryProvider>(
            create: (_) => CitizenRegistryProvider()),
        ChangeNotifierProvider<OccupationProvider>(
            create: (_) => OccupationProvider()),
        ChangeNotifierProvider<ContactInfoProvider>(
            create: (_) => ContactInfoProvider()),
        ChangeNotifierProvider<MigrantTransientProvider>(
            create: (_) => MigrantTransientProvider()),

        // --- Household Providers ---
        ChangeNotifierProvider<HouseholdProvider>(
            create: (_) => HouseholdProvider()),
        ChangeNotifierProvider<HouseholdLookupProvider>(
            create: (_) => HouseholdLookupProvider()),

        // --- Medical Providers ---
        ChangeNotifierProvider<MedicalInfoProvider>(
            create: (_) => MedicalInfoProvider()),
        ChangeNotifierProvider<MedInfoLookupProvider>(
            create: (_) => MedInfoLookupProvider()),

        // --- Farming & Other Providers ---
        ChangeNotifierProvider<FarmingLookupProvider>(
            create: (_) => FarmingLookupProvider()),
        ChangeNotifierProvider<QuestionLookupProvider>(
            create: (_) => QuestionLookupProvider()),
      ],
      child: scn.ShadcnApp(
        title: 'BRIMS',
        debugShowCheckedModeBanner: false,
        theme: scn.ThemeData(
          colorScheme: scn.ColorSchemes.darkGreen,
          radius: 0.5,
        ),
        home: const MainPage(),
      ),
    );
  }
}
