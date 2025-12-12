import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
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
}
