import 'package:brims/provider/household%20providers/household_provider.dart';
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

  // Insert to person table
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _suffixController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _residencyYearsController = TextEditingController();
  TextEditingController _birthPlaceController = TextEditingController();
  DateTime? _birthDate;
  DateTime? _deathDate;
  DateTime? _registrationDate;

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
  TextEditingController _zoneController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _blockController = TextEditingController();
  TextEditingController _lotController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer3<
        ProfileLookupProvider,
        HouseholdLookupProvider,
        HouseholdProvider
      >(
        builder: (
          _,
          profileLookupProvder,
          householdLookupProvider,
          householdProvider,
          _,
        ) {
          return SingleChildScrollView(
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
                            if (RegExp(r'[0-9]').hasMatch(value!)) {
                              return "Age cannot contain letters";
                            }
                            if (value!.contains(RegExp(r'-\d'))) {
                              return "Age must not be a negative number";
                            }
                          },
                          controller: _ageController,
                          decoration: InputDecoration(
                            hintText: "Enter the age here",
                            helperText: "Age must not contain letters",
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
                            final results = householdProvider.searchAddresses(
                              zone: _zoneController.text,
                              street: _streetController.text,
                              block: _blockController.text,
                              lot: _lotController.text,
                            );
                            setState(() {
                              _searchedAddress = results;
                            });
                          },
                          child: Text("Search"),
                        ),
                        _searchedAddress.isNotEmpty
                            ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Household Id: ${_searchedAddress[0]["household_id"]}",
                                ),
                                Text("Zone: ${_searchedAddress[0]["zone"]}"),
                                Text(
                                  "Street: ${_searchedAddress[0]["street"]}",
                                ),
                                Text("Block: ${_searchedAddress[0]["block"]}"),
                                Text("Lot: ${_searchedAddress[0]["lot"]}"),
                              ],
                            )
                            : Text("No results found"),
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
                          // validator: (value) {
                          //   if (RegExp(r'[0-9]').hasMatch(value!)) {
                          //     return "Middle name cannot contain numbers";
                          //   }
                          // },
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                            profileLookupProvder.allEthnicities.map((
                              ethnicity,
                            ) {
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                            if (RegExp(r'[0-9]').hasMatch(value!)) {
                              return "years of residency cannot contain letters";
                            }
                            if (value!.contains(RegExp(r'-\d'))) {
                              return "years of residency must not be a negative number";
                            }
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                            profileLookupProvder.allDailyIncomes.map((
                              dailyIncome,
                            ) {
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Is the individual currently enrolled to a school?",
                        ),
                        ...CurrentlyEnrolled.values.map((val) {
                          return RadioListTile<CurrentlyEnrolled>(
                            title: Text(
                              val.name,
                            ), // displays "no", "yes, public", "yes, private"
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
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
                  Padding(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Registration Date:"),
                        scn.DatePicker(
                          value: _registrationDate,
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
                              _registrationDate = value;
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
                        Text("Registration Status:"),
                        ...RegistrationStatus.values.map((val) {
                          return RadioListTile<RegistrationStatus>(
                            title: Text(
                              val.name,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
