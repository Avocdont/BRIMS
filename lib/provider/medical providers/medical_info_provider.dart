import 'package:brims/database/app_db.dart';
import 'package:brims/repository/medical%20repositories/medical_info_repository.dart';
import 'package:flutter/material.dart';

class MedicalInfoProvider extends ChangeNotifier {
  MedicalInfoProvider() {
    loadAllMedicalInfo();
  }

  final MedicalInfoRepository _medicalInfoRepository = MedicalInfoRepository();

  List<NewbornInformationData> _allNewbornInfo = [];
  List<NewbornInformationData> get allNewbornInfo => _allNewbornInfo;

  List<NewbornInformationData> _currentNewbornInfo = [];
  List<NewbornInformationData> get currentNewbornInfo => _currentNewbornInfo;

  List<HealthInsuranceData> _allHealthInsurances = [];
  List<HealthInsuranceData> get allHealthInsurances => _allHealthInsurances;

  List<HealthInsuranceData> _currentHealthInsurances = [];
  List<HealthInsuranceData> get currentHealthInsurances =>
      _currentHealthInsurances;

  List<VisitedFacilityData> _allVisitedFacilities = [];
  List<VisitedFacilityData> get allVisitedFacilities => _allVisitedFacilities;

  List<VisitedFacilityData> _currentVisitedFacilities = [];
  List<VisitedFacilityData> get currentVisitedFacilities =>
      _currentVisitedFacilities;

  List<MaternalInformationData> _allMaternalInformation = [];
  List<MaternalInformationData> get allMaternalInformation =>
      _allMaternalInformation;

  List<MaternalInformationData> _currentMaternalInformation = [];
  List<MaternalInformationData> get currentMaternalInformation =>
      _currentMaternalInformation;

  List<FamilyPlanningData> _allFamilyPlanning = [];
  List<FamilyPlanningData> get allFamilyPlanning => _allFamilyPlanning;

  List<FamilyPlanningData> _currentFamilyPlanning = [];
  List<FamilyPlanningData> get currentFamilyPlanning => _currentFamilyPlanning;

  Future<void> loadAllMedicalInfo() async {
    await getAllNewbornInfo();
    await getAllHealthInsurances();
    await getAllVisitedFacilities();
    await getAllMaternalInformation();
    await getAllFamilyPlanning();
  }

  // ------------ Newborn Information ------------
  getAllNewbornInfo() async {
    _allNewbornInfo = await _medicalInfoRepository.allNewbornInfo();
    _currentNewbornInfo = _allNewbornInfo;
    notifyListeners();
  }

  addNewbornInformation(NewbornInformationCompanion nic) async {
    await _medicalInfoRepository.addNewbornInformation(nic);
    await getAllNewbornInfo();
  }

  updateNewbornInformation(NewbornInformationCompanion nic) async {
    await _medicalInfoRepository.updateNewbornInformation(nic);
    await getAllNewbornInfo();
  }

  deleteNewbornInfo(int id) async {
    await _medicalInfoRepository.deleteNewbornInfo(id);
    await getAllNewbornInfo();
  }

  // ------------ Health Insurance Info ------------
  getAllHealthInsurances() async {
    _allHealthInsurances = await _medicalInfoRepository.allHealthInsurances();
    _currentHealthInsurances = _allHealthInsurances;
    notifyListeners();
  }

  addHealthInsurance(HealthInsurancesCompanion hic) async {
    await _medicalInfoRepository.addHealthInsurance(hic);
    await getAllHealthInsurances();
  }

  updateHealthInsurance(HealthInsurancesCompanion hic) async {
    await _medicalInfoRepository.updateHealthInsurance(hic);
    await getAllHealthInsurances();
  }

  deleteHealthInsurance(int id) async {
    await _medicalInfoRepository.deleteHealthInsurance(id);
    await getAllHealthInsurances();
  }

  // ------------ Visited Facilities ------------
  getAllVisitedFacilities() async {
    _allVisitedFacilities =
        await _medicalInfoRepository.allVisitiedFacilities();
    _currentVisitedFacilities = _allVisitedFacilities;
    notifyListeners();
  }

  addVisitedFacility(VisitedFacilitiesCompanion vfc) async {
    await _medicalInfoRepository.addVisitedFacility(vfc);
    await getAllVisitedFacilities();
  }

  updateVisitedFacility(VisitedFacilitiesCompanion vfc) async {
    await _medicalInfoRepository.updateVisitedFacility(vfc);
    await getAllVisitedFacilities();
  }

  deleteVisitedFacility(int id) async {
    await _medicalInfoRepository.deleteVisitedFacility(id);
    await getAllVisitedFacilities();
  }

  // ------------ Maternal Information ------------
  getAllMaternalInformation() async {
    _allMaternalInformation =
        await _medicalInfoRepository.allMaternalInformation();
    _currentMaternalInformation = _allMaternalInformation;
    notifyListeners();
  }

  addMaternalInformation(MaternalInformationCompanion mic) async {
    await _medicalInfoRepository.addMaternalInformation(mic);
    await getAllMaternalInformation();
  }

  updateMaternalInformation(MaternalInformationCompanion mic) async {
    await _medicalInfoRepository.updateMaternalInformation(mic);
    await getAllMaternalInformation();
  }

  deleteMaternalInformation(int id) async {
    await _medicalInfoRepository.deleteMaternalInformation(id);
    await getAllMaternalInformation();
  }

  // ------------ Family Planning ------------
  getAllFamilyPlanning() async {
    _allFamilyPlanning = await _medicalInfoRepository.allFamilyPlanning();
    _currentFamilyPlanning = _allFamilyPlanning;
    notifyListeners();
  }

  addFamilyPlanning(FamilyPlanningCompanion fpc) async {
    await _medicalInfoRepository.addFamilyPlanning(fpc);
    await getAllFamilyPlanning();
  }

  updateFamilyPlanning(FamilyPlanningCompanion fpc) async {
    await _medicalInfoRepository.updateFamilyPlanning(fpc);
    await getAllFamilyPlanning();
  }

  deleteFamilyPlanning(int id) async {
    await _medicalInfoRepository.deleteFamilyPlanning(id);
    await getAllFamilyPlanning();
  }
}
