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
import 'package:google_fonts/google_fonts.dart';
import '../database/tables/enums.dart';

class AddHouseholdPage extends StatefulWidget {
  const AddHouseholdPage({super.key});

  @override
  State<AddHouseholdPage> createState() => _AddHouseholdPageState();
}

class _AddHouseholdPageState extends State<AddHouseholdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // --- Consistent Color Palette ---
  static const Color primaryBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color navBackground = Color(0xFF40C4FF);
  static const Color navBackgroundDark = Color(0xFF29B6F6);
  static const Color actionGreen = Color(0xFF00C853);
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color secondaryText = Color(0xFF555555);

  // --- Styles ---
  final BoxDecoration _cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  InputDecoration _inputDecoration(String label,
      {String? helper, Color? fillColor = const Color(0xFFFAFAFA)}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      labelStyle: GoogleFonts.poppins(color: primaryText.withOpacity(0.8)),
      hintStyle: GoogleFonts.poppins(color: secondaryText.withOpacity(0.5)),
      helperStyle: GoogleFonts.poppins(color: secondaryText.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: navBackground, width: 2),
      ),
      filled: true,
      fillColor: fillColor,
    );
  }

  // --- 1. HEAD & MEMBERS STATE ---
  PersonData? _selectedHead;
  final TextEditingController _headSearchController = TextEditingController();
  List<PersonData> _headSearchResults = [];
  bool _showHeadResults = false;

  // Stores: {'person': PersonData, 'relationship_id': int?}
  List<Map<String, dynamic>> _addedMembers = [];
  final TextEditingController _memberSearchController = TextEditingController();
  List<PersonData> _memberSearchResults = [];
  bool _showMemberResults = false;

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
      context.read<PersonProvider>().getAllPersons();

      final lookupProvider = context.read<HouseholdLookupProvider>();
      lookupProvider.getAllBuildingTypes();
      // Load relationship types from DB
      lookupProvider.getAllRelationshipTypes();

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

  // Helper for Date Pickers to ensure consistent style
  Future<void> _pickDate({
    required BuildContext context,
    required DateTime? currentValue,
    required ValueChanged<DateTime?> onDatePicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: navBackgroundDark,
              onPrimary: Colors.white,
              onSurface: primaryText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDatePicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final householdLookupProvider = context.watch<HouseholdLookupProvider>();
    final questionProvider = context.watch<QuestionLookupProvider>();
    int totalMembers = (_selectedHead != null ? 1 : 0) + _addedMembers.length;

    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Text(
          "Add Household",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
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
                  // --- 1. HEAD & MEMBERS CARD ---------------------------------
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Household Members",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: navBackgroundDark)),
                        const Divider(
                            height: 32, thickness: 1, color: secondaryText),

                        // Head Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Head of Household",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: primaryText)),
                            Chip(
                                backgroundColor: navBackground.withOpacity(0.1),
                                label: Text("Total: $totalMembers",
                                    style: GoogleFonts.poppins(
                                        color: navBackgroundDark,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (_selectedHead == null) ...[
                          TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _headSearchController,
                            decoration: _inputDecoration("Search Person"),
                            onChanged: _searchHead,
                          ),
                          if (_showHeadResults)
                            Container(
                              height: 200,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                  color: cardBackground,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListView.builder(
                                itemCount: _headSearchResults.length,
                                itemBuilder: (context, index) {
                                  final person = _headSearchResults[index];
                                  return ListTile(
                                    title: Text(
                                        "${person.first_name} ${person.last_name}",
                                        style: GoogleFonts.poppins(
                                            color: primaryText)),
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
                            color: navBackground.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: navBackgroundDark,
                                  child: const Icon(Icons.person,
                                      color: Colors.white)),
                              title: Text(
                                  "${_selectedHead!.first_name} ${_selectedHead!.last_name}",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: primaryText)),
                              subtitle: Text("Selected as Head",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText)),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    setState(() => _selectedHead = null),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Members Section
                        Text("Add Other Members",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryText)),
                        const SizedBox(height: 12),

                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          controller: _memberSearchController,
                          decoration: _inputDecoration(
                              "Search Person to Add to Household"),
                          onChanged: _searchMember,
                        ),
                        if (_showMemberResults)
                          Container(
                            height: 200,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                                color: cardBackground,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8)),
                            child: ListView.builder(
                              itemCount: _memberSearchResults.length,
                              itemBuilder: (context, index) {
                                final person = _memberSearchResults[index];
                                return ListTile(
                                  title: Text(
                                      "${person.first_name} ${person.last_name}",
                                      style: GoogleFonts.poppins(
                                          color: primaryText)),
                                  trailing: Icon(Icons.add_circle_outline,
                                      color: actionGreen),
                                  onTap: () {
                                    setState(() {
                                      // Initialize relationship_id as null
                                      _addedMembers.add({
                                        'person': person,
                                        'relationship_id': null
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

                        // Added Members List
                        if (_addedMembers.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _addedMembers.length,
                            separatorBuilder: (ctx, i) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final memberMap = _addedMembers[index];
                              final person = memberMap['person'] as PersonData;
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryBackground,
                                  border: Border.all(
                                      color: secondaryText.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 24, color: navBackground),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${person.first_name} ${person.last_name}",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color: primaryText))),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 3,
                                      child: DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        style: GoogleFonts.poppins(
                                            color: primaryText),
                                        dropdownColor: cardBackground,
                                        decoration: _inputDecoration("Relation",
                                            fillColor: cardBackground),
                                        value: memberMap['relationship_id'],
                                        items: householdLookupProvider
                                            .allRelationshipTypes
                                            .map((r) => DropdownMenuItem<int>(
                                                value: r.relationship_id,
                                                child: Text(r.relationship,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: primaryText))))
                                            .toList(),
                                        onChanged: (val) => setState(() =>
                                            _addedMembers[index]
                                                ['relationship_id'] = val),
                                        validator: (val) {
                                          if (val == null) {
                                            return "Required";
                                          }
                                          return null;
                                        },
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 2. ADDRESS & HOUSEHOLD INFO CARD -----------------------
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Location & Building Details",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: navBackgroundDark)),
                        const Divider(
                            height: 32, thickness: 1, color: secondaryText),

                        // Address Search Fields
                        Row(children: [
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _zoneController,
                                  decoration: _inputDecoration('Zone'))),
                          const SizedBox(width: 16),
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _streetController,
                                  decoration: _inputDecoration('Street'))),
                        ]),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _blockController,
                                  decoration: _inputDecoration('Block'))),
                          const SizedBox(width: 16),
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _lotController,
                                  decoration: _inputDecoration('Lot'))),
                        ]),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.saved_search),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navBackgroundDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          label: Text("Search Address",
                              style: GoogleFonts.poppins()),
                        ),

                        // Search Results Display
                        if (_noResults)
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(children: [
                                Text(
                                    "No address found. Use entered data as new address?",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
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
                                                    content: Text(
                                                        "New Address Set.")));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: actionGreen,
                                              foregroundColor: Colors.white),
                                          child: const Text("Yes")),
                                      const SizedBox(width: 10),
                                      OutlinedButton(
                                          onPressed: () => setState(
                                              () => _noResults = false),
                                          child: Text("No",
                                              style: GoogleFonts.poppins(
                                                  color: primaryText))),
                                    ])
                              ]))
                        else if (_searchedAddress.isNotEmpty)
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  border:
                                      Border.all(color: Colors.green.shade300),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Address Found:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: primaryText)),
                                    Text(
                                        "Zone: ${_searchedAddress[0]['address']['zone']} | Street: ${_searchedAddress[0]['address']['street']}",
                                        style: GoogleFonts.poppins(
                                            color: primaryText)),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _addressId = _searchedAddress[0]
                                                ['address']['id'];
                                            final addr =
                                                _searchedAddress[0]['address'];
                                            _zoneController.text = addr['zone'];
                                            _streetController.text =
                                                addr['street'];
                                            _blockController.text =
                                                addr['block'];
                                            _lotController.text = addr['lot'];
                                            _searchedAddress = [];
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Existing Address Selected")));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: actionGreen,
                                            foregroundColor: Colors.white),
                                        child: const Text("Use This Address")),
                                    TextButton(
                                        onPressed: () => setState(
                                            () => _searchedAddress = []),
                                        child: Text("Cancel Search",
                                            style: GoogleFonts.poppins(
                                                color: Colors.red)))
                                  ])),

                        const SizedBox(height: 40),

                        // Household Details
                        DropdownButtonFormField<HouseholdTypes>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedHouseholdType,
                          decoration: _inputDecoration('Household Type',
                              fillColor: cardBackground),
                          items: HouseholdTypes.values
                              .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name,
                                      style: GoogleFonts.poppins(
                                          color: primaryText))))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedHouseholdType = val),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedBuildingTypeId,
                          decoration: _inputDecoration('Building Type',
                              fillColor: cardBackground),
                          items: householdLookupProvider.allBuildingTypes
                              .map((type) => DropdownMenuItem(
                                  value: type.building_type_id,
                                  child: Text(type.type,
                                      style: GoogleFonts.poppins(
                                          color: primaryText))))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedBuildingTypeId = val),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<OwnershipTypes>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedOwnershipType,
                          decoration: _inputDecoration('Ownership Type',
                              fillColor: cardBackground),
                          items: OwnershipTypes.values
                              .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name,
                                      style: GoogleFonts.poppins(
                                          color: primaryText))))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedOwnershipType = val),
                        ),
                      ],
                    ),
                  ),

                  // --- 3. UTILITIES CARD (Dynamic Questions) ------------------
                  if (questionProvider.allQuestions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text("UTILITIES & INFRASTRUCTURE",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        letterSpacing: 1.2,
                                        color: navBackgroundDark))),
                            const Divider(
                                height: 32, thickness: 1, color: secondaryText),
                            ...questionProvider.allQuestions.map((q) {
                              final choices = questionProvider
                                  .getChoicesForQuestion(q.question_id);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(q.question,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: primaryText)),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<int>(
                                      style: GoogleFonts.poppins(
                                          color: primaryText),
                                      dropdownColor: cardBackground,
                                      decoration: _inputDecoration(
                                          "Select option",
                                          fillColor: cardBackground),
                                      value: _utilityAnswers[q.question_id],
                                      hint: Text("Select option",
                                          style: GoogleFonts.poppins(
                                              color: secondaryText)),
                                      items: choices.map((choice) {
                                        return DropdownMenuItem<int>(
                                          value: choice.choice_id,
                                          child: Text(choice.choice,
                                              style: GoogleFonts.poppins(
                                                  color: primaryText)),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _utilityAnswers[q.question_id] = val;
                                        });
                                      },
                                      validator: (val) {
                                        if (val == null) return "Required";
                                        return null;
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

                  // --- 4. COMMUNITY SECTION CARD ------------------------------
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text("COMMUNITY HEALTH & RESIDENCY",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 1.2,
                                    color: navBackgroundDark))),
                        const Divider(
                            height: 32, thickness: 1, color: secondaryText),

                        // Female Mortality
                        Text("Female Mortality (Last 6 Months)",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryText)),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _fmAgeController,
                                  decoration: _inputDecoration('Age'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _fmCauseController,
                                  decoration: _inputDecoration('Cause'))),
                        ]),
                        const SizedBox(height: 24),

                        // Child Mortality
                        Text("Child Mortality (Age < 5, Last 6 Months)",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryText)),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                              child: TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _cmAgeController,
                            decoration: _inputDecoration('Age (0-5)'),
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
                            style: GoogleFonts.poppins(color: primaryText),
                            dropdownColor: cardBackground,
                            value: _cmSex,
                            decoration: _inputDecoration('Sex',
                                fillColor: cardBackground),
                            items: Sex.values
                                .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.name,
                                        style: GoogleFonts.poppins(
                                            color: primaryText))))
                                .toList(),
                            onChanged: (val) => setState(() => _cmSex = val),
                          )),
                        ]),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _cmCauseController,
                            decoration: _inputDecoration('Cause of Death')),

                        const SizedBox(height: 32),

                        // Primary Needs
                        Text("Primary Needs of Barangay (Top 3)",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryText)),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _need1Controller,
                            decoration: _inputDecoration('Need 1',
                                helper: 'Highest Priority')),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _need2Controller,
                            decoration: _inputDecoration('Need 2')),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _need3Controller,
                            decoration: _inputDecoration('Need 3',
                                helper: 'Lowest Priority')),

                        const SizedBox(height: 32),

                        // Future Residency
                        Text("Intend to Stay in Barangay (5 Years)",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryText)),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _frBarangayController,
                            decoration: _inputDecoration('Intended Barangay')),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _frMunicipalityController,
                            decoration:
                                _inputDecoration('Intended Municipality')),
                      ],
                    ),
                  ),

                  // --- 5. SURVEY INFO SECTION CARD ----------------------------
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text("SURVEY & REGISTRY INFO",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 1.2,
                                    color: navBackgroundDark))),
                        const Divider(
                            height: 32, thickness: 1, color: secondaryText),

                        // Visit Info
                        Row(children: [
                          Expanded(
                              child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _visitNumController,
                                  decoration:
                                      _inputDecoration('Number of visits'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: DropdownButtonFormField<BarangayPositions>(
                            style: GoogleFonts.poppins(color: primaryText),
                            dropdownColor: cardBackground,
                            value: _selectedBrgyPosition,
                            decoration: _inputDecoration('Barangay Position',
                                fillColor: cardBackground),
                            items: BarangayPositions.values
                                .map((pos) => DropdownMenuItem(
                                    value: pos,
                                    child: Text(pos.name,
                                        style: GoogleFonts.poppins(
                                            color: primaryText))))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedBrgyPosition = val),
                          )),
                        ]),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<ClientTypes>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedClientType,
                          decoration: _inputDecoration('Client Type',
                              fillColor: cardBackground),
                          items: ClientTypes.values
                              .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name,
                                      style: GoogleFonts.poppins(
                                          color: primaryText))))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedClientType = val),
                        ),
                        const SizedBox(height: 16),

                        // Visit Date
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          tileColor: primaryBackground,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  color: secondaryText.withOpacity(0.2))),
                          title: Text("Visit Date",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: primaryText)),
                          subtitle: Text(
                              _visitDate == null
                                  ? "Select Date"
                                  : _visitDate.toString().split(' ')[0],
                              style: GoogleFonts.poppins(color: secondaryText)),
                          trailing: const Icon(Icons.calendar_today,
                              color: navBackgroundDark),
                          onTap: () async {
                            await _pickDate(
                                context: context,
                                currentValue: _visitDate,
                                onDatePicked: (d) =>
                                    setState(() => _visitDate = d));
                          },
                        ),
                        const SizedBox(height: 24),

                        // Registration Status
                        DropdownButtonFormField<RegistrationStatus>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedRegistrationStatus,
                          decoration: _inputDecoration('Registration Status',
                              fillColor: cardBackground),
                          items: RegistrationStatus.values
                              .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s.name,
                                      style: GoogleFonts.poppins(
                                          color: primaryText))))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedRegistrationStatus = val),
                          validator: (val) {
                            if (val == null)
                              return "Registration status is required.";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Registration Date
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          tileColor: primaryBackground,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  color: secondaryText.withOpacity(0.2))),
                          title: Text("Registration Date",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: primaryText)),
                          subtitle: Text(
                              _registrationDate == null
                                  ? "Select Date"
                                  : _registrationDate.toString().split(' ')[0],
                              style: GoogleFonts.poppins(color: secondaryText)),
                          trailing: const Icon(Icons.calendar_today,
                              color: navBackgroundDark),
                          onTap: () async {
                            await _pickDate(
                                context: context,
                                currentValue: _registrationDate,
                                onDatePicked: (d) =>
                                    setState(() => _registrationDate = d));
                          },
                        ),
                      ],
                    ),
                  ),

                  // SAVE BUTTON
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: _isSaving
                              ? [Colors.grey.shade400, Colors.grey.shade600]
                              : [navBackground, navBackgroundDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isSaving
                                ? Colors.transparent
                                : navBackgroundDark.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveHousehold,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          disabledBackgroundColor: Colors.transparent,
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text("SAVE HOUSEHOLD",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2)),
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

      // 3. Link Members & Relationships
      // A. Link Head (No explicit relationship type for head in UI, so just Member)
      await provider.addHouseholdMember(HouseholdMembersCompanion(
        person_id: db.Value(_selectedHead!.person_id),
        household_id: db.Value(newHouseholdId),
      ));

      // B. Link Other Members + Their Relationships
      for (var member in _addedMembers) {
        final person = member['person'] as PersonData;
        final relationId = member['relationship_id'] as int?;

        // 1. Add to Members Table
        await provider.addHouseholdMember(HouseholdMembersCompanion(
          person_id: db.Value(person.person_id),
          household_id: db.Value(newHouseholdId),
        ));

        // 2. Add to Relationships Table (NEW)
        if (relationId != null) {
          // ENSURE THIS METHOD EXISTS IN YOUR PROVIDER
          await provider
              .addHouseholdRelationship(HouseholdRelationshipsCompanion(
            person_id: db.Value(person.person_id),
            household_id: db.Value(newHouseholdId),
            relationship_id: db.Value(relationId),
          ));
        }
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
            priority: db.Value(1)));
      if (_need2Controller.text.isNotEmpty)
        await provider.addPrimaryNeed(PrimaryNeedsCompanion(
            household_id: db.Value(newHouseholdId),
            need: db.Value(_need2Controller.text),
            priority: db.Value(2)));
      if (_need3Controller.text.isNotEmpty)
        await provider.addPrimaryNeed(PrimaryNeedsCompanion(
            household_id: db.Value(newHouseholdId),
            need: db.Value(_need3Controller.text),
            priority: db.Value(3)));

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
