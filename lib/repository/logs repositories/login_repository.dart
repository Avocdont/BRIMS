import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class LoginRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<LoginCredentialData>> allLoginCredential() async {
    try {
      return await db.select(db.loginCredentials).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getLoginCredentialByID(int id) async {
    try {
      return await (db.select(db.loginCredentials)..where(
        (loginCredential) => loginCredential.login_id.equals(
          id,
        ), // person here specifically is a row
      )).getSingle(); // .. is a cascde operator
    } catch (e) {
      log(e.toString());
    }
  }

  addLoginCredential(LoginCredentialsCompanion lcc) async {
    // PersonsCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.loginCredentials)
          .insert(lcc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateLoginCredential(LoginCredentialsCompanion lcc) async {
    // p holds row data
    try {
      return await db.update(db.loginCredentials).replace(lcc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteLoginCredential(int id) async {
    try {
      return await (db.delete(db.loginCredentials)
        ..where((loginCredential) => loginCredential.login_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
