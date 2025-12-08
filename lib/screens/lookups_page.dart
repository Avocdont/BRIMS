import 'package:brims/screens/old%20screens/farming_lookups_page.dart';
import 'package:brims/screens/old%20screens/household_lookups_page.dart';
import 'package:brims/screens/old%20screens/medinfo_lookups_page.dart';
import 'package:brims/screens/old%20screens/profile_lookups_page.dart';
import 'package:brims/screens/old%20screens/question_lookups_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:brims/provider/profiling providers/profile_lookup_provider.dart';
import 'package:brims/provider/household providers/household_lookup_provider.dart';
import 'package:brims/provider/medical providers/medinfo_lookup_provider.dart';
import 'package:brims/provider/lookup providers/farming_lookup_provider.dart';
import 'package:brims/provider/lookup providers/question_lookup_provider.dart';

class LookupsPage extends StatefulWidget {
  const LookupsPage({super.key});

  @override
  State<LookupsPage> createState() => _LookupsPageState();
}

class _LookupsPageState extends State<LookupsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileLookupProvider()),
        ChangeNotifierProvider(create: (_) => HouseholdLookupProvider()),
        ChangeNotifierProvider(create: (_) => MedInfoLookupProvider()),
        ChangeNotifierProvider(create: (_) => FarmingLookupProvider()),
        ChangeNotifierProvider(create: (_) => QuestionLookupProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Lookups")),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLookupBox("Profile Lookups", const ProfileLookups()),
            _buildLookupBox("Household Lookups", const HouseholdLookups()),
            _buildLookupBox("Medical Info Lookups", const MedInfoLookups()),
            _buildLookupBox("Farming Lookups", const FarmingLookups()),
            _buildLookupBox("Question Lookups", const QuestionLookups()),
          ],
        ),
      ),
    );
  }

  Widget _buildLookupBox(String title, Widget child) {
    return Center(
      child: Container(
        width: 400,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            SizedBox(
              height: 250,
              child: Padding(padding: const EdgeInsets.all(12.0), child: child),
            ),
          ],
        ),
      ),
    );
  }
}
