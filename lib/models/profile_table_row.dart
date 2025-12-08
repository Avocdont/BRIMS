// lib/models/profile_table_row.dart

import 'package:brims/database/tables/enums.dart';

class ProfileTableRow {
  final int personId;
  final String fullName;
  final int? age;
  final Sex? sex;
  final CivilStatus? civilStatus;
  final String address;

  // Added the raw ID for navigation logic
  final int? householdId;
  // Kept the string for easy display
  final String householdInfo;

  final String occupation;
  final String contactNumber;
  final RegistrationStatus registrationStatus;

  ProfileTableRow({
    required this.personId,
    required this.fullName,
    this.age,
    this.sex,
    this.civilStatus,
    required this.address,
    this.householdId,
    required this.householdInfo,
    required this.occupation,
    required this.contactNumber,
    required this.registrationStatus,
  });
}
