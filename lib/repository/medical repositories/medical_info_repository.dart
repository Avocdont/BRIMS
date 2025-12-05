import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class MedicalInfoRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Newborn Information ------------
  Future<List<NewbornInformationData>> allNewbornInfo() async {
    try {
      return await db.select(db.newbornInformation).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getNewbornInfoByID(int id) async {
    try {
      return await (db.select(db.newbornInformation)..where(
        (newbornInfo) => newbornInfo.newborn_info_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addNewbornInformation(NewbornInformationCompanion nic) async {
    try {
      return await db
          .into(db.newbornInformation)
          .insert(nic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateNewbornInformation(NewbornInformationCompanion nic) async {
    try {
      return await db.update(db.newbornInformation).replace(nic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteNewbornInfo(int id) async {
    try {
      return await (db.delete(db.newbornInformation)
        ..where((newbornInfo) => newbornInfo.newborn_info_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Health Insurance Info ------------
  Future<List<HealthInsuranceData>> allHealthInsurances() async {
    try {
      return await db.select(db.healthInsurances).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getHealthInsuranceByID(int id) async {
    try {
      return await (db.select(db.healthInsurances)..where(
        (healthInsurance) => healthInsurance.health_insurance_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addHealthInsurance(HealthInsurancesCompanion hic) async {
    try {
      return await db
          .into(db.healthInsurances)
          .insert(hic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateHealthInsurance(HealthInsurancesCompanion hic) async {
    try {
      return await db.update(db.healthInsurances).replace(hic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteHealthInsurance(int id) async {
    try {
      return await (db.delete(db.healthInsurances)..where(
        (healthInsurance) => healthInsurance.health_insurance_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Visited Facilities ------------
  Future<List<VisitedFacilityData>> allVisitiedFacilities() async {
    try {
      return await db.select(db.visitedFacilities).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getVisitedFacilityByID(int id) async {
    try {
      return await (db.select(db.visitedFacilities)..where(
        (visitedFacility) => visitedFacility.visited_facility_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addVisitedFacility(VisitedFacilitiesCompanion vfc) async {
    try {
      return await db
          .into(db.visitedFacilities)
          .insert(vfc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateVisitedFacility(VisitedFacilitiesCompanion vfc) async {
    try {
      return await db.update(db.visitedFacilities).replace(vfc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteVisitedFacility(int id) async {
    try {
      return await (db.delete(db.visitedFacilities)..where(
        (visitedFacility) => visitedFacility.visited_facility_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Maternal Information ------------
  Future<List<MaternalInformationData>> allMaternalInformation() async {
    try {
      return await db.select(db.maternalInformation).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getMaternalInforamtionByID(int id) async {
    try {
      return await (db.select(db.maternalInformation)..where(
        (maternalInformation) =>
            maternalInformation.maternal_info_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addMaternalInformation(MaternalInformationCompanion mic) async {
    try {
      return await db
          .into(db.maternalInformation)
          .insert(mic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateMaternalInformation(MaternalInformationCompanion mic) async {
    try {
      return await db.update(db.maternalInformation).replace(mic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteMaternalInformation(int id) async {
    try {
      return await (db.delete(db.maternalInformation)..where(
        (maternalInformation) =>
            maternalInformation.maternal_info_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Family Planning ------------
  Future<List<FamilyPlanningData>> allFamilyPlanning() async {
    try {
      return await db.select(db.familyPlanning).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getFamilyPlanningByID(int id) async {
    try {
      return await (db.select(db.familyPlanning)..where(
        (familyPlan) => familyPlan.family_planning_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addFamilyPlanning(FamilyPlanningCompanion fpc) async {
    try {
      return await db
          .into(db.familyPlanning)
          .insert(fpc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateFamilyPlanning(FamilyPlanningCompanion fpc) async {
    try {
      return await db.update(db.familyPlanning).replace(fpc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteFamilyPlanning(int id) async {
    try {
      return await (db.delete(db.familyPlanning)
        ..where((familyPlan) => familyPlan.family_planning_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
