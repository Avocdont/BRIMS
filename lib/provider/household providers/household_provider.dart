import 'package:brims/database/app_db.dart';
import 'package:brims/models/household_models.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/repository/household%20repositories/household_repository.dart';
import 'package:drift/drift.dart'; // Needed for Companions
import 'package:flutter/material.dart';

class HouseholdProvider extends ChangeNotifier {
  final HouseholdRepository _lookupRepository = HouseholdRepository();

  // --- HOUSEHOLDS ---
  List<HouseholdData> _allHouseholds = [];
  List<HouseholdData> get allHouseholds => _allHouseholds;

  List<HouseholdData> _currentHouseholds = [];
  List<HouseholdData> get currentHouseholds => _currentHouseholds;

  // List variable to store state
  List<HouseholdRelationship> _allHouseholdRelationships = [];
  List<HouseholdRelationship> get allHouseholdRelationships =>
      _allHouseholdRelationships;

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

  // --- FIX: Now accepts ONLY the Companion (ID is inside it) ---
  updateHousehold(HouseholdsCompanion hc) async {
    await _lookupRepository.updateHousehold(hc);
    getAllHouseholds();
  }

  deleteHousehold(int id) async {
    await _lookupRepository.deleteHousehold(id);
    getAllHouseholds();
  }

  // --- ADDRESSES ---
  List<AddressData> _allAddresses = [];
  List<AddressData> get allAddresses => _allAddresses;

  List<AddressData> _currentAddresses = [];
  List<AddressData> get currentAddresses => _currentAddresses;

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

  // --- SERVICES ---
  List<ServiceData> _allServices = [];
  List<ServiceData> get allServices => _allServices;

  List<ServiceData> _currentServices = [];
  List<ServiceData> get currentServices => _currentServices;

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

  // --- PRIMARY NEEDS ---
  List<PrimaryNeedData> _allPrimaryNeeds = [];
  List<PrimaryNeedData> get allPrimaryNeeds => _allPrimaryNeeds;

  List<PrimaryNeedData> _currentPrimaryNeeds = [];
  List<PrimaryNeedData> get currentPrimaryNeeds => _currentPrimaryNeeds;

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

  // --- FEMALE MORTALITY ---
  List<FemaleMortalityData> _allFemaleMortalities = [];
  List<FemaleMortalityData> get allFemaleMortalities => _allFemaleMortalities;

  List<FemaleMortalityData> _currentFemaleMortalities = [];
  List<FemaleMortalityData> get currentFemaleMortalities =>
      _currentFemaleMortalities;

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

  // --- CHILD MORTALITY ---
  List<ChildMortalityData> _allChildMortalities = [];
  List<ChildMortalityData> get allChildMortalities => _allChildMortalities;

  List<ChildMortalityData> _currentChildMortalities = [];
  List<ChildMortalityData> get currentChildMortalities =>
      _currentChildMortalities;

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

  // --- FUTURE RESIDENCY ---
  List<FutureResidency> _allFutureResidencies = [];
  List<FutureResidency> get allFutureResidencies => _allFutureResidencies;

  List<FutureResidency> _currentFutureResidencies = [];
  List<FutureResidency> get currentFutureResidencies =>
      _currentFutureResidencies;

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

  // --- HOUSEHOLD VISITS ---
  List<HouseholdVisitData> _allHouseholdVisits = [];
  List<HouseholdVisitData> get allHouseholdVisits => _allHouseholdVisits;

  List<HouseholdVisitData> _currentHouseholdVisits = [];
  List<HouseholdVisitData> get currentHouseholdVisits =>
      _currentHouseholdVisits;

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

  // --- HOUSEHOLD MEMBERS ---
  List<HouseholdMemberData> _allHouseholdMembers = [];
  List<HouseholdMemberData> get allHouseholdMembers => _allHouseholdMembers;

  getAllHouseholdMembers() async {
    _allHouseholdMembers = await _lookupRepository.allHouseholdMembers();
    notifyListeners();
  }

