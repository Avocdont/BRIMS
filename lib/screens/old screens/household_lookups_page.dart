import 'package:brims/database/app_db.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart' hide RadioGroup;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

class HouseholdLookups extends StatefulWidget {
  const HouseholdLookups({super.key});

  @override
  State<HouseholdLookups> createState() => _HouseholdLookupsState();
}

class _HouseholdLookupsState extends State<HouseholdLookups> {
  @override
  void initState() {
    super.initState();

    // Load all lookup data when the screen opens
    final lookupProvider = context.read<HouseholdLookupProvider>();
    lookupProvider.loadAllLookups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<HouseholdLookupProvider>(
        builder: (_, lookupProvider, __) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  // ------------ Building Types ------------
                  Text("Building Types").h4,
                  LookupTable<BuildingTypeData>(
                    columns: ["Type"],
                    items: lookupProvider.allBuildingTypes,
                    buildRow: (item) => [item.type],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        type: db.Value(newValues[0]),
                      );
                      lookupProvider.updateBuildingType(updated);
                    },
                    onDelete: (item) => lookupProvider.deleteBuildingType(
                      item.building_type_id,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AddLookup(
                          columns: ['Type'],
                          onInsert: (values) async {
                            final companion = BuildingTypesCompanion(
                              type: db.Value(values[0]),
                            );
                            await lookupProvider.addBuildingType(companion);
                            setState(() {});
                          },
                        ),
                      );
                    },
                    child: const Text("Add"),
                  ),
                  SizedBox(height: 15),

                  // ------------ Relationship Types ------------
                  Text("Relationship Types").h4,
                  LookupTable<RelationshipTypeData>(
                    columns: ["Relationship"],
                    items: lookupProvider.allRelationshipTypes,
                    buildRow: (item) => [item.relationship],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        relationship: db.Value(newValues[0]),
                      );
                      lookupProvider.updateRelationshipType(updated);
                    },
                    onDelete: (item) => lookupProvider.deleteRelationshipType(
                      item.relationship_id,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AddLookup(
                          columns: ['Relationship'],
                          onInsert: (values) async {
                            final companion = RelationshipTypesCompanion(
                              relationship: db.Value(values[0]),
                            );
                            await lookupProvider.addRelationshipType(
                              companion,
                            );
                            setState(() {});
                          },
                        ),
                      );
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
