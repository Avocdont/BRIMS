import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class MigrantTransientRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<MigrantTransientData>> allMigrantTransient() async {
    try {
      return await db.select(db.migrantTransients).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getMigrantTransientByID(int id) async {
    try {
      return await (db.select(db.migrantTransients)..where(
        (migrantTransient) => migrantTransient.migrant_transient_id.equals(
          id,
        ), // person here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addMigrantTransient(MigrantTransientsCompanion mtc) async {
    // MigrantTransientsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.migrantTransients)
          .insert(mtc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateMigrantTransient(MigrantTransientsCompanion mtc) async {
    // mtc holds row data
    try {
      return await db.update(db.migrantTransients).replace(mtc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteMigrantTransient(int id) async {
    try {
      return await (db.delete(db.migrantTransients)..where(
        (migrantTransient) => migrantTransient.migrant_transient_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
