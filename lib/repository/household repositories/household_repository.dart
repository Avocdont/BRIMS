/*import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class HouseholdRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<HouseholdData>> allPersons() async {
    try {
      return await db.select(db.persons).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getPersonByID(int id) async {
    try {
      return await (db.select(db.persons)..where(
        (person) =>
            person.person_id.equals(id), // person here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addPerson(PersonsCompanion p) async {
    // PersonsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.persons)
          .insert(p); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updatePerson(PersonsCompanion p) async {
    // p holds row data
    try {
      return await db.update(db.persons).replace(p);
    } catch (e) {
      log(e.toString());
    }
  }

  deletePerson(int id) async {
    try {
      return await (db.delete(db.persons)
        ..where((person) => person.person_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}*/
