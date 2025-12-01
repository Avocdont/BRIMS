import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class BuildingTypeRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<BuildingTypeData>> allBuildingTypes() async {
    try {
      return await db.select(db.buildingTypes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getBuildingTypeByID(int id) async {
    try {
      return await (db.select(db.buildingTypes)..where(
        (buildingType) => buildingType.building_type_id.equals(
          id,
        ), // buildingtype here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addBuildingType(BuildingTypesCompanion btc) async {
    // BuildingTypesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.buildingTypes)
          .insert(btc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateBuildingType(BuildingTypesCompanion btc) async {
    // btc holds row data
    try {
      return await db.update(db.buildingTypes).replace(btc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteBuildingType(int id) async {
    try {
      return await (db.delete(db.buildingTypes)..where(
        (buildingType) => buildingType.building_type_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
