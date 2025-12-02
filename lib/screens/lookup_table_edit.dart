import 'package:brims/database/app_db.dart';
import 'package:brims/provider/lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LookupTableEdit extends StatefulWidget {
  const LookupTableEdit({super.key});

  @override
  State<LookupTableEdit> createState() => _LookupTableEditState();
}

class _LookupTableEditState extends State<LookupTableEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LookupProvider>(
        builder: (_, lookupProvider, _) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AddRowDialog(
                          columns: ['Name'], // Columns for this table
                          onInsert: (values) async {
                            final companion = NationalitiesCompanion(
                              name: db.Value(values[0]),
                            );
                            await lookupProvider.addNationality(companion);
                            setState(() {}); // refresh table // Refresh table
                          },
                        ),
                  );
                },
                child: const Text("Add"),
              ),
              Container(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Text(lookupProvider.allNationalities[index].name);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
