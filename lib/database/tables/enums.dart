enum Sex { male, female }

enum CivilStatus { single, married, annulled, widowed, separated, liveIn }

enum SoloParent { no, yes_registered, yes_not_registered }

enum RegistrationStatus { completed, partial, refusal }

enum CurrentlyEnrolled { no, yes_public, yes_private }

enum Residency { permanent, temporary }

enum Transient { native, migrant, transient }

enum Immunization { fully_immunized, not_fully_immunized }

enum OccupationStatus { permanent, casual, contractual, none }

enum OccupationType {
  private,
  government,
  self_employed,
  employer_in_own_business,
  none,
}

enum Gadget { mobile, television, computer, psp, ipod }

enum HouseholdTypes { common_household, institutional }

enum ClientTypes {
  youth,
  adult,
  children,
  men,
  women,
  senior_citizen,
  solo_parent,
  all_types,
}

enum OwnershipTypes {
  rent_free_with_consent_of_owner,
  rent_free_without_consent_of_owner,
  rented,
  owned_or_being_amortized,
}

enum BarangayPositions {
  punong_barangay,
  brgy_secretary,
  brgy_treasurer,
  brgy_kagawad,
  bhw,
  bhrao,
  brgy_aide,
  sk_chairperson,
  sk_kagawad,
  brygy_tanod,
  lupon_master,
}

enum UserType { admin, brgy_secretary, brgy_staff }

enum ChangeType { added, updated, deleted }

enum PageChanged { profiling, household }
