import 'package:brims/locator.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:brims/screens/add_person_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

import 'provider/household providers/household_lookup_provider.dart';

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
        ChangeNotifierProvider<ProfileLookupProvider>(
          create: (_) => ProfileLookupProvider(),
        ),
        ChangeNotifierProvider<HouseholdLookupProvider>(
          create: (_) => HouseholdLookupProvider(),
        ),
      ],
      child: scn.ShadcnApp(
        theme: scn.ThemeData(
          colorScheme: scn.ColorSchemes.darkBlue(),
          radius: 0.5,
        ),
        home: AddPersonPage(),
      ),
    );
  }
}
