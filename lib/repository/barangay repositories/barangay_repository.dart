import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class BarangayRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<BarangayInfoData>> allBarangayInfos() async {
    try {
      return await db.select(db.barangayInfos).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getBarangayInfoByID(int id) async {
    try {
      return await (db.select(db.barangayInfos)..where(
        (barangayInfo) => barangayInfo.brgy_info_id.equals(
          id,
        ), // household here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addBarangayInfo(BarangayInfosCompanion bic) async {
    // HouseholdsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.barangayInfos)
          .insert(bic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateBarangayInfo(BarangayInfosCompanion bic) async {
    // hc holds row data
    try {
      return await db.update(db.barangayInfos).replace(bic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteBarangayInfo(int id) async {
    try {
      return await (db.delete(db.barangayInfos)
        ..where((barangayInfo) => barangayInfo.brgy_info_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<BarangayOfficialData>> allBarangayOfficials() async {
    try {
      return await db.select(db.barangayOfficials).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getBarangayOfficialByID(int id) async {
    try {
      return await (db.select(db.barangayOfficials)..where(
        (barangayOfficial) => barangayOfficial.brgy_official_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addBarangayOfficial(BarangayOfficialsCompanion boc) async {
    // HouseholdsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.barangayOfficials)
          .insert(boc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateBarangayOfficial(BarangayOfficialsCompanion boc) async {
    // hc holds row data
    try {
      return await db.update(db.barangayOfficials).replace(boc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteBarangayOfficial(int id) async {
    try {
      return await (db.delete(db.barangayOfficials)..where(
        (barangayOfficial) => barangayOfficial.brgy_official_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
