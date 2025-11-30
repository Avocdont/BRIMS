import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class BloodTypeRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<BloodTypeData>> allBloodTypes() async {
    try {
      return await db.select(db.bloodTypes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getBloodTypeByID(int id) async {
    try {
      return await (db.select(db.bloodTypes)..where(
        (bloodType) => bloodType.blood_type_id.equals(
          id,
        ), // bloodType here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addBloodType(BloodTypesCompanion btc) async {
    // BloodTypesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.bloodTypes)
          .insert(btc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateBloodType(BloodTypesCompanion btc) async {
    // btc holds row data
    try {
      return await db.update(db.bloodTypes).replace(btc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteBloodType(int id) async {
    try {
      return await (db.delete(db.bloodTypes)
        ..where((bloodType) => bloodType.blood_type_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
