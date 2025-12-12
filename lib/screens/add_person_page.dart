import 'package:brims/database/app_db.dart';
import 'package:brims/database/tables/extensions.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/citizen_registry_provider.dart';
import 'package:brims/provider/profiling%20providers/contact_info_provider.dart';
import 'package:brims/provider/profiling%20providers/occupation_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;
import 'package:google_fonts/google_fonts.dart'; // Added for consistent typography
import '../database/tables/enums.dart';
import '../provider/household providers/household_lookup_provider.dart';
import '../provider/profiling providers/profile_lookup_provider.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? personId;

  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background
  static const Color cardBackground =
      Color(0xFFFFFFFF); // White cards/dropdown background
  static const Color navBackground = Color(0xFF40C4FF);
  static const Color navBackgroundDark = Color(0xFF29B6F6); // Accent color
  static const Color actionGreen = Color(0xFF00C853);
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
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

  // --- 1. Capitalization Helper ---
  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  Future<void> pickDate({
    required BuildContext context,
    required DateTime? currentValue,
    required ValueChanged<DateTime?> onDatePicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: DateTime(1900),
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

  // Insert to person table
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _suffixController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _residencyYearsController = TextEditingController();
  TextEditingController _birthPlaceController = TextEditingController();
  TextEditingController _registrationPlaceController = TextEditingController();
  DateTime? _birthDate;
  DateTime? _deathDate;

  int? _yearsOfResidency;
  int? _selectedReligionId;
  int? _selectedNationalityId;
  int? _selectedEthnicityId;
  int? _selectedBloodTypeId;
  int? _selectedEducationId;
  int? _selectedMonthlyIncomeId;
  int? _selectedDailyIncomeId;

  bool? _selectedOfw;
  bool? _selectedLiterate;
  bool? _selectedPwd;
  bool? _selectedRegisteredVoter;
  bool? _selectedDeceased;
  // Enums
  Sex? _selectedSex;
  CivilStatus? _selectedCivilStatus;
  Residency? _selectedResidency;
  SoloParent? _selectedSoloParent;
  CurrentlyEnrolled? _selectedCurrentlyEnrolled;
  RegistrationStatus? _selectedRegistrationStatus;
  Transient? _selectedTransient;

  // Insert to address table
  List<Map<String, dynamic>> _searchedAddress = [];

  bool _noResults = false;
  TextEditingController _zoneController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _blockController = TextEditingController();
  TextEditingController _lotController = TextEditingController();

  int? _addressId;
  String? _Zone;
  String? _Street;
  String? _Block;
  String? _Lot;

  // Insert to email table
  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  TextEditingController _emailController = TextEditingController();

  // Insert to phone number table
  final _ph09Regex = RegExp(r'^09\d{9}$');
  TextEditingController _phoneNumberController = TextEditingController();

  // Insert to occupation table
  bool? _hasOccupation;
  TextEditingController _occupationController = TextEditingController();
  OccupationStatus? _selectedOccupationStatus;
  OccupationType? _selectedOccupationType;

  // Insert to gadgets table
  List<Gadget> _selectedGadgets = [];

  // Insert to voter registries table
  TextEditingController _placeOfVoteRegistryController =
      TextEditingController();

  int? _checkAge; // Insert to age of person table
  // Insert to registered senior citizen table
  bool _isSeniorCitizen = false;
  bool _registeredSeniorCitizen = false;

  // Insert to disability table
  TextEditingController _disabilityNameController = TextEditingController();
  TextEditingController _disabilityTypeController = TextEditingController();

  // Insert to enrolled table
  TextEditingController _enrolledAtController = TextEditingController();

  // Insert to CTC Records
  TextEditingController _issueNumController = TextEditingController();
  TextEditingController _placeOfIssueController = TextEditingController();
  DateTime? _issueDate;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _suffixController.dispose();
    _ageController.dispose();
    _residencyYearsController.dispose();
    _birthPlaceController.dispose();
    _registrationPlaceController.dispose();
    _zoneController.dispose();
    _streetController.dispose();
    _blockController.dispose();
    _lotController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _occupationController.dispose();
    _placeOfVoteRegistryController.dispose();
    _disabilityNameController.dispose();
    _disabilityTypeController.dispose();
    _enrolledAtController.dispose();
    _issueNumController.dispose();
    _placeOfIssueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = context.watch<PersonProvider>();
    final citizenRegistryProvider = context.watch<CitizenRegistryProvider>();
    final occupationProvider = context.watch<OccupationProvider>();
    final contactInfoProvider = context.watch<ContactInfoProvider>();
    final profileLookupProvder = context.watch<ProfileLookupProvider>();
    final householdProvider = context.watch<HouseholdProvider>();

    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Text(
          "Add Person",
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
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 1000), // Max width constraint
            child: Form(
              key: _formKey,
              child: Column(
                // Note: Removed the redundant Container wraps around every field/section
                children: [
                  // --- PERSONAL INFORMATION CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Personal Information",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: primaryText),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Last name cannot be empty.";
                                  }
                                  if (RegExp(r'[0-9]').hasMatch(value)) {
                                    return "Last name cannot contain numbers";
                                  }
                                },
                                controller: _lastNameController,
                                decoration: _inputDecoration("Last Name",
                                    helper: "Must not be blank"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: primaryText),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "First name cannot be empty.";
                                  }
                                  if (RegExp(r'[0-9]').hasMatch(value)) {
                                    return "First name cannot contain numbers";
                                  }
                                },
                                controller: _firstNameController,
                                decoration: _inputDecoration("First Name",
                                    helper: "Must not be blank"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: primaryText),
                                validator: (value) {
                                  if (RegExp(r'[0-9]').hasMatch(value!)) {
                                    return "Middle name cannot contain numbers";
                                  }
                                },
                                controller: _middleNameController,
                                decoration: _inputDecoration("Middle Name",
                                    helper: "Optional"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: primaryText),
                                validator: (value) {
                                  if (RegExp(r'[0-9]').hasMatch(value!)) {
                                    return "Suffix cannot contain numbers";
                                  }
                                },
                                controller: _suffixController,
                                decoration: _inputDecoration("Suffix",
                                    helper: "e.g. Sr., Jr."),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Age & Sex Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: primaryText),
                                validator: (value) {
                                  if (RegExp(r'[a-zA-Z]').hasMatch(value!))
                                    return "No letters";
                                  final int? age = int.tryParse(value);
                                  if (age != null && age < 0)
                                    return "Not negative";
                                },
                                controller: _ageController,
                                decoration: _inputDecoration("Age"),
                                onChanged: (text) {
                                  setState(() {
                                    _checkAge = int.tryParse(text);
                                    if (_checkAge != null && _checkAge! >= 60) {
                                      _isSeniorCitizen = true;
                                    } else {
                                      _isSeniorCitizen = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Sex",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: primaryText)),
                                  Wrap(
                                    spacing: 10,
                                    children: Sex.values.map((val) {
                                      return SizedBox(
                                        width: 120,
                                        child: RadioListTile<Sex>(
                                          title: Text(val.label,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: primaryText)),
                                          value: val,
                                          groupValue: _selectedSex,
                                          activeColor: navBackground,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedSex = value;
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Senior Citizen Logic
                        if (_isSeniorCitizen)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.orange.shade200)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Registered Senior Citizen?",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: primaryText)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: Text("Yes",
                                            style: GoogleFonts.poppins(
                                                color: primaryText)),
                                        value: true,
                                        groupValue: _registeredSeniorCitizen,
                                        activeColor: Colors.orange,
                                        onChanged: (value) => setState(() =>
                                            _registeredSeniorCitizen = value!),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<bool>(
                                        title: Text("No",
                                            style: GoogleFonts.poppins(
                                                color: primaryText)),
                                        value: false,
                                        groupValue: _registeredSeniorCitizen,
                                        activeColor: Colors.orange,
                                        onChanged: (value) => setState(() =>
                                            _registeredSeniorCitizen = value!),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Birth Date",
                                      style: GoogleFonts.poppins(
                                          color: primaryText)),
                                  const SizedBox(height: 5),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.calendar_today,
                                        size: 18),
                                    label: Text(
                                        _birthDate == null
                                            ? "Select Date"
                                            : "${_birthDate!.month}/${_birthDate!.day}/${_birthDate!.year}",
                                        style: GoogleFonts.poppins()),
                                    onPressed: () async {
                                      await pickDate(
                                        context: context,
                                        currentValue: _birthDate,
                                        onDatePicked: (d) =>
                                            setState(() => _birthDate = d),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: navBackground,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: primaryText),
                                controller: _birthPlaceController,
                                decoration: _inputDecoration("Birth Place"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Civil Status
                        Text("Civil Status",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          children: CivilStatus.values.map((g) {
                            return SizedBox(
                              width: 140,
                              child: RadioListTile<CivilStatus>(
                                title: Text(g.label,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: primaryText)),
                                value: g,
                                groupValue: _selectedCivilStatus,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCivilStatus = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Religion
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedReligionId,
                          items:
                              profileLookupProvder.allReligions.map((religion) {
                            return DropdownMenuItem<int>(
                              value: religion.religion_id,
                              child: Text(
                                religion.name,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedReligionId = value;
                            });
                          },
                          decoration: _inputDecoration("Religion",
                              fillColor: cardBackground),
                        ),
                        const SizedBox(height: 16),
                        // Nationality
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedNationalityId,
                          items: profileLookupProvder.allNationalities.map((
                            nationality,
                          ) {
                            return DropdownMenuItem<int>(
                              value: nationality.nationality_id,
                              child: Text(
                                nationality.name,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedNationalityId = value;
                            });
                          },
                          decoration: _inputDecoration("Nationality",
                              fillColor: cardBackground),
                        ),
                        const SizedBox(height: 16),
                        // Ethnicity
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedEthnicityId,
                          items: profileLookupProvder.allEthnicities
                              .map((ethnicity) {
                            return DropdownMenuItem<int>(
                              value: ethnicity.ethnicity_id,
                              child: Text(
                                ethnicity.name,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedEthnicityId = value;
                            });
                          },
                          decoration: _inputDecoration("Ethnicity",
                              fillColor: cardBackground),
                        ),
                        const SizedBox(height: 16),
                        // Blood Type
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedBloodTypeId,
                          items: profileLookupProvder.allBloodTypes
                              .map((bloodType) {
                            return DropdownMenuItem<int>(
                              value: bloodType.blood_type_id,
                              child: Text(
                                bloodType.type,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBloodTypeId = value;
                            });
                          },
                          decoration: _inputDecoration("Blood Type",
                              fillColor: cardBackground),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- ADDRESS CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address Information",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    style:
                                        GoogleFonts.poppins(color: primaryText),
                                    controller: _zoneController,
                                    decoration: _inputDecoration("Zone"))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: TextFormField(
                                    style:
                                        GoogleFonts.poppins(color: primaryText),
                                    controller: _streetController,
                                    decoration: _inputDecoration("Street"))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    style:
                                        GoogleFonts.poppins(color: primaryText),
                                    controller: _blockController,
                                    decoration: _inputDecoration("Block"))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: TextFormField(
                                    style:
                                        GoogleFonts.poppins(color: primaryText),
                                    controller: _lotController,
                                    decoration: _inputDecoration("Lot"))),
                          ],
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            // Force a reset first so the UI clears old state
                            setState(() {
                              _searchedAddress = [];
                              _noResults = false;
                              _addressId = null;
                            });

                            final results =
                                await householdProvider.searchAddresses(
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

                        // --- SEARCH RESULTS DISPLAY ---

                        // CASE 1: No Results Found -> Offer to Create New
                        if (_noResults)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
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
                                          // 1. Save values to the variables used by "Save Record"
                                          _Zone = _zoneController.text;
                                          _Street = _streetController.text;
                                          _Block = _blockController.text;
                                          _Lot = _lotController.text;

                                          // 2. Ensure we aren't using an existing ID
                                          _addressId = null;

                                          // 3. Clear the search UI so user knows it's "set"
                                          _noResults = false;

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "New Address Set. You can now save the record.")),
                                          );
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: actionGreen,
                                          foregroundColor: Colors.white),
                                      child: const Text("Yes"),
                                    ),
                                    const SizedBox(width: 10),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _noResults = false;
                                        });
                                      },
                                      child: Text("No",
                                          style: GoogleFonts.poppins(
                                              color: primaryText)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )

                        // CASE 2: Results Found -> Offer to Select
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
                                // Accessing the nested 'address' map
                                Text(
                                    "Zone: ${_searchedAddress[0]['address']['zone']}",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                Text(
                                    "Street: ${_searchedAddress[0]['address']['street']}",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                Text(
                                    "Block: ${_searchedAddress[0]['address']['block']}",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                Text(
                                    "Lot: ${_searchedAddress[0]['address']['lot']}",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),

                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      // 1. SET THE EXISTING ID
                                      _addressId =
                                          _searchedAddress[0]['address']['id'];

                                      // 2. Clear "new" variables to prevent accidental creation
                                      _Zone = null;
                                      _Street = null;
                                      _Block = null;
                                      _Lot = null;

                                      // 3. Auto-fill controllers to show user what they picked
                                      final addr =
                                          _searchedAddress[0]['address'];
                                      _zoneController.text = addr['zone'];
                                      _streetController.text = addr['street'];
                                      _blockController.text = addr['block'];
                                      _lotController.text = addr['lot'];

                                      // 4. Hide the results list since we picked one
                                      _searchedAddress = [];

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Existing Address Selected")),
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: actionGreen,
                                      foregroundColor: Colors.white),
                                  child: const Text("Use This Address"),
                                ),

                                // Optional: "Cancel / Clear Search" button
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchedAddress = [];
                                    });
                                  },
                                  child: Text("Cancel Search",
                                      style: GoogleFonts.poppins(
                                          color: Colors.red)),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- OTHER DETAILS CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Residency & Status",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),

                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          controller: _registrationPlaceController,
                          decoration: _inputDecoration("Place of Registration"),
                        ),
                        const SizedBox(height: 16),
                        // Residency
                        Text("Residency",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          children: Residency.values.map((val) {
                            return SizedBox(
                              width: 140,
                              child: RadioListTile<Residency>(
                                title: Text(
                                  val.label,
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                ),
                                value: val,
                                groupValue: _selectedResidency,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedResidency = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Years of Residency
                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          validator: (value) {
                            // Check for letters
                            if (RegExp(r'[a-zA-Z]').hasMatch(value!)) {
                              return "Years cannot contain letters";
                            }
                            // Convert to integer
                            final int? age = int.tryParse(value);
                            // Check for negative
                            if (age != null && age < 0) {
                              return "Years must not be negative";
                            }
                            _yearsOfResidency = age;
                          },
                          controller: _residencyYearsController,
                          decoration: _inputDecoration("Years of Residency",
                              helper: "Must be a number"),
                        ),
                        const SizedBox(height: 16),
                        // Transient
                        Text("Transient",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          children: Transient.values.map((g) {
                            return SizedBox(
                              width: 140,
                              child: RadioListTile<Transient>(
                                title: Text(
                                  g.label,
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                ),
                                value: g,
                                groupValue: _selectedTransient,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTransient = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Monthly Income
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedMonthlyIncomeId,
                          items: profileLookupProvder.allMonthlyIncomes.map((
                            monthlyIncome,
                          ) {
                            return DropdownMenuItem<int>(
                              value: monthlyIncome.monthly_income_id,
                              child: Text(
                                monthlyIncome.range,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMonthlyIncomeId = value;
                            });
                          },
                          decoration: _inputDecoration("Monthly Income",
                              fillColor: cardBackground),
                        ),
                        const SizedBox(height: 16),
                        // Daily Income
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedDailyIncomeId,
                          items: profileLookupProvder.allDailyIncomes
                              .map((dailyIncome) {
                            return DropdownMenuItem<int>(
                              value: dailyIncome.daily_income_id,
                              child: Text(
                                dailyIncome.range,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDailyIncomeId = value;
                            });
                          },
                          decoration: _inputDecoration("Daily Income",
                              fillColor: cardBackground),
                        ),
                        const SizedBox(height: 16),
                        // Solo Parent
                        Text("Solo Parent",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          children: SoloParent.values.map((val) {
                            return SizedBox(
                              width: 250,
                              child: RadioListTile<SoloParent>(
                                title: Text(
                                  val.label,
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                ),
                                value: val,
                                groupValue: _selectedSoloParent,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSoloParent = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // OFW
                        Text("Is the individual an OFW?",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("Yes",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: true,
                                groupValue: _selectedOfw,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOfw = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("No",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: false,
                                groupValue: _selectedOfw,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOfw = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Literate
                        Text("Able to Read & Write",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("Yes",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: true,
                                groupValue: _selectedLiterate,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLiterate = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("No",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: false,
                                groupValue: _selectedLiterate,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLiterate = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // PWD
                        Text("Is the individual a PWD?",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("Yes",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: true,
                                groupValue: _selectedPwd,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPwd = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("No",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: false,
                                groupValue: _selectedPwd,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPwd = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // Disability details if PWD
                        _selectedPwd == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      style: GoogleFonts.poppins(
                                          color: primaryText),
                                      controller: _disabilityNameController,
                                      decoration: _inputDecoration(
                                          "Name of Disability"),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      style: GoogleFonts.poppins(
                                          color: primaryText),
                                      controller: _disabilityTypeController,
                                      decoration: _inputDecoration(
                                          "Type of Disability"),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- EDUCATION & VOTER CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Education & Voter Registry",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),

                        // Education
                        DropdownButtonFormField<int>(
                          style: GoogleFonts.poppins(color: primaryText),
                          dropdownColor: cardBackground,
                          value: _selectedEducationId,
                          items: profileLookupProvder.allEducation
                              .map((education) {
                            return DropdownMenuItem<int>(
                              value: education.education_id,
                              child: Text(
                                education.level,
                                style: GoogleFonts.poppins(color: primaryText),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedEducationId = value;
                            });
                          },
                          decoration: _inputDecoration("Education",
                              fillColor: cardBackground),
                        ),
                        const SizedBox(height: 16),
                        // Currently Enrolled
                        Text(
                            "Is the individual currently enrolled to a school?",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          children: CurrentlyEnrolled.values.map((val) {
                            return SizedBox(
                              width: 250,
                              child: RadioListTile<CurrentlyEnrolled>(
                                title: Text(
                                  val.label,
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                ),
                                value: val,
                                groupValue: _selectedCurrentlyEnrolled,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCurrentlyEnrolled = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        // Enrolled School Field
                        _selectedCurrentlyEnrolled != CurrentlyEnrolled.no &&
                                _selectedCurrentlyEnrolled != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 16),
                                child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _enrolledAtController,
                                  decoration: _inputDecoration(
                                      "Enter school enrolled in"),
                                ),
                              )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 16),
                        // Registered Voter
                        Text("Is the individual a registered voter?",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("Yes",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: true,
                                groupValue: _selectedRegisteredVoter,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRegisteredVoter = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("No",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: false,
                                groupValue: _selectedRegisteredVoter,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRegisteredVoter = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // Voter Registry field if registered
                        _selectedRegisteredVoter == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 16),
                                child: TextFormField(
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                  controller: _placeOfVoteRegistryController,
                                  decoration: _inputDecoration(
                                      "Place of Vote Registry"),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- CONTACT & OCCUPATION CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Contact & Occupation",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; // It's fine if empty
                            }
                            if (!_emailRegex.hasMatch(value!)) {
                              return "Enter a valid email address";
                            }
                          },
                          controller: _emailController,
                          decoration: _inputDecoration("Email",
                              helper: "Optional, for non-primary contact"),
                        ),
                        const SizedBox(height: 16),
                        // Phone Number
                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; // It's fine if empty
                            }
                            if (!_ph09Regex.hasMatch(value!)) {
                              return "Enter a valid Philippine phone number (09xxxxxxxx)";
                            }
                          },
                          controller: _phoneNumberController,
                          decoration: _inputDecoration("Phone Number",
                              helper: "09xxxxxxxxx"),
                        ),
                        const SizedBox(height: 16),

                        // Occupation Check
                        Text("Has occupation?",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("Yes",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: true,
                                groupValue: _hasOccupation,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _hasOccupation = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("No",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: false,
                                groupValue: _hasOccupation,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _hasOccupation = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // Occupation Details if applicable
                        _hasOccupation == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      style: GoogleFonts.poppins(
                                          color: primaryText),
                                      controller: _occupationController,
                                      decoration:
                                          _inputDecoration("Occupation"),
                                    ),
                                    const SizedBox(height: 16),
                                    Text("Occupation Status:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: primaryText)),
                                    Wrap(
                                      children:
                                          OccupationStatus.values.map((val) {
                                        return SizedBox(
                                          width: 150,
                                          child:
                                              RadioListTile<OccupationStatus>(
                                            title: Text(val.label,
                                                style: GoogleFonts.poppins(
                                                    color: primaryText)),
                                            value: val,
                                            groupValue:
                                                _selectedOccupationStatus,
                                            activeColor: navBackground,
                                            contentPadding: EdgeInsets.zero,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOccupationStatus =
                                                    value;
                                              });
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 8),
                                    Text("Occupation Type:",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: primaryText)),
                                    Wrap(
                                      children:
                                          OccupationType.values.map((val) {
                                        return SizedBox(
                                          width: 150,
                                          child: RadioListTile<OccupationType>(
                                            title: Text(val.label,
                                                style: GoogleFonts.poppins(
                                                    color: primaryText)),
                                            value: val,
                                            groupValue: _selectedOccupationType,
                                            activeColor: navBackground,
                                            contentPadding: EdgeInsets.zero,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOccupationType = value;
                                              });
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        const Divider(height: 32, color: secondaryText),

                        // Gadgets
                        Text("Gadgets Owned:",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          spacing: 20,
                          runSpacing: 0,
                          children: Gadget.values.map((gadget) {
                            return SizedBox(
                              width: 150,
                              child: CheckboxListTile(
                                title: Text(gadget.label,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: primaryText)),
                                value: _selectedGadgets.contains(gadget),
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool? checked) {
                                  setState(() {
                                    if (checked == true) {
                                      _selectedGadgets.add(gadget);
                                    } else {
                                      _selectedGadgets.remove(gadget);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- LEGAL & DECEASED CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Legal & Deceased Status",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),

                        // CTC Records
                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          validator: (value) {
                            if (RegExp(r'[a-zA-Z]').hasMatch(value!)) {
                              return "Issue number cannot contain letters";
                            }
                          },
                          controller: _issueNumController,
                          decoration: _inputDecoration("CTC Issue No."),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          style: GoogleFonts.poppins(color: primaryText),
                          controller: _placeOfIssueController,
                          decoration: _inputDecoration("Place of Issuance"),
                        ),
                        const SizedBox(height: 16),
                        // CTC Issue Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CTC Issue Date",
                                style: GoogleFonts.poppins(
                                    color: primaryText,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 5),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.date_range, size: 18),
                              label: Text(
                                  _issueDate == null
                                      ? "Select Issue Date"
                                      : "${_issueDate!.month}/${_issueDate!.day}/${_issueDate!.year}",
                                  style: GoogleFonts.poppins()),
                              onPressed: () async {
                                await pickDate(
                                  context: context,
                                  currentValue: _issueDate,
                                  onDatePicked: (d) =>
                                      setState(() => _issueDate = d),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navBackground,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Deceased Status
                        Text("Is the individual already deceased?",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("Yes",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: true,
                                groupValue: _selectedDeceased,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDeceased = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: RadioListTile<bool>(
                                title: Text("No",
                                    style: GoogleFonts.poppins(
                                        color: primaryText)),
                                value: false,
                                groupValue: _selectedDeceased,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDeceased = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // Date of Death if deceased
                        _selectedDeceased == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Date of Death",
                                        style: GoogleFonts.poppins(
                                            color: primaryText,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.event_busy,
                                          size: 18),
                                      label: Text(
                                          _deathDate == null
                                              ? "Select Date of Death"
                                              : "${_deathDate!.month}/${_deathDate!.day}/${_deathDate!.year}",
                                          style: GoogleFonts.poppins()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      onPressed: () async {
                                        await pickDate(
                                          context: context,
                                          currentValue: _deathDate,
                                          onDatePicked: (d) =>
                                              setState(() => _deathDate = d),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- REGISTRATION STATUS CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Registration Status",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navBackgroundDark)),
                        const SizedBox(height: 16),
                        // Registration Status
                        Text("Overall Registration Status:",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: primaryText)),
                        Wrap(
                          children: RegistrationStatus.values.map((val) {
                            return SizedBox(
                              width: 150,
                              child: RadioListTile<RegistrationStatus>(
                                title: Text(
                                  val.label,
                                  style:
                                      GoogleFonts.poppins(color: primaryText),
                                ),
                                value: val,
                                groupValue: _selectedRegistrationStatus,
                                activeColor: navBackground,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRegistrationStatus = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- SAVE BUTTON ---
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [navBackground, navBackgroundDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: navBackgroundDark.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_selectedRegistrationStatus == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please select a registration status.")),
                            );
                            return; // stop submit
                          }
                          if (_formKey.currentState!.validate()) {
                            if (_addressId == null) {
                              final addressCompanion = AddressesCompanion(
                                zone: _Zone != null && _Zone != ""
                                    ? db.Value(_Zone)
                                    : db.Value.absent(),
                                street: _Street != null && _Street != ""
                                    ? db.Value(_Street)
                                    : db.Value.absent(),
                                block: _Block != null && _Block != ""
                                    ? db.Value(_Block)
                                    : db.Value.absent(),
                                lot: _Lot != null && _Lot != ""
                                    ? db.Value(_Lot)
                                    : db.Value.absent(),
                              );

                              final hasAddress =
                                  addressCompanion.zone.present ||
                                      addressCompanion.street.present ||
                                      addressCompanion.block.present ||
                                      addressCompanion.lot.present;

                              if (hasAddress) {
                                _addressId = await householdProvider.addAddress(
                                  addressCompanion,
                                );
                              }
                            }

                            final personCompanion = PersonsCompanion(
                              last_name: db.Value(
                                  _capitalize(_lastNameController.text)),
                              first_name: db.Value(
                                  _capitalize(_firstNameController.text)),

                              // Handle Optional Middle Name Capitalization
                              middle_name: _middleNameController.text.isNotEmpty
                                  ? db.Value(
                                      _capitalize(_middleNameController.text))
                                  : const db.Value.absent(),
                              suffix: _suffixController.text.isNotEmpty
                                  ? db.Value(_suffixController.text)
                                  : db.Value.absent(),
                              sex: _selectedSex != null
                                  ? db.Value(_selectedSex)
                                  : db.Value.absent(),
                              age: _checkAge != null
                                  ? db.Value(_checkAge)
                                  : db.Value.absent(),
                              birth_date: _birthDate != null
                                  ? db.Value(_birthDate)
                                  : db.Value.absent(),
                              birth_place: _birthPlaceController.text.isNotEmpty
                                  ? db.Value(_birthPlaceController.text)
                                  : db.Value.absent(),
                              civil_status: // Enum
                                  _selectedCivilStatus != null
                                      ? db.Value(_selectedCivilStatus)
                                      : db.Value.absent(),
                              nationality_id: // Reference Table
                                  _selectedNationalityId != null
                                      ? db.Value(_selectedNationalityId)
                                      : db.Value.absent(),
                              religion_id: _selectedReligionId != null
                                  ? db.Value(_selectedReligionId)
                                  : db.Value.absent(),
                              ethnicity_id: _selectedEthnicityId != null
                                  ? db.Value(_selectedEthnicityId)
                                  : db.Value.absent(),
                              blood_type_id: _selectedBloodTypeId != null
                                  ? db.Value(_selectedBloodTypeId)
                                  : db.Value.absent(),
                              address_id: _addressId != null
                                  ? db.Value(_addressId)
                                  : db.Value.absent(),
                              registration_place: _registrationPlaceController
                                      .text.isNotEmpty
                                  ? db.Value(_registrationPlaceController.text)
                                  : db.Value.absent(),
                              residency: _selectedResidency != null
                                  ? db.Value(_selectedResidency)
                                  : db.Value.absent(),
                              years_of_residency: _yearsOfResidency != null
                                  ? db.Value(_yearsOfResidency)
                                  : db.Value.absent(),
                              transient_type: _selectedTransient != null
                                  ? db.Value(_selectedTransient)
                                  : db.Value.absent(),
                              monthly_income_id:
                                  _selectedMonthlyIncomeId != null
                                      ? db.Value(_selectedMonthlyIncomeId)
                                      : db.Value.absent(),
                              daily_income_id: _selectedDailyIncomeId != null
                                  ? db.Value(_selectedDailyIncomeId)
                                  : db.Value.absent(),
                              solo_parent: _selectedSoloParent != null
                                  ? db.Value(_selectedSoloParent)
                                  : db.Value.absent(),
                              ofw: _selectedOfw != null
                                  ? db.Value(_selectedOfw)
                                  : db.Value.absent(),
                              literate: _selectedLiterate != null
                                  ? db.Value(_selectedLiterate)
                                  : db.Value.absent(),
                              pwd: _selectedPwd != null
                                  ? db.Value(_selectedPwd)
                                  : db.Value.absent(),
                              registered_voter: _selectedRegisteredVoter != null
                                  ? db.Value(_selectedRegisteredVoter)
                                  : db.Value.absent(),
                              currently_enrolled:
                                  _selectedCurrentlyEnrolled != null
                                      ? db.Value(_selectedCurrentlyEnrolled)
                                      : db.Value.absent(),
                              education_id: _selectedEducationId != null
                                  ? db.Value(_selectedEducationId)
                                  : db.Value.absent(),
                              deceased: _selectedDeceased != null
                                  ? db.Value(_selectedDeceased)
                                  : db.Value.absent(),
                              death_date: _deathDate != null
                                  ? db.Value(_deathDate)
                                  : db.Value.absent(),
                              registration_status: db.Value(
                                _selectedRegistrationStatus!,
                              ),
                            );

                            personId =
                                await personProvider.addPerson(personCompanion);

                            if (_emailController.text.isNotEmpty) {
                              final emailCompanion = EmailsCompanion(
                                person_id: db.Value(personId!),
                                email_address: db.Value(_emailController.text),
                              );

                              await contactInfoProvider
                                  .addEmail(emailCompanion);
                            }
                            if (_phoneNumberController.text.isNotEmpty) {
                              final phoneNumberCompanion =
                                  PhoneNumbersCompanion(
                                person_id: db.Value(personId!),
                                phone_num: db.Value(
                                  int.tryParse(_phoneNumberController.text)!,
                                ),
                              );
                              await contactInfoProvider.addPhoneNumber(
                                phoneNumberCompanion,
                              );
                            }

                            if (_selectedGadgets.isNotEmpty) {
                              for (Gadget gadget in _selectedGadgets) {
                                final gadgetCompanion = GadgetsCompanion(
                                  person_id: db.Value(personId!),
                                  gadget: db.Value(gadget),
                                );

                                await contactInfoProvider
                                    .addGadget(gadgetCompanion);
                              }
                            }

                            if (_occupationController.text.isNotEmpty) {
                              final occupationCompanion = OccupationsCompanion(
                                person_id: db.Value(personId!),
                                occupation:
                                    db.Value(_occupationController.text),
                                occupation_status:
                                    _selectedOccupationStatus != null
                                        ? db.Value(_selectedOccupationStatus)
                                        : db.Value.absent(),
                                occupation_type: _selectedOccupationType != null
                                    ? db.Value(_selectedOccupationType)
                                    : db.Value.absent(),
                              );

                              await occupationProvider.addOccupation(
                                occupationCompanion,
                              );
                            }

                            if (_isSeniorCitizen == true &&
                                _registeredSeniorCitizen == true) {
                              final registeredSeniorCompanion =
                                  RegisteredSeniorsCompanion(
                                person_id: db.Value(personId!),
                              );

                              await citizenRegistryProvider.addRegisteredSenior(
                                registeredSeniorCompanion,
                              );
                            }

                            if (_enrolledAtController.text.isNotEmpty) {
                              final enrolledCompanion = EnrolledCompanion(
                                person_id: db.Value(personId!),
                                school: db.Value(_enrolledAtController.text),
                                education_id: _selectedEducationId != null
                                    ? db.Value(_selectedEducationId!)
                                    : db.Value.absent(),
                              );

                              await citizenRegistryProvider.addEnrolled(
                                enrolledCompanion,
                              );
                            }

                            if (_selectedPwd == true &&
                                _disabilityNameController.text.isNotEmpty) {
                              final disabilityCompanion = DisabilitiesCompanion(
                                person_id: db.Value(personId!),
                                name: _disabilityNameController.text.isNotEmpty
                                    ? db.Value(_disabilityNameController.text)
                                    : db.Value.absent(),
                                type: _disabilityTypeController.text.isNotEmpty
                                    ? db.Value(_disabilityTypeController.text)
                                    : db.Value.absent(),
                              );

                              await citizenRegistryProvider.addDisability(
                                disabilityCompanion,
                              );
                            }

                            if (_selectedRegisteredVoter == true &&
                                _placeOfVoteRegistryController
                                    .text.isNotEmpty) {
                              final voterCompanion = VoterRegistriesCompanion(
                                  person_id: db.Value(personId!),
                                  place_of_vote_registry: db.Value(
                                      _placeOfVoteRegistryController.text));
                              await citizenRegistryProvider.addVoterRegistry(
                                voterCompanion,
                              );
                            }

                            if (_issueNumController.text != "") {
                              final ctcCompanion = CTCRecordsCompanion(
                                person_id: db.Value(personId!),
                                issue_num: db.Value(
                                  int.parse(_issueNumController.text),
                                ),
                                place_of_issue:
                                    _placeOfIssueController.text.isNotEmpty
                                        ? db.Value(_placeOfIssueController.text)
                                        : db.Value.absent(),
                                date_of_issue: _issueDate != null
                                    ? db.Value(_issueDate)
                                    : db.Value.absent(),
                              );

                              await citizenRegistryProvider
                                  .addCTCRecord(ctcCompanion);
                            }
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          "SAVE RECORD",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
