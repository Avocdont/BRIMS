import 'package:brims/database/app_db.dart';
import 'package:brims/repository/lookup repositories/farming_lookup_repository.dart';
import 'package:flutter/material.dart';

class FarmingLookupProvider extends ChangeNotifier {
  FarmingLookupProvider() {
    loadAllLookups();
  }

  final FarmingLookupRepository _lookupRepository = FarmingLookupRepository();

  List<AgriProductData> _allAgriProducts = [];
  List<AgriProductData> get allAgriProducts => _allAgriProducts;

  List<AgriProductData> _currentAgriProducts = [];
  List<AgriProductData> get currentAgriProducts => _currentAgriProducts;

  List<LivestockProductData> _allLivestockProducts = [];
  List<LivestockProductData> get allLivestockProducts => _allLivestockProducts;

  List<LivestockProductData> _currentLivestockProducts = [];
  List<LivestockProductData> get currentLivestockProducts =>
      _currentLivestockProducts;

  List<FishingProductData> _allFishingProducts = [];
  List<FishingProductData> get allFishingProducts => _allFishingProducts;

  List<FishingProductData> _currentFishingProducts = [];
  List<FishingProductData> get currentFishingProducts =>
      _currentFishingProducts;

  Future<void> loadAllLookups() async {
    await getAllAgriProducts();
    await getAllLivestockProducts();
    await getAllFishingProducts();
  }

  // ------------ Agri Products ------------

  getAllAgriProducts() async {
    _allAgriProducts = await _lookupRepository.allAgriProducts();
    _currentAgriProducts = _allAgriProducts;
    notifyListeners();
  }

  addAgriProduct(AgriProductsCompanion apc) async {
    await _lookupRepository.addAgriProduct(apc);
    await getAllAgriProducts();
  }

  updateAgriProduct(AgriProductsCompanion apc) async {
    await _lookupRepository.updateAgriProduct(apc);
    await getAllAgriProducts();
  }

  deleteAgriProduct(int id) async {
    await _lookupRepository.deleteAgriProduct(id);
    await getAllAgriProducts();
  }

  // ------------ Livestock Products ------------

  getAllLivestockProducts() async {
    _allLivestockProducts = await _lookupRepository.allLivestockProducts();
    _currentLivestockProducts = _allLivestockProducts;
    notifyListeners();
  }

  addLivestockProduct(LivestockProductsCompanion lpc) async {
    await _lookupRepository.addLivestockProduct(lpc);
    await getAllLivestockProducts();
  }

  updateLivestockProduct(LivestockProductsCompanion lpc) async {
    await _lookupRepository.updateLivestockProduct(lpc);
    await getAllLivestockProducts();
  }

  deleteLivestockProduct(int id) async {
    await _lookupRepository.deleteLivestockProduct(id);
    await getAllLivestockProducts();
  }

  // ------------ Fishing Products ------------

  getAllFishingProducts() async {
    _allFishingProducts = await _lookupRepository.allFishingProducts();
    _currentFishingProducts = _allFishingProducts;
    notifyListeners();
  }

  addFishingProduct(FishingProductsCompanion fpc) async {
    await _lookupRepository.addFishingProduct(fpc);
    await getAllFishingProducts();
  }

  updateFishingProduct(FishingProductsCompanion fpc) async {
    await _lookupRepository.updateFishingProduct(fpc);
    await getAllFishingProducts();
  }

  deleteFishingProduct(int id) async {
    await _lookupRepository.deleteFishingProduct(id);
    await getAllFishingProducts();
  }
}
