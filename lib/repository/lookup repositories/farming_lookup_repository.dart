import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class FarmingLookupRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Agri Products ------------
  Future<List<AgriProductData>> allAgriProducts() async {
    try {
      return await db.select(db.agriProducts).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getAgriProductByID(int id) async {
    try {
      return await (db.select(db.agriProducts)..where(
        (agriProduct) => agriProduct.agri_product_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addAgriProduct(AgriProductsCompanion apc) async {
    try {
      return await db
          .into(db.agriProducts)
          .insert(apc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateAgriProduct(AgriProductsCompanion apc) async {
    try {
      return await db.update(db.agriProducts).replace(apc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteAgriProduct(int id) async {
    try {
      return await (db.delete(db.agriProducts)
        ..where((agriProduct) => agriProduct.agri_product_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Livestock Products ------------
  Future<List<LivestockProductData>> allLivestockProducts() async {
    try {
      return await db.select(db.livestockProducts).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getLivestockProductByID(int id) async {
    try {
      return await (db.select(db.livestockProducts)..where(
        (livestockProduct) => livestockProduct.livestock_product_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addLivestockProduct(LivestockProductsCompanion lpc) async {
    try {
      return await db
          .into(db.livestockProducts)
          .insert(lpc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateLivestockProduct(LivestockProductsCompanion lpc) async {
    try {
      return await db.update(db.livestockProducts).replace(lpc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteLivestockProduct(int id) async {
    try {
      return await (db.delete(db.livestockProducts)..where(
        (livestockProduct) => livestockProduct.livestock_product_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Fishing Products ------------
  Future<List<FishingProductData>> allFishingProducts() async {
    try {
      return await db.select(db.fishingProducts).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getFishingProductByID(int id) async {
    try {
      return await (db.select(db.fishingProducts)..where(
        (fishingProduct) => fishingProduct.fishing_product_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addFishingProduct(FishingProductsCompanion fpc) async {
    try {
      return await db
          .into(db.fishingProducts)
          .insert(fpc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateFishingProduct(FishingProductsCompanion fpc) async {
    try {
      return await db.update(db.fishingProducts).replace(fpc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteFishingProduct(int id) async {
    try {
      return await (db.delete(db.fishingProducts)..where(
        (fishingProduct) => fishingProduct.fishing_product_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
