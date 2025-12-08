import 'package:brims/database/app_db.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/screens/add_person_page.dart';
import 'package:brims/screens/old%20screens/household_lookups_page.dart';
import 'package:brims/screens/old%20screens/medinfo_lookups_page.dart';
import 'package:brims/screens/old%20screens/profile_lookups_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewLookupPage extends StatefulWidget {
  const ViewLookupPage({super.key});

  @override
  State<ViewLookupPage> createState() => _ViewLookupPageState();
}

class _ViewLookupPageState extends State<ViewLookupPage> {
  @override
  void initState() {
    super.initState();

    // You can load data here if needed, e.g.:
    // context.read<HouseholdProvider>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final lookupProvider =
        context.watch<HouseholdProvider>(); // <- watch to rebuild on changes

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileLookups()),
                  ),
              child: Text("View Profile Lookups"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HouseholdLookups()),
                  ),
              child: Text("View Household Lookups"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MedInfoLookups()),
                  ),
              child: Text("View Med Info Lookups"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddPersonPage()),
                  ),
              child: Text("Add Person"),
            ),
            // Wrap ListView in Expanded so it works inside Column
            Expanded(
              child: ListView.builder(
                itemCount: lookupProvider.allAddresses.length,
                itemBuilder: (_, index) {
                  final address = lookupProvider.allAddresses[index];
                  return Column(
                    children: [
                      Text(address.address_id.toString() ?? 'No block'),
                      Text(address.zone ?? 'No block'),
                      Text(address.street ?? 'No block'),
                      Text(address.block ?? 'No block'),
                      Text(address.lot ?? 'No block'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
