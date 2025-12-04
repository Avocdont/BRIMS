import 'package:brims/database/app_db.dart';
import 'package:brims/repository/household%20repositories/household_repository.dart';
import 'package:flutter/material.dart';

class HouseholdProvider extends ChangeNotifier {
  final HouseholdRepository _lookupRepository = HouseholdRepository();

  List<HouseholdData> _allHouseholds = [];
  List<HouseholdData> get allHouseholds => _allHouseholds;

  List<AddressData> _allAddresses = [];
  List<AddressData> get allAddresses => _allAddresses;

  getAllHouseholds() async {
    _allHouseholds = await _lookupRepository.allHouseholds();
    notifyListeners();
  }

  getHouseholdByID(int id) async {
    return await _lookupRepository.getHouseholdByID(id);
  }

  addHousehold(HouseholdsCompanion hc) async {
    await _lookupRepository.addHousehold(hc);
    getAllHouseholds();
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
    notifyListeners();
  }

  getAddressByID(int id) async {
    return await _lookupRepository.getAddressByID(id);
  }

  addAddress(AddressesCompanion ac) async {
    await _lookupRepository.addAddress(ac);
    getAllAddresses();
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
    await _lookupRepository.searchAddresses(
      zone: zone,
      street: street,
      block: block,
      lot: lot,
    );
  }
}
