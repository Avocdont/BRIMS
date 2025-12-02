import 'package:brims/database/app_db.dart';
import 'package:brims/repository/profiling%20repositories/lookup_repository.dart';
import 'package:flutter/material.dart';

class LookupProvider extends ChangeNotifier {
  LookupProvider() {
    getAllNationalities();
  }
  LookupRepository _lookupRepository = LookupRepository();

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

  // ------------ Nationalities ------------
  getAllNationalities() async {
    _allNationalities = await _lookupRepository.allNationalities();
    notifyListeners();
  }

  addNationality(NationalitiesCompanion nc) async {
    await _lookupRepository.addNationality(nc);
    getAllNationalities();
  }

  updateNationality(NationalitiesCompanion nc) async {
    await _lookupRepository.updateNationality(nc);
    getAllNationalities();
  }

  deleteNationality(int id) async {
    await _lookupRepository.deleteNationality(id);
    getAllNationalities();
  }

  // ------------ Ethnicities ------------

  getAllEthnicities() async {
    _allEthnicities = await _lookupRepository.allEthnicities();
    notifyListeners();
  }

  addEthnicity(EthnicitiesCompanion ec) async {
    await _lookupRepository.addEthnicity(ec);
    getAllEthnicities();
  }

  updateEthnicity(EthnicitiesCompanion ec) async {
    await _lookupRepository.updateEthnicity(ec);
    getAllEthnicities();
  }

  deleteEthnicity(int id) async {
    await _lookupRepository.deleteEthnicity(id);
    getAllEthnicities();
  }

  // ------------ Religions ------------

  getAllReligions() async {
    _allReligions = await _lookupRepository.allReligions();
    notifyListeners();
  }

  addReligion(ReligionsCompanion rc) async {
    await _lookupRepository.addReligion(rc);
    getAllReligions();
  }

  updateReligion(ReligionsCompanion rc) async {
    await _lookupRepository.updateReligion(rc);
    getAllReligions();
  }

  deleteReligion(int id) async {
    await _lookupRepository.deleteReligion(id);
    getAllReligions();
  }

  // ------------ Education ------------

  getAllEducation() async {
    _allEducation = await _lookupRepository.allEducation();
    notifyListeners();
  }

  addEducation(EducationCompanion ec) async {
    await _lookupRepository.addEducation(ec);
    getAllEducation();
  }

  updateEducation(EducationCompanion ec) async {
    await _lookupRepository.updateEducation(ec);
    getAllEducation();
  }

  deleteEducation(int id) async {
    await _lookupRepository.deleteEducation(id);
    getAllEducation();
  }

  // ------------ Blood Types ------------

  getAllBloodTypes() async {
    _allBloodTypes = await _lookupRepository.allBloodTypes();
    notifyListeners();
  }

  addBloodType(BloodTypesCompanion bc) async {
    await _lookupRepository.addBloodType(bc);
    getAllBloodTypes();
  }

  updateBloodType(BloodTypesCompanion bc) async {
    await _lookupRepository.updateBloodType(bc);
    getAllBloodTypes();
  }

  deleteBloodType(int id) async {
    await _lookupRepository.deleteBloodType(id);
    getAllBloodTypes();
  }

  // ------------ Monthly Incomes ------------

  getAllMonthlyIncomes() async {
    _allMonthlyIncomes = await _lookupRepository.allMonthlyIncomes();
    notifyListeners();
  }

  addMonthlyIncome(MonthlyIncomesCompanion mic) async {
    await _lookupRepository.addMonthlyIncome(mic);
    getAllMonthlyIncomes();
  }

  updateMonthlyIncome(MonthlyIncomesCompanion mic) async {
    await _lookupRepository.updateMonthlyIncome(mic);
    getAllMonthlyIncomes();
  }

  deleteMonthlyIncome(int id) async {
    await _lookupRepository.deleteMonthlyIncome(id);
    getAllMonthlyIncomes();
  }

  // ------------ Daily Incomes ------------

  getAllDailyIncomes() async {
    _allDailyIncomes = await _lookupRepository.allDailyIncomes();
    notifyListeners();
  }

  addDailyIncome(DailyIncomesCompanion dc) async {
    await _lookupRepository.addDailyIncome(dc);
    getAllDailyIncomes();
  }

  updateDailyIncome(DailyIncomesCompanion dc) async {
    await _lookupRepository.updateDailyIncome(dc);
    getAllDailyIncomes();
  }

  deleteDailyIncome(int id) async {
    await _lookupRepository.deleteDailyIncome(id);
    getAllDailyIncomes();
  }
}
