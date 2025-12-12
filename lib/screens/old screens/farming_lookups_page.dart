import 'package:brims/database/app_db.dart';
import 'package:brims/provider/lookup%20providers/farming_lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart' hide RadioGroup;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;
import 'package:google_fonts/google_fonts.dart';

class FarmingLookups extends StatefulWidget {
  const FarmingLookups({super.key});

  @override
  State<FarmingLookups> createState() => _FarmingLookupsState();
}

class _FarmingLookupsState extends State<FarmingLookups> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background (for Scaffold/padding)
  static const Color cardBackground =
      Color(0xFFFFFFFF); // White cards/table background
  static const Color navBackground = Color(0xFF40C4FF); // Primary blue
  static const Color navBackgroundDark =
      Color(0xFF29B6F6); // Darker accent/button
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
  static const Color secondaryText = Color(0xFF555555); // Secondary text
  static const Color dividerColor = Color(0xFFE0E0E0); // Light divider

  // --- Styles ---
  final ButtonStyle _primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: navBackgroundDark,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
  );

  final TextStyle _sectionTitleStyle = GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.bold, color: navBackgroundDark);

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
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Text("Farming Lookups",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [navBackground, navBackgroundDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Consumer<FarmingLookupProvider>(
        builder: (_, lookupProvider, __) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    // ------------ Agri Products ------------
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Agricultural Products",
                          style: _sectionTitleStyle),
                    ),
                    LookupTable<AgriProductData>(
                      columns: const ["Product Name"],
                      items: lookupProvider.allAgriProducts,
                      buildRow: (item) => [item.name],
                      onEdit: (item, newValues) {
                        final companion = item.toCompanion(true);
                        final updated = companion.copyWith(
                          name: db.Value(newValues[0]),
                        );
                        lookupProvider.updateAgriProduct(updated);
                      },
                      onDelete: (item) => lookupProvider.deleteAgriProduct(
                        item.agri_product_id,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddLookup(
                            columns: const ['Product Name'],
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
                      style: _primaryButtonStyle,
                      label: const Text("Add Agricultural Product"),
                    ),
                    const SizedBox(height: 40),

                    // ------------ Livestock Products ------------
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child:
                          Text("Livestock Products", style: _sectionTitleStyle),
                    ),
                    LookupTable<LivestockProductData>(
                      columns: const ["Product Name"],
                      items: lookupProvider.allLivestockProducts,
                      buildRow: (item) => [item.name],
                      onEdit: (item, newValues) {
                        final companion = item.toCompanion(true);
                        final updated = companion.copyWith(
                          name: db.Value(newValues[0]),
                        );
                        lookupProvider.updateLivestockProduct(updated);
                      },
                      onDelete: (item) => lookupProvider.deleteLivestockProduct(
                        item.livestock_product_id,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddLookup(
                            columns: const ['Product Name'],
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
                      style: _primaryButtonStyle,
                      label: const Text("Add Livestock Product"),
                    ),
                    const SizedBox(height: 40),

                    // ------------ Fishing Products ------------
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child:
                          Text("Fishing Products", style: _sectionTitleStyle),
                    ),
                    LookupTable<FishingProductData>(
                      columns: const ["Product Name"],
                      items: lookupProvider.allFishingProducts,
                      buildRow: (item) => [item.name],
                      onEdit: (item, newValues) {
                        final companion = item.toCompanion(true);
                        final updated = companion.copyWith(
                          name: db.Value(newValues[0]),
                        );
                        lookupProvider.updateFishingProduct(updated);
                      },
                      onDelete: (item) => lookupProvider.deleteFishingProduct(
                        item.fishing_product_id,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddLookup(
                            columns: const ['Product Name'],
                            onInsert: (values) async {
                              final companion = FishingProductsCompanion(
                                name: db.Value(values[0]),
                              );
                              await lookupProvider.addFishingProduct(
                                companion,
                              );
                              setState(() {});
                            },
                          ),
                        );
                      },
                      style: _primaryButtonStyle,
                      label: const Text("Add Fishing Product"),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
