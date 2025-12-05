import 'dart:developer';
import 'package:brims/repository/profiling%20repositories/transient_repository.dart';
import 'package:flutter/material.dart';
import 'package:brims/database/app_db.dart';

class MigrantTransientProvider extends ChangeNotifier {
  MigrantTransientProvider() {
    getAllMigrantTransients();
  }

  final MigrantTransientRepository _migrantTransientRepository =
      MigrantTransientRepository();

  List<MigrantTransientData> _allMigrantTransients = [];
  List<MigrantTransientData> get allMigrantTransients => _allMigrantTransients;

  List<MigrantTransientData> _currentMigrantTransients = [];
  List<MigrantTransientData> get currentMigrantTransients =>
      _currentMigrantTransients;

  getAllMigrantTransients() async {
    _allMigrantTransients =
        await _migrantTransientRepository.allMigrantTransient();
    _currentMigrantTransients = _allMigrantTransients;
    log(
      "MigrantTransientProvider: Loaded all $_allMigrantTransients migrant transient records",
    );
    notifyListeners();
  }

  getMigrantTransientById(int id) async {
    return await _migrantTransientRepository.getMigrantTransientByID(id);
  }

  addMigrantTransient(MigrantTransientsCompanion mtc) async {
    await _migrantTransientRepository.addMigrantTransient(mtc);
    getAllMigrantTransients();
  }

  updateMigrantTransient(MigrantTransientsCompanion mtc) async {
    await _migrantTransientRepository.updateMigrantTransient(mtc);
    getAllMigrantTransients();
  }

  deleteMigrantTransient(int id) async {
    await _migrantTransientRepository.deleteMigrantTransient(id);
    getAllMigrantTransients();
  }
}
