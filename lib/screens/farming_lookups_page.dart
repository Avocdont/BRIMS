import 'package:brims/database/app_db.dart';
import 'package:brims/provider/lookup%20providers/farming_lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

class FarmingLookups extends StatefulWidget {
  const FarmingLookups({super.key});

  @override
  State<FarmingLookups> createState() => _FarmingLookupsState();
}

class _FarmingLookupsState extends State<FarmingLookups> {
  @override
  void initState() {
    super.initState();

    // Load all lookup data when the screen opens
    final lookupProvider = context.read<FarmingLookupProvider>();
    lookupProvider.loadAllLookups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FarmingLookupProvider>(
        builder: (_, lookupProvider, __) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // ------------ Agri Products ------------
                Text("Agricultural Products").h4,
                LookupTable<AgriProductData>(
                  columns: ["Product Name"],
                  items: lookupProvider.allAgriProducts,
                  buildRow: (item) => [item.name],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      name: db.Value(newValues[0]),
                    );
                    lookupProvider.updateAgriProduct(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteAgriProduct(
                        item.agri_product_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Product Name'],
                            onInsert: (values) async {
                              final companion = AgriProductsCompanion(
                                name: db.Value(values[0]),
                              );
                              await lookupProvider.addAgriProduct(companion);
                              setState(() {}); // refresh table
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 15),

                // ------------ Livestock Products ------------
                Text("Livestock Products").h4,
                LookupTable<LivestockProductData>(
                  columns: ["Product Name"],
                  items: lookupProvider.allLivestockProducts,
                  buildRow: (item) => [item.name],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      name: db.Value(newValues[0]),
                    );
                    lookupProvider.updateLivestockProduct(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteLivestockProduct(
                        item.livestock_product_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Product Name'],
                            onInsert: (values) async {
                              final companion = LivestockProductsCompanion(
                                name: db.Value(values[0]),
                              );
                              await lookupProvider.addLivestockProduct(
                                companion,
                              );
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 15),

                // ------------ Fishing Products ------------
                Text("Fishing Products").h4,
                LookupTable<FishingProductData>(
                  columns: ["Product Name"],
                  items: lookupProvider.allFishingProducts,
                  buildRow: (item) => [item.name],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      name: db.Value(newValues[0]),
                    );
                    lookupProvider.updateFishingProduct(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteFishingProduct(
                        item.fishing_product_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Product Name'],
                            onInsert: (values) async {
                              final companion = FishingProductsCompanion(
                                name: db.Value(values[0]),
                              );
                              await lookupProvider.addFishingProduct(companion);
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
