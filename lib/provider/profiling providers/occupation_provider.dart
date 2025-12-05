import 'dart:developer';
import 'package:brims/repository/profiling%20repositories/occupation_repository.dart';
import 'package:flutter/material.dart';
import 'package:brims/database/app_db.dart';

class OccupationProvider extends ChangeNotifier {
  OccupationProvider() {
    getAllOccupations();
  }

  final OccupationRepository _occupationRepository = OccupationRepository();

  List<OccupationData> _allOccupations = [];
  List<OccupationData> get allOccupations => _allOccupations;

  List<OccupationData> _currentOccupations = [];
  List<OccupationData> get currentOccupations => _currentOccupations;

  getAllOccupations() async {
    _allOccupations = await _occupationRepository.allOccupations();
    _currentOccupations = _allOccupations;
    log(
      "OccupationProvider: Loaded all ${_allOccupations.length} occupation records",
    );
    notifyListeners();
  }

  getOccupationById(int id) async {
    return await _occupationRepository.getOccupationByID(id);
  }

  addOccupation(OccupationsCompanion oc) async {
    await _occupationRepository.addOccupation(oc);
    getAllOccupations();
    log("Occupation Details: $oc");
  }

  updateOccupation(OccupationsCompanion oc) async {
    await _occupationRepository.updateOccupation(oc);
    getAllOccupations();
  }

  deleteOccupation(int id) async {
    await _occupationRepository.deleteOccupation(id);
    getAllOccupations();
  }
}
