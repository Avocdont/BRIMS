import 'package:brims/database/tables/enums.dart';
import 'package:brims/models/household_models.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HouseholdFilterDialog extends StatefulWidget {
  final HouseholdFilterOptions currentFilters;
  final Function(HouseholdFilterOptions) onApply;

  const HouseholdFilterDialog({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<HouseholdFilterDialog> createState() => _HouseholdFilterDialogState();
}

class _HouseholdFilterDialogState extends State<HouseholdFilterDialog> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray for unselected chips
  static const Color cardBackground =
      Color(0xFFFFFFFF); // White for dialog background
  static const Color navBackground =
      Color(0xFF40C4FF); // Primary blue for selected chips
  static const Color navBackgroundDark =
      Color(0xFF29B6F6); // Darker accent/button
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
  static const Color dividerColor = Color(0xFFE0E0E0); // Light divider

  // Local state for selections
  List<HouseholdTypes> _selectedHouseholdTypes = [];
  List<OwnershipTypes> _selectedOwnershipTypes = [];
  List<int> _selectedBuildingTypeIds = [];

  @override
  void initState() {
    super.initState();
    // Initialize with current values
    _selectedHouseholdTypes = List.from(widget.currentFilters.householdTypes);
    _selectedOwnershipTypes = List.from(widget.currentFilters.ownershipTypes);
    _selectedBuildingTypeIds = List.from(widget.currentFilters.buildingTypeIds);
  }

  @override
  Widget build(BuildContext context) {
    final lookupProvider = context.watch<HouseholdLookupProvider>();

    return AlertDialog(
      backgroundColor: cardBackground, // Set dialog background to white
      title: Text("Filter Households",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: navBackgroundDark)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500, // Explicit width for better dialog appearance
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Household Type"),
              Wrap(
                spacing: 8,
                children: HouseholdTypes.values.map((type) {
                  final isSelected = _selectedHouseholdTypes.contains(type);
                  return FilterChip(
                    label: Text(type.name,
                        style: GoogleFonts.poppins(
                            color: isSelected ? cardBackground : primaryText)),
                    selected: isSelected,
                    selectedColor: navBackground,
                    backgroundColor: primaryBackground,
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? _selectedHouseholdTypes.add(type)
                            : _selectedHouseholdTypes.remove(type);
                      });
                    },
                  );
                }).toList(),
              ),
              const Divider(height: 32, color: dividerColor),
              _buildSectionTitle("Ownership Type"),
              Wrap(
                spacing: 8,
                children: OwnershipTypes.values.map((type) {
                  final isSelected = _selectedOwnershipTypes.contains(type);
                  return FilterChip(
                    label: Text(type.name,
                        style: GoogleFonts.poppins(
                            color: isSelected ? cardBackground : primaryText)),
                    selected: isSelected,
                    selectedColor: navBackground,
                    backgroundColor: primaryBackground,
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? _selectedOwnershipTypes.add(type)
                            : _selectedOwnershipTypes.remove(type);
                      });
                    },
                  );
                }).toList(),
              ),
              const Divider(height: 32, color: dividerColor),
              _buildSectionTitle("Building Type"),
              Wrap(
                spacing: 8,
                children: lookupProvider.allBuildingTypes.map((b) {
                  final isSelected =
                      _selectedBuildingTypeIds.contains(b.building_type_id);
                  return FilterChip(
                    label: Text(b.type,
                        style: GoogleFonts.poppins(
                            color: isSelected ? cardBackground : primaryText)),
                    selected: isSelected,
                    selectedColor: navBackground,
                    backgroundColor: primaryBackground,
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? _selectedBuildingTypeIds.add(b.building_type_id)
                            : _selectedBuildingTypeIds
                                .remove(b.building_type_id);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Clear all
            setState(() {
              _selectedHouseholdTypes.clear();
              _selectedOwnershipTypes.clear();
              _selectedBuildingTypeIds.clear();
            });
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text("Reset",
              style: GoogleFonts.poppins(
                  color: Colors.red, fontWeight: FontWeight.w500)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(HouseholdFilterOptions(
              householdTypes: _selectedHouseholdTypes,
              ownershipTypes: _selectedOwnershipTypes,
              buildingTypeIds: _selectedBuildingTypeIds,
            ));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: navBackgroundDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text("Apply",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: primaryText)),
    );
  }
}
