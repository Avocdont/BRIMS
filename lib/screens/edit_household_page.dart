import 'package:brims/database/app_db.dart';
import 'package:brims/database/tables/extensions.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:brims/provider/lookup%20providers/question_lookup_provider.dart';
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

  // IDs to track existing records for updates
  int? _existingAddressId;
  int? _existingServiceId;
  int? _existingFemaleMortalityId;
  int? _existingChildMortalityId;
  int? _existingFutureResidencyId;
  int? _existingVisitId;
  final Map<int, int> _existingNeedIds = {};

  // Head/Member
  PersonData? _selectedHead;
  final TextEditingController _headSearchController = TextEditingController();
  List<PersonData> _headSearchResults = [];
  bool _showHeadResults = false;

  // Member Management
  // Structure: {
  //   'person': PersonData,
  //   'relationship_id': int? (The ID from dropdown),
  //   'rel_pk': int? (The Primary Key of the existing relationship record, if any)
  // }
  List<Map<String, dynamic>> _addedMembers = [];
  List<PersonData> _removedMembers = [];

  final TextEditingController _memberSearchController = TextEditingController();
  List<PersonData> _memberSearchResults = [];
  bool _showMemberResults = false;

  // Address
  final _zoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _blockController = TextEditingController();
  final _lotController = TextEditingController();

  // Address Search State
  String? _Zone;
  String? _Street;
  String? _Block;
  String? _Lot;
  List<Map<String, dynamic>> _searchedAddress = [];
  bool _noResults = false;

  // Household
  HouseholdTypes? _selectedHouseholdType;
  int? _selectedBuildingTypeId;
  OwnershipTypes? _selectedOwnershipType;

  // Mortality
  final _fmAgeController = TextEditingController();
  final _fmCauseController = TextEditingController();
  final _cmAgeController = TextEditingController();
  final _cmCauseController = TextEditingController();
  Sex? _cmSex;

  // Needs
  final _need1Controller = TextEditingController();
  final _need2Controller = TextEditingController();
  final _need3Controller = TextEditingController();

  // Residency
  final _frBarangayController = TextEditingController();
  final _frMunicipalityController = TextEditingController();

  // Survey Info
  final _visitNumController = TextEditingController();
  BarangayPositions? _selectedBrgyPosition;
  ClientTypes? _selectedClientType;
  DateTime? _visitDate;
  RegistrationStatus? _selectedRegistrationStatus;
  DateTime? _registrationDate;

  // UTILITIES (Dynamic)
  final Map<int, int?> _utilityAnswers = {};
  final Map<int, int> _existingResponseIds = {};

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

  Future<void> _loadData() async {
    try {
      final householdProvider = context.read<HouseholdProvider>();
      final personProvider = context.read<PersonProvider>();
      final lookupProvider = context.read<HouseholdLookupProvider>();
      final questionProvider = context.read<QuestionLookupProvider>();

      await Future.wait<void>([
        lookupProvider.getAllBuildingTypes(),
        lookupProvider.getAllRelationshipTypes(), // Load Lookups
        personProvider.getAllPersons(),
        householdProvider.getAllServices(),
        householdProvider.getAllPrimaryNeeds(),
        householdProvider.getAllFemaleMortalities(),
        householdProvider.getAllChildMortalities(),
        householdProvider.getAllFutureResidencies(),
        householdProvider.getAllHouseholdVisits(),
        householdProvider.getAllHouseholdMembers(),
        householdProvider
            .getAllHouseholdRelationships(), // Load Relationship Table
        questionProvider.getAllQuestions(),
        questionProvider.getAllQuestionChoices(),
      ]);

      if (!mounted) return;

      final household =
          await householdProvider.getHouseholdByID(widget.householdId);

      if (household != null) {
        // --- HEAD ---
        try {
          _selectedHead = personProvider.allPersons
              .cast<PersonData?>()
              .firstWhere(
                  (p) => "${p!.first_name} ${p.last_name}" == household.head,
                  orElse: () => null);
        } catch (e) {
          debugPrint("Head not found: $e");
        }

        // --- MEMBERS & RELATIONSHIPS ---
        // 1. Get members linked to this household
        final currentMembersLinks = householdProvider.allHouseholdMembers
            .where((m) => m.household_id == widget.householdId)
            .toList();

        // 2. Get relationships linked to this household
        final currentRelationships = householdProvider.allHouseholdRelationships
            .where((r) => r.household_id == widget.householdId)
            .toList();

        _addedMembers = [];
        for (var link in currentMembersLinks) {
          try {
            // Find Person Data
            final p = personProvider.allPersons
                .firstWhere((person) => person.person_id == link.person_id);

            // Don't add the head to the member list
            if (_selectedHead == null ||
                p.person_id != _selectedHead!.person_id) {
              // Find if this person has a relationship record
              final relRecord = currentRelationships.firstWhere(
                  (r) => r.person_id == p.person_id,
                  orElse: () => HouseholdRelationship(
                      household_relationship_id: -1, // Dummy
                      person_id: -1,
                      household_id: -1,
                      relationship_id: null));

              _addedMembers.add({
                'person': p,
                'relationship_id':
                    relRecord.relationship_id, // The ID for dropdown
                'rel_pk': relRecord.relationship_id != null
                    ? relRecord.household_relationship_id
                    : null, // PK for updating
              });
            }
          } catch (e) {
            debugPrint("Error loading member: $e");
          }
        }

        // --- ENUMS & BASIC INFO ---
        _selectedHouseholdType = household.household_type_id;
        _selectedBuildingTypeId = household.building_type_id;
        _selectedOwnershipType = household.ownership_type_id;

        _selectedRegistrationStatus = household.registration_status;
        _registrationDate = household.registration_date;

        // --- ADDRESS ---
        if (household.address_id != null) {
          _existingAddressId = household.address_id;
          final address =
              await householdProvider.getAddressByID(household.address_id!);
          if (address != null) {
            _zoneController.text = address.zone ?? "";
            _streetController.text = address.street ?? "";
            _blockController.text = address.block ?? "";
            _lotController.text = address.lot ?? "";
          }
        }

        // --- SERVICES ---
        try {
          final services = householdProvider.allServices
              .where((s) => s.household_id == widget.householdId)
              .toList();
          if (services.isNotEmpty) {
            _existingServiceId = services.first.service_id;
            _selectedClientType = services.first.client_type_id;
            _visitNumController.text =
                services.first.ave_client_num?.toString() ?? "";
          }
        } catch (e) {}

        // --- VISITS ---
        try {
          final visits = householdProvider.allHouseholdVisits
              .where((v) => v.household_id == widget.householdId)
              .toList();
          if (visits.isNotEmpty) {
            _existingVisitId = visits.first.household_visit_id;
            _selectedBrgyPosition = visits.first.brgy_position;
            _visitDate = visits.first.visit_date;
            if (_visitNumController.text.isEmpty) {
              _visitNumController.text =
                  visits.first.visit_num?.toString() ?? "";
            }
          }
        } catch (e) {}

        // --- UTILITIES ---
        final existingResponses =
            await questionProvider.getHouseholdResponses(widget.householdId);
        for (var resp in existingResponses) {
          _utilityAnswers[resp.question_id] = resp.choice_id;
          _existingResponseIds[resp.question_id] = resp.response_id;
        }

        // --- NEEDS ---
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

        // --- RESIDENCY ---
        try {
          final resList = householdProvider.allFutureResidencies
              .where((r) => r.household_id == widget.householdId)
              .toList();
          if (resList.isNotEmpty) {
            _existingFutureResidencyId = resList.first.future_residency_id;
            _frBarangayController.text = resList.first.barangay ?? "";
            _frMunicipalityController.text = resList.first.municipality ?? "";
          }
        } catch (e) {}

        // --- MORTALITY ---
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
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error loading: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
          .where((p) => "${p.first_name} ${p.last_name}"
              .toLowerCase()
              .contains(query.toLowerCase()))
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
        if (_addedMembers
            .any((m) => (m['person'] as PersonData).person_id == p.person_id))
          return false;
        return fullName.contains(query.toLowerCase());
      }).toList();
      _showMemberResults = true;
    });
  }

  // Helper for Section Headers
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
                color: Colors.blueGrey)),
        const Divider(thickness: 1.5),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final householdLookupProvider = context.watch<HouseholdLookupProvider>();
    final questionProvider = context.watch<QuestionLookupProvider>();

    if (_isLoading) {
      return Scaffold(
          appBar: AppBar(title: const Text("Edit Household")),
          body: const Center(child: CircularProgressIndicator()));
    }
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
                  _buildSectionHeader("Head of Household"),

                  if (_selectedHead == null) ...[
                    TextFormField(
                      controller: _headSearchController,
                      decoration: InputDecoration(
                        labelText: "Search New Head",
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        suffixIcon: _headSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _headSearchController.clear();
                                  _searchHead('');
                                })
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
                            borderRadius: BorderRadius.circular(4)),
                        child: ListView.builder(
                          itemCount: _headSearchResults.length,
                          itemBuilder: (context, index) {
                            final person = _headSearchResults[index];
                            return ListTile(
                              title: Text(
                                  "${person.first_name} ${person.last_name}"),
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
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                            "${_selectedHead!.first_name} ${_selectedHead!.last_name}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text("Current Head"),
                        trailing: IconButton(
                            icon: const Icon(Icons.change_circle,
                                color: Colors.blue),
                            onPressed: () =>
                                setState(() => _selectedHead = null)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("HOUSEHOLD MEMBERS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.2,
                                color: Colors.blueGrey)),
                        Chip(
                            label: Text("Total: $totalMembers",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)))
                      ]),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _memberSearchController,
                    decoration: InputDecoration(
                      labelText: "Add Member",
                      prefixIcon: const Icon(Icons.person_add),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      suffixIcon: _memberSearchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _memberSearchController.clear();
                                _searchMember('');
                              })
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
                          borderRadius: BorderRadius.circular(4)),
                      child: ListView.builder(
                        itemCount: _memberSearchResults.length,
                        itemBuilder: (context, index) {
                          final person = _memberSearchResults[index];
                          return ListTile(
                            title: Text(
                                "${person.first_name} ${person.last_name}"),
                            trailing: const Icon(Icons.add_circle,
                                color: Colors.green),
                            onTap: () {
                              setState(() {
                                _addedMembers.add({
                                  'person': person,
                                  'relationship_id': null,
                                  'rel_pk':
                                      null // New member, so no existing PK
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
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 24, color: Colors.grey),
                              const SizedBox(width: 12),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      "${person.first_name} ${person.last_name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600))),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                      labelText: "Relation",
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      border: OutlineInputBorder()),
                                  value: memberMap['relationship_id'],
                                  items: householdLookupProvider
                                      .allRelationshipTypes
                                      .map((r) => DropdownMenuItem(
                                          value: r.relationship_id,
                                          child: Text(r.relationship,
                                              style: const TextStyle(
                                                  fontSize: 14))))
                                      .toList(),
                                  onChanged: (val) => setState(() =>
                                      _addedMembers[index]['relationship_id'] =
                                          val),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    // Track removed member for DB deletion
                                    _removedMembers.add(person);
                                    _addedMembers.removeAt(index);
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),

                  // ADDRESS
                  _buildSectionHeader("Address Information"),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                            controller: _zoneController,
                            decoration: const InputDecoration(
                                labelText: 'Zone',
                                border: OutlineInputBorder()))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: TextFormField(
                            controller: _streetController,
                            decoration: const InputDecoration(
                                labelText: 'Street',
                                border: OutlineInputBorder()))),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                            controller: _blockController,
                            decoration: const InputDecoration(
                                labelText: 'Block',
                                border: OutlineInputBorder()))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: TextFormField(
                            controller: _lotController,
                            decoration: const InputDecoration(
                                labelText: 'Lot',
                                border: OutlineInputBorder()))),
                  ]),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final provider = context.read<HouseholdProvider>();
                      setState(() {
                        _searchedAddress = [];
                        _noResults = false;
                        // Don't clear existingAddressId immediately, wait for user selection
                      });
                      final results = await provider.searchAddresses(
                        zone: _zoneController.text.isNotEmpty
                            ? _zoneController.text
                            : null,
                        street: _streetController.text.isNotEmpty
                            ? _streetController.text
                            : null,
                        block: _blockController.text.isNotEmpty
                            ? _blockController.text
                            : null,
                        lot: _lotController.text.isNotEmpty
                            ? _lotController.text
                            : null,
                      );
                      setState(() {
                        _searchedAddress = results;
                        _noResults = results.isEmpty;
                      });
                    },
                    child: const Text("Search Address"),
                  ),
                  if (_noResults)
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Text(
                              "No address found. Use entered data as new address?"),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _Zone = _zoneController.text;
                                        _Street = _streetController.text;
                                        _Block = _blockController.text;
                                        _Lot = _lotController.text;
                                        _existingAddressId = null; // Create new
                                        _noResults = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("New Address Set.")));
                                    },
                                    child: const Text("Yes")),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () =>
                                        setState(() => _noResults = false),
                                    child: const Text("No")),
                              ])
                        ]))
                  else if (_searchedAddress.isNotEmpty)
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Address Found:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  "Zone: ${_searchedAddress[0]['address']['zone']}"),
                              Text(
                                  "Street: ${_searchedAddress[0]['address']['street']}"),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _existingAddressId =
                                          _searchedAddress[0]['address']['id'];
                                      final addr =
                                          _searchedAddress[0]['address'];
                                      _zoneController.text = addr['zone'];
                                      _streetController.text = addr['street'];
                                      _blockController.text = addr['block'];
                                      _lotController.text = addr['lot'];
                                      _searchedAddress = [];
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Existing Address Selected")));
                                  },
                                  child: const Text("Use This Address")),
                              TextButton(
                                  onPressed: () =>
                                      setState(() => _searchedAddress = []),
                                  child: const Text("Cancel Search",
                                      style: TextStyle(color: Colors.red)))
                            ])),

                  const SizedBox(height: 40),

                  // HOUSEHOLD DETAILS
                  _buildSectionHeader("Household Details"),
                  DropdownButtonFormField<HouseholdTypes>(
                    value: _selectedHouseholdType,
                    decoration: const InputDecoration(
                        labelText: 'Household Type',
                        border: OutlineInputBorder()),
                    items: HouseholdTypes.values
                        .map((type) => DropdownMenuItem(
                            value: type, child: Text(type.name)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedHouseholdType = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedBuildingTypeId,
                    decoration: const InputDecoration(
                        labelText: 'Building Type',
                        border: OutlineInputBorder()),
                    items: householdLookupProvider.allBuildingTypes
                        .map((type) => DropdownMenuItem(
                            value: type.building_type_id,
                            child: Text(type.type)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedBuildingTypeId = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<OwnershipTypes>(
                    value: _selectedOwnershipType,
                    decoration: const InputDecoration(
                        labelText: 'Ownership Type',
                        border: OutlineInputBorder()),
                    items: OwnershipTypes.values
                        .map((type) => DropdownMenuItem(
                            value: type, child: Text(type.name)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedOwnershipType = val),
                  ),

                  // UTILITIES
                  if (questionProvider.allQuestions.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                  child: Text("UTILITIES",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 1.2,
                                          color: Colors.blueGrey))),
                              const Divider(height: 32, thickness: 1),
                              ...questionProvider.allQuestions.map((q) {
                                final choices = questionProvider
                                    .getChoicesForQuestion(q.question_id);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(q.question,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<int>(
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12),
                                            border: OutlineInputBorder(),
                                            isDense: true),
                                        value: _utilityAnswers[q.question_id],
                                        hint: const Text("Select option"),
                                        items: choices.map((choice) {
                                          return DropdownMenuItem<int>(
                                              value: choice.choice_id,
                                              child: Text(choice.choice));
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _utilityAnswers[q.question_id] =
                                                val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ]),
                      ),
                    ),
                  ],

                  // COMMUNITY
                  const SizedBox(height: 40),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                                child: Text("COMMUNITY",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1.2,
                                        color: Colors.blueGrey))),
                            const Divider(height: 32, thickness: 1),
                            const Text("Female died in the last 6 months",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                  child: TextFormField(
                                      controller: _fmAgeController,
                                      decoration: const InputDecoration(
                                          labelText: 'Age',
                                          border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: TextFormField(
                                      controller: _fmCauseController,
                                      decoration: const InputDecoration(
                                          labelText: 'Cause',
                                          border: OutlineInputBorder()))),
                            ]),
                            const SizedBox(height: 24),
                            const Text(
                                "5 Years old below died in the last 6 months",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                  child: TextFormField(
                                      controller: _cmAgeController,
                                      decoration: const InputDecoration(
                                          labelText: 'Age',
                                          border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          final age = int.tryParse(value);
                                          if (age == null || age > 5)
                                            return "Age must be 5 or below";
                                        }
                                        return null;
                                      })),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: DropdownButtonFormField<Sex>(
                                      value: _cmSex,
                                      decoration: const InputDecoration(
                                          labelText: 'Sex',
                                          border: OutlineInputBorder()),
                                      items: Sex.values
                                          .map((s) => DropdownMenuItem(
                                              value: s, child: Text(s.name)))
                                          .toList(),
                                      onChanged: (val) =>
                                          setState(() => _cmSex = val))),
                            ]),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _cmCauseController,
                                decoration: const InputDecoration(
                                    labelText: 'Cause of Death',
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 32),
                            const Text("Primary needs of barangay",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _need1Controller,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text("1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))))),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _need2Controller,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text("2",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))))),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _need3Controller,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text("3",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))))),
                            const SizedBox(height: 32),
                            const Text("Intend to stay five years from now",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _frBarangayController,
                                decoration: const InputDecoration(
                                    labelText: 'Intended Barangay',
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 12),
                            TextFormField(
                                controller: _frMunicipalityController,
                                decoration: const InputDecoration(
                                    labelText: 'Intended Municipality',
                                    border: OutlineInputBorder())),
                          ]),
                    ),
                  ),

                  // SURVEY INFO
                  const SizedBox(height: 40),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                                child: Text("SURVEY INFO",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1.2,
                                        color: Colors.blueGrey))),
                            const Divider(height: 32, thickness: 1),
                            Row(children: [
                              Expanded(
                                  child: TextFormField(
                                      controller: _visitNumController,
                                      decoration: const InputDecoration(
                                          labelText: 'Number of visits',
                                          border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: DropdownButtonFormField<
                                          BarangayPositions>(
                                      value: _selectedBrgyPosition,
                                      decoration: const InputDecoration(
                                          labelText: 'Barangay Position',
                                          border: OutlineInputBorder()),
                                      items: BarangayPositions.values
                                          .map((pos) => DropdownMenuItem(
                                              value: pos,
                                              child: Text(pos.name)))
                                          .toList(),
                                      onChanged: (val) => setState(
                                          () => _selectedBrgyPosition = val))),
                            ]),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<ClientTypes>(
                                value: _selectedClientType,
                                decoration: const InputDecoration(
                                    labelText: 'Client Type',
                                    border: OutlineInputBorder()),
                                items: ClientTypes.values
                                    .map((type) => DropdownMenuItem(
                                        value: type, child: Text(type.name)))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedClientType = val)),
                            const SizedBox(height: 16),
                            ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: const BorderSide(color: Colors.grey)),
                                title: const Text("Visit Date"),
                                subtitle: Text(_visitDate == null
                                    ? "Select Date"
                                    : _visitDate.toString().split(' ')[0]),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () async {
                                  final d = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  if (d != null) setState(() => _visitDate = d);
                                }),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<RegistrationStatus>(
                                value: _selectedRegistrationStatus,
                                decoration: const InputDecoration(
                                    labelText: 'Registration Status',
                                    border: OutlineInputBorder()),
                                items: RegistrationStatus.values
                                    .map((s) => DropdownMenuItem(
                                        value: s, child: Text(s.name)))
                                    .toList(),
                                onChanged: (val) => setState(
                                    () => _selectedRegistrationStatus = val),
                                validator: (val) => val == null
                                    ? 'Please select a status'
                                    : null),
                            const SizedBox(height: 16),
                            ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: const BorderSide(color: Colors.grey)),
                                title: const Text("Registration Date"),
                                subtitle: Text(_registrationDate == null
                                    ? "Select Date"
                                    : _registrationDate
                                        .toString()
                                        .split(' ')[0]),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () async {
                                  final d = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  if (d != null)
                                    setState(() => _registrationDate = d);
                                }),
                          ]),
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
                              borderRadius: BorderRadius.circular(8))),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("UPDATE HOUSEHOLD",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
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
          const SnackBar(content: Text("Please select a Head of Household")));
      return;
    }
    if (_selectedRegistrationStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select Registration Status")));
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final qProvider = context.read<QuestionLookupProvider>();
      final provider = context.read<HouseholdProvider>();

      try {
        // --- ADDRESS ---
        final addressCompanion = AddressesCompanion(
          zone:
              _Zone != null ? db.Value(_Zone) : db.Value(_zoneController.text),
          street: _Street != null
              ? db.Value(_Street)
              : db.Value(_streetController.text),
          block: _Block != null
              ? db.Value(_Block)
              : db.Value(_blockController.text),
          lot: _Lot != null ? db.Value(_Lot) : db.Value(_lotController.text),
        );

        if (_existingAddressId == null) {
          if (addressCompanion.zone.present ||
              addressCompanion.street.present ||
              addressCompanion.block.present ||
              addressCompanion.lot.present) {
            _existingAddressId = await provider.addAddress(addressCompanion);
          }
        } else {
          await provider.updateAddress(addressCompanion.copyWith(
              address_id: db.Value(_existingAddressId!)));
        }

        // --- MAIN HOUSEHOLD ---
        bool hasFm = _fmAgeController.text.isNotEmpty ||
            _fmCauseController.text.isNotEmpty;
        bool hasCm = _cmAgeController.text.isNotEmpty ||
            _cmCauseController.text.isNotEmpty;
        int memberCount = 1 + _addedMembers.length; // Head + Members

        final householdCompanion = HouseholdsCompanion(
          household_id: db.Value(widget.householdId),
          head: _selectedHead != null
              ? db.Value(
                  "${_selectedHead!.first_name} ${_selectedHead!.last_name}")
              : const db.Value.absent(),
          address_id: _existingAddressId != null
              ? db.Value(_existingAddressId!)
              : const db.Value.absent(),
          household_type_id: _selectedHouseholdType != null
              ? db.Value(_selectedHouseholdType!)
              : const db.Value.absent(),
          building_type_id: db.Value(_selectedBuildingTypeId),
          ownership_type_id: _selectedOwnershipType != null
              ? db.Value(_selectedOwnershipType!)
              : const db.Value.absent(),
          registration_status: db.Value(_selectedRegistrationStatus!),
          registration_date: db.Value(_registrationDate),
          female_mortality: db.Value(hasFm),
          child_mortality: db.Value(hasCm),
          household_members_num: db.Value(memberCount),
        );

        await provider.updateHousehold(householdCompanion);

        // --- MEMBERS & RELATIONSHIPS ---

        // 1. Remove deleted members (Cascade delete should handle relationship rows)
        for (var p in _removedMembers) {
          await provider.deleteHouseholdMember(widget.householdId, p.person_id);
        }

        // 2. Process Current Members
        await provider.getAllHouseholdMembers();

        for (var m in _addedMembers) {
          final person = m['person'] as PersonData;
          final int? relId = m['relationship_id'];
          final int? relPk = m['rel_pk'];

          // A. Ensure Member Link Exists
          bool exists = provider.allHouseholdMembers.any((dbm) =>
              dbm.household_id == widget.householdId &&
              dbm.person_id == person.person_id);

          if (!exists) {
            await provider.addHouseholdMember(HouseholdMembersCompanion(
                household_id: db.Value(widget.householdId),
                person_id: db.Value(person.person_id)));
          }

          // B. Handle Relationship Logic
          if (relPk != null) {
            // Existing Relationship Record: Update or Delete?
            if (relId != null) {
              // Update
              await provider.updateHouseholdRelationship(
                  HouseholdRelationshipsCompanion(
                      household_relationship_id: db.Value(relPk),
                      relationship_id: db.Value(relId)));
            } else {
              // User cleared relationship -> Delete record
              // Assuming you have a delete method, otherwise ignore
              // await provider.deleteHouseholdRelationship(relPk);
            }
          } else {
            // No Existing Record: Insert new if ID selected
            if (relId != null) {
              await provider.addHouseholdRelationship(
                  HouseholdRelationshipsCompanion(
                      household_id: db.Value(widget.householdId),
                      person_id: db.Value(person.person_id),
                      relationship_id: db.Value(relId)));
            }
          }
        }

        // --- SERVICES ---
        await provider.getAllServices();
        bool hasServiceData =
            _selectedClientType != null || _visitNumController.text.isNotEmpty;
        if (_existingServiceId == null) {
          final freshList = provider.allServices
              .where((s) => s.household_id == widget.householdId)
              .toList();
          if (freshList.isNotEmpty)
            _existingServiceId = freshList.first.service_id;
        }
        if (_existingServiceId != null) {
          await provider.updateService(ServicesCompanion(
              service_id: db.Value(_existingServiceId!),
              household_id: db.Value(widget.householdId),
              service: const db.Value("Service"),
              client_type_id: db.Value(_selectedClientType),
              ave_client_num:
                  db.Value(int.tryParse(_visitNumController.text))));
        } else if (hasServiceData) {
          await provider.addService(ServicesCompanion(
              household_id: db.Value(widget.householdId),
              service: const db.Value("Service"),
              client_type_id: db.Value(_selectedClientType),
              ave_client_num:
                  db.Value(int.tryParse(_visitNumController.text))));
        }

        // --- VISITS ---
        await provider.getAllHouseholdVisits();
        if (_existingVisitId == null) {
          final freshList = provider.allHouseholdVisits
              .where((v) => v.household_id == widget.householdId)
              .toList();
          if (freshList.isNotEmpty)
            _existingVisitId = freshList.first.household_visit_id;
        }
        if (_existingVisitId != null) {
          await provider.updateHouseholdVisit(HouseholdVisitsCompanion(
              household_visit_id: db.Value(_existingVisitId!),
              household_id: db.Value(widget.householdId),
              visit_num: db.Value(int.tryParse(_visitNumController.text)),
              brgy_position: db.Value(_selectedBrgyPosition!),
              visit_date: db.Value(_visitDate)));
        } else if (_selectedBrgyPosition != null) {
          await provider.addHouseholdVisit(HouseholdVisitsCompanion(
              household_id: db.Value(widget.householdId),
              visit_num: db.Value(int.tryParse(_visitNumController.text)),
              brgy_position: db.Value(_selectedBrgyPosition!),
              visit_date: db.Value(_visitDate)));
        }

        // --- NEEDS ---
        Future<void> handleNeed(int priority, String text) async {
          if (_existingNeedIds.containsKey(priority)) {
            await provider.updatePrimaryNeed(PrimaryNeedsCompanion(
                primary_need_id: db.Value(_existingNeedIds[priority]!),
                household_id: db.Value(widget.householdId),
                need: db.Value(text)));
          } else if (text.isNotEmpty) {
            await provider.addPrimaryNeed(PrimaryNeedsCompanion(
                household_id: db.Value(widget.householdId),
                need: db.Value(text),
                priority: db.Value(priority)));
          }
        }

        await handleNeed(1, _need1Controller.text);
        await handleNeed(2, _need2Controller.text);
        await handleNeed(3, _need3Controller.text);

        // --- MORTALITY ---
        await provider.getAllFemaleMortalities();
        await provider.getAllChildMortalities();
        if (hasFm && _existingFemaleMortalityId == null) {
          final fresh = provider.allFemaleMortalities
              .where((x) => x.household_id == widget.householdId)
              .toList();
          if (fresh.isNotEmpty)
            _existingFemaleMortalityId = fresh.first.female_mortality_id;
        }
        if (hasFm) {
          if (_existingFemaleMortalityId != null) {
            await provider.updateFemaleMortality(FemaleMortalitiesCompanion(
                female_mortality_id: db.Value(_existingFemaleMortalityId!),
                household_id: db.Value(widget.householdId),
                age: db.Value(int.tryParse(_fmAgeController.text)),
                death_cause: db.Value(_fmCauseController.text)));
          } else {
            await provider.addFemaleMortality(FemaleMortalitiesCompanion(
                household_id: db.Value(widget.householdId),
                age: db.Value(int.tryParse(_fmAgeController.text)),
                death_cause: db.Value(_fmCauseController.text)));
          }
        }
        if (hasCm && _existingChildMortalityId == null) {
          final fresh = provider.allChildMortalities
              .where((x) => x.household_id == widget.householdId)
              .toList();
          if (fresh.isNotEmpty)
            _existingChildMortalityId = fresh.first.child_mortality_id;
        }
        if (hasCm) {
          if (_existingChildMortalityId != null) {
            await provider.updateChildMortality(ChildMortalitiesCompanion(
                child_mortality_id: db.Value(_existingChildMortalityId!),
                household_id: db.Value(widget.householdId),
                age: db.Value(int.tryParse(_cmAgeController.text)),
                sex: db.Value(_cmSex),
                death_cause: db.Value(_cmCauseController.text)));
          } else {
            await provider.addChildMortality(ChildMortalitiesCompanion(
                household_id: db.Value(widget.householdId),
                age: db.Value(int.tryParse(_cmAgeController.text)),
                sex: db.Value(_cmSex),
                death_cause: db.Value(_cmCauseController.text)));
          }
        }

        // --- RESIDENCY ---
        await provider.getAllFutureResidencies();
        if ((_frBarangayController.text.isNotEmpty ||
                _frMunicipalityController.text.isNotEmpty) &&
            _existingFutureResidencyId == null) {
          final fresh = provider.allFutureResidencies
              .where((x) => x.household_id == widget.householdId)
              .toList();
          if (fresh.isNotEmpty)
            _existingFutureResidencyId = fresh.first.future_residency_id;
        }
        if (_frBarangayController.text.isNotEmpty ||
            _frMunicipalityController.text.isNotEmpty) {
          if (_existingFutureResidencyId != null) {
            await provider.updateFutureResidency(FutureResidenciesCompanion(
                future_residency_id: db.Value(_existingFutureResidencyId!),
                household_id: db.Value(widget.householdId),
                barangay: db.Value(_frBarangayController.text),
                municipality: db.Value(_frMunicipalityController.text)));
          } else {
            await provider.addFutureResidency(FutureResidenciesCompanion(
                household_id: db.Value(widget.householdId),
                barangay: db.Value(_frBarangayController.text),
                municipality: db.Value(_frMunicipalityController.text)));
          }
        }

        // --- UTILITIES ---
        for (var entry in _utilityAnswers.entries) {
          int qId = entry.key;
          int? choiceId = entry.value;
          int? existingResponseId = _existingResponseIds[qId];
          if (choiceId != null) {
            final companion = HouseholdResponsesCompanion(
              response_id: existingResponseId != null
                  ? db.Value(existingResponseId)
                  : const db.Value.absent(),
              household_id: db.Value(widget.householdId),
              question_id: db.Value(qId),
              choice_id: db.Value(choiceId),
            );
            if (existingResponseId != null) {
              await qProvider.updateHouseholdResponse(companion);
            } else {
              await qProvider.addHouseholdResponse(companion);
            }
          } else if (existingResponseId != null) {
            await qProvider.deleteHouseholdResponse(existingResponseId);
          }
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error saving: $e")));
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
}
