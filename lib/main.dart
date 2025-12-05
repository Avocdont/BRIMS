import 'package:brims/locator.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/citizen_registry_provider.dart';
import 'package:brims/provider/profiling%20providers/contact_info_provider.dart';
import 'package:brims/provider/profiling%20providers/occupation_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:brims/screens/add_person_page.dart';
import 'package:brims/screens/view_lookup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

import 'provider/household providers/household_lookup_provider.dart';
import 'provider/profiling providers/transient_provider.dart';

void main() {
  runApp(const MainApp());
  setUp();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonProvider>(create: (_) => PersonProvider()),
        ChangeNotifierProvider<ProfileLookupProvider>(
          create: (_) => ProfileLookupProvider(),
        ),
        ChangeNotifierProvider<HouseholdProvider>(
          create: (_) => HouseholdProvider(),
        ),
        ChangeNotifierProvider<HouseholdLookupProvider>(
          create: (_) => HouseholdLookupProvider(),
        ),
        ChangeNotifierProvider<CitizenRegistryProvider>(
          create: (_) => CitizenRegistryProvider(),
        ),
        ChangeNotifierProvider<OccupationProvider>(
          create: (_) => OccupationProvider(),
        ),
        ChangeNotifierProvider<MigrantTransientProvider>(
          create: (_) => MigrantTransientProvider(),
        ),
        ChangeNotifierProvider<ContactInfoProvider>(
          create: (_) => ContactInfoProvider(),
        ),
      ],
      child: scn.ShadcnApp(
        theme: scn.ThemeData(
          colorScheme: scn.ColorSchemes.darkBlue(),
          radius: 0.5,
        ),
        home: ViewLookupPage(),
      ),
    );
  }
}
