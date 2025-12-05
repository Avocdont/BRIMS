import 'package:brims/database/app_db.dart';
import 'package:brims/repository/lookup%20repositories/profile_lookup_repository.dart';
import 'package:flutter/material.dart';

class ProfileLookupProvider extends ChangeNotifier {
  ProfileLookupProvider() {
    loadAllLookups();
  }
  final ProfileLookupRepository _lookupRepository = ProfileLookupRepository();

  List<NationalityData> _allNationalities = [];
  List<NationalityData> get allNationalities => _allNationalities;

  List<EthnicityData> _allEthnicities = [];
  List<EthnicityData> get allEthnicities => _allEthnicities;

  List<ReligionData> _allReligions = [];
  List<ReligionData> get allReligions => _allReligions;

  List<EducationData> _allEducation = [];
  List<EducationData> get allEducation => _allEducation;

  List<BloodTypeData> _allBloodTypes = [];
  List<BloodTypeData> get allBloodTypes => _allBloodTypes;

  List<MonthlyIncomeData> _allMonthlyIncomes = [];
  List<MonthlyIncomeData> get allMonthlyIncomes => _allMonthlyIncomes;

  List<DailyIncomeData> _allDailyIncomes = [];
  List<DailyIncomeData> get allDailyIncomes => _allDailyIncomes;

  Future<void> loadAllLookups() async {
    await getAllNationalities();
    await getAllEthnicities();
    await getAllReligions();
    await getAllEducation();
    await getAllBloodTypes();
    await getAllMonthlyIncomes();
    await getAllDailyIncomes();
  }

  // ------------ Nationalities ------------
  getAllNationalities() async {
    _allNationalities = await _lookupRepository.allNationalities();
    notifyListeners();
  }

  addNationality(NationalitiesCompanion nc) async {
    await _lookupRepository.addNationality(nc);
    await getAllNationalities();
  }

  updateNationality(NationalitiesCompanion nc) async {
    await _lookupRepository.updateNationality(nc);
    await getAllNationalities();
  }

  deleteNationality(int id) async {
    await _lookupRepository.deleteNationality(id);
    await getAllNationalities();
  }

  // ------------ Ethnicities ------------

  getAllEthnicities() async {
    _allEthnicities = await _lookupRepository.allEthnicities();
    notifyListeners();
  }

  addEthnicity(EthnicitiesCompanion ec) async {
    await _lookupRepository.addEthnicity(ec);
    await getAllEthnicities();
  }

  updateEthnicity(EthnicitiesCompanion ec) async {
    await _lookupRepository.updateEthnicity(ec);
    await getAllEthnicities();
  }

  deleteEthnicity(int id) async {
    await _lookupRepository.deleteEthnicity(id);
    await getAllEthnicities();
  }

  // ------------ Religions ------------

  getAllReligions() async {
    _allReligions = await _lookupRepository.allReligions();
    notifyListeners();
  }

  addReligion(ReligionsCompanion rc) async {
    await _lookupRepository.addReligion(rc);
    await getAllReligions();
  }

  updateReligion(ReligionsCompanion rc) async {
    await _lookupRepository.updateReligion(rc);
    await getAllReligions();
  }

  deleteReligion(int id) async {
    await _lookupRepository.deleteReligion(id);
    await getAllReligions();
  }

  // ------------ Education ------------

  getAllEducation() async {
    _allEducation = await _lookupRepository.allEducation();
    notifyListeners();
  }

  addEducation(EducationCompanion ec) async {
    await _lookupRepository.addEducation(ec);
    await getAllEducation();
  }

  updateEducation(EducationCompanion ec) async {
    await _lookupRepository.updateEducation(ec);
    await getAllEducation();
  }

  deleteEducation(int id) async {
    await _lookupRepository.deleteEducation(id);
    await getAllEducation();
  }

  // ------------ Blood Types ------------

  getAllBloodTypes() async {
    _allBloodTypes = await _lookupRepository.allBloodTypes();
    notifyListeners();
  }

  addBloodType(BloodTypesCompanion bc) async {
    await _lookupRepository.addBloodType(bc);
    await getAllBloodTypes();
  }

  updateBloodType(BloodTypesCompanion bc) async {
    await _lookupRepository.updateBloodType(bc);
    await getAllBloodTypes();
  }

  deleteBloodType(int id) async {
    await _lookupRepository.deleteBloodType(id);
    await getAllBloodTypes();
  }

  // ------------ Monthly Incomes ------------

  getAllMonthlyIncomes() async {
    _allMonthlyIncomes = await _lookupRepository.allMonthlyIncomes();
    notifyListeners();
  }

  addMonthlyIncome(MonthlyIncomesCompanion mic) async {
    await _lookupRepository.addMonthlyIncome(mic);
    await getAllMonthlyIncomes();
  }

  updateMonthlyIncome(MonthlyIncomesCompanion mic) async {
    await _lookupRepository.updateMonthlyIncome(mic);
    await getAllMonthlyIncomes();
  }

  deleteMonthlyIncome(int id) async {
    await _lookupRepository.deleteMonthlyIncome(id);
    await getAllMonthlyIncomes();
  }

  // ------------ Daily Incomes ------------

  getAllDailyIncomes() async {
    _allDailyIncomes = await _lookupRepository.allDailyIncomes();
    notifyListeners();
  }

  addDailyIncome(DailyIncomesCompanion dc) async {
    await _lookupRepository.addDailyIncome(dc);
    await getAllDailyIncomes();
  }

  updateDailyIncome(DailyIncomesCompanion dc) async {
    await _lookupRepository.updateDailyIncome(dc);
    await getAllDailyIncomes();
  }

  deleteDailyIncome(int id) async {
    await _lookupRepository.deleteDailyIncome(id);
    await getAllDailyIncomes();
  }
}
