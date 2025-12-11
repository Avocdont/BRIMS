import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:brims/repository/profiling%20repositories/person_repository.dart';
import 'package:drift/drift.dart';

class HouseholdRepository {
  AppDatabase db = locator.get<AppDatabase>();

  PersonRepository personRepository = PersonRepository();

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
            ..where(
              (household) => household.household_id.equals(
                id,
              ), // household here specifically is a row
            ))
          .getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  searchHouseholdHead(String lastName, String firstName) async {
    try {
      return await (db.select(db.persons)
            ..where(
              (persons) =>
                  persons.last_name.equals(lastName) &
                  persons.first_name.equals(firstName),
            ))
          .getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addHousehold(HouseholdsCompanion hc) async {
    // HouseholdsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.households)
          .insert(hc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateHousehold(HouseholdsCompanion hc) async {
    // hc holds row data
    try {
      return await db.update(db.households).replace(hc);
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
    // hc holds row data
    try {
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
    // Named parameters, optional but you have to specify which arguments you're gonna pass. Ex: Zone : "1B"
    String? zone,
    String? street,
    String? block,
    String? lot,
  }) async {
    // Select all addresses whose id matches those in
    // household's address_id and even those addresses with
    // no matching household address_id but leave those as null
    final query = db.select(db.addresses).join([
      leftOuterJoin(
        db.households,
        db.households.address_id.equalsExp(db.addresses.address_id),
      ),
    ]);

    // If user passed a zone, street, block, lot, add these queries
    if (zone != null && zone.isNotEmpty) {
      query.where(db.addresses.zone.like('%$zone%'));
      // From all the addresses above,
      // narrow it down to where zone in address is like user typed zone
    }
    if (street != null && street.isNotEmpty) {
      query.where(db.addresses.street.like('%$street%'));
      // Same as above
    }
    if (block != null && block.isNotEmpty) {
      query.where(db.addresses.block.like('%$block%'));
    }
    if (lot != null && lot.isNotEmpty) {
      query.where(db.addresses.lot.like('%$lot%'));
    }

    final results =
        await query.get(); // Contains combined columns of address and household

    // Map each row to a null-safe result
    return results.map((row) {
      // Map row, if empty list, code below doesn't execute
      // Assign data from the address table to address
      final address = row.readTable(db.addresses);
      // Assign data from the household table to household
      final household = row.readTableOrNull(db.households);

      return {
        // A map or dictionary
        'householdId': household?.household_id, // null if no household
        'address': {
          // Use address.zone if not null, else empty string
          'id': address.address_id,
          'zone': address.zone ?? '',
          'street': address.street ?? '',
          'block': address.block ?? '',
          'lot': address.lot ?? '',
        },
      };
    }).toList();
  }
  // ------------ Services ------------

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

  // ------------ Primary Needs ------------

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

  // ------------ Female Mortalities ------------

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

  // ------------ Child Mortalities ------------

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

  // ------------ Future Residencies ------------

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

  Future<void> addHouseholdMember(HouseholdMembersCompanion hmc) async {
    await db.into(db.householdMembers).insert(hmc);
  }

  Future<void> addHouseholdRelationship(
    HouseholdRelationshipsCompanion hrc,
  ) async {
    await db.into(db.householdRelationships).insert(hrc);
  }
}
