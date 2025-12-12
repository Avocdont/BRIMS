import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:brims/models/household_models.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/repository/profiling%20repositories/person_repository.dart';
import 'package:drift/drift.dart';

class HouseholdRepository {
  AppDatabase db = locator.get<AppDatabase>();

  PersonRepository personRepository = PersonRepository();

  // --- HOUSEHOLDS ---
  Future<List<HouseholdData>> allHouseholds() async {
    try {
      return await db.select(db.households).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getHouseholdByID(int id) async {
    try {
      return await (db.select(db.households)
            ..where((household) => household.household_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  searchHouseholdHead(String lastName, String firstName) async {
    try {
      return await (db.select(db.persons)
            ..where((persons) =>
                persons.last_name.equals(lastName) &
                persons.first_name.equals(firstName)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addHousehold(HouseholdsCompanion hc) async {
    try {
      return await db.into(db.households).insert(hc);
    } catch (e) {
      log(e.toString());
    }
  }

  // ** FIX: Use WRITE to update specific columns without replacing (deleting) the row **
  updateHousehold(HouseholdsCompanion hc) async {
    try {
      return await (db.update(db.households)
            ..where((t) => t.household_id.equals(hc.household_id.value)))
          .write(hc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteHousehold(int id) async {
    try {
      return await (db.delete(db.households)
            ..where((household) => household.household_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- ADDRESSES ---
  Future<List<AddressData>> allAddresses() async {
    try {
      return await db.select(db.addresses).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getAddressByID(int id) async {
    try {
      return await (db.select(db.addresses)
            ..where((address) => address.address_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addAddress(AddressesCompanion ac) async {
    return await db.into(db.addresses).insert(ac);
  }

  updateAddress(AddressesCompanion ac) async {
    try {
      // For address, replace is usually fine, or you can switch to .write() if needed
      return await db.update(db.addresses).replace(ac);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteAddress(int id) async {
    try {
      return await (db.delete(db.addresses)
            ..where((address) => address.address_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> searchAddresses({
    String? zone,
    String? street,
    String? block,
    String? lot,
  }) async {
    final query = db.select(db.addresses).join([
      leftOuterJoin(
        db.households,
        db.households.address_id.equalsExp(db.addresses.address_id),
      ),
    ]);

    if (zone != null && zone.isNotEmpty) {
      query.where(db.addresses.zone.like('%$zone%'));
    }
    if (street != null && street.isNotEmpty) {
      query.where(db.addresses.street.like('%$street%'));
    }
    if (block != null && block.isNotEmpty) {
      query.where(db.addresses.block.like('%$block%'));
    }
    if (lot != null && lot.isNotEmpty) {
      query.where(db.addresses.lot.like('%$lot%'));
    }

    final results = await query.get();

    return results.map((row) {
      final address = row.readTable(db.addresses);
      final household = row.readTableOrNull(db.households);

      return {
        'householdId': household?.household_id,
        'address': {
          'id': address.address_id,
          'zone': address.zone ?? '',
          'street': address.street ?? '',
          'block': address.block ?? '',
          'lot': address.lot ?? '',
        },
      };
    }).toList();
  }

  // --- SERVICES ---
  Future<List<ServiceData>> allServices() async {
    try {
      return await db.select(db.services).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getServiceByID(int id) async {
    try {
      return await (db.select(db.services)
            ..where((service) => service.service_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addService(ServicesCompanion sc) async {
    try {
      return await db.into(db.services).insert(sc);
    } catch (e) {
      log(e.toString());
    }
  }

  updateService(ServicesCompanion sc) async {
    try {
      return await db.update(db.services).replace(sc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteService(int id) async {
    try {
      return await (db.delete(db.services)
            ..where((service) => service.service_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- PRIMARY NEEDS ---
  Future<List<PrimaryNeedData>> allPrimaryNeeds() async {
    try {
      return await db.select(db.primaryNeeds).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getPrimaryNeedByID(int id) async {
    try {
      return await (db.select(db.primaryNeeds)
            ..where((need) => need.primary_need_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addPrimaryNeed(PrimaryNeedsCompanion pnc) async {
    try {
      return await db.into(db.primaryNeeds).insert(pnc);
    } catch (e) {
      log(e.toString());
    }
  }

  updatePrimaryNeed(PrimaryNeedsCompanion pnc) async {
    try {
      return await db.update(db.primaryNeeds).replace(pnc);
    } catch (e) {
      log(e.toString());
    }
  }

  deletePrimaryNeed(int id) async {
    try {
      return await (db.delete(db.primaryNeeds)
            ..where((need) => need.primary_need_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- FEMALE MORTALITIES ---
  Future<List<FemaleMortalityData>> allFemaleMortalities() async {
    try {
      return await db.select(db.femaleMortalities).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getFemaleMortalityByID(int id) async {
    try {
      return await (db.select(db.femaleMortalities)
            ..where((fm) => fm.female_mortality_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addFemaleMortality(FemaleMortalitiesCompanion fmc) async {
    try {
      return await db.into(db.femaleMortalities).insert(fmc);
    } catch (e) {
      log(e.toString());
    }
  }

  updateFemaleMortality(FemaleMortalitiesCompanion fmc) async {
    try {
      return await db.update(db.femaleMortalities).replace(fmc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteFemaleMortality(int id) async {
    try {
      return await (db.delete(db.femaleMortalities)
            ..where((fm) => fm.female_mortality_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- CHILD MORTALITIES ---
  Future<List<ChildMortalityData>> allChildMortalities() async {
    try {
      return await db.select(db.childMortalities).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getChildMortalityByID(int id) async {
    try {
      return await (db.select(db.childMortalities)
            ..where((cm) => cm.child_mortality_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addChildMortality(ChildMortalitiesCompanion cmc) async {
    try {
      return await db.into(db.childMortalities).insert(cmc);
    } catch (e) {
      log(e.toString());
    }
  }

  updateChildMortality(ChildMortalitiesCompanion cmc) async {
    try {
      return await db.update(db.childMortalities).replace(cmc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteChildMortality(int id) async {
    try {
      return await (db.delete(db.childMortalities)
            ..where((cm) => cm.child_mortality_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- FUTURE RESIDENCIES ---
  Future<List<FutureResidency>> allFutureResidencies() async {
    try {
      return await db.select(db.futureResidencies).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getFutureResidencyByID(int id) async {
    try {
      return await (db.select(db.futureResidencies)
            ..where((fr) => fr.future_residency_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addFutureResidency(FutureResidenciesCompanion frc) async {
    try {
      return await db.into(db.futureResidencies).insert(frc);
    } catch (e) {
      log(e.toString());
    }
  }

  updateFutureResidency(FutureResidenciesCompanion frc) async {
    try {
      return await db.update(db.futureResidencies).replace(frc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteFutureResidency(int id) async {
    try {
      return await (db.delete(db.futureResidencies)
            ..where((fr) => fr.future_residency_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- HOUSEHOLD VISITS ---
  Future<List<HouseholdVisitData>> allHouseholdVisits() async {
    try {
      return await db.select(db.householdVisits).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getHouseholdVisitByID(int id) async {
    try {
      return await (db.select(db.householdVisits)
            ..where((visit) => visit.household_visit_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addHouseholdVisit(HouseholdVisitsCompanion hvc) async {
    try {
      return await db.into(db.householdVisits).insert(hvc);
    } catch (e) {
      log(e.toString());
    }
  }

  updateHouseholdVisit(HouseholdVisitsCompanion hvc) async {
    try {
      return await db.update(db.householdVisits).replace(hvc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteHouseholdVisit(int id) async {
    try {
      return await (db.delete(db.householdVisits)
            ..where((visit) => visit.household_visit_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // --- HOUSEHOLD MEMBERS & RELATIONSHIPS ---

  // ** Added to fetch members **
  Future<List<HouseholdMemberData>> allHouseholdMembers() async {
    try {
      return await db.select(db.householdMembers).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> addHouseholdMember(HouseholdMembersCompanion hmc) async {
    await db.into(db.householdMembers).insert(hmc);
  }

  // ** Added to delete specific member **
  Future<void> deleteHouseholdMember(int householdId, int personId) async {
    try {
      await (db.delete(db.householdMembers)
            ..where((m) =>
                m.household_id.equals(householdId) &
                m.person_id.equals(personId)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addHouseholdRelationship(
    HouseholdRelationshipsCompanion hrc,
  ) async {
    await db.into(db.householdRelationships).insert(hrc);
  }

  // Update an existing relationship
  Future<void> updateHouseholdRelationship(
      HouseholdRelationshipsCompanion hrc) async {
    await (db.update(db.householdRelationships)
          ..where((t) => t.household_relationship_id
              .equals(hrc.household_relationship_id.value)))
        .write(hrc);
  }

  // Delete a relationship (Useful if a user sets "Relation" back to empty/null)
  Future<void> deleteHouseholdRelationship(int id) async {
    await (db.delete(db.householdRelationships)
          ..where((t) => t.household_relationship_id.equals(id)))
        .go();
  }

  // Fetch all relationships (Required for Edit Page to load existing data)
  Future<List<HouseholdRelationship>> getAllHouseholdRelationships() async {
    return await db.select(db.householdRelationships).get();
  }

  // --- QUERY BUILDER ---
  JoinedSelectStatement _buildQuery(
    String? searchQuery,
    HouseholdFilterOptions filters,
  ) {
    // 1. Base Join
    final query = db.select(db.households).join([
      leftOuterJoin(
        db.addresses,
        db.addresses.address_id.equalsExp(db.households.address_id),
      ),
      leftOuterJoin(
        db.buildingTypes,
        db.buildingTypes.building_type_id
            .equalsExp(db.households.building_type_id),
      ),
    ]);

    // 2. Search Filter (Head Name)
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(db.households.head.contains(searchQuery));
    }

    // 3. Apply Filters
    if (filters.householdTypes.isNotEmpty) {
      query.where(db.households.household_type_id.isIn(
        filters.householdTypes.map((e) => e.name),
      ));
    }
    if (filters.ownershipTypes.isNotEmpty) {
      query.where(db.households.ownership_type_id.isIn(
        filters.ownershipTypes.map((e) => e.name),
      ));
    }
    if (filters.buildingTypeIds.isNotEmpty) {
      query.where(db.households.building_type_id.isIn(filters.buildingTypeIds));
    }

    return query;
  }

  // --- GET DATA ---
  Future<List<HouseholdTableRow>> getHouseholdTableData({
    int page = 0,
    int limit = 10,
    String? searchQuery,
    required HouseholdFilterOptions filters,
    HouseholdSortColumn sortColumn = HouseholdSortColumn.none,
    SortDirection sortDirection = SortDirection.asc,
  }) async {
    try {
      final joinedQuery = _buildQuery(searchQuery, filters);

      // --- SORTING ---
      OrderingMode mode = sortDirection == SortDirection.asc
          ? OrderingMode.asc
          : OrderingMode.desc;

      if (sortColumn != HouseholdSortColumn.none) {
        Expression? sortExpr;

        switch (sortColumn) {
          case HouseholdSortColumn.head:
            sortExpr = db.households.head;
            break;
          case HouseholdSortColumn.street:
            sortExpr = db.addresses.street;
            break;
          case HouseholdSortColumn.zone:
            sortExpr = db.addresses.zone;
            break;
          case HouseholdSortColumn.block:
            sortExpr = db.addresses.block;
            break;
          case HouseholdSortColumn.lot:
            sortExpr = db.addresses.lot;
            break;
          case HouseholdSortColumn.members:
            sortExpr = db.households.household_members_num;
            break;
          case HouseholdSortColumn.householdType:
            sortExpr = db.households.household_type_id;
            break;
          case HouseholdSortColumn.ownershipType:
            sortExpr = db.households.ownership_type_id;
            break;
          case HouseholdSortColumn.buildingType:
            sortExpr = db.buildingTypes.type;
            break;
          default:
            break;
        }

        if (sortExpr != null) {
          joinedQuery.orderBy([OrderingTerm(expression: sortExpr, mode: mode)]);
        }
      }

      // --- PAGINATION ---
      joinedQuery.limit(limit, offset: page * limit);

      final rows = await joinedQuery.get();

      // --- MAPPING ---
      return rows.map((row) {
        final household = row.readTable(db.households);
        final address = row.readTableOrNull(db.addresses);
        final bType = row.readTableOrNull(db.buildingTypes);

        return HouseholdTableRow(
          householdId: household.household_id,
          headName: household.head ?? 'N/A',
          street: address?.street ?? 'N/A',
          zone: address?.zone ?? 'N/A',
          block: address?.block ?? 'N/A',
          lot: address?.lot ?? 'N/A',
          memberCount: household.household_members_num ?? 0,

          // Dynamic fields
          householdType: household.household_type_id?.name, // Enum to String
          ownershipType: household.ownership_type_id?.name, // Enum to String
          buildingType: bType?.type,
        );
      }).toList();
    } catch (e) {
      log("Error fetching household table: $e");
      return [];
    }
  }

  // --- COUNT (For Paginator) ---
  Future<int> getTotalHouseholdCount({
    String? searchQuery,
    required HouseholdFilterOptions filters,
  }) async {
    final baseQuery = _buildQuery(searchQuery, filters);

    final countExp = db.households.household_id.count();

    // 1. Add the column (returns void)
    baseQuery.addColumns([countExp]);

    // 2. Execute the query
    final result = await baseQuery.map((row) => row.read(countExp)).getSingle();

    return result ?? 0;
  }
}
