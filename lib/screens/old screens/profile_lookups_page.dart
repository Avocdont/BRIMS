import 'package:brims/database/app_db.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

class ProfileLookups extends StatefulWidget {
  const ProfileLookups({super.key});

  @override
  State<ProfileLookups> createState() => _ProfileLookupsState();
}

class _ProfileLookupsState extends State<ProfileLookups> {
  @override
  void initState() {
    super.initState();

    // Load all lookup data when the screen opens
    final lookupProvider = context.read<ProfileLookupProvider>();
    lookupProvider.loadAllLookups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ProfileLookupProvider>(
        builder: (_, lookupProvider, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text("Nationality").h4,
                SizedBox(height: 10),
                LookupTable<NationalityData>(
                  columns: ["Name"],
                  items:
                      lookupProvider.allNationalities, // A list of NationalData
                  // Extract certain fields from each item
                  buildRow: (item) => [item.name],
                  onEdit: (item, newValues) {
                    // Change item(NationalityData) to NationalitiesCompanion and store in companion
                    final companion = item.toCompanion(true);
                    // Copy all values from companion such as id + add the updated value
                    final updated = companion.copyWith(
                      name: db.Value(newValues[0]),
                    );

                    lookupProvider.updateNationality(updated);
                  },
                  onDelete:
                      (item) =>
                          lookupProvider.deleteNationality(item.nationality_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
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
                SizedBox(height: 10),
                Text("Ethnicity").h4,
                LookupTable<EthnicityData>(
                  columns: ["Name"],
                  items: lookupProvider.allEthnicities,
                  buildRow: (item) => [item.name],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      name: db.Value(newValues[0]),
                    );

                    lookupProvider.updateEthnicity(updated);
                  },
                  onDelete:
                      (item) =>
                          lookupProvider.deleteEthnicity(item.ethnicity_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Name'], // Columns for this table
                            onInsert: (values) async {
                              final companion = EthnicitiesCompanion(
                                name: db.Value(values[0]),
                              );
                              await lookupProvider.addEthnicity(companion);
                              setState(() {}); // refresh table // Refresh table
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Religion").h4,
                LookupTable<ReligionData>(
                  columns: ["Name"],
                  items: lookupProvider.allReligions,
                  buildRow: (item) => [item.name],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      name: db.Value(newValues[0]),
                    );

                    lookupProvider.updateReligion(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteReligion(item.religion_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Name'],
                            onInsert: (values) async {
                              final companion = ReligionsCompanion(
                                name: db.Value(values[0]),
                              );
                              await lookupProvider.addReligion(companion);
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Education").h4,
                LookupTable<EducationData>(
                  columns: ["Level"],
                  items: lookupProvider.allEducation,
                  buildRow: (item) => [item.level],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      level: db.Value(newValues[0]),
                    );

                    lookupProvider.updateEducation(updated);
                  },
                  onDelete:
                      (item) =>
                          lookupProvider.deleteEducation(item.education_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Level'],
                            onInsert: (values) async {
                              final companion = EducationCompanion(
                                level: db.Value(values[0]),
                              );
                              await lookupProvider.addEducation(companion);
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Blood Type").h4,
                LookupTable<BloodTypeData>(
                  columns: ["Type"],
                  items: lookupProvider.allBloodTypes,
                  buildRow: (item) => [item.type],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      type: db.Value(newValues[0]),
                    );

                    lookupProvider.updateBloodType(updated);
                  },
                  onDelete:
                      (item) =>
                          lookupProvider.deleteBloodType(item.blood_type_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Type'],
                            onInsert: (values) async {
                              final companion = BloodTypesCompanion(
                                type: db.Value(values[0]),
                              );
                              await lookupProvider.addBloodType(companion);
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Monthly Income").h4,
                LookupTable<MonthlyIncomeData>(
                  columns: ["Range"],
                  items: lookupProvider.allMonthlyIncomes,
                  buildRow: (item) => [item.range],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      range: db.Value(newValues[0]),
                    );

                    lookupProvider.updateMonthlyIncome(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteMonthlyIncome(
                        item.monthly_income_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Range'],
                            onInsert: (values) async {
                              final companion = MonthlyIncomesCompanion(
                                range: db.Value(values[0]),
                              );
                              await lookupProvider.addMonthlyIncome(companion);
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 10),
                Text("Daily Income").h4,
                LookupTable<DailyIncomeData>(
                  columns: ["Range"],
                  items: lookupProvider.allDailyIncomes,
                  buildRow: (item) => [item.range],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      range: db.Value(newValues[0]),
                    );

                    lookupProvider.updateDailyIncome(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteDailyIncome(
                        item.daily_income_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Range'],
                            onInsert: (values) async {
                              final companion = DailyIncomesCompanion(
                                range: db.Value(values[0]),
                              );
                              await lookupProvider.addDailyIncome(companion);
                              setState(() {});
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
