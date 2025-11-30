import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class DailyIncomeRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<DailyIncomeData>> allDailyIncomes() async {
    try {
      return await db.select(db.dailyIncomes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getDailyIncomeByID(int id) async {
    try {
      return await (db.select(db.dailyIncomes)..where(
        (dailyincome) => dailyincome.daily_income_id.equals(
          id,
        ), // dailyincome here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addDailyIncome(DailyIncomesCompanion dic) async {
    // DailyIncomesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.dailyIncomes)
          .insert(dic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updatDailyIncome(DailyIncomesCompanion dic) async {
    // dic holds row data
    try {
      return await db.update(db.dailyIncomes).replace(dic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteDailyIncome(int id) async {
    try {
      return await (db.delete(db.dailyIncomes)
        ..where((dailyincome) => dailyincome.daily_income_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
