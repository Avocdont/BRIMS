import 'package:brims/database/app_db.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

import '../provider/household providers/household_lookup_provider.dart';

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
        builder: (_, lookupProvider, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text("Household Types").h4,
                SizedBox(height: 10),
                LookupTable<HouseholdTypeData>(
                  columns: ["Type"],
                  items:
                      lookupProvider
                          .allHouseholdTypes, // A list of HouseholdTypeData
                  // Extract certain fields from each item
                  buildRow: (item) => [item.type],
                  onEdit: (item, newValues) {
                    // Change item(NationalityData) to NationalitiesCompanion and store in companion
                    final companion = item.toCompanion(true);
                    // Copy all values from companion such as id + add the updated value
                    final updated = companion.copyWith(
                      // id : db.Value(1)
                      type: db.Value(newValues[0]),
                    );

                    lookupProvider.updateHouseholdType(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteHouseholdType(
                        item.household_type_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Type'], // Columns for this table
                            onInsert: (values) async {
                              final companion = HouseholdTypesCompanion(
                                type: db.Value(values[0]),
                              );
                              await lookupProvider.addHouseholdType(companion);
                              setState(() {}); // refresh table // Refresh table
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Building types").h4,
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
                  onDelete:
                      (item) => lookupProvider.deleteBuildingType(
                        item.building_type_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Type'], // Columns for this table
                            onInsert: (values) async {
                              final companion = BuildingTypesCompanion(
                                type: db.Value(values[0]),
                              );
                              await lookupProvider.addBuildingType(companion);
                              setState(() {}); // refresh table // Refresh table
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Ownership types").h4,
                LookupTable<OwnershipTypeData>(
                  columns: ["Type"],
                  items: lookupProvider.allOwnershipTypes,
                  buildRow: (item) => [item.type],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      type: db.Value(newValues[0]),
                    );

                    lookupProvider.updateOwnershipType(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteOwnershipType(
                        item.ownership_type_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Type'], // Columns for this table
                            onInsert: (values) async {
                              final companion = OwnershipTypesCompanion(
                                type: db.Value(values[0]),
                              );
                              await lookupProvider.addOwnershipType(companion);
                              setState(() {}); // refresh table // Refresh table
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
