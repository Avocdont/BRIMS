import 'package:brims/database/tables/enums.dart';

enum HouseholdSortColumn {
  none,
  head,
  street,
  zone,
  block,
  lot,
  members,
  // Dynamic columns
  householdType,
  buildingType,
  ownershipType
}

class HouseholdTableRow {
  final int householdId;
  final String headName;
  final String street;
  final String zone;
  final String block;
  final String lot;
  final int memberCount;

  // Dynamic Fields (Nullable, only shown if filtered)
  final String? householdType;
  final String? buildingType;
  final String? ownershipType;

  HouseholdTableRow({
    required this.householdId,
    required this.headName,
    required this.street,
    required this.zone,
    required this.block,
    required this.lot,
    required this.memberCount,
    this.householdType,
    this.buildingType,
    this.ownershipType,
  });
}

class HouseholdFilterOptions {
  final List<HouseholdTypes> householdTypes;
  final List<int> buildingTypeIds;
  final List<OwnershipTypes> ownershipTypes;

  HouseholdFilterOptions({
    this.householdTypes = const [],
    this.buildingTypeIds = const [],
    this.ownershipTypes = const [],
  });

  bool get isEmpty =>
      householdTypes.isEmpty &&
      buildingTypeIds.isEmpty &&
      ownershipTypes.isEmpty;
}
