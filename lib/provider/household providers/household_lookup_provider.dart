import 'package:brims/database/app_db.dart';
import 'package:brims/repository/lookup%20repositories/household_lookup_repository.dart';
import 'package:flutter/material.dart';

class HouseholdLookupProvider extends ChangeNotifier {
  HouseholdLookupProvider() {
    loadAllLookups();
  }
  final HouseholdLookupRepository _lookupRepository =
      HouseholdLookupRepository();

  List<BuildingTypeData> _allBuildingTypes = [];
  List<BuildingTypeData> get allBuildingTypes => _allBuildingTypes;

  List<BuildingTypeData> _currentBuildingTypes = [];
  List<BuildingTypeData> get currentBuildingTypes => _currentBuildingTypes;

  List<RelationshipTypeData> _allRelationshipTypes = [];
  List<RelationshipTypeData> get allRelationshipTypes => _allRelationshipTypes;

  List<RelationshipTypeData> _currentRelationshipTypes = [];
  List<RelationshipTypeData> get currentRelationshipTypes =>
      _currentRelationshipTypes;

  Future<void> loadAllLookups() async {
    await getAllBuildingTypes();
    await getAllRelationshipTypes();
  }

  // ------------ Building Types ------------

  getAllBuildingTypes() async {
    _allBuildingTypes = await _lookupRepository.allBuildingTypes();
    _currentBuildingTypes = _allBuildingTypes;
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

  getAllRelationshipTypes() async {
    _allRelationshipTypes = await _lookupRepository.allRelationshipTypes();
    _currentRelationshipTypes = _allRelationshipTypes;
    notifyListeners();
  }

  addRelationshipType(RelationshipTypesCompanion rtc) async {
    await _lookupRepository.addRelationshipType(rtc);
    await getAllRelationshipTypes();
  }

  updateRelationshipType(RelationshipTypesCompanion rtc) async {
    await _lookupRepository.updateRelationshipType(rtc);
    await getAllRelationshipTypes();
  }

  deleteRelationshipType(int id) async {
    await _lookupRepository.deleteRelationshipType(id);
    await getAllRelationshipTypes();
  }
}
