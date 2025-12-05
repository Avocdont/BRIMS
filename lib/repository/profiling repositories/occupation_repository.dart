import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class OccupationRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<OccupationData>> allOccupations() async {
    try {
      return await db.select(db.occupations).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getOccupationByID(int id) async {
    try {
      return await (db.select(db.occupations)..where(
        (occupation) => occupation.occupation_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addOccupation(OccupationsCompanion oc) async {
    try {
      return await db
          .into(db.occupations)
          .insert(oc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateOccupation(OccupationsCompanion oc) async {
    try {
      return await db.update(db.occupations).replace(oc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteOccupation(int id) async {
    try {
      return await (db.delete(db.occupations)
        ..where((occupation) => occupation.occupation_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
