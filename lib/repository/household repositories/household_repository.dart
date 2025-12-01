import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

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
}