  Future<void> addHouseholdMember(HouseholdMembersCompanion hmc) async {
    await _lookupRepository.addHouseholdMember(hmc);
    getAllHouseholdMembers();
  }

  Future<void> deleteHouseholdMember(int householdId, int personId) async {
    await _lookupRepository.deleteHouseholdMember(householdId, personId);
    getAllHouseholdMembers();
  }

  // Fetcher
  Future<void> getAllHouseholdRelationships() async {
    _allHouseholdRelationships =
        await _lookupRepository.getAllHouseholdRelationships();
    notifyListeners();
  }

  // Update Function
  Future<void> updateHouseholdRelationship(
      HouseholdRelationshipsCompanion hrc) async {
    await _lookupRepository.updateHouseholdRelationship(hrc);
    await getAllHouseholdRelationships(); // Refresh list after update
  }

  Future<void> addHouseholdRelationship(
    HouseholdRelationshipsCompanion hrc,
  ) async {
    await _lookupRepository.addHouseholdRelationship(hrc);
    await getAllHouseholdRelationships(); // Refresh list after update
  }

  // Delete Function
  Future<void> deleteHouseholdRelationship(int id) async {
    await _lookupRepository.deleteHouseholdRelationship(id);
    await getAllHouseholdRelationships(); // Refresh list after delete
  }

  final HouseholdRepository _tableRepository = HouseholdRepository();

  // --- Table State ---
  List<HouseholdTableRow> _tableHouseholds = [];
  int _totalRows = 0;
  bool _isTableLoading = false;

  int _currentPageIndex = 0;
  int _rowsPerPage = 10;
  String? _searchQuery;

  HouseholdSortColumn _sortColumn = HouseholdSortColumn.none;
  SortDirection _sortDirection = SortDirection.asc;
  HouseholdFilterOptions _filters = HouseholdFilterOptions();

  // --- Getters ---
  List<HouseholdTableRow> get tableHouseholds => _tableHouseholds;
  int get totalRows => _totalRows;
  bool get isTableLoading => _isTableLoading;
  int get currentPageIndex => _currentPageIndex;
  int get rowsPerPage => _rowsPerPage;
  HouseholdSortColumn get sortColumn => _sortColumn;
  SortDirection get sortDirection => _sortDirection;
  HouseholdFilterOptions get filters => _filters;

  // --- Logic ---

  Future<void> loadHouseholdTable() async {
    _isTableLoading = true;
    notifyListeners();

    _tableHouseholds = await _tableRepository.getHouseholdTableData(
      page: _currentPageIndex,
      limit: _rowsPerPage,
      searchQuery: _searchQuery,
      filters: _filters,
      sortColumn: _sortColumn,
      sortDirection: _sortDirection,
    );

    _totalRows = await _tableRepository.getTotalHouseholdCount(
      searchQuery: _searchQuery,
      filters: _filters,
    );

    _isTableLoading = false;
    notifyListeners();
  }

  void onPageChanged(int firstRowIndex) {
    _currentPageIndex = firstRowIndex ~/ _rowsPerPage;
    loadHouseholdTable();
  }

  void onRowsPerPageChanged(int newRowsPerPage) {
    _rowsPerPage = newRowsPerPage;
    _currentPageIndex = 0;
    loadHouseholdTable();
  }

  void search(String query) {
    _searchQuery = query;
    _currentPageIndex = 0;
    loadHouseholdTable();
  }

  void sort(HouseholdSortColumn column) {
    if (_sortColumn != column) {
      _sortColumn = column;
      _sortDirection = SortDirection.asc;
    } else {
      // Toggle: Asc -> Desc -> None
      if (_sortDirection == SortDirection.asc) {
        _sortDirection = SortDirection.desc;
      } else {
        _sortColumn = HouseholdSortColumn.none;
        _sortDirection = SortDirection.asc;
      }
    }
    loadHouseholdTable();
  }

  void updateFilters(HouseholdFilterOptions newFilters) {
    _filters = newFilters;
    _currentPageIndex = 0;
    loadHouseholdTable();
  }
}
