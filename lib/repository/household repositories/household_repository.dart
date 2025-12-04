import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:drift/drift.dart';

class HouseholdRepository {
  AppDatabase db = locator.get<AppDatabase>();

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
      return await (db.select(db.households)..where(
        (household) => household.household_id.equals(
          id,
        ), // household here specifically is a row
      )).getSingle(); // .. is a cascde operator
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
        ..where((household) => household.household_id.equals(id))).go();
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
        ..where((address) => address.address_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addAddress(AddressesCompanion ac) async {
    // HouseholdsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.addresses)
          .insert(ac); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
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
        ..where((address) => address.address_id.equals(id))).go();
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
          'zone': address.zone ?? '',
          'street': address.street ?? '',
          'block': address.block ?? '',
          'lot': address.lot ?? '',
        },
      };
    }).toList();
  }
}
