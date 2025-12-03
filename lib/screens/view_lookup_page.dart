import 'package:brims/screens/household_lookups.dart';
import 'package:brims/screens/profile_lookups.dart';
import 'package:flutter/material.dart';

class ViewLookupPage extends StatelessWidget {
  const ViewLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileLookups()),
                    ),
                  },
              child: Text("View Profile Lookups"),
            ),
            ElevatedButton(
              onPressed:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HouseholdLookups()),
                    ),
                  },
              child: Text("View Household Lookups"),
            ),
          ],
        ),
      ),
    );
  }
}
