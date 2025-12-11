import 'package:brims/database/app_db.dart';
import 'package:brims/provider/medical%20providers/medinfo_lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart' hide RadioGroup;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

class MedInfoLookups extends StatefulWidget {
  const MedInfoLookups({super.key});

  @override
  State<MedInfoLookups> createState() => _MedInfoLookupsState();
}

class _MedInfoLookupsState extends State<MedInfoLookups> {
  @override
  void initState() {
    super.initState();

    // Load all lookup data when the screen opens
    final lookupProvider = context.read<MedInfoLookupProvider>();
    lookupProvider.loadAllLookups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MedInfoLookupProvider>(
        builder: (_, lookupProvider, __) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  Text("Place of Delivery").h4,
                  LookupTable<DeliveryPlaceData>(
                    columns: ["Places"],
                    items: lookupProvider.allDeliveryPlaces,
                    buildRow: (item) => [item.place],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        place: db.Value(newValues[0]),
                      );

                      lookupProvider.updateDeliveryPlace(updated);
                    },
                    onDelete:
                        (item) => lookupProvider.deleteDeliveryPlace(
                          item.delivery_place_id,
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AddLookup(
                              columns: ['Place'], // Columns for this table
                              onInsert: (values) async {
                                final companion = DeliveryPlacesCompanion(
                                  place: db.Value(values[0]),
                                );
                                await lookupProvider.addDeliveryPlace(
                                  companion,
                                );
                                setState(
                                  () {},
                                ); // refresh table // Refresh table
                              },
                            ),
                      );
                    },
                    child: const Text("Add"),
                  ),
                  SizedBox(height: 15), //AssistedPerson
                  Text("Persons who assisted in birth").h4,
                  LookupTable<AssistedPersonData>(
                    columns: ["People"],
                    items: lookupProvider.allAssistedPersons,
                    buildRow: (item) => [item.name],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        name: db.Value(newValues[0]),
                      );

                      lookupProvider.updateAssistedPerson(updated);
                    },
                    onDelete:
                        (item) => lookupProvider.deleteAssistedPerson(
                          item.assisted_person_id,
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AddLookup(
                              columns: ['People'], // Columns for this table
                              onInsert: (values) async {
                                final companion = AssistedPersonsCompanion(
                                  name: db.Value(values[0]),
                                );
                                await lookupProvider.addAssistedPerson(
                                  companion,
                                );
                                setState(
                                  () {},
                                ); // refresh table // Refresh table
                              },
                            ),
                      );
                    },
                    child: const Text("Add"),
                  ),
                  SizedBox(height: 15), //VisitReason
                  Text("Reason for visiting the facility").h4,
                  LookupTable<VisitReasonData>(
                    columns: ["Reasons"],
                    items: lookupProvider.allVisitReasons,
                    buildRow: (item) => [item.reason],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        reason: db.Value(newValues[0]),
                      );

                      lookupProvider.updateVisitReason(updated);
                    },
                    onDelete:
                        (item) => lookupProvider.deleteVisitReason(
                          item.visit_reason_id,
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AddLookup(
                              columns: ['Place'], // Columns for this table
                              onInsert: (values) async {
                                final companion = VisitReasonsCompanion(
                                  reason: db.Value(values[0]),
                                );
                                await lookupProvider.addVisitReason(companion);
                                setState(
                                  () {},
                                ); // refresh table // Refresh table
                              },
                            ),
                      );
                    },
                    child: const Text("Add"),
                  ),
                  SizedBox(height: 15), //Source of family planning
                  Text("Source of family planning").h4,
                  LookupTable<FpSourceData>(
                    columns: ["Source"],
                    items: lookupProvider.allFpSources,
                    buildRow: (item) => [item.source],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        source: db.Value(newValues[0]),
                      );

                      lookupProvider.updateFpSource(updated);
                    },
                    onDelete:
                        (item) =>
                            lookupProvider.deleteFpSource(item.fp_source_id),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AddLookup(
                              columns: ['Source'], // Columns for this table
                              onInsert: (values) async {
                                final companion = FpSourcesCompanion(
                                  source: db.Value(values[0]),
                                );
                                await lookupProvider.addFpSource(companion);
                                setState(
                                  () {},
                                ); // refresh table // Refresh table
                              },
                            ),
                      );
                    },
                    child: const Text("Add"),
                  ),
                  SizedBox(height: 15), //FP Methods
                  Text("Family planning").h4,
                  LookupTable<FpMethodData>(
                    columns: ["FP"],
                    items: lookupProvider.allFpMethods,
                    buildRow: (item) => [item.method],
                    onEdit: (item, newValues) {
                      final companion = item.toCompanion(true);
                      final updated = companion.copyWith(
                        method: db.Value(newValues[0]),
                      );

                      lookupProvider.updateFpMethod(updated);
                    },
                    onDelete:
                        (item) =>
                            lookupProvider.deleteFpMethod(item.fp_method_id),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AddLookup(
                              columns: ['FP'], // Columns for this table
                              onInsert: (values) async {
                                final companion = FpMethodsCompanion(
                                  method: db.Value(values[0]),
                                );
                                await lookupProvider.addFpMethod(companion);
                                setState(
                                  () {},
                                ); // refresh table // Refresh table
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
