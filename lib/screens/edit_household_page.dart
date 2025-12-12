import 'package:brims/database/app_db.dart';
import 'package:brims/database/tables/extensions.dart'; // Ensure .label extension is imported
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

class EditHouseholdPage extends StatefulWidget {
  final int householdId;

  const EditHouseholdPage({super.key, required this.householdId});

  @override
  State<EditHouseholdPage> createState() => _EditHouseholdPageState();
}

class _EditHouseholdPageState extends State<EditHouseholdPage> {
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
  static const Color actionGreen = Color(0xFF00C853);

  // --- Styles ---
  InputDecoration _inputDecoration(String label, {Color? fillColor}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: primaryText.withOpacity(0.8)),
      hintStyle: GoogleFonts.poppins(color: secondaryText.withOpacity(0.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
      fillColor: fillColor ?? primaryBackground,
    );
  }

  // Helper for Section Headers
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2,
                color: navBackgroundDark)),
        const Divider(thickness: 1.5, color: dividerColor, height: 24),
        const SizedBox(height: 10),
      ],
    );
  }

  // Helper for Date Pickers
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
  Widget _buildCardHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2,
                color: navBackgroundDark)),
        const Divider(thickness: 1.5, color: dividerColor, height: 24),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final householdProvider = context.watch<HouseholdProvider>();
    final householdLookupProvider = context.watch<HouseholdLookupProvider>();
    final questionProvider = context.watch<QuestionLookupProvider>();

    if (_isLoading) {
      return Scaffold(
          backgroundColor: primaryBackground,
          appBar: AppBar(
            title: Text("Edit Household",
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
          body: Center(
              child: CircularProgressIndicator(color: navBackgroundDark)));
    }
    int totalMembers = (_selectedHead != null ? 1 : 0) + _addedMembers.length;

    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Text("Edit Household",
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
                  // CARD 1: HEAD AND MEMBERS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader("Head of Household"),
                        if (_selectedHead == null) ...[
                          TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _headSearchController,
                            decoration: _inputDecoration("Search New Head"),
                            onChanged: _searchHead,
                          ),
                          if (_showHeadResults)
                            Container(
                              height: 200,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                  color: cardBackground,
                                  border: Border.all(color: dividerColor),
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
                                side: BorderSide(color: navBackground),
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: navBackgroundDark,
                                  child: const Icon(Icons.star,
                                      color: Colors.white)),
                              title: Text(
                                  "${_selectedHead!.first_name} ${_selectedHead!.last_name}",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: primaryText)),
                              subtitle: Text("Current Head",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText)),
                              trailing: IconButton(
                                  icon: Icon(Icons.change_circle,
                                      color: navBackgroundDark),
                                  onPressed: () =>
                                      setState(() => _selectedHead = null)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Household Members",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: primaryText)),
                              Chip(
                                  backgroundColor:
                                      navBackground.withOpacity(0.1),
                                  label: Text("Total: $totalMembers",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: navBackgroundDark)))
                            ]),
                        const SizedBox(height: 10),
                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          controller: _memberSearchController,
                          decoration: _inputDecoration("Add Member"),
                          onChanged: _searchMember,
                        ),
                        if (_showMemberResults)
                          Container(
                            height: 200,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                                color: cardBackground,
                                border: Border.all(color: dividerColor),
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
                                  trailing: const Icon(Icons.add_circle,
                                      color: actionGreen),
                                  onTap: () {
                                    setState(() {
                                      _addedMembers.add({
                                        'person': person,
                                        'relationship_id': null,
                                        'rel_pk': null
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
                            separatorBuilder: (ctx, i) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final memberMap = _addedMembers[index];
                              final person = memberMap['person'] as PersonData;
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: primaryBackground,
                                    border: Border.all(color: dividerColor),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Icon(Icons.person,
                                        size: 24, color: navBackgroundDark),
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
                                            .map((r) => DropdownMenuItem(
                                                value: r.relationship_id,
                                                child: Text(r.relationship,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: primaryText))))
                                            .toList(),
                                        onChanged: (val) => setState(() =>
                                            _addedMembers[index]
                                                ['relationship_id'] = val),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
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
                      ],
                    ),
                  ),

                  // CARD 2: ADDRESS AND DETAILS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader("Location & Details"),

                        // Address Fields
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _zoneController,
                            decoration: _inputDecoration('Zone')),
                        const SizedBox(height: 16),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _streetController,
                            decoration: _inputDecoration('Street')),
                        const SizedBox(height: 16),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _blockController,
                            decoration: _inputDecoration('Block')),
                        const SizedBox(height: 16),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _lotController,
                            decoration: _inputDecoration('Lot')),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            final provider = context.read<HouseholdProvider>();
                            setState(() {
                              _searchedAddress = [];
                              _noResults = false;
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
                                    : null);
                            setState(() {
                              _searchedAddress = results;
                              _noResults = results.isEmpty;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navBackgroundDark,
                            foregroundColor: Colors.white,
                          ),
                          label: Text("Search Address",
                              style: GoogleFonts.poppins()),
                        ),
                        // Address Search Results Logic (Simplified)
                        if (_noResults)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("No address found. Using entered data.",
                                style: GoogleFonts.poppins(
                                    color: Colors.orange.shade700)),
                          ),
                        const SizedBox(height: 24),

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

                  // CARD 3: UTILITIES
                  if (questionProvider.allQuestions.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCardHeader("Utilities"),
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
                                    style:
                                        GoogleFonts.poppins(color: primaryText),
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
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                  // CARD 4: COMMUNITY & MORTALITY
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader("Community & Mortality"),
                        Text("Female Mortality (Last 6 months)",
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
                        Text("Child Mortality (Age 0-5, Last 6 months)",
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
                                  controller: _cmAgeController,
                                  decoration: _inputDecoration('Age'),
                                  keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: DropdownButtonFormField<Sex>(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
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
                                  onChanged: (val) =>
                                      setState(() => _cmSex = val))),
                        ]),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _cmCauseController,
                            decoration: _inputDecoration('Cause of Death')),
                        const SizedBox(height: 32),
                        Text("Primary Needs of Barangay (Top 3)",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryText)),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _need1Controller,
                            decoration: _inputDecoration('Priority 1')),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _need2Controller,
                            decoration: _inputDecoration('Priority 2')),
                        const SizedBox(height: 12),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _need3Controller,
                            decoration: _inputDecoration('Priority 3')),
                        const SizedBox(height: 32),
                        Text("Future Residency (5 Years)",
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

                  // CARD 5: SURVEY INFO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader("Survey Info"),
                        TextFormField(
                            style: GoogleFonts.poppins(color: primaryText),
                            controller: _visitNumController,
                            decoration: _inputDecoration('Number of visits'),
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<BarangayPositions>(
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
                                setState(() => _selectedBrgyPosition = val)),
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
                                setState(() => _selectedClientType = val)),
                        const SizedBox(height: 16),
                        // Visit Date
                        Row(children: [
                          Text("Visit Date: ",
                              style: GoogleFonts.poppins(
                                  color: primaryText.withOpacity(0.8))),
                          Text(_visitDate?.toString().split(' ')[0] ?? "N/A",
                              style: GoogleFonts.poppins(color: primaryText)),
                          const Spacer(),
                          ElevatedButton.icon(
                              onPressed: () => _pickDate(
                                  context: context,
                                  currentValue: _visitDate,
                                  onDatePicked: (d) =>
                                      setState(() => _visitDate = d)),
                              icon: const Icon(Icons.calendar_today),
                              label: const Text("Select")),
                        ]),
                        const SizedBox(height: 16),
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
                            onChanged: (val) => setState(
                                () => _selectedRegistrationStatus = val),
                            validator: (val) =>
                                val == null ? 'Please select a status' : null),
                        const SizedBox(height: 16),
                        // Registration Date
                        Row(children: [
                          Text("Registration Date: ",
                              style: GoogleFonts.poppins(
                                  color: primaryText.withOpacity(0.8))),
                          Text(
                              _registrationDate?.toString().split(' ')[0] ??
                                  "N/A",
                              style: GoogleFonts.poppins(color: primaryText)),
                          const Spacer(),
                          ElevatedButton.icon(
                              onPressed: () => _pickDate(
                                  context: context,
                                  currentValue: _registrationDate,
                                  onDatePicked: (d) =>
                                      setState(() => _registrationDate = d)),
                              icon: const Icon(Icons.calendar_today),
                              label: const Text("Select")),
                        ]),
                      ],
                    ),
                  ),

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
                        onPressed: _isSaving ? null : _updateHousehold,
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
                            : Text("UPDATE HOUSEHOLD",
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
