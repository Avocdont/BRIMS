import 'package:drift/drift.dart';

@DataClassName('AgriProductData')
class AgriProducts extends Table {
  IntColumn get agri_product_id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('LivestockProductData')
class LivestockProducts extends Table {
  IntColumn get livestock_product_id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('FishingProductData')
class FishingProducts extends Table {
  IntColumn get fishing_product_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
