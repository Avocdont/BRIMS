import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class PersonRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<PersonData>> allPersons() async {
    try {
      return await db.select(db.persons).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getPersonByID(int id) async {
    try {
      return await (db.select(db.persons)
            ..where(
              (person) => person.person_id
                  .equals(id), // person here specifically is a row
            ))
          .getSingle(); // .. is a cascde operator
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
            ..where((person) => person.person_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> getFullPersonDetails(int personId) async {
    try {
      final person = await (db.select(db.persons)
            ..where((p) => p.person_id.equals(personId)))
          .getSingleOrNull();
      if (person == null) return {};

      final results = await Future.wait([
        // [0-8] Existing...
        (db.select(db.addresses)
              ..where((a) => a.address_id.equals(person.address_id ?? -1)))
            .getSingleOrNull(),
        (db.select(db.occupations)..where((o) => o.person_id.equals(personId)))
            .getSingleOrNull(),
        (db.select(db.emails)..where((e) => e.person_id.equals(personId)))
            .getSingleOrNull(),
        (db.select(db.phoneNumbers)..where((p) => p.person_id.equals(personId)))
            .getSingleOrNull(),
        (db.select(db.householdMembers)
              ..where((h) => h.person_id.equals(personId)))
            .getSingleOrNull(),
        (db.select(db.enrolled)..where((e) => e.person_id.equals(personId)))
            .getSingleOrNull(),
        (db.select(db.healthInsurances)
              ..where((h) => h.person_id.equals(personId)))
            .get(),
        (db.select(db.disabilities)..where((d) => d.person_id.equals(personId)))
            .getSingleOrNull(),
        (db.select(db.voterRegistries)
              ..where((v) => v.person_id.equals(personId)))
            .getSingleOrNull(),

        // [9] CTC Records
        (db.select(db.cTCRecords)..where((c) => c.person_id.equals(personId)))
            .getSingleOrNull(),

        // [10] NEW: Gadgets (Returns a List)
        (db.select(db.gadgets)..where((g) => g.person_id.equals(personId)))
            .get(),

        // [11] NEW: Registered Senior
        (db.select(db.registeredSeniors)
              ..where((r) => r.person_id.equals(personId)))
            .getSingleOrNull(),
      ]);

      return {
        'person': person,
        'address': results[0],
        'occupation': results[1],
        'email': results[2],
        'phone': results[3],
        'householdMember': results[4],
        'enrolled': results[5],
        'insurance': results[6],
        'disability': results[7],
        'voter': results[8],
        'ctc': results[9],
        'gadgets': results[10], // List<GadgetData>
        'senior': results[11], // RegisteredSeniorsData
      };
    } catch (e) {
      // log("Error: $e");
      return {};
    }
  }
}
