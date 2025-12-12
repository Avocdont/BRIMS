import 'package:brims/database/tables/enums.dart';
import 'package:brims/models/household_models.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      title: const Text("Filter Households"),
      content: SingleChildScrollView(
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
                  label: Text(type.name),
                  selected: isSelected,
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
            const SizedBox(height: 16),
            _buildSectionTitle("Ownership Type"),
            Wrap(
              spacing: 8,
              children: OwnershipTypes.values.map((type) {
                final isSelected = _selectedOwnershipTypes.contains(type);
                return FilterChip(
                  label: Text(type.name),
                  selected: isSelected,
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
            const SizedBox(height: 16),
            _buildSectionTitle("Building Type"),
            Wrap(
              spacing: 8,
              children: lookupProvider.allBuildingTypes.map((b) {
                final isSelected =
                    _selectedBuildingTypeIds.contains(b.building_type_id);
                return FilterChip(
                  label: Text(b.type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selected
                          ? _selectedBuildingTypeIds.add(b.building_type_id)
                          : _selectedBuildingTypeIds.remove(b.building_type_id);
                    });
                  },
                );
              }).toList(),
            ),
          ],
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
          child: const Text("Reset", style: TextStyle(color: Colors.red)),
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
          child: const Text("Apply"),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
