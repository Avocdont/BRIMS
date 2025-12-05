import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class MedInfoLookupRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Delivery Places ------------

  Future<List<DeliveryPlaceData>> allDeliveryPlaces() async {
    try {
      return await db.select(db.deliveryPlaces).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getDeliveryPlaceByID(int id) async {
    try {
      return await (db.select(db.deliveryPlaces)..where(
        (deliveryPlace) => deliveryPlace.delivery_place_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addDeliveryPlace(DeliveryPlacesCompanion dpc) async {
    try {
      return await db
          .into(db.deliveryPlaces)
          .insert(dpc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateDeliveryPlace(DeliveryPlacesCompanion dpc) async {
    try {
      return await db.update(db.deliveryPlaces).replace(dpc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteDeliveryPlace(int id) async {
    try {
      return await (db.delete(db.deliveryPlaces)..where(
        (deliveryPlace) => deliveryPlace.delivery_place_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Assisted Persons ------------

  Future<List<AssistedPersonData>> allAssistedPersons() async {
    try {
      return await db.select(db.assistedPersons).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getAssistedPersonByID(int id) async {
    try {
      return await (db.select(db.assistedPersons)..where(
        (assistedPerson) => assistedPerson.assisted_person_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addAssistedPerson(AssistedPersonsCompanion apc) async {
    try {
      return await db
          .into(db.assistedPersons)
          .insert(apc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateAssistedPerson(AssistedPersonsCompanion apc) async {
    try {
      return await db.update(db.assistedPersons).replace(apc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteAssistedPerson(int id) async {
    try {
      return await (db.delete(db.assistedPersons)..where(
        (assistedPerson) => assistedPerson.assisted_person_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Visit Reasons ------------

  Future<List<VisitReasonData>> allVisitReasons() async {
    try {
      return await db.select(db.visitReasons).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getVisitReasonByID(int id) async {
    try {
      return await (db.select(db.visitReasons)..where(
        (assistedPerson) => assistedPerson.visit_reason_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addVisitReason(VisitReasonsCompanion vrc) async {
    try {
      return await db
          .into(db.visitReasons)
          .insert(vrc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateVisitReason(VisitReasonsCompanion vrc) async {
    try {
      return await db.update(db.visitReasons).replace(vrc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteVisitReason(int id) async {
    try {
      return await (db.delete(db.visitReasons)
        ..where((visitReason) => visitReason.visit_reason_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Family Planning Source ------------

  Future<List<FpSourceData>> allFpSources() async {
    try {
      return await db.select(db.fpSources).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getFpSourceByID(int id) async {
    try {
      return await (db.select(db.fpSources)
        ..where((fpSource) => fpSource.fp_source_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addFpSource(FpSourcesCompanion fsc) async {
    try {
      return await db
          .into(db.fpSources)
          .insert(fsc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateFpSource(FpSourcesCompanion fsc) async {
    try {
      return await db.update(db.fpSources).replace(fsc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteFpSource(int id) async {
    try {
      return await (db.delete(db.fpSources)
        ..where((fpSource) => fpSource.fp_source_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Family Methods ------------

  Future<List<FpMethodData>> allFpMethods() async {
    try {
      return await db.select(db.fpMethods).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getFpMethodByID(int id) async {
    try {
      return await (db.select(db.fpMethods)
        ..where((fpMethod) => fpMethod.fp_method_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addFpMethod(FpMethodsCompanion fmc) async {
    try {
      return await db
          .into(db.fpMethods)
          .insert(fmc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateFpMethod(FpMethodsCompanion fmc) async {
    try {
      return await db.update(db.fpMethods).replace(fmc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteFpMethod(int id) async {
    try {
      return await (db.delete(db.fpMethods)
        ..where((fpMethod) => fpMethod.fp_method_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
