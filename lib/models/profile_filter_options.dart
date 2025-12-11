import 'package:brims/database/tables/enums.dart';

enum SortColumn { none, name, age }

enum SortDirection { asc, desc }

class ProfileFilterOptions {
  List<Sex> sex;
  List<CivilStatus> civilStatus;
  List<int> nationalityIds;
  List<int> ethnicityIds;
  List<int> religionIds;
  List<int> educationIds;
  List<int> bloodTypeIds;

  List<RegistrationStatus> registrationStatus;
  bool? hasDisability;
  CurrentlyEnrolled? currentlyEnrolled;
  bool? registeredVoter;

  int? minAge;
  int? maxAge;

  ProfileFilterOptions({
    // Initialize with empty mutable lists, NOT const []
    List<Sex>? sex,
    List<CivilStatus>? civilStatus,
    List<int>? nationalityIds,
    List<int>? ethnicityIds,
    List<int>? religionIds,
    List<int>? educationIds,
    List<int>? bloodTypeIds,
    List<RegistrationStatus>? registrationStatus,
    this.hasDisability,
    this.currentlyEnrolled,
    this.registeredVoter,
    this.minAge,
    this.maxAge,
  }) : sex = sex ?? [],
       civilStatus = civilStatus ?? [],
       nationalityIds = nationalityIds ?? [],
       ethnicityIds = ethnicityIds ?? [],
       religionIds = religionIds ?? [],
       educationIds = educationIds ?? [],
       bloodTypeIds = bloodTypeIds ?? [],
       registrationStatus = registrationStatus ?? [];

  // Helper to deep copy (useful for the Dialog)
  ProfileFilterOptions copy() {
    return ProfileFilterOptions(
      sex: List.from(sex),
      civilStatus: List.from(civilStatus),
      nationalityIds: List.from(nationalityIds),
      ethnicityIds: List.from(ethnicityIds),
      religionIds: List.from(religionIds),
      educationIds: List.from(educationIds),
      bloodTypeIds: List.from(bloodTypeIds),
      registrationStatus: List.from(registrationStatus),
      hasDisability: hasDisability,
      currentlyEnrolled: currentlyEnrolled,
      registeredVoter: registeredVoter,
      minAge: minAge,
      maxAge: maxAge,
    );
  }

  void clear() {
    // Re-assign empty lists instead of .clear() to avoid unmodifiable errors
    sex = [];
    civilStatus = [];
    nationalityIds = [];
    ethnicityIds = [];
    religionIds = [];
    educationIds = [];
    bloodTypeIds = [];
    registrationStatus = [];
    hasDisability = null;
    currentlyEnrolled = null;
    registeredVoter = null;
    minAge = null;
    maxAge = null;
  }
}
