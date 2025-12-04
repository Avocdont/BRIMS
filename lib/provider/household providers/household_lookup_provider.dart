import 'package:brims/database/app_db.dart';
import 'package:brims/repository/household%20repositories/household_lookup_repository.dart';
import 'package:flutter/material.dart';

class HouseholdLookupProvider extends ChangeNotifier {
  HouseholdLookupProvider() {
    loadAllLookups();
  }
  final HouseholdLookupRepository _lookupRepository =
      HouseholdLookupRepository();

  List<BuildingTypeData> _allBuildingTypes = [];
  List<BuildingTypeData> get allBuildingTypes => _allBuildingTypes;

  Future<void> loadAllLookups() async {
    await getAllBuildingTypes();
  }

  // ------------ Building Types ------------

  getAllBuildingTypes() async {
    _allBuildingTypes = await _lookupRepository.allBuildingTypes();
    notifyListeners();
  }

  addBuildingType(BuildingTypesCompanion btc) async {
    await _lookupRepository.addBuildingType(btc);
    await getAllBuildingTypes();
  }

  updateBuildingType(BuildingTypesCompanion btc) async {
    await _lookupRepository.updateBuildingType(btc);
    await getAllBuildingTypes();
  }

  deleteBuildingType(int id) async {
    await _lookupRepository.deleteBuildingType(id);
    await getAllBuildingTypes();
  }
}
