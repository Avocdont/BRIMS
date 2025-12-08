import 'package:flutter/material.dart';

class ViewPersonDetailsPage extends StatelessWidget {
  final int personId;

  const ViewPersonDetailsPage({super.key, required this.personId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Person Details")),
      body: Center(child: Text("Details for Person ID: $personId")),
    );
  }
}
