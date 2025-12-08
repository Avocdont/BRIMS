import 'package:flutter/material.dart';

class ViewHouseholdPage extends StatelessWidget {
  final int householdId;

  const ViewHouseholdPage({super.key, required this.householdId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Household #$householdId")),
      body: Center(child: Text("Details for Household ID: $householdId")),
    );
  }
}
