import 'package:brims/database/app_db.dart';
import 'package:brims/database/tables/extensions.dart'; // Required for .label
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/citizen_registry_provider.dart';
import 'package:brims/provider/profiling%20providers/contact_info_provider.dart';
import 'package:brims/provider/profiling%20providers/occupation_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;
import '../database/tables/enums.dart';

class EditPersonPage extends StatefulWidget {
  final int personId;

  const EditPersonPage({super.key, required this.personId});

  @override
  State<EditPersonPage> createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // --- 1. Regex Validators ---
  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  final _ph09Regex = RegExp(r'^09\d{9}$');

  // --- 2. Address Logic Variables ---
  String? _Zone;
  String? _Street;
  String? _Block;
  String? _Lot;

  List<Map<String, dynamic>> _searchedAddress = [];
  bool _noResults = false;
  int? _addressId;

  // --- 3. Senior Citizen Logic ---
  int? _checkAge;
  bool _isSeniorCitizen = false;
  bool _registeredSeniorCitizen = false;

  // --- 4. Sub-Table IDs ---
  int? _occupationId;
  int? _emailId;
  int? _phoneId;
  int? _voterId;
  int? _disabilityId;
  int? _enrolledId;
  int? _ctcId;
  int? _seniorId;

  // --- 5. Controllers ---
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _ageController = TextEditingController();
  final _residencyYearsController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _registrationPlaceController = TextEditingController();

  final _zoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _blockController = TextEditingController();
  final _lotController = TextEditingController();

  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _occupationController = TextEditingController();
  final _placeOfVoteRegistryController = TextEditingController();
  final _disabilityNameController = TextEditingController();
  final _disabilityTypeController = TextEditingController();
  final _enrolledAtController = TextEditingController();
  final _issueNumController = TextEditingController();
  final _placeOfIssueController = TextEditingController();

  // --- 6. State Variables ---
  DateTime? _birthDate;
  DateTime? _deathDate;
  DateTime? _issueDate;

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
  bool? _hasOccupation;

  Sex? _selectedSex;
  CivilStatus? _selectedCivilStatus;
  Residency? _selectedResidency;
  SoloParent? _selectedSoloParent;
  CurrentlyEnrolled? _selectedCurrentlyEnrolled;
  RegistrationStatus? _selectedRegistrationStatus;
  Transient? _selectedTransient;
  OccupationStatus? _selectedOccupationStatus;
  OccupationType? _selectedOccupationType;

