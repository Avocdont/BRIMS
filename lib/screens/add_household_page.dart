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

class AddHouseholdPage extends StatefulWidget {
  const AddHouseholdPage({super.key});

  @override
  State<AddHouseholdPage> createState() => _AddHouseholdPageState();
}

class _AddHouseholdPageState extends State<AddHouseholdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // --- 1. HEAD & MEMBERS STATE ---
  PersonData? _selectedHead;
  final TextEditingController _headSearchController = TextEditingController();
  List<PersonData> _headSearchResults = [];
  bool _showHeadResults = false;

  List<Map<String, dynamic>> _addedMembers = [];
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
    "Other"
  ];

  // --- 2. ADDRESS ---
  int? _addressId;
  final _zoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _blockController = TextEditingController();
  final _lotController = TextEditingController();

  // Variables to hold address state if user confirms "Use This Address" from search
  String? _Zone;
  String? _Street;
  String? _Block;
  String? _Lot;
  List<Map<String, dynamic>> _searchedAddress = [];
  bool _noResults = false;

  // --- 3. HOUSEHOLD INFO ---
  HouseholdTypes? _selectedHouseholdType;
  int? _selectedBuildingTypeId;
  OwnershipTypes? _selectedOwnershipType;

  // --- 4. COMMUNITY: MORTALITY ---
  final _fmAgeController = TextEditingController();
  final _fmCauseController = TextEditingController();

  final _cmAgeController = TextEditingController();
  final _cmCauseController = TextEditingController();
  Sex? _cmSex;

  // --- 5. COMMUNITY: PRIMARY NEEDS ---
  final _need1Controller = TextEditingController();
  final _need2Controller = TextEditingController();
  final _need3Controller = TextEditingController();

  // --- 6. COMMUNITY: RESIDENCY ---
  final _frBarangayController = TextEditingController();
  final _frMunicipalityController = TextEditingController();

  // --- 7. SURVEY INFO ---
  final _visitNumController = TextEditingController();
  BarangayPositions? _selectedBrgyPosition;
  ClientTypes? _selectedClientType;
  DateTime? _visitDate;

  RegistrationStatus? _selectedRegistrationStatus;
  DateTime? _registrationDate;

  // --- 8. UTILITIES (Dynamic Questions) ---
  final Map<int, int?> _utilityAnswers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HouseholdLookupProvider>().getAllBuildingTypes();
      context.read<PersonProvider>().getAllPersons();

      final qProvider = context.read<QuestionLookupProvider>();
      qProvider.getAllQuestions();
      qProvider.getAllQuestionChoices();
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
    _fmAgeController.dispose();
    _fmCauseController.dispose();
    _cmAgeController.dispose();
    _cmCauseController.dispose();
    _need1Controller.dispose();
    _need2Controller.dispose();
    _need3Controller.dispose();
    _frBarangayController.dispose();
    _frMunicipalityController.dispose();
    _visitNumController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final householdLookupProvider = context.watch<HouseholdLookupProvider>();
    final questionProvider = context.watch<QuestionLookupProvider>();
    int totalMembers = (_selectedHead != null ? 1 : 0) + _addedMembers.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Household"), centerTitle: true),
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
                  // --------------------------------------------------------
                  // 1. HEAD & MEMBERS
                  // --------------------------------------------------------
                  const Text("Head of Household",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),

                  if (_selectedHead == null) ...[
                    TextFormField(
                      controller: _headSearchController,
                      decoration: InputDecoration(
                        labelText: "Search Person",
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
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
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                            "${_selectedHead!.first_name} ${_selectedHead!.last_name}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text("Selected as Head"),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => setState(() => _selectedHead = null),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Household Members",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Chip(label: Text("Total: $totalMembers")),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _memberSearchController,
                    decoration: InputDecoration(
                      labelText: "Search Member to Add",
                      prefixIcon: const Icon(Icons.person_add),
                      border: const OutlineInputBorder(),
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
                            trailing: const Icon(Icons.add_circle_outline,
                                color: Colors.green),
                            onTap: () {
                              setState(() {
                                _addedMembers.add(
                                    {'person': person, 'relationship': null});
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
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                      labelText: "Relation",
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: OutlineInputBorder()),
                                  value: memberMap['relationship'],
                                  items: _relationshipTypes
                                      .map((r) => DropdownMenuItem(
                                          value: r,
                                          child: Text(r,
                                              style: const TextStyle(
                                                  fontSize: 14))))
                                      .toList(),
                                  onChanged: (val) => setState(() =>
                                      _addedMembers[index]['relationship'] =
                                          val),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () => setState(
                                    () => _addedMembers.removeAt(index)),
                              )
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),

                  // --------------------------------------------------------
                  // 2. ADDRESS & HOUSEHOLD INFO
                  // --------------------------------------------------------
                  const Text("Address Information",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),

                  // Address Inputs and Search Logic
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
                        _addressId = null;
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
                                        _addressId = null;
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
                                      _addressId =
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

                  const Text("Household Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
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

                  // --------------------------------------------------------
                  // 3. UTILITIES (Dynamic Questions) - MOVED HERE
                  // --------------------------------------------------------
                  if (questionProvider.allQuestions.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
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
                                        fontSize: 20,
                                        letterSpacing: 1.2))),
                            const Divider(height: 32, thickness: 1),
                            ...questionProvider.allQuestions.map((q) {
                              final choices = questionProvider
                                  .getChoicesForQuestion(q.question_id);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(q.question,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      value: _utilityAnswers[q.question_id],
                                      hint: const Text("Select option"),
                                      items: choices.map((choice) {
                                        return DropdownMenuItem<int>(
                                          value: choice.choice_id,
                                          child: Text(choice.choice),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _utilityAnswers[q.question_id] = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // --------------------------------------------------------
                  // 4. COMMUNITY SECTION (CARD)
                  // --------------------------------------------------------
                  const SizedBox(height: 40),
                  Card(
                    elevation: 2,
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
                                      fontSize: 20,
                                      letterSpacing: 1.2))),
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
                              },
                            )),
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
                              onChanged: (val) => setState(() => _cmSex = val),
                            )),
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
                        ],
                      ),
                    ),
                  ),

                  // --------------------------------------------------------
                  // 5. SURVEY INFO SECTION (CARD)
                  // --------------------------------------------------------
                  const SizedBox(height: 40),
                  Card(
                    elevation: 2,
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
                                      fontSize: 20,
                                      letterSpacing: 1.2))),
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
                                child:
                                    DropdownButtonFormField<BarangayPositions>(
                              value: _selectedBrgyPosition,
                              decoration: const InputDecoration(
                                  labelText: 'Barangay Position',
                                  border: OutlineInputBorder()),
                              items: BarangayPositions.values
                                  .map((pos) => DropdownMenuItem(
                                      value: pos, child: Text(pos.name)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedBrgyPosition = val),
                            )),
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
                                setState(() => _selectedClientType = val),
                          ),
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
                            },
                          ),
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
                          ),
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
                                : _registrationDate.toString().split(' ')[0]),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final d = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (d != null)
                                setState(() => _registrationDate = d);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // SAVE BUTTON
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveHousehold,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SAVE HOUSEHOLD",
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

  Future<void> _saveHousehold() async {
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

      final provider = context.read<HouseholdProvider>();
      final qProvider = context.read<QuestionLookupProvider>();

      // 1. Create Address
      if (_addressId == null) {
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
        if (addressCompanion.zone.present ||
            addressCompanion.street.present ||
            addressCompanion.block.present ||
            addressCompanion.lot.present) {
          _addressId = await provider.addAddress(addressCompanion);
        }
      }

      // 2. Create Household
      int totalMembers = 1 + _addedMembers.length;
      bool hasFm = _fmAgeController.text.isNotEmpty ||
          _fmCauseController.text.isNotEmpty;
      bool hasCm = _cmAgeController.text.isNotEmpty ||
          _cmCauseController.text.isNotEmpty;

      final householdCompanion = HouseholdsCompanion(
        head: db.Value(
            "${_selectedHead!.first_name} ${_selectedHead!.last_name}"),
        address_id: _addressId != null
            ? db.Value(_addressId!)
            : const db.Value.absent(),
        household_type_id: _selectedHouseholdType != null
            ? db.Value(_selectedHouseholdType!)
            : const db.Value.absent(),
        building_type_id: db.Value(_selectedBuildingTypeId),
        ownership_type_id: _selectedOwnershipType != null
            ? db.Value(_selectedOwnershipType!)
            : const db.Value.absent(),
        household_members_num: db.Value(totalMembers),
        registration_date: db.Value(_registrationDate),
        registration_status: db.Value(_selectedRegistrationStatus!),
        female_mortality: db.Value(hasFm),
        child_mortality: db.Value(hasCm),
      );

      final newHouseholdId = await provider.addHousehold(householdCompanion);

      // 3. Link Members
      await provider.addHouseholdMember(HouseholdMembersCompanion(
        person_id: db.Value(_selectedHead!.person_id),
        household_id: db.Value(newHouseholdId),
      ));
      for (var member in _addedMembers) {
        final person = member['person'] as PersonData;
        await provider.addHouseholdMember(HouseholdMembersCompanion(
          person_id: db.Value(person.person_id),
          household_id: db.Value(newHouseholdId),
        ));
      }

      // 4. Save Sub-tables
      if (_selectedClientType != null || _visitNumController.text.isNotEmpty) {
        await provider.addService(ServicesCompanion(
          household_id: db.Value(newHouseholdId),
          client_type_id: db.Value(_selectedClientType),
          ave_client_num: db.Value(int.tryParse(_visitNumController.text)),
        ));
      }

      if (_need1Controller.text.isNotEmpty)
        await provider.addPrimaryNeed(PrimaryNeedsCompanion(
            household_id: db.Value(newHouseholdId),
            need: db.Value(_need1Controller.text),
            priority: const db.Value(1)));
      if (_need2Controller.text.isNotEmpty)
        await provider.addPrimaryNeed(PrimaryNeedsCompanion(
            household_id: db.Value(newHouseholdId),
            need: db.Value(_need2Controller.text),
            priority: const db.Value(2)));
      if (_need3Controller.text.isNotEmpty)
        await provider.addPrimaryNeed(PrimaryNeedsCompanion(
            household_id: db.Value(newHouseholdId),
            need: db.Value(_need3Controller.text),
            priority: const db.Value(3)));

      if (hasFm) {
        await provider.addFemaleMortality(FemaleMortalitiesCompanion(
          household_id: db.Value(newHouseholdId),
          age: db.Value(int.tryParse(_fmAgeController.text)),
          death_cause: db.Value(_fmCauseController.text),
        ));
      }

      if (hasCm) {
        await provider.addChildMortality(ChildMortalitiesCompanion(
          household_id: db.Value(newHouseholdId),
          age: db.Value(int.tryParse(_cmAgeController.text)),
          sex: db.Value(_cmSex),
          death_cause: db.Value(_cmCauseController.text),
        ));
      }

      if (_frBarangayController.text.isNotEmpty ||
          _frMunicipalityController.text.isNotEmpty) {
        await provider.addFutureResidency(FutureResidenciesCompanion(
          household_id: db.Value(newHouseholdId),
          barangay: db.Value(_frBarangayController.text),
          municipality: db.Value(_frMunicipalityController.text),
        ));
      }

      if (_selectedBrgyPosition != null) {
        await provider.addHouseholdVisit(HouseholdVisitsCompanion(
          household_id: db.Value(newHouseholdId),
          visit_num: db.Value(int.tryParse(_visitNumController.text)),
          brgy_position: db.Value(_selectedBrgyPosition!),
          visit_date: db.Value(_visitDate),
        ));
      }

      // 5. SAVE UTILITIES (Dynamic)
      for (var entry in _utilityAnswers.entries) {
        if (entry.value != null) {
          await qProvider.addHouseholdResponse(HouseholdResponsesCompanion(
            household_id: db.Value(newHouseholdId),
            question_id: db.Value(entry.key),
            choice_id: db.Value(entry.value!),
          ));
        }
      }

      setState(() => _isSaving = false);
      if (mounted) Navigator.pop(context);
    }
  }
}
