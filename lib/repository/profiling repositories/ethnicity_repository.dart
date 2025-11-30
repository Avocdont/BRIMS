import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class EthnicityRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<EthnicityData>> allEthnicities() async {
    try {
      return await db.select(db.ethnicities).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getEthnicityByID(int id) async {
    try {
      return await (db.select(db.ethnicities)..where(
        (ethnicity) => ethnicity.ethnicity_id.equals(
          id,
        ), // ethnicity here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addEthnicity(EthnicitiesCompanion ec) async {
    // EthnicitiesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.ethnicities)
          .insert(ec); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateEthnicity(EthnicitiesCompanion ec) async {
    // ec holds row data
    try {
      return await db.update(db.ethnicities).replace(ec);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteEthnicity(int id) async {
    try {
      return await (db.delete(db.ethnicities)
        ..where((ethnicity) => ethnicity.ethnicity_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
