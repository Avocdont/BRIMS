import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class ReligionRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<ReligionData>> allReligions() async {
    try {
      return await db.select(db.religions).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getReligionByID(int id) async {
    try {
      return await (db.select(db.religions)..where(
        (religion) => religion.religion_id.equals(
          id,
        ), // religion here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addReligion(ReligionsCompanion rc) async {
    // ReligionsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.religions)
          .insert(rc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateReligion(ReligionsCompanion rc) async {
    // r holds row data
    try {
      return await db.update(db.religions).replace(rc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteReligion(int id) async {
    try {
      return await (db.delete(db.religions)
        ..where((religion) => religion.religion_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
