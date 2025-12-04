import 'package:brims/database/tables/lookups/farming_lookup_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:drift/drift.dart';

@DataClassName('AgricultureData')
class Agriculture extends Table {
  IntColumn get agriculture_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get agri_product_id =>
      integer().nullable().references(
        AgriProducts,
        #agri_product_id,
        onDelete: KeyAction.restrict,
      )();
  RealColumn get area_ha => real().nullable()();
  RealColumn get volume_kg => real().nullable()();
  IntColumn get production_value => integer().nullable()();
  IntColumn get farmer_count => integer().nullable()();
}

@DataClassName('LivestockData')
class Livestock extends Table {
  IntColumn get livestock_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get livestock_product_id =>
      integer().nullable().references(
        LivestockProducts,
        #livestock_product_id,
        onDelete: KeyAction.restrict,
      )();
  RealColumn get area_ha => real().nullable()();
  RealColumn get volume_kg => real().nullable()();
  IntColumn get production_value => integer().nullable()();
  IntColumn get farmer_count => integer().nullable()();
}

@DataClassName('FishingData')
class Fishing extends Table {
  IntColumn get fishing_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get fishing_product_id =>
      integer().nullable().references(
        FishingProducts,
        #fishing_product_id,
        onDelete: KeyAction.restrict,
      )();
  RealColumn get area_ha => real().nullable()();
  RealColumn get volume_kg => real().nullable()();
  IntColumn get production_value => integer().nullable()();
  IntColumn get fisherman_count => integer().nullable()();
}
