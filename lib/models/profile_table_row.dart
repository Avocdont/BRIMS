import 'package:brims/database/tables/enums.dart';

class ProfileTableRow {
  final int personId;
  final String fullName;
  final int? age;
  final Sex? sex;
  final CivilStatus? civilStatus;
  final String address;
  final int? householdId;
  final String householdInfo;
  // Removed Occupation
  final String contactNumber;
  final RegistrationStatus registrationStatus;

  // New optional fields for dynamic columns
  final String? nationality;
  final String? ethnicity;
  final String? religion;
  final String? education;
  final String? bloodType;

  ProfileTableRow({
    required this.personId,
    required this.fullName,
    this.age,
    this.sex,
    this.civilStatus,
    required this.address,
    this.householdId,
    required this.householdInfo,
    required this.contactNumber,
    required this.registrationStatus,
    this.nationality,
    this.ethnicity,
    this.religion,
    this.education,
    this.bloodType,
  });
}
