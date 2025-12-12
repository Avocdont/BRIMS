import 'package:brims/database/tables/enums.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for consistent typography

class ProfileFilterDialog extends StatefulWidget {
  final ProfileFilterOptions currentFilters;
  final Function(ProfileFilterOptions) onApply;

  const ProfileFilterDialog({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<ProfileFilterDialog> createState() => _ProfileFilterDialogState();
}

class _ProfileFilterDialogState extends State<ProfileFilterDialog> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background
  static const Color cardBackground =
      Color(0xFFFFFFFF); // White for inner elements
  static const Color navBackground = Color(0xFF40C4FF); // Primary blue
  static const Color navBackgroundDark = Color(0xFF29B6F6); // Darker accent
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
  static const Color secondaryText = Color(0xFF555555); // Secondary text/border
  static const Color dividerColor = Color(0xFFE0E0E0); // Light divider

  late ProfileFilterOptions _filters;

  // FIX: Use Controllers instead of initialValue
  late TextEditingController _minAgeController;
  late TextEditingController _maxAgeController;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters.copy();

    // Initialize controllers with current values
    _minAgeController = TextEditingController(
      text: _filters.minAge != null ? _filters.minAge.toString() : '',
    );
    _maxAgeController = TextEditingController(
      text: _filters.maxAge != null ? _filters.maxAge.toString() : '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileLookupProvider>().loadAllLookups();
    });
  }

  @override
  void dispose() {
    _minAgeController.dispose();
    _maxAgeController.dispose();
    super.dispose();
  }

  // --- Input Decoration Helper ---
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: primaryText.withOpacity(0.8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: navBackground, width: 2),
      ),
      filled: true,
      fillColor: primaryBackground,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lookup = context.watch<ProfileLookupProvider>();

    return AlertDialog(
      backgroundColor: cardBackground, // White background for the dialog itself
      title: Text("Filter Profiles",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: navBackgroundDark)),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEnumFilter("Sex", Sex.values, _filters.sex),
              const Divider(color: dividerColor),
              _buildEnumFilter(
                "Civil Status",
                CivilStatus.values,
                _filters.civilStatus,
              ),
              const Divider(color: dividerColor),
              _buildEnumFilter(
                "Registration Status",
                RegistrationStatus.values,
                _filters.registrationStatus,
              ),
              const Divider(color: dividerColor),

              // --- Lookups ---
              _buildLookupFilter(
                "Nationality",
                lookup.allNationalities,
                (item) => item.name,
                (item) => item.nationality_id,
                _filters.nationalityIds,
              ),
              const Divider(color: dividerColor),
              _buildLookupFilter(
                "Ethnicity",
                lookup.allEthnicities,
                (item) => item.name,
                (item) => item.ethnicity_id,
                _filters.ethnicityIds,
              ),
              const Divider(color: dividerColor),
              _buildLookupFilter(
                "Religion",
                lookup.allReligions,
                (item) => item.name,
                (item) => item.religion_id,
                _filters.religionIds,
              ),
              const Divider(color: dividerColor),
              _buildLookupFilter(
                "Education",
                lookup.allEducation,
                (item) => item.level,
                (item) => item.education_id,
                _filters.educationIds,
              ),
              const Divider(color: dividerColor),
              _buildLookupFilter(
                "Blood Type",
                lookup.allBloodTypes,
                (item) => item.type,
                (item) => item.blood_type_id,
                _filters.bloodTypeIds,
              ),
              const Divider(color: dividerColor),

              // --- Age Range (FIXED) ---
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "Age Range",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: primaryText),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.poppins(color: primaryText),
                      controller: _minAgeController, // FIX: Use controller
                      decoration: _inputDecoration("Min Age"),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _filters.minAge = int.tryParse(v ?? ''),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      style: GoogleFonts.poppins(color: primaryText),
                      controller: _maxAgeController, // FIX: Use controller
                      decoration: _inputDecoration("Max Age"),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _filters.maxAge = int.tryParse(v ?? ''),
                    ),
                  ),
                ],
              ),
              const Divider(color: dividerColor),

              // --- Checkboxes ---
              CheckboxListTile(
                title: Text("Registered Voter Only",
                    style: GoogleFonts.poppins(color: primaryText)),
                value: _filters.registeredVoter ?? false,
                activeColor: navBackground,
                onChanged: (val) {
                  setState(() {
                    _filters.registeredVoter = (val == true) ? true : null;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Has Disability Only",
                    style: GoogleFonts.poppins(color: primaryText)),
                value: _filters.hasDisability ?? false,
                activeColor: navBackground,
                onChanged: (val) {
                  setState(() {
                    _filters.hasDisability = (val == true) ? true : null;
                  });
                },
              ),

              // --- Choice Chips (Currently Enrolled) ---
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "Currently Enrolled?",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primaryText),
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text("Any",
                        style: GoogleFonts.poppins(
                            color: _filters.currentlyEnrolled == null
                                ? cardBackground
                                : primaryText)),
                    selected: _filters.currentlyEnrolled == null,
                    selectedColor: navBackgroundDark,
                    onSelected: (b) =>
                        setState(() => _filters.currentlyEnrolled = null),
                  ),
                  ...CurrentlyEnrolled.values.map((val) {
                    return ChoiceChip(
                      label: Text(val.name,
                          style: GoogleFonts.poppins(
                              color: _filters.currentlyEnrolled == val
                                  ? cardBackground
                                  : primaryText)),
                      selected: _filters.currentlyEnrolled == val,
                      selectedColor: navBackgroundDark,
                      onSelected: (b) {
                        setState(() {
                          _filters.currentlyEnrolled = b ? val : null;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _filters.clear();
              // FIX: Explicitly clear the text fields
              _minAgeController.clear();
              _maxAgeController.clear();
            });
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child:
              Text("Clear All", style: GoogleFonts.poppins(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_filters);
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

  // --- Helper Widgets ---

  // Enum Filter Chip Builder
  Widget _buildEnumFilter<T extends Enum>(
    String title,
    List<T> values,
    List<T> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: primaryText)),
        ),
        Wrap(
          spacing: 8,
          children: values.map((val) {
            final isSelected = selectedList.contains(val);
            return FilterChip(
              label: Text(val.name,
                  style: GoogleFonts.poppins(
                      color: isSelected ? cardBackground : primaryText)),
              selected: isSelected,
              selectedColor: navBackground,
              backgroundColor: primaryBackground,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedList.add(val);
                  } else {
                    selectedList.remove(val);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Lookup Filter Chip Builder
  Widget _buildLookupFilter<T>(
    String title,
    List<T> allItems,
    String Function(T) getName,
    int Function(T) getId,
    List<int> selectedIds,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: primaryText)),
        ),
        if (allItems.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No options available",
              style: GoogleFonts.poppins(color: secondaryText),
            ),
          ),
        Wrap(
          spacing: 8,
          children: allItems.map((item) {
            final id = getId(item);
            final name = getName(item);
            final isSelected = selectedIds.contains(id);

            return FilterChip(
              label: Text(name,
                  style: GoogleFonts.poppins(
                      color: isSelected ? cardBackground : primaryText)),
              selected: isSelected,
              selectedColor: navBackground,
              backgroundColor: primaryBackground,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedIds.add(id);
                  } else {
                    selectedIds.remove(id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
