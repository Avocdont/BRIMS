/*import 'package:flutter/material.dart';
//import 'package:drift/drift.dart' as db;
//import 'package:provider/provider.dart';
//import 'package:brims/database/app_db.dart';
//import 'package:brims/database/tables/enums.dart';
//import 'package:brims/provider/person_provider.dart';
//import 'package:brims/repository/person_repository.dart';

class TestScreenPerson extends StatefulWidget {
  final PersonData? pd;
  const TestScreenPerson({super.key, this.pd});

  @override
  State<TestScreenPerson> createState() => _TestScreenPersonState();
}

class _TestScreenPersonState extends State<TestScreenPerson> {
  TextEditingController _lastNameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Builder(
          builder: (context) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Last Name", style: TextStyle(fontWeight: FontWeight.w200)),
                  SizedBox(height: 4),
                  TextField(controller: _lastNameController),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}*/
