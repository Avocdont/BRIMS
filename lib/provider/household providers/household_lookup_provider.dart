import 'package:brims/database/app_db.dart';
import 'package:brims/repository/household%20repositories/household_lookup_repository.dart';
import 'package:flutter/material.dart';

class HouseholdLookupProvider extends ChangeNotifier {
  HouseholdLookupProvider() {
    loadAllLookups();
  }
  final HouseholdLookupRepository _lookupRepository =
      HouseholdLookupRepository();

  List<HouseholdTypeData> _allHouseholdTypes = [];
  List<HouseholdTypeData> get allHouseholdTypes => _allHouseholdTypes;

  List<BuildingTypeData> _allBuildingTypes = [];
  List<BuildingTypeData> get allBuildingTypes => _allBuildingTypes;

  List<OwnershipTypeData> _allOwnershipTypes = [];
  List<OwnershipTypeData> get allOwnershipTypes => _allOwnershipTypes;

  Future<void> loadAllLookups() async {
    await getAllHouseholdTypes();
    await getAllBuildingTypes();
    await getAllOwnershipTypes();
  }

  // ------------ Household Types ------------
  getAllHouseholdTypes() async {
    _allHouseholdTypes = await _lookupRepository.allHouseholdTypes();
    notifyListeners();
  }

  addHouseholdType(HouseholdTypesCompanion htc) async {
    await _lookupRepository.addHouseholdType(htc);
    await getAllHouseholdTypes();
  }

  updateHouseholdType(HouseholdTypesCompanion htc) async {
    await _lookupRepository.updateHouseholdType(htc);
    await getAllHouseholdTypes();
  }

  deleteHouseholdType(int id) async {
    await _lookupRepository.deleteHouseholdType(id);
    await getAllHouseholdTypes();
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

  // ------------ Ownership Types ------------
  getAllOwnershipTypes() async {
    _allOwnershipTypes = await _lookupRepository.allOwnershipTypes();
    notifyListeners();
  }

  addOwnershipType(OwnershipTypesCompanion otc) async {
    await _lookupRepository.addOwnershipType(otc);
    await getAllOwnershipTypes();
  }

  updateOwnershipType(OwnershipTypesCompanion otc) async {
    await _lookupRepository.updateOwnershipType(otc);
    await getAllOwnershipTypes();
  }

  deleteOwnershipType(int id) async {
    await _lookupRepository.deleteOwnershipType(id);
    await getAllOwnershipTypes();
  }
}
