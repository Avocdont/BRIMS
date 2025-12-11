import 'package:brims/database/app_db.dart';
import 'package:brims/repository/household%20repositories/household_repository.dart';
import 'package:flutter/material.dart';

class HouseholdProvider extends ChangeNotifier {
  final HouseholdRepository _lookupRepository = HouseholdRepository();

  List<HouseholdData> _allHouseholds = [];
  List<HouseholdData> get allHouseholds => _allHouseholds;

  List<HouseholdData> _currentHouseholds = [];
  List<HouseholdData> get currentHouseholds => _currentHouseholds;

  List<AddressData> _allAddresses = [];
  List<AddressData> get allAddresses => _allAddresses;

  List<AddressData> _currentAddresses = [];
  List<AddressData> get currentAddresses => _currentAddresses;

  List<ServiceData> _allServices = [];
  List<ServiceData> get allServices => _allServices;

  List<ServiceData> _currentServices = [];
  List<ServiceData> get currentServices => _currentServices;

  List<PrimaryNeedData> _allPrimaryNeeds = [];
  List<PrimaryNeedData> get allPrimaryNeeds => _allPrimaryNeeds;

  List<PrimaryNeedData> _currentPrimaryNeeds = [];
  List<PrimaryNeedData> get currentPrimaryNeeds => _currentPrimaryNeeds;

  List<FemaleMortalityData> _allFemaleMortalities = [];
  List<FemaleMortalityData> get allFemaleMortalities => _allFemaleMortalities;

  List<FemaleMortalityData> _currentFemaleMortalities = [];
  List<FemaleMortalityData> get currentFemaleMortalities =>
      _currentFemaleMortalities;

  List<ChildMortalityData> _allChildMortalities = [];
  List<ChildMortalityData> get allChildMortalities => _allChildMortalities;

  List<ChildMortalityData> _currentChildMortalities = [];
  List<ChildMortalityData> get currentChildMortalities =>
      _currentChildMortalities;

  List<FutureResidency> _allFutureResidencies = [];
  List<FutureResidency> get allFutureResidencies => _allFutureResidencies;

  List<FutureResidency> _currentFutureResidencies = [];
  List<FutureResidency> get currentFutureResidencies =>
      _currentFutureResidencies;

  List<HouseholdVisitData> _allHouseholdVisits = [];
  List<HouseholdVisitData> get allHouseholdVisits => _allHouseholdVisits;

  List<HouseholdVisitData> _currentHouseholdVisits = [];
  List<HouseholdVisitData> get currentHouseholdVisits =>
      _currentHouseholdVisits;

  getAllHouseholds() async {
    _allHouseholds = await _lookupRepository.allHouseholds();
    _currentHouseholds = _allHouseholds;
    notifyListeners();
  }

  getHouseholdByID(int id) async {
    return await _lookupRepository.getHouseholdByID(id);
  }

  addHousehold(HouseholdsCompanion hc) async {
    int id = await _lookupRepository.addHousehold(hc);
    getAllHouseholds();
    return id;
  }

  updateHousehold(HouseholdsCompanion hc) async {
    await _lookupRepository.updateHousehold(hc);
    getAllHouseholds();
  }

  deleteHousehold(int id) async {
    await _lookupRepository.deleteHousehold(id);
    getAllHouseholds();
  }

  getAllAddresses() async {
    _allAddresses = await _lookupRepository.allAddresses();
    _currentAddresses = _allAddresses;
    notifyListeners();
  }

  getAddressByID(int id) async {
    return await _lookupRepository.getAddressByID(id);
  }

  addAddress(AddressesCompanion ac) async {
    int addressId = await _lookupRepository.addAddress(ac);
    getAllAddresses();
    return addressId;
  }

  updateAddress(AddressesCompanion ac) async {
    await _lookupRepository.updateAddress(ac);
    getAllAddresses();
  }

  deleteAddress(int id) async {
    await _lookupRepository.deleteAddress(id);
    getAllAddresses();
  }

  searchAddresses({
    // Named parameters, optional but you have to specify which arguments you're gonna pass. Ex: Zone : "1B"
    String? zone,
    String? street,
    String? block,
    String? lot,
  }) async {
    return await _lookupRepository.searchAddresses(
      zone: zone,
      street: street,
      block: block,
      lot: lot,
    );
  }

  getAllServices() async {
    _allServices = await _lookupRepository.allServices();
    _currentServices = _allServices;
    notifyListeners();
  }

  getServiceByID(int id) async {
    return await _lookupRepository.getServiceByID(id);
  }

  addService(ServicesCompanion sc) async {
    await _lookupRepository.addService(sc);
    getAllServices();
  }

