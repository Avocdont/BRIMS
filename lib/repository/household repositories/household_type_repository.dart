import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class HouseholdTypeRepository {
  AppDatabase db = locator.get<AppDatabase>();

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
}
