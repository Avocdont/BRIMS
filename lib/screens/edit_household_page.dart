import 'package:brims/database/app_db.dart';
import 'package:brims/database/tables/extensions.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;
import '../database/tables/enums.dart';

class EditHouseholdPage extends StatefulWidget {
  final int householdId;

  const EditHouseholdPage({super.key, required this.householdId});

  @override
  State<EditHouseholdPage> createState() => _EditHouseholdPageState();
}

class _EditHouseholdPageState extends State<EditHouseholdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // --- IDs ---
  int? _existingAddressId;
  int? _existingServiceId;
  int? _existingFemaleMortalityId;
  int? _existingChildMortalityId;
  int? _existingFutureResidencyId;
  final Map<int, int> _existingNeedIds = {};

  // --- 1. HEAD & MEMBERS ---
  PersonData? _selectedHead;
  final TextEditingController _headSearchController = TextEditingController();
  List<PersonData> _headSearchResults = [];
  bool _showHeadResults = false;

  List<Map<String, dynamic>> _addedMembers = [];
  List<PersonData> _removedMembers = [];

  final TextEditingController _memberSearchController = TextEditingController();
  List<PersonData> _memberSearchResults = [];
  bool _showMemberResults = false;

  final List<String> _relationshipTypes = [
    "Spouse",
    "Son",
    "Daughter",
    "Parent",
    "Sibling",
    "Grandparent",
    "Grandchild",
    "Other",
  ];

  // --- 2. ADDRESS ---
  final _zoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _blockController = TextEditingController();
  final _lotController = TextEditingController();

  // --- 3. HOUSEHOLD ---
  HouseholdTypes? _selectedHouseholdType;
  int? _selectedBuildingTypeId;
  OwnershipTypes? _selectedOwnershipType;

  // --- 4. MORTALITY ---
  final _fmAgeController = TextEditingController();
  final _fmCauseController = TextEditingController();
  final _cmAgeController = TextEditingController();
  final _cmCauseController = TextEditingController();
  Sex? _cmSex;

  // --- 5. NEEDS ---
  final _need1Controller = TextEditingController();
  final _need2Controller = TextEditingController();
  final _need3Controller = TextEditingController();

  // --- 6. RESIDENCY ---
  final _frBarangayController = TextEditingController();
  final _frMunicipalityController = TextEditingController();

  // --- 7. SURVEY INFO ---
  final _visitNumController = TextEditingController();
  BarangayPositions? _selectedBrgyPosition;
  ClientTypes? _selectedClientType;
  DateTime? _visitDate;
  RegistrationStatus? _selectedRegistrationStatus;
  DateTime? _registrationDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _headSearchController.dispose();
    _memberSearchController.dispose();
    _zoneController.dispose();
    _streetController.dispose();
    _blockController.dispose();
    _lotController.dispose();
    _visitNumController.dispose();
    _fmAgeController.dispose();
    _fmCauseController.dispose();
    _cmAgeController.dispose();
    _cmCauseController.dispose();
    _frBarangayController.dispose();
    _frMunicipalityController.dispose();
    _need1Controller.dispose();
    _need2Controller.dispose();
    _need3Controller.dispose();
    super.dispose();
  }

  // --- LOAD DATA ---
  Future<void> _loadData() async {
    try {
      final householdProvider = context.read<HouseholdProvider>();
      final personProvider = context.read<PersonProvider>();
      final lookupProvider = context.read<HouseholdLookupProvider>();

      await Future.wait<void>([
        lookupProvider.getAllBuildingTypes(),
        personProvider.getAllPersons(),
        householdProvider.getAllServices(),
        householdProvider.getAllPrimaryNeeds(),
        householdProvider.getAllFemaleMortalities(),
        householdProvider.getAllChildMortalities(),
        householdProvider.getAllFutureResidencies(),
      ]);

      final household = await householdProvider.getHouseholdByID(
        widget.householdId,
      );

      if (household != null) {
        // Head
        try {
          _selectedHead = personProvider.allPersons.firstWhere(
            (p) => "${p.first_name} ${p.last_name}" == household.head,
            orElse: () => personProvider.allPersons.first,
          );
        } catch (e) {}

        // Household Fields
        if (household.household_type_id != null) {
          _selectedHouseholdType = HouseholdTypes.values.asMap().containsKey(
                    household.household_type_id,
                  )
              ? HouseholdTypes.values[household.household_type_id!]
              : null;
        }
        _selectedBuildingTypeId = household.building_type_id;
        if (household.ownership_type_id != null) {
          _selectedOwnershipType = OwnershipTypes.values.asMap().containsKey(
                    household.ownership_type_id,
                  )
              ? OwnershipTypes.values[household.ownership_type_id!]
              : null;
        }
        _selectedRegistrationStatus = household.registration_status;
        _registrationDate = household.registration_date;

        // Address
        if (household.address_id != null) {
          _existingAddressId = household.address_id;
          final address = await householdProvider.getAddressByID(
            household.address_id!,
          );
          if (address != null) {
            _zoneController.text = address.zone ?? "";
            _streetController.text = address.street ?? "";
            _blockController.text = address.block ?? "";
            _lotController.text = address.lot ?? "";
          }
        }

        // Survey Info
        try {
          final services = householdProvider.allServices
              .where((s) => s.household_id == widget.householdId)
              .toList();
          if (services.isNotEmpty) {
            final service = services.first;
            _existingServiceId = service.service_id;
            _selectedClientType = service.client_type_id;
            _visitNumController.text = service.ave_client_num?.toString() ?? "";
          }
        } catch (e) {}

        // Primary Needs
        try {
          final needs = householdProvider.allPrimaryNeeds
              .where((n) => n.household_id == widget.householdId)
              .toList();
          for (var n in needs) {
            if (n.priority == 1) {
              _need1Controller.text = n.need;
              _existingNeedIds[1] = n.primary_need_id;
            }
            if (n.priority == 2) {
              _need2Controller.text = n.need;
              _existingNeedIds[2] = n.primary_need_id;
            }
            if (n.priority == 3) {
              _need3Controller.text = n.need;
              _existingNeedIds[3] = n.primary_need_id;
            }
          }
        } catch (e) {}

        // Residency
        try {
          final resList = householdProvider.allFutureResidencies
              .where((r) => r.household_id == widget.householdId)
              .toList();
          if (resList.isNotEmpty) {
            final fr = resList.first;
            _existingFutureResidencyId = fr.future_residency_id;
            _frBarangayController.text = fr.barangay ?? "";
            _frMunicipalityController.text = fr.municipality ?? "";
          }
        } catch (e) {}

        // Mortality
        final fmList = householdProvider.allFemaleMortalities
            .where((f) => f.household_id == widget.householdId)
            .toList();
        if (fmList.isNotEmpty) {
          _existingFemaleMortalityId = fmList.first.female_mortality_id;
          _fmAgeController.text = fmList.first.age?.toString() ?? "";
          _fmCauseController.text = fmList.first.death_cause ?? "";
        }
        final cmList = householdProvider.allChildMortalities
            .where((c) => c.household_id == widget.householdId)
            .toList();
        if (cmList.isNotEmpty) {
          _existingChildMortalityId = cmList.first.child_mortality_id;
          _cmAgeController.text = cmList.first.age?.toString() ?? "";
          _cmCauseController.text = cmList.first.death_cause ?? "";
          _cmSex = cmList.first.sex;
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- SEARCH LOGIC ---
  void _searchHead(String query) {
    if (query.isEmpty) {
      setState(() {
        _showHeadResults = false;
        _headSearchResults = [];
      });
      return;
    }
    final allPersons = context.read<PersonProvider>().allPersons;
    setState(() {
      _headSearchResults = allPersons
          .where(
            (p) => "${p.first_name} ${p.last_name}".toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
      _showHeadResults = true;
    });
  }

  void _searchMember(String query) {
    if (query.isEmpty) {
      setState(() {
        _showMemberResults = false;
        _memberSearchResults = [];
      });
      return;
    }
    final allPersons = context.read<PersonProvider>().allPersons;
    setState(() {
      _memberSearchResults = allPersons.where((p) {
        final fullName = "${p.first_name} ${p.last_name}".toLowerCase();
        if (_selectedHead?.person_id == p.person_id) return false;
        if (_addedMembers.any(
          (m) => (m['person'] as PersonData).person_id == p.person_id,
        )) return false;
        return fullName.contains(query.toLowerCase());
      }).toList();
      _showMemberResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final householdLookupProvider = context.watch<HouseholdLookupProvider>();
    if (_isLoading)
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Household")),
        body: const Center(child: CircularProgressIndicator()),
      );
    int totalMembers = (_selectedHead != null ? 1 : 0) + _addedMembers.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Household"), centerTitle: true),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEAD & MEMBERS
                  const Text(
                    "Head of Household",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedHead == null) ...[
                    TextFormField(
                      controller: _headSearchController,
                      decoration: InputDecoration(
                        labelText: "Search New Head",
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        suffixIcon: _headSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _headSearchController.clear();
                                  _searchHead('');
                                },
                              )
                            : null,
                      ),
                      onChanged: _searchHead,
                    ),
                    if (_showHeadResults)
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.builder(
                          itemCount: _headSearchResults.length,
                          itemBuilder: (context, index) {
                            final person = _headSearchResults[index];
                            return ListTile(
                              title: Text(
                                "${person.first_name} ${person.last_name}",
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedHead = person;
                                  _showHeadResults = false;
                                  _headSearchController.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ] else ...[
                    Card(
                      elevation: 0,
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          "${_selectedHead!.first_name} ${_selectedHead!.last_name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("Current Head"),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.change_circle,
                            color: Colors.blue,
                          ),
                          onPressed: () => setState(() => _selectedHead = null),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Household Members",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Chip(label: Text("Total: $totalMembers")),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _memberSearchController,
                    decoration: InputDecoration(
                      labelText: "Add Member",
                      prefixIcon: const Icon(Icons.person_add),
                      border: const OutlineInputBorder(),
                      suffixIcon: _memberSearchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _memberSearchController.clear();
                                _searchMember('');
                              },
                            )
                          : null,
                    ),
                    onChanged: _searchMember,
                  ),
                  if (_showMemberResults)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListView.builder(
                        itemCount: _memberSearchResults.length,
                        itemBuilder: (context, index) {
                          final person = _memberSearchResults[index];
                          return ListTile(
                            title: Text(
                              "${person.first_name} ${person.last_name}",
                            ),
                            trailing: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            onTap: () {
                              setState(() {
                                _addedMembers.add({
                                  'person': person,
                                  'relationship': null,
                                });
                                _showMemberResults = false;
                                _memberSearchController.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (_addedMembers.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _addedMembers.length,
                      separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final memberMap = _addedMembers[index];
                        final person = memberMap['person'] as PersonData;
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 24,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "${person.first_name} ${person.last_name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: "Relation",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  value: memberMap['relationship'],
                                  items: _relationshipTypes
                                      .map(
                                        (r) => DropdownMenuItem(
                                          value: r,
                                          child: Text(
                                            r,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) => setState(
                                    () => _addedMembers[index]['relationship'] =
                                        val,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _removedMembers.add(person);
                                    _addedMembers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),

                  // 2. ADDRESS & INFO
                  const Text(
                    "Address Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _zoneController,
                          decoration: const InputDecoration(
                            labelText: 'Zone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _streetController,
                          decoration: const InputDecoration(
                            labelText: 'Street',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _blockController,
                          decoration: const InputDecoration(
                            labelText: 'Block',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lotController,
                          decoration: const InputDecoration(
                            labelText: 'Lot',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Household Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<HouseholdTypes>(
                    value: _selectedHouseholdType,
                    decoration: const InputDecoration(
                      labelText: 'Household Type',
                      border: OutlineInputBorder(),
                    ),
                    items: HouseholdTypes.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedHouseholdType = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedBuildingTypeId,
                    decoration: const InputDecoration(
                      labelText: 'Building Type',
                      border: OutlineInputBorder(),
                    ),
                    items: householdLookupProvider.allBuildingTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type.building_type_id,
                            child: Text(type.type),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedBuildingTypeId = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<OwnershipTypes>(
                    value: _selectedOwnershipType,
                    decoration: const InputDecoration(
                      labelText: 'Ownership Type',
                      border: OutlineInputBorder(),
                    ),
                    items: OwnershipTypes.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedOwnershipType = val),
                  ),

                  // 3. COMMUNITY CARD
                  const SizedBox(height: 40),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "COMMUNITY",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const Divider(height: 32, thickness: 1),
                          const Text(
                            "Female died in the last 6 months",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fmAgeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _fmCauseController,
                                  decoration: const InputDecoration(
                                    labelText: 'Cause',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "5 Years old below died in the last 6 months",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cmAgeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final age = int.tryParse(value);
                                      if (age == null || age > 5)
                                        return "Age must be 5 or below";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<Sex>(
                                  value: _cmSex,
                                  decoration: const InputDecoration(
                                    labelText: 'Sex',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: Sex.values
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _cmSex = val),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cmCauseController,
                            decoration: const InputDecoration(
                              labelText: 'Cause of Death',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            "Primary needs of barangay",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _need1Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _need2Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _need3Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            "Intend to stay five years from now",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _frBarangayController,
                            decoration: const InputDecoration(
                              labelText: 'Intended Barangay',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _frMunicipalityController,
                            decoration: const InputDecoration(
                              labelText: 'Intended Municipality',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. SURVEY INFO CARD
                  const SizedBox(height: 40),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "SURVEY INFO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const Divider(height: 32, thickness: 1),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _visitNumController,
                                  decoration: const InputDecoration(
                                    labelText: 'Number of visits',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    DropdownButtonFormField<BarangayPositions>(
                                  value: _selectedBrgyPosition,
                                  decoration: const InputDecoration(
                                    labelText: 'Barangay Position',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: BarangayPositions.values
                                      .map(
                                        (pos) => DropdownMenuItem(
                                          value: pos,
                                          child: Text(pos.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) => setState(
                                    () => _selectedBrgyPosition = val,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<ClientTypes>(
                            value: _selectedClientType,
                            decoration: const InputDecoration(
                              labelText: 'Client Type',
                              border: OutlineInputBorder(),
                            ),
                            items: ClientTypes.values
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedClientType = val),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            title: const Text("Visit Date"),
                            subtitle: Text(
                              _visitDate == null
                                  ? "Select Date"
                                  : _visitDate.toString().split(' ')[0],
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (d != null) setState(() => _visitDate = d);
                            },
                          ),
                          const SizedBox(height: 24),
                          DropdownButtonFormField<RegistrationStatus>(
                            value: _selectedRegistrationStatus,
                            decoration: const InputDecoration(
                              labelText: 'Registration Status',
                              border: OutlineInputBorder(),
                            ),
                            items: RegistrationStatus.values
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => setState(
                              () => _selectedRegistrationStatus = val,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            title: const Text("Registration Date"),
                            subtitle: Text(
                              _registrationDate == null
                                  ? "Select Date"
                                  : _registrationDate.toString().split(' ')[0],
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (d != null)
                                setState(() => _registrationDate = d);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateHousehold,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "UPDATE HOUSEHOLD",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateHousehold() async {
    if (_selectedHead == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A Head of Household is required.")),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final provider = context.read<HouseholdProvider>();

      try {
        // Address
        int? finalAddressId = _existingAddressId;
        final addressCompanion = AddressesCompanion(
          address_id: _existingAddressId != null
              ? db.Value(_existingAddressId!)
              : const db.Value.absent(),
          zone: db.Value(_zoneController.text),
          street: db.Value(_streetController.text),
          block: db.Value(_blockController.text),
          lot: db.Value(_lotController.text),
        );
        if (_existingAddressId != null)
          await provider.updateAddress(addressCompanion);
        else if (_zoneController.text.isNotEmpty)
          finalAddressId = await provider.addAddress(addressCompanion);

        // Household
        int totalMembers = 1 + _addedMembers.length;
        bool hasFm = _fmAgeController.text.isNotEmpty ||
            _fmCauseController.text.isNotEmpty;
        bool hasCm = _cmAgeController.text.isNotEmpty ||
            _cmCauseController.text.isNotEmpty;

        final householdCompanion = HouseholdsCompanion(
          household_id: db.Value(widget.householdId),
          head: db.Value(
            "${_selectedHead!.first_name} ${_selectedHead!.last_name}",
          ),
          address_id: finalAddressId != null
              ? db.Value(finalAddressId)
              : const db.Value.absent(),
          household_type_id: _selectedHouseholdType != null
              ? db.Value(_selectedHouseholdType!)
              : const db.Value.absent(),
          ownership_type_id: _selectedOwnershipType != null
              ? db.Value(_selectedOwnershipType!)
              : const db.Value.absent(),
          building_type_id: db.Value(_selectedBuildingTypeId),
          household_members_num: db.Value(totalMembers),
          registration_date: db.Value(_registrationDate),
          registration_status: db.Value(_selectedRegistrationStatus!),
          female_mortality: db.Value(hasFm),
          child_mortality: db.Value(hasCm),
        );
        await provider.updateHousehold(householdCompanion);

        // Survey Info (Service)
        if (_selectedClientType != null ||
            _visitNumController.text.isNotEmpty) {
          final sCompanion = ServicesCompanion(
            service_id: _existingServiceId != null
                ? db.Value(_existingServiceId!)
                : const db.Value.absent(),
            household_id: db.Value(widget.householdId),
            client_type_id: db.Value(_selectedClientType),
            ave_client_num: db.Value(int.tryParse(_visitNumController.text)),
          );
          if (_existingServiceId != null)
            await provider.updateService(sCompanion);
          else
            await provider.addService(sCompanion);
        } else if (_existingServiceId != null) {
          await provider.deleteService(_existingServiceId!);
        }

        // Needs
        List<TextEditingController> needsCtrls = [
          _need1Controller,
          _need2Controller,
          _need3Controller,
        ];
        for (int i = 0; i < 3; i++) {
          int priority = i + 1;
          int? existingId = _existingNeedIds[priority];
          String text = needsCtrls[i].text;
          if (text.isNotEmpty) {
            final nCompanion = PrimaryNeedsCompanion(
              primary_need_id: existingId != null
                  ? db.Value(existingId)
                  : const db.Value.absent(),
              household_id: db.Value(widget.householdId),
              need: db.Value(text),
              priority: db.Value(priority),
            );
            if (existingId != null)
              await provider.updatePrimaryNeed(nCompanion);
            else
              await provider.addPrimaryNeed(nCompanion);
          } else if (existingId != null) {
            await provider.deletePrimaryNeed(existingId);
          }
        }

        // Residency
        if (_frBarangayController.text.isNotEmpty ||
            _frMunicipalityController.text.isNotEmpty) {
          final frCompanion = FutureResidenciesCompanion(
            future_residency_id: _existingFutureResidencyId != null
                ? db.Value(_existingFutureResidencyId!)
                : const db.Value.absent(),
            household_id: db.Value(widget.householdId),
            barangay: db.Value(_frBarangayController.text),
            municipality: db.Value(_frMunicipalityController.text),
          );
          if (_existingFutureResidencyId != null)
            await provider.updateFutureResidency(frCompanion);
          else
            await provider.addFutureResidency(frCompanion);
        } else if (_existingFutureResidencyId != null) {
          await provider.deleteFutureResidency(_existingFutureResidencyId!);
        }

        // Mortalities
        if (hasFm) {
          final fmCompanion = FemaleMortalitiesCompanion(
            female_mortality_id: _existingFemaleMortalityId != null
                ? db.Value(_existingFemaleMortalityId!)
                : const db.Value.absent(),
            household_id: db.Value(widget.householdId),
            age: db.Value(int.tryParse(_fmAgeController.text)),
            death_cause: db.Value(_fmCauseController.text),
          );
          if (_existingFemaleMortalityId != null)
            await provider.updateFemaleMortality(fmCompanion);
          else
            await provider.addFemaleMortality(fmCompanion);
        } else if (_existingFemaleMortalityId != null) {
          await provider.deleteFemaleMortality(_existingFemaleMortalityId!);
        }

        if (hasCm) {
          final cmCompanion = ChildMortalitiesCompanion(
            child_mortality_id: _existingChildMortalityId != null
                ? db.Value(_existingChildMortalityId!)
                : const db.Value.absent(),
            household_id: db.Value(widget.householdId),
            age: db.Value(int.tryParse(_cmAgeController.text)),
            sex: db.Value(_cmSex),
            death_cause: db.Value(_cmCauseController.text),
          );
          if (_existingChildMortalityId != null)
            await provider.updateChildMortality(cmCompanion);
          else
            await provider.addChildMortality(cmCompanion);
        } else if (_existingChildMortalityId != null) {
          await provider.deleteChildMortality(_existingChildMortalityId!);
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating: $e")));
        setState(() => _isSaving = false);
      }
    }
  }
}
