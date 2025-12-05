import 'package:brims/database/app_db.dart';
import 'package:brims/repository/lookup%20repositories/medinfo_lookup_repository.dart';
import 'package:flutter/material.dart';

class MedInfoLookupProvider extends ChangeNotifier {
  MedInfoLookupProvider() {
    loadAllLookups();
  }

  final MedInfoLookupRepository _lookupRepository = MedInfoLookupRepository();

  List<DeliveryPlaceData> _allDeliveryPlaces = [];
  List<DeliveryPlaceData> get allDeliveryPlaces => _allDeliveryPlaces;

  List<DeliveryPlaceData> _currentDeliveryPlaces = [];
  List<DeliveryPlaceData> get currentDeliveryPlaces => _currentDeliveryPlaces;

  List<AssistedPersonData> _allAssistedPersons = [];
  List<AssistedPersonData> get allAssistedPersons => _allAssistedPersons;

  List<AssistedPersonData> _currentAssistedPersons = [];
  List<AssistedPersonData> get currentAssistedPersons =>
      _currentAssistedPersons;

  List<VisitReasonData> _allVisitReasons = [];
  List<VisitReasonData> get allVisitReasons => _allVisitReasons;

  List<VisitReasonData> _currentVisitReasons = [];
  List<VisitReasonData> get currentVisitReasons => _currentVisitReasons;

  List<FpSourceData> _allFpSources = [];
  List<FpSourceData> get allFpSources => _allFpSources;

  List<FpSourceData> _currentFpSources = [];
  List<FpSourceData> get currentFpSources => _currentFpSources;

  List<FpMethodData> _allFpMethods = [];
  List<FpMethodData> get allFpMethods => _allFpMethods;

  List<FpMethodData> _currentFpMethods = [];
  List<FpMethodData> get currentFpMethods => _currentFpMethods;

  Future<void> loadAllLookups() async {
    await getAllDeliveryPlaces();
    await getAllAssistedPersons();
    await getAllVisitReasons();
    await getAllFpSources();
    await getAllFpMethods();
  }

  // ------------ Delivery Places ------------

  getAllDeliveryPlaces() async {
    _allDeliveryPlaces = await _lookupRepository.allDeliveryPlaces();
    _currentDeliveryPlaces = _allDeliveryPlaces;
    notifyListeners();
  }

  addDeliveryPlace(DeliveryPlacesCompanion dpc) async {
    await _lookupRepository.addDeliveryPlace(dpc);
    await getAllDeliveryPlaces();
  }

  updateDeliveryPlace(DeliveryPlacesCompanion dpc) async {
    await _lookupRepository.updateDeliveryPlace(dpc);
    await getAllDeliveryPlaces();
  }

  deleteDeliveryPlace(int id) async {
    await _lookupRepository.deleteDeliveryPlace(id);
    await getAllDeliveryPlaces();
  }

  // ------------ Assisted Persons ------------

  getAllAssistedPersons() async {
    _allAssistedPersons = await _lookupRepository.allAssistedPersons();
    _currentAssistedPersons = _allAssistedPersons;
    notifyListeners();
  }

  addAssistedPerson(AssistedPersonsCompanion apc) async {
    await _lookupRepository.addAssistedPerson(apc);
    await getAllAssistedPersons();
  }

  updateAssistedPerson(AssistedPersonsCompanion apc) async {
    await _lookupRepository.updateAssistedPerson(apc);
    await getAllAssistedPersons();
  }

  deleteAssistedPerson(int id) async {
    await _lookupRepository.deleteAssistedPerson(id);
    await getAllAssistedPersons();
  }

  // ------------ Visit Reasons ------------

  getAllVisitReasons() async {
    _allVisitReasons = await _lookupRepository.allVisitReasons();
    _currentVisitReasons = _allVisitReasons;
    notifyListeners();
  }

  addVisitReason(VisitReasonsCompanion vrc) async {
    await _lookupRepository.addVisitReason(vrc);
    await getAllVisitReasons();
  }

  updateVisitReason(VisitReasonsCompanion vrc) async {
    await _lookupRepository.updateVisitReason(vrc);
    await getAllVisitReasons();
  }

  deleteVisitReason(int id) async {
    await _lookupRepository.deleteVisitReason(id);
    await getAllVisitReasons();
  }

  // ------------ Family Planning Source ------------

  getAllFpSources() async {
    _allFpSources = await _lookupRepository.allFpSources();
    _currentFpSources = _allFpSources;
    notifyListeners();
  }

  addFpSource(FpSourcesCompanion fsc) async {
    await _lookupRepository.addFpSource(fsc);
    await getAllFpSources();
  }

  updateFpSource(FpSourcesCompanion fsc) async {
    await _lookupRepository.updateFpSource(fsc);
    await getAllFpSources();
  }

  deleteFpSource(int id) async {
    await _lookupRepository.deleteFpSource(id);
    await getAllFpSources();
  }

  // ------------ Family Methods ------------

  getAllFpMethods() async {
    _allFpMethods = await _lookupRepository.allFpMethods();
    _currentFpMethods = _allFpMethods;
    notifyListeners();
  }

  addFpMethod(FpMethodsCompanion fmc) async {
    await _lookupRepository.addFpMethod(fmc);
    await getAllFpMethods();
  }

  updateFpMethod(FpMethodsCompanion fmc) async {
    await _lookupRepository.updateFpMethod(fmc);
    await getAllFpMethods();
  }

  deleteFpMethod(int id) async {
    await _lookupRepository.deleteFpMethod(id);
    await getAllFpMethods();
  }
}
