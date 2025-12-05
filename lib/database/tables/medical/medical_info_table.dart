import 'package:brims/database/tables/lookups/medinfo_lookup_table.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:drift/drift.dart';

@DataClassName('NewbornInformationData')
class NewbornInformation extends Table {
  IntColumn get newborn_info_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  BoolColumn get immunization => boolean().nullable()();
  IntColumn get delivery_place_id =>
      integer().nullable().references(
        DeliveryPlaces,
        #delivery_place_id,
        onDelete: KeyAction.noAction,
      )();
  IntColumn get assisted_person_id =>
      integer().nullable().references(
        AssistedPersons,
        #assisted_person_id,
        onDelete: KeyAction.restrict,
      )();
}

@DataClassName('HealthInsuranceData')
class HealthInsurances extends Table {
  IntColumn get health_insurance_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
}

@DataClassName('VisitedFacilityData')
class VisitedFacilities extends Table {
  IntColumn get visited_facility_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  DateTimeColumn get date => dateTime().nullable()();
  IntColumn get visit_reason_id =>
      integer().nullable().references(
        VisitReasons,
        #visit_reason_id,
        onDelete: KeyAction.restrict,
      )();
}

@DataClassName('MaternalInformationData')
class MaternalInformation extends Table {
  IntColumn get maternal_info_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  BoolColumn get pregnant => boolean().nullable()();
  BoolColumn get lactating => boolean().nullable()();
  IntColumn get living_children_num => integer().nullable()();
  BoolColumn get fp_intention => boolean().nullable()();
}

@DataClassName('FamilyPlanningData')
class FamilyPlanning extends Table {
  IntColumn get family_planning_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get fp_method_id =>
      integer().nullable().references(
        FpMethods,
        #fp_method_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get fp_source_id =>
      integer().nullable().references(
        FpSources,
        #fp_source_id,
        onDelete: KeyAction.restrict,
      )();
}
