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

  // Insert to person table
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
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

  bool _addNewAddress = false;

  String? _newZone;
  String? _newStreet;
  String? _newBlock;
  String? _newLot;

  // Insert to email table
  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  TextEditingController _emailController = TextEditingController();

  // Insert to phone number table
  final _ph09Regex = RegExp(r'^09\d{9}$');
  TextEditingController _phoneNumberController = TextEditingController();

  // Insert to occupation table
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
  Widget build(BuildContext context) {
    final personProvider = context.watch<PersonProvider>();
    final citizenRegistryProvider = context.watch<CitizenRegistryProvider>();
    final occupationProvider = context.watch<OccupationProvider>();
    final contactInfoProvider = context.watch<ContactInfoProvider>();
    final profileLookupProvder = context.watch<ProfileLookupProvider>();
    final householdProvider = context.watch<HouseholdProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Last Name:"),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Last name cannot be empty.";
                        }
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          return "Last name cannot contain numbers";
                        }
                      },

                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: "Enter the last name here",
                        helperText: "Last name must not be blank",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("First Name:"),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "First name cannot be empty.";
                        }
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          return "First name cannot contain numbers";
                        }
                      },
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: "Enter the first name here",
                        helperText: "First name must not be blank",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Middle Name:"),
                    TextFormField(
                      validator: (value) {
                        if (RegExp(r'[0-9]').hasMatch(value!)) {
                          return "Middle name cannot contain numbers";
                        }
                      },
                      controller: _middleNameController,
                      decoration: InputDecoration(
                        hintText: "Enter the middle name here",
                        helperText: "Middle name must not contain numbers",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Suffix:"),
                    TextFormField(
                      validator: (value) {
                        if (RegExp(r'[0-9]').hasMatch(value!)) {
                          return "Suffix cannot contain numbers";
                        }
                      },
                      controller: _suffixController,
                      decoration: InputDecoration(
                        hintText: "Enter the suffix (e.g. Sr., Jr., etc.)",
                        helperText: "Suffix name must not contain numbers",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...Sex.values.map((val) {
                      return RadioListTile<Sex>(
                        title: Text(
                          val.name,
                        ), // displays "male", "female", "other"
                        value: val,
                        groupValue: _selectedSex,
                        onChanged: (value) {
                          setState(() {
                            _selectedSex = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Age:"),
                    TextFormField(
                      validator: (value) {
                        // Check for letters
                        if (RegExp(r'[a-zA-Z]').hasMatch(value!)) {
                          return "Age cannot contain letters";
                        }

                        // Convert to integer
                        final int? age = int.tryParse(value);

                        // Check for negative
                        if (age != null && age < 0) {
                          return "Age must not be negative";
                        }
                      },
                      controller: _ageController,
                      decoration: InputDecoration(
                        hintText: "Enter the age here",
                        helperText: "Age must not contain letters",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        setState(() {
                          int? _checkAge = int.tryParse(text);

                          if (_checkAge != null && _checkAge >= 60) {
                            _isSeniorCitizen = true;
                          } else {
                            _isSeniorCitizen = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              _isSeniorCitizen == true
                  ? Column(
                    children: [
                      Text("Registered Senior Citizen?"),
                      RadioListTile<bool>(
                        title: Text("Yes"),
                        value: true,
                        groupValue: _registeredSeniorCitizen,
                        onChanged: (value) {
                          setState(() {
                            _registeredSeniorCitizen = value!;
                          });
                        },
                      ),
                      RadioListTile<bool>(
                        title: Text("No"),
                        value: false,
                        groupValue: _registeredSeniorCitizen,
                        onChanged: (value) {
                          setState(() {
                            _registeredSeniorCitizen = value!;
                          });
                        },
                      ),
                    ],
                  )
                  : SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Birth Date:"),
                    scn.DatePicker(
                      value: _birthDate,
                      mode: scn.PromptMode.popover,
                      // Disable selecting dates after "today".
                      stateBuilder: (date) {
                        if (date.isAfter(DateTime.now())) {
                          return scn.DateState.disabled;
                        }
                        return scn.DateState.enabled;
                      },
                      onChanged: (value) {
                        setState(() {
                          _birthDate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Search for an address"),
                    TextFormField(
                      controller: _zoneController,
                      decoration: InputDecoration(
                        label: Text("Zone"),
                        hintText: "Enter the zone here",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        label: Text("Street"),
                        hintText: "Enter the street here",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _blockController,
                      decoration: InputDecoration(
                        label: Text("Block"),
                        hintText: "Enter the block here",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _lotController,
                      decoration: InputDecoration(
                        label: Text("Lot"),
                        hintText: "Enter the lot here",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final results = await householdProvider.searchAddresses(
                          zone:
                              _zoneController.text != ""
                                  ? _zoneController.text
                                  : null,
                          street:
                              _streetController.text != ""
                                  ? _streetController.text
                                  : null,
                          block:
                              _blockController.text != ""
                                  ? _blockController.text
                                  : null,
                          lot:
                              _lotController.text != ""
                                  ? _lotController.text
                                  : null,
                        );
                        setState(() {
                          _searchedAddress = results;
                          if (_searchedAddress.isEmpty) {
                            _noResults = true;
                          }
                        });
                      },
                      child: Text("Search"),
                    ),
                    if (_noResults == true && _searchedAddress.isEmpty) ...[
                      Text("No results. Set this as the address?"),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_zoneController.text != "") {
                              _newZone = _zoneController.text;
                            }
                            if (_streetController.text != "") {
                              _newStreet = _streetController.text;
                            }
                            if (_blockController.text != "") {
                              _newBlock = _blockController.text;
                            }
                            if (_lotController.text != "") {
                              _newLot = _lotController.text;
                            }
                            _noResults = false;
                          });
                        },
                        child: Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _noResults = false;
                          });
                        },
                        child: Text("No"),
                      ),
                    ] else if (_noResults == false &&
                        _searchedAddress.isNotEmpty) ...[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Zone: ${_searchedAddress[0]["zone"]}"),
                          Text("Street: ${_searchedAddress[0]["street"]}"),
                          Text("Block: ${_searchedAddress[0]["block"]}"),
                          Text("Lot: ${_searchedAddress[0]["lot"]}"),
                          Text("Set this as the address?"),
                          ElevatedButton(
                            onPressed: () {
                              setState(() async {
                                if (_zoneController.text != "") {
                                  _newZone = _zoneController.text;
                                }
                                if (_streetController.text != "") {
                                  _newStreet = _streetController.text;
                                }
                                if (_blockController.text != "") {
                                  _newBlock = _blockController.text;
                                }
                                if (_lotController.text != "") {
                                  _newLot = _lotController.text;
                                }
                                _noResults = false;
                              });
                            },
                            child: Text("Yes"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _noResults = true;
                              });
                            },
                            child: Text("No"),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Birth Place:"),
                    TextFormField(
                      controller: _birthPlaceController,
                      decoration: InputDecoration(
                        hintText: "Enter the birth place here",
                        //   helperText: "Middle name must not contain numbers",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Civil Status"),
                  ...CivilStatus.values.map((g) {
                    return RadioListTile<CivilStatus>(
                      title: Text(
                        g.name,
                      ), // displays "single", "married", "other"
                      value: g,
                      groupValue: _selectedCivilStatus,
                      onChanged: (value) {
                        setState(() {
                          _selectedCivilStatus = value;
                        });
                      },
                    );
                  }),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Religion"),
                  DropdownButtonFormField<int>(
                    value: _selectedReligionId,
                    items:
                        profileLookupProvder.allReligions.map((religion) {
                          return DropdownMenuItem<int>(
                            value:
                                religion
                                    .religion_id, // the id goes into person table
                            child: Text(
                              religion.name,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedReligionId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nationality"),
                  DropdownButtonFormField<int>(
                    value: _selectedNationalityId,
                    items:
                        profileLookupProvder.allNationalities.map((
                          nationality,
                        ) {
                          return DropdownMenuItem<int>(
                            value:
                                nationality
                                    .nationality_id, // the id goes into person table
                            child: Text(
                              nationality.name,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNationalityId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ethnicity"),
                  DropdownButtonFormField<int>(
                    value: _selectedEthnicityId,
                    items:
                        profileLookupProvder.allEthnicities.map((ethnicity) {
                          return DropdownMenuItem<int>(
                            value:
                                ethnicity
                                    .ethnicity_id, // the id goes into person table
                            child: Text(
                              ethnicity.name,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEthnicityId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Blood Type"),
                  DropdownButtonFormField<int>(
                    value: _selectedBloodTypeId,
                    items:
                        profileLookupProvder.allBloodTypes.map((bloodType) {
                          return DropdownMenuItem<int>(
                            value:
                                bloodType
                                    .blood_type_id, // the id goes into person table
                            child: Text(
                              bloodType.type,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBloodTypeId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Place of Registration:"),
                    TextFormField(
                      controller: _registrationPlaceController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Residency"),
                    ...Residency.values.map((val) {
                      return RadioListTile<Residency>(
                        title: Text(
                          val.name,
                        ), // displays "male", "female", "other"
                        value: val,
                        groupValue: _selectedResidency,
                        onChanged: (value) {
                          setState(() {
                            _selectedResidency = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Years of Residency:"),
                    TextFormField(
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
                      decoration: InputDecoration(
                        hintText: "Enter the years of residency here",
                        helperText:
                            "years of residency must not contain letters",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Transient"),
                    ...Transient.values.map((g) {
                      return RadioListTile<Transient>(
                        title: Text(
                          g.name,
                        ), // displays "native", "migrant", "transient"
                        value: g,
                        groupValue: _selectedTransient,
                        onChanged: (value) {
                          setState(() {
                            _selectedTransient = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Monthly Income"),
                  DropdownButtonFormField<int>(
                    value: _selectedMonthlyIncomeId,
                    items:
                        profileLookupProvder.allMonthlyIncomes.map((
                          monthlyIncome,
                        ) {
                          return DropdownMenuItem<int>(
                            value:
                                monthlyIncome
                                    .monthly_income_id, // the id goes into person table
                            child: Text(
                              monthlyIncome.range,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonthlyIncomeId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Daily Income"),
                  DropdownButtonFormField<int>(
                    value: _selectedDailyIncomeId,
                    items:
                        profileLookupProvder.allDailyIncomes.map((dailyIncome) {
                          return DropdownMenuItem<int>(
                            value:
                                dailyIncome
                                    .daily_income_id, // the id goes into person table
                            child: Text(
                              dailyIncome.range,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDailyIncomeId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Solo Parent"),
                    ...SoloParent.values.map((val) {
                      return RadioListTile<SoloParent>(
                        title: Text(
                          val.name,
                        ), // displays "no", "yes, registered", "yes, not registered"
                        value: val,
                        groupValue: _selectedSoloParent,
                        onChanged: (value) {
                          setState(() {
                            _selectedSoloParent = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Is the individual an OFW?"),
                    RadioListTile<bool>(
                      title: Text("Yes"),
                      value: true,
                      groupValue: _selectedOfw,
                      onChanged: (value) {
                        setState(() {
                          _selectedOfw = value;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: Text("No"),
                      value: false,
                      groupValue: _selectedOfw,
                      onChanged: (value) {
                        setState(() {
                          _selectedOfw = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Able to Read & Write"),
                    RadioListTile<bool>(
                      title: Text("Yes"),
                      value: true,
                      groupValue: _selectedLiterate,
                      onChanged: (value) {
                        setState(() {
                          _selectedLiterate = value;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: Text("No"),
                      value: false,
                      groupValue: _selectedLiterate,
                      onChanged: (value) {
                        setState(() {
                          _selectedLiterate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Is the individual a PWD?"),
                    RadioListTile<bool>(
                      title: Text("Yes"),
                      value: true,
                      groupValue: _selectedPwd,
                      onChanged: (value) {
                        setState(() {
                          _selectedPwd = value;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: Text("No"),
                      value: false,
                      groupValue: _selectedPwd,
                      onChanged: (value) {
                        setState(() {
                          _selectedPwd = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _selectedPwd == true
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name of Disability:"),
                        TextFormField(
                          controller: _disabilityNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text("Type of Disability:"),
                        TextFormField(
                          controller: _disabilityTypeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Is the individual a registered voter?"),
                    RadioListTile<bool>(
                      title: Text("Yes"),
                      value: true,
                      groupValue: _selectedRegisteredVoter,
                      onChanged: (value) {
                        setState(() {
                          _selectedRegisteredVoter = value;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: Text("No"),
                      value: false,
                      groupValue: _selectedRegisteredVoter,
                      onChanged: (value) {
                        setState(() {
                          _selectedRegisteredVoter = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _selectedRegisteredVoter == true
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Place of Vote Registry:"),
                        TextFormField(
                          controller: _placeOfVoteRegistryController,
                          decoration: InputDecoration(
                            hintText: "Enter the place of vote registry here",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Education"),
                  DropdownButtonFormField<int>(
                    value: _selectedEducationId,
                    items:
                        profileLookupProvder.allEducation.map((education) {
                          return DropdownMenuItem<int>(
                            value:
                                education
                                    .education_id, // the id goes into person table
                            child: Text(
                              education.level,
                            ), // name displayed to user
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEducationId = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Is the individual currently enrolled to a school?"),
                    ...CurrentlyEnrolled.values.map((val) {
                      return RadioListTile<CurrentlyEnrolled>(
                        title: Text(
                          val.label,
                        ), // displays "no", "yes_public", "yes_private"
                        value: val,
                        groupValue: _selectedCurrentlyEnrolled,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrentlyEnrolled = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),

              _selectedCurrentlyEnrolled != CurrentlyEnrolled.no
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter school enrolled in:"),
                        TextFormField(
                          controller: _enrolledAtController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Is the individual already deceased?"),
                    RadioListTile<bool>(
                      title: Text("Yes"),
                      value: true,
                      groupValue: _selectedDeceased,
                      onChanged: (value) {
                        setState(() {
                          _selectedDeceased = value;
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: Text("No"),
                      value: false,
                      groupValue: _selectedDeceased,
                      onChanged: (value) {
                        setState(() {
                          _selectedDeceased = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _selectedDeceased == true
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date of Death:"),
                        scn.DatePicker(
                          value: _deathDate,
                          mode: scn.PromptMode.popover,
                          // Disable selecting dates after "today".
                          stateBuilder: (date) {
                            if (date.isAfter(DateTime.now())) {
                              return scn.DateState.disabled;
                            }
                            return scn.DateState.enabled;
                          },
                          onChanged: (value) {
                            setState(() {
                              _deathDate = value;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email:"),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null; // It's fine if empty
                        }
                        if (!_emailRegex.hasMatch(value!)) {
                          return "Enter a valid email address";
                        }
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email here",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone Number:"),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null; // It's fine if empty
                        }
                        if (!_ph09Regex.hasMatch(value!)) {
                          return "Enter a valid Philippine phone number";
                        }
                      },
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number here",
                        helperText: "Phone number must not contain letters",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Occupation:"),
                    TextFormField(
                      controller: _occupationController,
                      decoration: InputDecoration(
                        hintText: "Enter your email here",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Text("Occupation Status:"),
                    ...OccupationStatus.values.map((val) {
                      return RadioListTile<OccupationStatus>(
                        title: Text(val.label),
                        value: val,
                        groupValue: _selectedOccupationStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedOccupationStatus = value;
                          });
                        },
                      );
                    }),
                    Text("Occupation Type:"),
                    ...OccupationType.values.map((val) {
                      return RadioListTile<OccupationType>(
                        title: Text(val.label),
                        value: val,
                        groupValue: _selectedOccupationType,
                        onChanged: (value) {
                          setState(() {
                            _selectedOccupationType = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gadgets:"),
                    ...Gadget.values.map((gadget) {
                      return CheckboxListTile(
                        title: Text(gadget.label),
                        value: _selectedGadgets.contains(gadget),
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedGadgets.add(gadget);
                            } else {
                              _selectedGadgets.remove(gadget);
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CTC Issue No:"),
                    TextFormField(
                      validator: (value) {
                        if (RegExp(r'[a-zA-Z]').hasMatch(value!)) {
                          return "Issue number cannot contain letters";
                        }
                      },
                      controller: _issueNumController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Text("Place of Issuance:"),
                    TextFormField(
                      controller: _placeOfIssueController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Issuance Date:"),
                        scn.DatePicker(
                          value: _issueDate,
                          mode: scn.PromptMode.popover,
                          // Disable selecting dates after "today".
                          stateBuilder: (date) {
                            if (date.isAfter(DateTime.now())) {
                              return scn.DateState.disabled;
                            }
                            return scn.DateState.enabled;
                          },
                          onChanged: (value) {
                            setState(() {
                              _issueDate = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Registration Status:"),
                    ...RegistrationStatus.values.map((val) {
                      return RadioListTile<RegistrationStatus>(
                        title: Text(
                          val.label,
                        ), // displays "completed", "partial", "refusal"
                        value: val,
                        groupValue: _selectedRegistrationStatus,
                        onChanged: (value) {
                          setState(() {
                            _selectedRegistrationStatus = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedRegistrationStatus == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select a registration status."),
                      ),
                    );
                    return; // stop submit
                  }
                  if (_formKey.currentState!.validate()) {
                    final addressCompanion = AddressesCompanion(
                      zone:
                          _newZone != null && _newZone != ""
                              ? db.Value(_newZone)
                              : db.Value.absent(),
                      street:
                          _newStreet != null && _newStreet != ""
                              ? db.Value(_newStreet)
                              : db.Value.absent(),
                      block:
                          _newBlock != null && _newBlock != ""
                              ? db.Value(_newBlock)
                              : db.Value.absent(),
                      lot:
                          _newLot != null && _newLot != ""
                              ? db.Value(_newLot)
                              : db.Value.absent(),
                    );

                    final hasAddress =
                        addressCompanion.zone.present ||
                        addressCompanion.street.present ||
                        addressCompanion.block.present ||
                        addressCompanion.lot.present;
                    int? _addressId;
                    if (hasAddress) {
                      _addressId = await householdProvider.addAddress(
                        addressCompanion,
                      );
                    }

                    final personCompanion = PersonsCompanion(
                      last_name: db.Value(_lastNameController.text),
                      first_name: db.Value(_firstNameController.text),
                      middle_name:
                          _middleNameController.text.isNotEmpty
                              ? db.Value(_middleNameController.text)
                              : db.Value.absent(),
                      suffix:
                          _suffixController.text.isNotEmpty
                              ? db.Value(_suffixController.text)
                              : db.Value.absent(),
                      sex:
                          _selectedSex != null
                              ? db.Value(_selectedSex)
                              : db.Value.absent(),
                      age:
                          _checkAge != null
                              ? db.Value(_checkAge)
                              : db.Value.absent(),
                      birth_date:
                          _birthDate != null
                              ? db.Value(_birthDate)
                              : db.Value.absent(),
                      birth_place:
                          _birthPlaceController.text.isNotEmpty
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
                      religion_id:
                          _selectedReligionId != null
                              ? db.Value(_selectedReligionId)
                              : db.Value.absent(),
                      ethnicity_id:
                          _selectedEthnicityId != null
                              ? db.Value(_selectedEthnicityId)
                              : db.Value.absent(),
                      blood_type_id:
                          _selectedBloodTypeId != null
                              ? db.Value(_selectedBloodTypeId)
                              : db.Value.absent(),
                      address_id:
                          _addressId != null
                              ? db.Value(_addressId)
                              : db.Value.absent(),
                      registration_place:
                          _registrationPlaceController.text.isNotEmpty
                              ? db.Value(_registrationPlaceController.text)
                              : db.Value.absent(),
                      residency:
                          _selectedResidency != null
                              ? db.Value(_selectedResidency)
                              : db.Value.absent(),
                      years_of_residency:
                          _yearsOfResidency != null
                              ? db.Value(_yearsOfResidency)
                              : db.Value.absent(),
                      transient_type:
                          _selectedTransient != null
                              ? db.Value(_selectedTransient)
                              : db.Value.absent(),
                      monthly_income_id:
                          _selectedMonthlyIncomeId != null
                              ? db.Value(_selectedMonthlyIncomeId)
                              : db.Value.absent(),
                      daily_income_id:
                          _selectedDailyIncomeId != null
                              ? db.Value(_selectedDailyIncomeId)
                              : db.Value.absent(),
                      solo_parent:
                          _selectedSoloParent != null
                              ? db.Value(_selectedSoloParent)
                              : db.Value.absent(),
                      ofw:
                          _selectedOfw != null
                              ? db.Value(_selectedOfw)
                              : db.Value.absent(),
                      literate:
                          _selectedLiterate != null
                              ? db.Value(_selectedLiterate)
                              : db.Value.absent(),
                      pwd:
                          _selectedPwd != null
                              ? db.Value(_selectedPwd)
                              : db.Value.absent(),

                      registered_voter:
                          _selectedRegisteredVoter != null
                              ? db.Value(_selectedRegisteredVoter)
                              : db.Value.absent(),
                      currently_enrolled:
                          _selectedCurrentlyEnrolled != null
                              ? db.Value(_selectedCurrentlyEnrolled)
                              : db.Value.absent(),
                      education_id:
                          _selectedEducationId != null
                              ? db.Value(_selectedEducationId)
                              : db.Value.absent(),
                      deceased:
                          _selectedDeceased != null
                              ? db.Value(_selectedDeceased)
                              : db.Value.absent(),
                      death_date:
                          _deathDate != null
                              ? db.Value(_deathDate)
                              : db.Value.absent(),
                      registration_status: db.Value(
                        _selectedRegistrationStatus!,
                      ),
                    );

                    personId = await personProvider.addPerson(personCompanion);

                    if (_emailController.text.isNotEmpty) {
                      final emailCompanion = EmailsCompanion(
                        person_id: db.Value(personId!),
                        email_address: db.Value(_emailController.text),
                      );

                      await contactInfoProvider.addEmail(emailCompanion);
                    }
                    if (_phoneNumberController.text.isNotEmpty) {
                      final phoneNumberCompanion = PhoneNumbersCompanion(
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

                        await contactInfoProvider.addGadget(gadgetCompanion);
                      }
                    }

                    if (_occupationController.text.isNotEmpty) {
                      final occupationCompanion = OccupationsCompanion(
                        person_id: db.Value(personId!),
                        occupation: db.Value(_occupationController.text),
                        occupation_status:
                            _selectedOccupationStatus != null
                                ? db.Value(_selectedOccupationStatus)
                                : db.Value.absent(),
                        occupation_type:
                            _selectedOccupationType != null
                                ? db.Value(_selectedOccupationType)
                                : db.Value.absent(),
                      );

                      await occupationProvider.addOccupation(
                        occupationCompanion,
                      );
                    }

                    if (_isSeniorCitizen == true) {
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
                        education_id:
                            _selectedEducationId != null
                                ? db.Value(_selectedEducationId!)
                                : db.Value.absent(),
                      );

                      await citizenRegistryProvider.addEnrolled(
                        enrolledCompanion,
                      );
                    }

                    if (_selectedPwd == true) {
                      final disabilityCompanion = DisabilitiesCompanion(
                        person_id: db.Value(personId!),
                        name:
                            _disabilityNameController.text.isNotEmpty
                                ? db.Value(_disabilityNameController.text)
                                : db.Value.absent(),
                        type:
                            _disabilityTypeController.text.isNotEmpty
                                ? db.Value(_disabilityTypeController.text)
                                : db.Value.absent(),
                      );

                      await citizenRegistryProvider.addDisability(
                        disabilityCompanion,
                      );
                    }

                    if (_selectedRegisteredVoter == true) {
                      final voterCompanion = VoterRegistriesCompanion(
                        person_id: db.Value(personId!),
                        place_of_vote_registry:
                            _placeOfVoteRegistryController.text.isNotEmpty
                                ? db.Value(_placeOfVoteRegistryController.text)
                                : db.Value.absent(),
                      );
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
                        date_of_issue:
                            _issueDate != null
                                ? db.Value(_issueDate)
                                : db.Value.absent(),
                      );
                    }
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
