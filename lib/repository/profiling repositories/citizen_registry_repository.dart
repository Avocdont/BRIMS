import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class CitizenRegistryRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Voter Registry ------------

  Future<List<VoterRegistryData>> allVoterRegistries() async {
    try {
      return await db.select(db.voterRegistries).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getVoterRegistryByID(int id) async {
    try {
      return await (db.select(db.voterRegistries)..where(
        (voterRegistry) => voterRegistry.voter_registry_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addVoterRegistry(VoterRegistriesCompanion vrc) async {
    try {
      return await db
          .into(db.voterRegistries)
          .insert(vrc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateVoterRegistry(VoterRegistriesCompanion vrc) async {
    try {
      return await db.update(db.voterRegistries).replace(vrc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteVoterRegistry(int id) async {
    try {
      return await (db.delete(db.voterRegistries)..where(
        (voterRegistry) => voterRegistry.voter_registry_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Registered Senior Citizen ------------

  Future<List<RegisteredSeniorData>> allRegisteredSeniors() async {
    try {
      return await db.select(db.registeredSeniors).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getRegisteredSeniorByID(int id) async {
    try {
      return await (db.select(db.registeredSeniors)..where(
        (registeredSenior) => registeredSenior.registered_senior_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addRegisteredSenior(RegisteredSeniorsCompanion rsc) async {
    try {
      return await db
          .into(db.registeredSeniors)
          .insert(rsc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateRegisteredSenior(RegisteredSeniorsCompanion rsc) async {
    try {
      return await db.update(db.registeredSeniors).replace(rsc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteRegisteredSenior(int id) async {
    try {
      return await (db.delete(db.registeredSeniors)..where(
        (registeredSenior) => registeredSenior.registered_senior_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Disabilities ------------

  Future<List<DisabilityData>> allDisabilities() async {
    try {
      return await db.select(db.disabilities).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getDisabilityByID(int id) async {
    try {
      return await (db.select(db.disabilities)..where(
        (disability) => disability.disability_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addDisability(DisabilitiesCompanion dc) async {
    try {
      return await db
          .into(db.disabilities)
          .insert(dc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateDisability(DisabilitiesCompanion dc) async {
    try {
      return await db.update(db.disabilities).replace(dc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteDisability(int id) async {
    try {
      return await (db.delete(db.disabilities)
        ..where((disability) => disability.disability_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Enrolled ------------

  Future<List<EnrolledData>> allEnrolled() async {
    try {
      return await db.select(db.enrolled).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getEnrolledByID(int id) async {
    try {
      return await (db.select(db.enrolled)
        ..where((enrolled) => enrolled.enrolled_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addEnrolled(EnrolledCompanion enc) async {
    try {
      return await db
          .into(db.enrolled)
          .insert(enc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateEnrolled(EnrolledCompanion enc) async {
    try {
      return await db.update(db.enrolled).replace(enc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteEnrolled(int id) async {
    try {
      return await (db.delete(db.enrolled)
        ..where((enrolled) => enrolled.enrolled_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ CTC Records ------------

  Future<List<CTCRecordData>> allCTCRecords() async {
    try {
      return await db.select(db.cTCRecords).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getCTCRecordByID(int id) async {
    try {
      return await (db.select(db.cTCRecords)
        ..where((cTCRecord) => cTCRecord.ctc_record_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addCTCRecord(CTCRecordsCompanion crc) async {
    try {
      return await db
          .into(db.cTCRecords)
          .insert(crc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateCTCRecord(CTCRecordsCompanion crc) async {
    try {
      return await db.update(db.cTCRecords).replace(crc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteCTCRecord(int id) async {
    try {
      return await (db.delete(db.cTCRecords)
        ..where((cTCRecord) => cTCRecord.ctc_record_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
