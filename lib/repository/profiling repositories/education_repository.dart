import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class EducationRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<EducationData>> allEducation() async {
    try {
      return await db.select(db.education).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getEducationByID(int id) async {
    try {
      // education here is the table
      return await (db.select(db.education)..where(
        (education) => education.education_id.equals(
          id,
        ), // education here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addEducation(EducationCompanion edc) async {
    // EducationCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.education)
          .insert(edc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateEducation(EducationCompanion edc) async {
    // edc holds row data
    try {
      return await db.update(db.education).replace(edc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteEducation(int id) async {
    try {
      return await (db.delete(db.education)
        ..where((education) => education.education_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
