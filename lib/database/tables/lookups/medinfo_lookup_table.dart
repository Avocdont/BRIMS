import 'package:drift/drift.dart';

@DataClassName('DeliveryPlaceData')
class DeliveryPlaces extends Table {
  IntColumn get delivery_place_id => integer().autoIncrement()();
  TextColumn get place => text().nullable()();
}

@DataClassName('AssistedPersonData')
class AssistedPersons extends Table {
  IntColumn get assisted_person_id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
}

@DataClassName('VisitReasonData')
class VisitReasons extends Table {
  IntColumn get visit_reason_id => integer().autoIncrement()();
  TextColumn get reason => text().nullable()();
}

@DataClassName('FpSourceData')
class FpSources extends Table {
  IntColumn get fp_source_id => integer().autoIncrement()();
  TextColumn get source => text().nullable()();
}

@DataClassName('FpMethodData')
class FpMethods extends Table {
  IntColumn get fp_method_id => integer().autoIncrement()();
  TextColumn get method => text().nullable()();
}