  List<Gadget> _selectedGadgets = [];

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
    );

    if (picked != null) {
      onDatePicked(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // --- HELPER: Capitalize ---
  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  // --- LOAD DATA ---
  Future<void> _loadData() async {
    final personProvider = context.read<PersonProvider>();
    final lookupProvider = context.read<ProfileLookupProvider>();

    await lookupProvider.loadAllLookups();
    await personProvider.loadPersonDetails(widget.personId);

    final data = personProvider.selectedPersonDetails;

    if (data.isNotEmpty) {
      final PersonData p = data['person'];
      final AddressData? addr = data['address'];
      final OccupationData? occ = data['occupation'];
      final EmailData? email = data['email'];
      final PhoneNumberData? phone = data['phone'];
      final DisabilityData? dis = data['disability'];
      final VoterRegistryData? voter = data['voter'];
      final EnrolledData? enrolled = data['enrolled'];
      final CTCRecordData? ctc = data['ctc'];

      // Singular TableData naming as requested
      final RegisteredSeniorData? senior = data['senior'];
      final List<GadgetData> gadgets = data['gadgets'] != null
          ? (data['gadgets'] as List).cast<GadgetData>()
          : [];

      setState(() {
        // Person
        _lastNameController.text = p.last_name;
        _firstNameController.text = p.first_name;
        _middleNameController.text = p.middle_name ?? "";
        _suffixController.text = p.suffix ?? "";
        _ageController.text = p.age?.toString() ?? "";

        _checkAge = p.age;
        if ((_checkAge ?? 0) >= 60) _isSeniorCitizen = true;

        _birthPlaceController.text = p.birth_place ?? "";
        _residencyYearsController.text = p.years_of_residency?.toString() ?? "";
        _registrationPlaceController.text = p.registration_place ?? "";
        _birthDate = p.birth_date;
        _deathDate = p.death_date;

        // Enums & IDs
        _selectedSex = p.sex;
        _selectedCivilStatus = p.civil_status;
        _selectedResidency = p.residency;
        _selectedSoloParent = p.solo_parent;
        _selectedCurrentlyEnrolled = p.currently_enrolled;
        _selectedRegistrationStatus = p.registration_status;
        _selectedTransient = p.transient_type;
        _selectedOfw = p.ofw;
        _selectedLiterate = p.literate;
        _selectedPwd = p.pwd;
        _selectedRegisteredVoter = p.registered_voter;
        _selectedDeceased = p.deceased;

        _selectedNationalityId = p.nationality_id;
        _selectedEthnicityId = p.ethnicity_id;
        _selectedReligionId = p.religion_id;
        _selectedEducationId = p.education_id;
        _selectedBloodTypeId = p.blood_type_id;
        _selectedMonthlyIncomeId = p.monthly_income_id;
        _selectedDailyIncomeId = p.daily_income_id;

        // Address
        if (addr != null) {
          _addressId = addr.address_id;
          _zoneController.text = addr.zone ?? "";
          _streetController.text = addr.street ?? "";
          _blockController.text = addr.block ?? "";
          _lotController.text = addr.lot ?? "";
        }

        // Occupation
        if (occ != null) {
          _occupationId = occ.occupation_id;
          _hasOccupation = true;
          _occupationController.text = occ.occupation;
          _selectedOccupationStatus = occ.occupation_status;
          _selectedOccupationType = occ.occupation_type;
        } else {
          _hasOccupation = false;
        }

        // Contact
        if (email != null) {
          _emailId = email.email_id;
          _emailController.text = email.email_address;
        }
        if (phone != null) {
          _phoneId = phone.phone_number_id;
          _phoneNumberController.text = phone.phone_num.toString();
        }

        // Sub Tables
        if (dis != null) {
          _disabilityId = dis.disability_id;
          _disabilityNameController.text = dis.name;
          _disabilityTypeController.text = dis.type ?? "";
        }
        if (voter != null) {
          _voterId = voter.voter_registry_id;
          _placeOfVoteRegistryController.text = voter.place_of_vote_registry;
        }
        if (enrolled != null) {
          _enrolledId = enrolled.enrolled_id;
          _enrolledAtController.text = enrolled.school;
        }
        if (ctc != null) {
          _ctcId = ctc.ctc_record_id;
          _issueNumController.text = ctc.issue_num.toString();
          _placeOfIssueController.text = ctc.place_of_issue ?? "";
          _issueDate = ctc.date_of_issue;
        }

        if (senior != null) {
          _seniorId = senior.registered_senior_id;
          _registeredSeniorCitizen = true;
        } else {
          _registeredSeniorCitizen = false;
        }

        // --- GADGETS FIX ---
        // Filter out any null gadgets and cast safely
        _selectedGadgets = gadgets
            .map((g) => g.gadget)
            .where((g) => g != null)
            .cast<Gadget>()
            .toList();

        _isLoading = false;
      });
    }
  }

  // --- SAVE / UPDATE LOGIC ---
  Future<void> _savePerson() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final personProvider = context.read<PersonProvider>();
      final citizenRegistryProvider = context.read<CitizenRegistryProvider>();
      final occupationProvider = context.read<OccupationProvider>();
      final contactInfoProvider = context.read<ContactInfoProvider>();
      final householdProvider = context.read<HouseholdProvider>();

      // 1. Address
      int? finalAddressId = _addressId;
      if (finalAddressId == null &&
          (_zoneController.text.isNotEmpty ||
              _streetController.text.isNotEmpty)) {
        final addressCompanion = AddressesCompanion(
          zone: _zoneController.text.isNotEmpty
              ? db.Value(_zoneController.text)
              : const db.Value.absent(),
          street: _streetController.text.isNotEmpty
              ? db.Value(_streetController.text)
              : const db.Value.absent(),
          block: _blockController.text.isNotEmpty
              ? db.Value(_blockController.text)
              : const db.Value.absent(),
          lot: _lotController.text.isNotEmpty
              ? db.Value(_lotController.text)
              : const db.Value.absent(),
        );
        finalAddressId = await householdProvider.addAddress(addressCompanion);
      }

      // 2. Update Person
      final personCompanion = PersonsCompanion(
        person_id: db.Value(widget.personId),
        last_name: db.Value(_capitalize(_lastNameController.text)),
        first_name: db.Value(_capitalize(_firstNameController.text)),
        middle_name: _middleNameController.text.isNotEmpty
            ? db.Value(_capitalize(_middleNameController.text))
            : const db.Value.absent(),
        suffix: _suffixController.text.isNotEmpty
            ? db.Value(_suffixController.text)
            : const db.Value.absent(),
        age: db.Value(int.tryParse(_ageController.text)),
        sex: db.Value(_selectedSex),
        years_of_residency: _residencyYearsController.text.isNotEmpty
            ? db.Value(int.tryParse(_residencyYearsController.text))
            : const db.Value.absent(),
        birth_date: db.Value(_birthDate),
        birth_place: db.Value(_birthPlaceController.text),
        civil_status: db.Value(_selectedCivilStatus),
        nationality_id: db.Value(_selectedNationalityId),
        religion_id: db.Value(_selectedReligionId),
        ethnicity_id: db.Value(_selectedEthnicityId),
        blood_type_id: db.Value(_selectedBloodTypeId),
        address_id: finalAddressId != null
            ? db.Value(finalAddressId)
            : const db.Value.absent(),
        registration_place: db.Value(_registrationPlaceController.text),
        residency: db.Value(_selectedResidency),
        transient_type: db.Value(_selectedTransient),
        monthly_income_id: db.Value(_selectedMonthlyIncomeId),
        daily_income_id: db.Value(_selectedDailyIncomeId),
        solo_parent: db.Value(_selectedSoloParent),
        ofw: db.Value(_selectedOfw),
        literate: db.Value(_selectedLiterate),
        pwd: db.Value(_selectedPwd),
        registered_voter: db.Value(_selectedRegisteredVoter),
        currently_enrolled: db.Value(_selectedCurrentlyEnrolled),
        education_id: db.Value(_selectedEducationId),
        deceased: db.Value(_selectedDeceased),
        death_date: db.Value(_deathDate),
        registration_status: db.Value(_selectedRegistrationStatus!),
      );

      await personProvider.updatePerson(personCompanion);

      // 3. Update Sub-Tables

      // Occupation
      if (_occupationController.text.isNotEmpty) {
        final occComp = OccupationsCompanion(
          person_id: db.Value(widget.personId),
          occupation: db.Value(_occupationController.text),
          occupation_status: db.Value(_selectedOccupationStatus),
          occupation_type: db.Value(_selectedOccupationType),
        );
        if (_hasOccupation == true && _occupationId != null) {
          await occupationProvider.updateOccupation(
              occComp.copyWith(occupation_id: db.Value(_occupationId!)));
        } else {
          await occupationProvider.addOccupation(occComp);
        }
      } else if (_occupationId != null) {
        await occupationProvider.deleteOccupation(_occupationId!);
      }

      // Email
      if (_emailController.text.isNotEmpty) {
        final emailComp = EmailsCompanion(
          person_id: db.Value(widget.personId),
          email_address: db.Value(_emailController.text),
        );
        if (_emailId != null) {
          await contactInfoProvider
              .updateEmail(emailComp.copyWith(email_id: db.Value(_emailId!)));
        } else {
          await contactInfoProvider.addEmail(emailComp);
        }
      } else if (_emailId != null) {
        await contactInfoProvider.deleteEmail(_emailId!);
      }

      // Phone
      if (_phoneNumberController.text.isNotEmpty) {
        final phoneComp = PhoneNumbersCompanion(
          person_id: db.Value(widget.personId),
          phone_num: db.Value(int.tryParse(_phoneNumberController.text)!),
        );
        if (_phoneId != null) {
          await contactInfoProvider.updatePhoneNumber(
              phoneComp.copyWith(phone_number_id: db.Value(_phoneId!)));
        } else {
          await contactInfoProvider.addPhoneNumber(phoneComp);
        }
      } else if (_phoneId != null) {
        await contactInfoProvider.deletePhoneNumber(_phoneId!);
      }

      // Disability
      if (_selectedPwd == true && _disabilityNameController.text.isNotEmpty) {
        final disComp = DisabilitiesCompanion(
          person_id: db.Value(widget.personId),
          name: db.Value(_disabilityNameController.text),
          type: db.Value(_disabilityTypeController.text),
        );
        if (_disabilityId != null) {
          await citizenRegistryProvider.updateDisability(
              disComp.copyWith(disability_id: db.Value(_disabilityId!)));
        } else {
          await citizenRegistryProvider.addDisability(disComp);
        }
      } else if (_disabilityId != null) {
        await citizenRegistryProvider.deleteDisability(_disabilityId!);
      }

      // Voter
      if (_selectedRegisteredVoter == true &&
          _placeOfVoteRegistryController.text.isNotEmpty) {
        final voteComp = VoterRegistriesCompanion(
          person_id: db.Value(widget.personId),
          place_of_vote_registry: db.Value(_placeOfVoteRegistryController.text),
        );
        if (_voterId != null) {
          await citizenRegistryProvider.updateVoterRegistry(
              voteComp.copyWith(voter_registry_id: db.Value(_voterId!)));
        } else {
          await citizenRegistryProvider.addVoterRegistry(voteComp);
        }
      } else if (_voterId != null) {
        await citizenRegistryProvider.deleteVoterRegistry(_voterId!);
      }

      // Enrolled
      if (_enrolledAtController.text.isNotEmpty) {
        final enrollComp = EnrolledCompanion(
          person_id: db.Value(widget.personId),
          school: db.Value(_enrolledAtController.text),
          education_id: _selectedEducationId != null
              ? db.Value(_selectedEducationId!)
              : const db.Value.absent(),
        );
        if (_enrolledId != null) {
          await citizenRegistryProvider.updateEnrolled(
              enrollComp.copyWith(enrolled_id: db.Value(_enrolledId!)));
        } else {
          await citizenRegistryProvider.addEnrolled(enrollComp);
        }
      } else if (_enrolledId != null) {
        await citizenRegistryProvider.deleteEnrolled(_enrolledId!);
      }

      // CTC Record
      if (_issueNumController.text.isNotEmpty) {
        final ctcComp = CTCRecordsCompanion(
          person_id: db.Value(widget.personId),
          issue_num: db.Value(int.tryParse(_issueNumController.text)!),
          place_of_issue: db.Value(_placeOfIssueController.text),
          date_of_issue: db.Value(_issueDate),
        );
        if (_ctcId != null) {
          await citizenRegistryProvider.updateCTCRecord(
              ctcComp.copyWith(ctc_record_id: db.Value(_ctcId!)));
        } else {
          await citizenRegistryProvider.addCTCRecord(ctcComp);
        }
      } else if (_ctcId != null) {
        await citizenRegistryProvider.deleteCTCRecord(_ctcId!);
      }

      // Registered Senior Logic
      if (_isSeniorCitizen && _registeredSeniorCitizen) {
        if (_seniorId == null) {
          await citizenRegistryProvider.addRegisteredSenior(
              RegisteredSeniorsCompanion(person_id: db.Value(widget.personId)));
        }
      } else if (_seniorId != null) {
        await citizenRegistryProvider.deleteRegisteredSenior(_seniorId!);
      }

      // Gadgets (Add Only Strategy)
      // 1. Delete ALL existing gadgets for this person
      await contactInfoProvider.deleteGadgetsByPersonId(widget.personId);

      // 2. Add only the currently selected ones
      if (_selectedGadgets.isNotEmpty) {
        for (Gadget gadget in _selectedGadgets) {
          await contactInfoProvider.addGadget(GadgetsCompanion(
              person_id: db.Value(widget.personId), gadget: db.Value(gadget)));
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Person Updated Successfully!")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error updating: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final profileLookupProvder = context.watch<ProfileLookupProvider>();
    final householdProvider = context.read<HouseholdProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Person"), centerTitle: true),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- 1. NAMES ---
              Container(
                width: 1000,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Last Name:"),
                      TextFormField(
                        validator: (value) => value!.isEmpty
                            ? "Last name cannot be empty."
                            : null,
                        controller: _lastNameController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ]),
              ),
              Container(
                width: 1000,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("First Name:"),
                      TextFormField(
                        validator: (value) => value!.isEmpty
                            ? "First name cannot be empty."
                            : null,
                        controller: _firstNameController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ]),
              ),
              Container(
                width: 1000,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Middle Name:"),
                      TextFormField(
                          controller: _middleNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder())),
                    ]),
              ),
              Container(
                width: 1000,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Suffix:"),
                      TextFormField(
                          controller: _suffixController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder())),
                    ]),
              ),

              // --- 2. SEX ---
              Container(
                width: 1000,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...Sex.values.map((val) => RadioListTile<Sex>(
                          title: Text(val.label),
                          value: val,
                          groupValue: _selectedSex,
                          onChanged: (value) =>
                              setState(() => _selectedSex = value),
                        )),
                  ],
                ),
              ),

              // --- 3. AGE & SENIOR ---
              Container(
                width: 500,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Age:"),
                      TextFormField(
                        controller: _ageController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (RegExp(r'[a-zA-Z]').hasMatch(value!))
                            return "Age cannot contain letters";
                          final int? age = int.tryParse(value);
                          if (age != null && age < 0)
                            return "Age must not be negative";
                          return null;
                        },
                        onChanged: (text) {
                          setState(() {
                            _checkAge = int.tryParse(text);
                            _isSeniorCitizen =
                                (_checkAge != null && _checkAge! >= 60);
                          });
                        },
                      ),
                    ]),
              ),
              if (_isSeniorCitizen)
                Column(children: [
                  const Text("Registered Senior Citizen?"),
                  RadioListTile<bool>(
                      title: const Text("Yes"),
                      value: true,
                      groupValue: _registeredSeniorCitizen,
                      onChanged: (v) =>
                          setState(() => _registeredSeniorCitizen = v!)),
                  RadioListTile<bool>(
                      title: const Text("No"),
                      value: false,
                      groupValue: _registeredSeniorCitizen,
                      onChanged: (v) =>
                          setState(() => _registeredSeniorCitizen = v!)),
                ]),

              // --- 4. BIRTH DATE & PLACE ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await pickDate(
                        context: context,
                        currentValue: _birthDate,
                        onDatePicked: (d) => setState(() => _birthDate = d),
                      );
                    },
                    child: const Text("Select Birth Date"),
                  ),
                  if (_birthDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Selected: ${_birthDate!.month}/${_birthDate!.day}/${_birthDate!.year}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Birth Place:"),
                      TextFormField(
                          controller: _birthPlaceController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder())),
                    ]),
              ),

              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Place of Registration:"),
                        TextFormField(
                            controller: _registrationPlaceController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder())),
                      ])),

              // --- 5. ADDRESS ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Address Information",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                                controller: _zoneController,
                                decoration: const InputDecoration(
                                    labelText: "Zone",
                                    border: OutlineInputBorder()))),
                        const SizedBox(width: 5),
                        Expanded(
                            child: TextFormField(
                                controller: _streetController,
                                decoration: const InputDecoration(
                                    labelText: "Street",
                                    border: OutlineInputBorder()))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                                controller: _blockController,
                                decoration: const InputDecoration(
                                    labelText: "Block",
                                    border: OutlineInputBorder()))),
                        const SizedBox(width: 5),
                        Expanded(
                            child: TextFormField(
                                controller: _lotController,
                                decoration: const InputDecoration(
                                    labelText: "Lot",
                                    border: OutlineInputBorder()))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _searchedAddress = [];
                          _noResults = false;
                          _addressId = null;
                        });
                        final results = await householdProvider.searchAddresses(
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
                        color: Colors.orange.shade100,
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Text("No address found. Create new?"),
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
                              },
                              child: const Text("Yes"))
                        ]),
                      )
                    else if (_searchedAddress.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Column(children: [
                          Text(
                              "Zone: ${_searchedAddress[0]['address']['zone']}"),
                          Text(
                              "Street: ${_searchedAddress[0]['address']['street']}"),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final addr = _searchedAddress[0]['address'];
                                  _addressId = addr['id'];
                                  _zoneController.text = addr['zone'];
                                  _streetController.text = addr['street'];
                                  _blockController.text = addr['block'];
                                  _lotController.text = addr['lot'];
                                  _searchedAddress = [];
                                });
                              },
                              child: const Text("Use This Address"))
                        ]),
                      )
                  ],
                ),
              ),

              // --- 6. CIVIL STATUS & RELIGION ---
              Column(children: [
                const Text("Civil Status"),
                ...CivilStatus.values.map((g) => RadioListTile<CivilStatus>(
                    title: Text(g.label),
                    value: g,
                    groupValue: _selectedCivilStatus,
                    onChanged: (v) =>
                        setState(() => _selectedCivilStatus = v))),
              ]),
              DropdownButtonFormField<int>(
                value: _selectedReligionId,
                decoration: const InputDecoration(
                    labelText: "Religion", border: OutlineInputBorder()),
                items: profileLookupProvder.allReligions
                    .map((r) => DropdownMenuItem(
                        value: r.religion_id, child: Text(r.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedReligionId = v),
              ),
              DropdownButtonFormField<int>(
                value: _selectedNationalityId,
                decoration: const InputDecoration(
                    labelText: "Nationality", border: OutlineInputBorder()),
                items: profileLookupProvder.allNationalities
                    .map((n) => DropdownMenuItem(
                        value: n.nationality_id, child: Text(n.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedNationalityId = v),
              ),
              DropdownButtonFormField<int>(
                value: _selectedEthnicityId,
                decoration: const InputDecoration(
                    labelText: "Ethnicity", border: OutlineInputBorder()),
                items: profileLookupProvder.allEthnicities
                    .map((e) => DropdownMenuItem(
                        value: e.ethnicity_id, child: Text(e.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedEthnicityId = v),
              ),
              DropdownButtonFormField<int>(
                value: _selectedBloodTypeId,
                decoration: const InputDecoration(
                    labelText: "Blood Type", border: OutlineInputBorder()),
                items: profileLookupProvder.allBloodTypes
                    .map((b) => DropdownMenuItem(
                        value: b.blood_type_id, child: Text(b.type)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedBloodTypeId = v),
              ),

              // --- 8. RESIDENCY & INCOME ---
              Column(children: [
                const Text("Residency"),
                ...Residency.values.map((v) => RadioListTile<Residency>(
                    title: Text(v.label),
                    value: v,
                    groupValue: _selectedResidency,
                    onChanged: (val) =>
                        setState(() => _selectedResidency = val))),
              ]),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Years of Residency:"),
                        TextFormField(
                            controller: _residencyYearsController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder())),
                      ])),
              Column(children: [
                const Text("Transient"),
                ...Transient.values.map((v) => RadioListTile<Transient>(
                    title: Text(v.label),
                    value: v,
                    groupValue: _selectedTransient,
                    onChanged: (val) =>
                        setState(() => _selectedTransient = val))),
              ]),
              DropdownButtonFormField<int>(
                value: _selectedMonthlyIncomeId,
                decoration: const InputDecoration(
                    labelText: "Monthly Income", border: OutlineInputBorder()),
                items: profileLookupProvder.allMonthlyIncomes
                    .map((m) => DropdownMenuItem(
                        value: m.monthly_income_id, child: Text(m.range)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedMonthlyIncomeId = v),
              ),
              DropdownButtonFormField<int>(
                value: _selectedDailyIncomeId,
                decoration: const InputDecoration(
                    labelText: "Daily Income", border: OutlineInputBorder()),
                items: profileLookupProvder.allDailyIncomes
                    .map((d) => DropdownMenuItem(
                        value: d.daily_income_id, child: Text(d.range)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDailyIncomeId = v),
              ),

              // --- 9. SOCIO ---
              Column(children: [
                const Text("Solo Parent"),
                ...SoloParent.values.map((v) => RadioListTile<SoloParent>(
                    title: Text(v.label),
                    value: v,
                    groupValue: _selectedSoloParent,
                    onChanged: (val) =>
                        setState(() => _selectedSoloParent = val))),
              ]),
              Column(children: [
                const Text("OFW?"),
                RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _selectedOfw,
                    onChanged: (v) => setState(() => _selectedOfw = v)),
                RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _selectedOfw,
                    onChanged: (v) => setState(() => _selectedOfw = v)),
              ]),
              Column(children: [
                const Text("Literate?"),
                RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _selectedLiterate,
                    onChanged: (v) => setState(() => _selectedLiterate = v)),
                RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _selectedLiterate,
                    onChanged: (v) => setState(() => _selectedLiterate = v)),
              ]),

              // --- 10. PWD ---
              Column(children: [
                const Text("PWD?"),
                RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _selectedPwd,
                    onChanged: (v) => setState(() => _selectedPwd = v)),
                RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _selectedPwd,
                    onChanged: (v) => setState(() => _selectedPwd = v)),
              ]),
              if (_selectedPwd == true)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      TextFormField(
                          controller: _disabilityNameController,
                          decoration: const InputDecoration(
                              labelText: "Name of Disability",
                              border: OutlineInputBorder())),
                      TextFormField(
                          controller: _disabilityTypeController,
                          decoration: const InputDecoration(
                              labelText: "Type", border: OutlineInputBorder())),
                    ])),

              // --- 11. VOTER ---
              Column(children: [
                const Text("Registered Voter?"),
                RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _selectedRegisteredVoter,
                    onChanged: (v) =>
                        setState(() => _selectedRegisteredVoter = v)),
                RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _selectedRegisteredVoter,
                    onChanged: (v) =>
                        setState(() => _selectedRegisteredVoter = v)),
              ]),
              if (_selectedRegisteredVoter == true)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: _placeOfVoteRegistryController,
                        decoration: const InputDecoration(
                            labelText: "Place of Registry",
                            border: OutlineInputBorder()))),

              // --- 12. EDUCATION ---
              DropdownButtonFormField<int>(
                value: _selectedEducationId,
                decoration: const InputDecoration(
                    labelText: "Highest Education",
                    border: OutlineInputBorder()),
                items: profileLookupProvder.allEducation
                    .map((e) => DropdownMenuItem(
                        value: e.education_id, child: Text(e.level)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedEducationId = v),
              ),
              Column(children: [
                const Text("Currently Enrolled?"),
                ...CurrentlyEnrolled.values.map((v) =>
                    RadioListTile<CurrentlyEnrolled>(
                        title: Text(v.label),
                        value: v,
                        groupValue: _selectedCurrentlyEnrolled,
                        onChanged: (val) =>
                            setState(() => _selectedCurrentlyEnrolled = val))),
              ]),
              _selectedCurrentlyEnrolled != CurrentlyEnrolled.no
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("School enrolled at"),
                          TextFormField(
                              controller: _enrolledAtController,
                              decoration: const InputDecoration(
                                  labelText: "School Name",
                                  border: OutlineInputBorder())),
                        ],
                      ))
                  : SizedBox.shrink(),

              // --- 13. DECEASED ---
              Column(children: [
                const Text("Deceased?"),
                RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: _selectedDeceased,
                    onChanged: (v) => setState(() => _selectedDeceased = v)),
                RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: _selectedDeceased,
                    onChanged: (v) => setState(() => _selectedDeceased = v)),
              ]),
              _selectedDeceased == true
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await pickDate(
                                context: context,
                                currentValue: _deathDate,
                                onDatePicked: (d) =>
                                    setState(() => _deathDate = d),
                              );
                            },
                            child: const Text("Select Date of Death"),
                          ),
                          if (_deathDate != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "Selected: ${_deathDate!.month}/${_deathDate!.day}/${_deathDate!.year}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                        ],
                      ))
                  : SizedBox.shrink(),

              // --- 14. CONTACT INFO ---
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email:"),
                        TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder())),
                        const Text("Phone:"),
                        TextFormField(
                            controller: _phoneNumberController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder())),
                      ])),

              // --- 15. OCCUPATION ---
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Has Occupation?"),
                        RadioListTile<bool>(
                            title: const Text("Yes"),
                            value: true,
                            groupValue: _hasOccupation,
                            onChanged: (v) =>
                                setState(() => _hasOccupation = v)),
                        RadioListTile<bool>(
                            title: const Text("No"),
                            value: false,
                            groupValue: _hasOccupation,
                            onChanged: (v) =>
                                setState(() => _hasOccupation = v)),
                      ])),
              if (_hasOccupation == true)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      TextFormField(
                          controller: _occupationController,
                          decoration: const InputDecoration(
                              labelText: "Occupation",
                              border: OutlineInputBorder())),
                      const Text("Status:"),
                      ...OccupationStatus.values.map((v) => RadioListTile<
                              OccupationStatus>(
                          title: Text(v.label),
                          value: v,
                          groupValue: _selectedOccupationStatus,
                          onChanged: (val) =>
                              setState(() => _selectedOccupationStatus = val))),
                      const Text("Type:"),
                      ...OccupationType.values.map((v) => RadioListTile<
                              OccupationType>(
                          title: Text(v.label),
                          value: v,
                          groupValue: _selectedOccupationType,
                          onChanged: (val) =>
                              setState(() => _selectedOccupationType = val))),
                    ])),

              // --- 16. GADGETS ---
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gadgets:"),
                        ...Gadget.values.map((g) => CheckboxListTile(
                            title: Text(g.label),
                            value: _selectedGadgets.contains(g),
                            onChanged: (b) => setState(() {
                                  if (b!)
                                    _selectedGadgets.add(g);
                                  else
                                    _selectedGadgets.remove(g);
                                }))),
                      ])),

              // --- 17. CTC ---
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("CTC Issue No:"),
                        TextFormField(
                            controller: _issueNumController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder())),
                        const Text("Place of Issuance:"),
                        TextFormField(
                            controller: _placeOfIssueController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder())),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await pickDate(
                                  context: context,
                                  currentValue: _issueDate,
                                  onDatePicked: (d) =>
                                      setState(() => _issueDate = d),
                                );
                              },
                              child: const Text("Select Issue Date"),
                            ),
                            if (_issueDate != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "Selected: ${_issueDate!.month}/${_issueDate!.day}/${_issueDate!.year}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                          ],
                        )
                      ])),

              // --- 18. FINAL REGISTRATION STATUS ---
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Registration Status:"),
                        ...RegistrationStatus.values.map((v) =>
                            RadioListTile<RegistrationStatus>(
                                title: Text(v.label),
                                value: v,
                                groupValue: _selectedRegistrationStatus,
                                onChanged: (val) => setState(
                                    () => _selectedRegistrationStatus = val))),
                      ])),

              // --- SAVE BUTTON ---
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _savePerson,
                    child: const Text("Update Record"),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
