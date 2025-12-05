import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/repository/profiling%20repositories/citizen_registry_repository.dart';
import 'package:flutter/material.dart';

class CitizenRegistryProvider extends ChangeNotifier {
  CitizenRegistryProvider() {
    loadAllCitizenRegistry();
  }

  final CitizenRegistryRepository _citizenRegistryRepository =
      CitizenRegistryRepository();

  List<VoterRegistryData> _allVoterRegistries = [];
  List<VoterRegistryData> get allVoterRegistries => _allVoterRegistries;

  List<VoterRegistryData> _currentVoterRegistries = [];
  List<VoterRegistryData> get currentVoterRegistries => _currentVoterRegistries;

  List<RegisteredSeniorData> _allRegisteredSeniors = [];
  List<RegisteredSeniorData> get allRegisteredSeniors => _allRegisteredSeniors;

  List<RegisteredSeniorData> _currentRegisteredSeniors = [];
  List<RegisteredSeniorData> get currentRegisteredSeniors =>
      _currentRegisteredSeniors;

  List<DisabilityData> _allDisabilities = [];
  List<DisabilityData> get allDisabilities => _allDisabilities;

  List<DisabilityData> _currentDisabilities = [];
  List<DisabilityData> get currentDisabilities => _currentDisabilities;

  List<EnrolledData> _allEnrolled = [];
  List<EnrolledData> get allEnrolled => _allEnrolled;

  List<EnrolledData> _currentEnrolled = [];
  List<EnrolledData> get currentEnrolled => _currentEnrolled;

  List<CTCRecordData> _allCTCRecords = [];
  List<CTCRecordData> get allCTCRecords => _allCTCRecords;

  List<CTCRecordData> _currentCTCRecords = [];
  List<CTCRecordData> get currentCTCRecords => _currentCTCRecords;

  Future<void> loadAllCitizenRegistry() async {
    await getAllVoterRegistries();
    await getAllRegisteredSeniors();
    await getAllDisabilities();
    await getAllEnrolled();
    await getAllCTCRecords();
  }

  // ------------ Voter Registry ------------
  getAllVoterRegistries() async {
    _allVoterRegistries = await _citizenRegistryRepository.allVoterRegistries();
    _currentVoterRegistries = _allVoterRegistries;
    notifyListeners();
  }

  addVoterRegistry(VoterRegistriesCompanion vrc) async {
    await _citizenRegistryRepository.addVoterRegistry(vrc);
    getAllVoterRegistries();
    log("Voter Registry Details: $vrc");
  }

  updateVoterRegistry(VoterRegistriesCompanion vrc) async {
    await _citizenRegistryRepository.updateVoterRegistry(vrc);
    await getAllVoterRegistries();
  }

  deleteVoterRegistry(int id) async {
    await _citizenRegistryRepository.deleteVoterRegistry(id);
    await getAllVoterRegistries();
  }

  // ------------ Registered Senior Citizen ------------
  getAllRegisteredSeniors() async {
    _allRegisteredSeniors =
        await _citizenRegistryRepository.allRegisteredSeniors();
    _currentRegisteredSeniors = _allRegisteredSeniors;
    notifyListeners();
  }

  addRegisteredSenior(RegisteredSeniorsCompanion rsc) async {
    await _citizenRegistryRepository.addRegisteredSenior(rsc);
    getAllRegisteredSeniors();
    log("Registered Senior Details: $rsc");
  }

  updateRegisteredSenior(RegisteredSeniorsCompanion rsc) async {
    await _citizenRegistryRepository.updateRegisteredSenior(rsc);
    await getAllRegisteredSeniors();
  }

  deleteRegisteredSenior(int id) async {
    await _citizenRegistryRepository.deleteRegisteredSenior(id);
    await getAllRegisteredSeniors();
  }

  // ------------ Disabilities ------------
  getAllDisabilities() async {
    _allDisabilities = await _citizenRegistryRepository.allDisabilities();
    _currentDisabilities = _allDisabilities;
    notifyListeners();
  }

  addDisability(DisabilitiesCompanion dc) async {
    await _citizenRegistryRepository.addDisability(dc);
    getAllDisabilities();
    log("Disability Details: $dc");
  }

  updateDisability(DisabilitiesCompanion dc) async {
    await _citizenRegistryRepository.updateDisability(dc);
    await getAllDisabilities();
  }

  deleteDisability(int id) async {
    await _citizenRegistryRepository.deleteDisability(id);
    await getAllDisabilities();
  }

  // ------------ Enrolled ------------
  getAllEnrolled() async {
    _allEnrolled = await _citizenRegistryRepository.allEnrolled();
    _currentEnrolled = _allEnrolled;
    notifyListeners();
  }

  addEnrolled(EnrolledCompanion enc) async {
    await _citizenRegistryRepository.addEnrolled(enc);
    getAllEnrolled();
    log("Enrolled Details: $enc");
  }

  updateEnrolled(EnrolledCompanion enc) async {
    await _citizenRegistryRepository.updateEnrolled(enc);
    await getAllEnrolled();
  }

  deleteEnrolled(int id) async {
    await _citizenRegistryRepository.deleteEnrolled(id);
    await getAllEnrolled();
  }

  // ------------ CTC Records ------------
  getAllCTCRecords() async {
    _allCTCRecords = await _citizenRegistryRepository.allCTCRecords();
    _currentCTCRecords = _allCTCRecords;
    notifyListeners();
  }

  addCTCRecord(CTCRecordsCompanion crc) async {
    await _citizenRegistryRepository.addCTCRecord(crc);
    getAllCTCRecords();
    log("CTC Details: $crc");
  }

  updateCTCRecord(CTCRecordsCompanion crc) async {
    await _citizenRegistryRepository.updateCTCRecord(crc);
    await getAllCTCRecords();
  }

  deleteCTCRecord(int id) async {
    await _citizenRegistryRepository.deleteCTCRecord(id);
    await getAllCTCRecords();
  }
}
