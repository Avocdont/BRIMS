import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class NationalityRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<NationalityData>> allNationalities() async {
    try {
      return await db.select(db.nationalities).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getNationalityByID(int id) async {
    try {
      return await (db.select(db.nationalities)..where(
        (nationality) => nationality.nationality_id.equals(
          id,
        ), // nationality here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addNationality(NationalitiesCompanion nc) async {
    // NationalitiesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.nationalities)
          .insert(nc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updatNationality(NationalitiesCompanion nc) async {
    // nc holds row data
    try {
      return await db.update(db.nationalities).replace(nc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteNationality(int id) async {
    try {
      return await (db.delete(db.nationalities)
        ..where((nationality) => nationality.nationality_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
