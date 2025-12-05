import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class ContactInfoRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Emails ------------
  Future<List<EmailData>> allEmails() async {
    try {
      return await db.select(db.emails).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getEmailByID(int id) async {
    try {
      return await (db.select(db.emails)
        ..where((email) => email.email_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addEmail(EmailsCompanion ec) async {
    try {
      return await db
          .into(db.emails)
          .insert(ec); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateEmail(EmailsCompanion ec) async {
    try {
      return await db.update(db.emails).replace(ec);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteEmail(int id) async {
    try {
      return await (db.delete(db.emails)
        ..where((email) => email.email_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Phone Numbers ------------

  Future<List<PhoneNumberData>> allPhoneNumbers() async {
    try {
      return await db.select(db.phoneNumbers).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getPhoneNumberByID(int id) async {
    try {
      return await (db.select(db.phoneNumbers)..where(
        (phoneNumber) => phoneNumber.phone_number_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addPhoneNumber(PhoneNumbersCompanion pnc) async {
    try {
      return await db
          .into(db.phoneNumbers)
          .insert(pnc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updatePhoneNumber(PhoneNumbersCompanion pnc) async {
    try {
      return await db.update(db.phoneNumbers).replace(pnc);
    } catch (e) {
      log(e.toString());
    }
  }

  deletePhoneNumber(int id) async {
    try {
      return await (db.delete(db.phoneNumbers)
        ..where((phoneNumber) => phoneNumber.phone_number_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Gadgets ------------

  Future<List<GadgetData>> allGadgets() async {
    try {
      return await db.select(db.gadgets).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getGadgetByID(int id) async {
    try {
      return await (db.select(db.gadgets)
        ..where((gadget) => gadget.gadget_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addGadget(GadgetsCompanion gc) async {
    try {
      return await db
          .into(db.gadgets)
          .insert(gc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateGadget(GadgetsCompanion gc) async {
    try {
      return await db.update(db.gadgets).replace(gc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteGadget(int id) async {
    try {
      return await (db.delete(db.gadgets)
        ..where((gadget) => gadget.gadget_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
