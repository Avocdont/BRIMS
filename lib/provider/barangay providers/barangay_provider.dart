import 'package:brims/database/app_db.dart';
import 'package:brims/repository/barangay%20repositories/barangay_repository.dart';

import 'package:flutter/material.dart';

class BarangayProvider extends ChangeNotifier {
  BarangayProvider() {
    loadAllBarangayData();
  }

  final BarangayRepository _barangayRepository = BarangayRepository();

  List<BarangayInfoData> _allBarangayInfos = [];
  List<BarangayInfoData> get allBarangayInfos => _allBarangayInfos;

  List<BarangayInfoData> _currentBarangayInfos = [];
  List<BarangayInfoData> get currentBarangayInfos => _currentBarangayInfos;

  List<BarangayOfficialData> _allBarangayOfficials = [];
  List<BarangayOfficialData> get allBarangayOfficials => _allBarangayOfficials;

  List<BarangayOfficialData> _currentBarangayOfficials = [];
  List<BarangayOfficialData> get currentBarangayOfficials =>
      _currentBarangayOfficials;

  Future<void> loadAllBarangayData() async {
    await getAllBarangayInfos();
    await getAllBarangayOfficials();
  }

  // ------------ Barangay Info ------------
  getAllBarangayInfos() async {
    _allBarangayInfos = await _barangayRepository.allBarangayInfos();
    _currentBarangayInfos = _allBarangayInfos;
    notifyListeners();
  }

  addBarangayInfo(BarangayInfosCompanion bic) async {
    await _barangayRepository.addBarangayInfo(bic);
    await getAllBarangayInfos();
  }

  updateBarangayInfo(BarangayInfosCompanion bic) async {
    await _barangayRepository.updateBarangayInfo(bic);
    await getAllBarangayInfos();
  }

  deleteBarangayInfo(int id) async {
    await _barangayRepository.deleteBarangayInfo(id);
    await getAllBarangayInfos();
  }

  // ------------ Barangay Officials ------------
  getAllBarangayOfficials() async {
    _allBarangayOfficials = await _barangayRepository.allBarangayOfficials();
    _currentBarangayOfficials = _allBarangayOfficials;
    notifyListeners();
  }

  addBarangayOfficial(BarangayOfficialsCompanion boc) async {
    await _barangayRepository.addBarangayOfficial(boc);
    await getAllBarangayOfficials();
  }

  updateBarangayOfficial(BarangayOfficialsCompanion boc) async {
    await _barangayRepository.updateBarangayOfficial(boc);
    await getAllBarangayOfficials();
  }

  deleteBarangayOfficial(int id) async {
    await _barangayRepository.deleteBarangayOfficial(id);
    await getAllBarangayOfficials();
  }
}
