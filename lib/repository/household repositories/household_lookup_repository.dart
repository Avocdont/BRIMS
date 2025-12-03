import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class HouseholdLookupRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ HouseholdTypes ------------
  Future<List<HouseholdTypeData>> allHouseholdTypes() async {
    try {
      return await db.select(db.householdTypes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getHouseholdTypeByID(int id) async {
    try {
      return await (db.select(db.householdTypes)..where(
        (householdType) => householdType.household_type_id.equals(
          id,
        ), // householdtype here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addHouseholdType(HouseholdTypesCompanion htc) async {
    // HouseholdTypesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.householdTypes)
          .insert(htc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateHouseholdType(HouseholdTypesCompanion htc) async {
    // htc holds row data
    try {
      return await db.update(db.householdTypes).replace(htc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteHouseholdType(int id) async {
    try {
      return await (db.delete(db.householdTypes)..where(
        (householdType) => householdType.household_type_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ BuildingTypes ------------

  Future<List<BuildingTypeData>> allBuildingTypes() async {
    try {
      return await db.select(db.buildingTypes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getBuildingTypeByID(int id) async {
    try {
      return await (db.select(db.buildingTypes)..where(
        (buildingType) => buildingType.building_type_id.equals(
          id,
        ), // buildingtype here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addBuildingType(BuildingTypesCompanion btc) async {
    // BuildingTypesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.buildingTypes)
          .insert(btc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateBuildingType(BuildingTypesCompanion btc) async {
    // btc holds row data
    try {
      return await db.update(db.buildingTypes).replace(btc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteBuildingType(int id) async {
    try {
      return await (db.delete(db.buildingTypes)..where(
        (buildingType) => buildingType.building_type_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ OwnershipTypes ------------

  Future<List<OwnershipTypeData>> allOwnershipTypes() async {
    try {
      return await db.select(db.ownershipTypes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getOwnershipTypeByID(int id) async {
    try {
      return await (db.select(db.ownershipTypes)..where(
        (ownershipType) => ownershipType.ownership_type_id.equals(
          id,
        ), // ownershiptype here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addOwnershipType(OwnershipTypesCompanion ostc) async {
    // OwnershipTypesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.ownershipTypes)
          .insert(ostc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateOwnershipType(OwnershipTypesCompanion ostc) async {
    // ostc holds row data
    try {
      return await db.update(db.ownershipTypes).replace(ostc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteOwnershipType(int id) async {
    try {
      return await (db.delete(db.ownershipTypes)..where(
        (ownershipType) => ownershipType.ownership_type_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
