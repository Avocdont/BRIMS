import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class LookupRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Nationalities ------------
  Future<List<NationalityData>> allNationalities() async {
    try {
      return await db.select(db.nationalities).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getNationalityByID(int id) async {
    try {
      return await (db.select(db.nationalities)..where(
        (nationality) => nationality.nationality_id.equals(
          id,
        ), // nationality here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addNationality(NationalitiesCompanion nc) async {
    // NationalitiesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.nationalities)
          .insert(nc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateNationality(NationalitiesCompanion nc) async {
    // nc holds row data
    try {
      return await db.update(db.nationalities).replace(nc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteNationality(int id) async {
    try {
      return await (db.delete(db.nationalities)
        ..where((nationality) => nationality.nationality_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Ethnicities ------------

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

  // ------------ Religions ------------

  Future<List<ReligionData>> allReligions() async {
    try {
      return await db.select(db.religions).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getReligionByID(int id) async {
    try {
      return await (db.select(db.religions)..where(
        (religion) => religion.religion_id.equals(
          id,
        ), // religion here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addReligion(ReligionsCompanion rc) async {
    // ReligionsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.religions)
          .insert(rc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateReligion(ReligionsCompanion rc) async {
    // r holds row data
    try {
      return await db.update(db.religions).replace(rc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteReligion(int id) async {
    try {
      return await (db.delete(db.religions)
        ..where((religion) => religion.religion_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Education ------------

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

  // ------------ Blood Types ------------

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

  // ------------ Monthly Incomes ------------

  Future<List<MonthlyIncomeData>> allMonthlyIncomes() async {
    try {
      return await db.select(db.monthlyIncomes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getMonthlyIncomeByID(int id) async {
    try {
      return await (db.select(db.monthlyIncomes)..where(
        (monthlyincome) => monthlyincome.monthly_income_id.equals(
          id,
        ), // monthlyincome here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addMonthlyIncome(MonthlyIncomesCompanion mic) async {
    // MonthlyIncomesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.monthlyIncomes)
          .insert(mic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateMonthlyIncome(MonthlyIncomesCompanion mic) async {
    // mic holds row data
    try {
      return await db.update(db.monthlyIncomes).replace(mic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteMonthlyIncome(int id) async {
    try {
      return await (db.delete(db.monthlyIncomes)..where(
        (monthlyincome) => monthlyincome.monthly_income_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Monthly Incomes ------------

  Future<List<DailyIncomeData>> allDailyIncomes() async {
    try {
      return await db.select(db.dailyIncomes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getDailyIncomeByID(int id) async {
    try {
      return await (db.select(db.dailyIncomes)..where(
        (dailyincome) => dailyincome.daily_income_id.equals(
          id,
        ), // dailyincome here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addDailyIncome(DailyIncomesCompanion dic) async {
    // DailyIncomesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.dailyIncomes)
          .insert(dic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateDailyIncome(DailyIncomesCompanion dic) async {
    // dic holds row data
    try {
      return await db.update(db.dailyIncomes).replace(dic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteDailyIncome(int id) async {
    try {
      return await (db.delete(db.dailyIncomes)
        ..where((dailyincome) => dailyincome.daily_income_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
