import 'package:brims/database/tables/enums.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final lookup = context.watch<ProfileLookupProvider>();

    return AlertDialog(
      title: const Text("Filter Profiles"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEnumFilter("Sex", Sex.values, _filters.sex),
              const Divider(),
              _buildEnumFilter(
                "Civil Status",
                CivilStatus.values,
                _filters.civilStatus,
              ),
              const Divider(),
              _buildEnumFilter(
                "Registration Status",
                RegistrationStatus.values,
                _filters.registrationStatus,
              ),
              const Divider(),

              // --- Lookups ---
              _buildLookupFilter(
                "Nationality",
                lookup.allNationalities,
                (item) => item.name,
                (item) => item.nationality_id,
                _filters.nationalityIds,
              ),
              const Divider(),
              _buildLookupFilter(
                "Ethnicity",
                lookup.allEthnicities,
                (item) => item.name,
                (item) => item.ethnicity_id,
                _filters.ethnicityIds,
              ),
              const Divider(),
              _buildLookupFilter(
                "Religion",
                lookup.allReligions,
                (item) => item.name,
                (item) => item.religion_id,
                _filters.religionIds,
              ),
              const Divider(),
              _buildLookupFilter(
                "Education",
                lookup.allEducation,
                (item) => item.level,
                (item) => item.education_id,
                _filters.educationIds,
              ),
              const Divider(),
              _buildLookupFilter(
                "Blood Type",
                lookup.allBloodTypes,
                (item) => item.type,
                (item) => item.blood_type_id,
                _filters.bloodTypeIds,
              ),
              const Divider(),

              // --- Age Range (FIXED) ---
              const Text(
                "Age Range",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minAgeController, // FIX: Use controller
                      decoration: const InputDecoration(labelText: "Min Age"),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _filters.minAge = int.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _maxAgeController, // FIX: Use controller
                      decoration: const InputDecoration(labelText: "Max Age"),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _filters.maxAge = int.tryParse(v),
                    ),
                  ),
                ],
              ),
              const Divider(),

              CheckboxListTile(
                title: const Text("Registered Voter Only"),
                value: _filters.registeredVoter ?? false,
                onChanged: (val) {
                  setState(() {
                    _filters.registeredVoter = (val == true) ? true : null;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Has Disability Only"),
                value: _filters.hasDisability ?? false,
                onChanged: (val) {
                  setState(() {
                    _filters.hasDisability = (val == true) ? true : null;
                  });
                },
              ),

              const Text(
                "Currently Enrolled?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text("Any"),
                    selected: _filters.currentlyEnrolled == null,
                    onSelected:
                        (b) =>
                            setState(() => _filters.currentlyEnrolled = null),
                  ),
                  ...CurrentlyEnrolled.values.map((val) {
                    return ChoiceChip(
                      label: Text(val.name),
                      selected: _filters.currentlyEnrolled == val,
                      onSelected: (b) {
                        setState(() {
                          _filters.currentlyEnrolled = b ? val : null;
                        });
                      },
                    );
                  }),
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
          child: const Text("Clear All"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_filters);
            Navigator.pop(context);
          },
          child: const Text("Apply"),
        ),
      ],
    );
  }

  // (Helpers _buildEnumFilter and _buildLookupFilter remain the same)
  Widget _buildEnumFilter<T extends Enum>(
    String title,
    List<T> values,
    List<T> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children:
              values.map((val) {
                final isSelected = selectedList.contains(val);
                return FilterChip(
                  label: Text(val.name),
                  selected: isSelected,
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (allItems.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "No options available",
              style: TextStyle(color: Colors.grey),
            ),
          ),

        Wrap(
          spacing: 8,
          children:
              allItems.map((item) {
                final id = getId(item);
                final name = getName(item);
                final isSelected = selectedIds.contains(id);

                return FilterChip(
                  label: Text(name),
                  selected: isSelected,
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
