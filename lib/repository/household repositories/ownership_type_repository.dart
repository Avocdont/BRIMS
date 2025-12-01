import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class OwnershipTypeRepository {
  AppDatabase db = locator.get<AppDatabase>();

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