  updateService(ServicesCompanion sc) async {
    await _lookupRepository.updateService(sc);
    getAllServices();
  }

  deleteService(int id) async {
    await _lookupRepository.deleteService(id);
    getAllServices();
  }

  getAllPrimaryNeeds() async {
    _allPrimaryNeeds = await _lookupRepository.allPrimaryNeeds();
    _currentPrimaryNeeds = _allPrimaryNeeds;
    notifyListeners();
  }

  getPrimaryNeedByID(int id) async {
    return await _lookupRepository.getPrimaryNeedByID(id);
  }

  addPrimaryNeed(PrimaryNeedsCompanion pnc) async {
    await _lookupRepository.addPrimaryNeed(pnc);
    getAllPrimaryNeeds();
  }

  updatePrimaryNeed(PrimaryNeedsCompanion pnc) async {
    await _lookupRepository.updatePrimaryNeed(pnc);
    getAllPrimaryNeeds();
  }

  deletePrimaryNeed(int id) async {
    await _lookupRepository.deletePrimaryNeed(id);
    getAllPrimaryNeeds();
  }

  getAllFemaleMortalities() async {
    _allFemaleMortalities = await _lookupRepository.allFemaleMortalities();
    _currentFemaleMortalities = _allFemaleMortalities;
    notifyListeners();
  }

  getFemaleMortalityByID(int id) async {
    return await _lookupRepository.getFemaleMortalityByID(id);
  }

  addFemaleMortality(FemaleMortalitiesCompanion fmc) async {
    await _lookupRepository.addFemaleMortality(fmc);
    getAllFemaleMortalities();
  }

  updateFemaleMortality(FemaleMortalitiesCompanion fmc) async {
    await _lookupRepository.updateFemaleMortality(fmc);
    getAllFemaleMortalities();
  }

  deleteFemaleMortality(int id) async {
    await _lookupRepository.deleteFemaleMortality(id);
    getAllFemaleMortalities();
  }

  getAllChildMortalities() async {
    _allChildMortalities = await _lookupRepository.allChildMortalities();
    _currentChildMortalities = _allChildMortalities;
    notifyListeners();
  }

  getChildMortalityByID(int id) async {
    return await _lookupRepository.getChildMortalityByID(id);
  }

  addChildMortality(ChildMortalitiesCompanion cmc) async {
    await _lookupRepository.addChildMortality(cmc);
    getAllChildMortalities();
  }

  updateChildMortality(ChildMortalitiesCompanion cmc) async {
    await _lookupRepository.updateChildMortality(cmc);
    getAllChildMortalities();
  }

  deleteChildMortality(int id) async {
    await _lookupRepository.deleteChildMortality(id);
    getAllChildMortalities();
  }

  getAllFutureResidencies() async {
    _allFutureResidencies = await _lookupRepository.allFutureResidencies();
    _currentFutureResidencies = _allFutureResidencies;
    notifyListeners();
  }

  getFutureResidencyByID(int id) async {
    return await _lookupRepository.getFutureResidencyByID(id);
  }

  addFutureResidency(FutureResidenciesCompanion frc) async {
    await _lookupRepository.addFutureResidency(frc);
    getAllFutureResidencies();
  }

  updateFutureResidency(FutureResidenciesCompanion frc) async {
    await _lookupRepository.updateFutureResidency(frc);
    getAllFutureResidencies();
  }

  deleteFutureResidency(int id) async {
    await _lookupRepository.deleteFutureResidency(id);
    getAllFutureResidencies();
  }

  getAllHouseholdVisits() async {
    _allHouseholdVisits = await _lookupRepository.allHouseholdVisits();
    _currentHouseholdVisits = _allHouseholdVisits;
    notifyListeners();
  }

  getHouseholdVisitByID(int id) async {
    return await _lookupRepository.getHouseholdVisitByID(id);
  }

  addHouseholdVisit(HouseholdVisitsCompanion hvc) async {
    await _lookupRepository.addHouseholdVisit(hvc);
    getAllHouseholdVisits();
  }

  updateHouseholdVisit(HouseholdVisitsCompanion hvc) async {
    await _lookupRepository.updateHouseholdVisit(hvc);
    getAllHouseholdVisits();
  }

  deleteHouseholdVisit(int id) async {
    await _lookupRepository.deleteHouseholdVisit(id);
    getAllHouseholdVisits();
  }

  Future<void> addHouseholdMember(HouseholdMembersCompanion hmc) async {
    await _lookupRepository.addHouseholdMember(hmc);
  }

  Future<void> addHouseholdRelationship(
    HouseholdRelationshipsCompanion hrc,
  ) async {
    await _lookupRepository.addHouseholdRelationship(hrc);
  }
}
