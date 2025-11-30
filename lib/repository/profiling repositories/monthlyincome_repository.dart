import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

class DailyIncomeRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<MonthlyIncomeData>> allMonthlyIncomes() async {
    try {
      return await db.select(db.monthlyIncomes).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getMonthlyIncomeByID(int id) async {
    try {
      return await (db.select(db.monthlyIncomes)..where(
        (monthlyincome) => monthlyincome.monthly_income_id.equals(
          id,
        ), // monthlyincome here specifically is a row
      )).getSingle(); // .. is a cascade operator
    } catch (e) {
      log(e.toString());
    }
  }

  addMonthlyIncome(MonthlyIncomesCompanion mic) async {
    // MonthlyIncomesCompanion is a Drift generated type safe table inserter that enforces required fields, prevents illegal values, and lets you choose which columns to insert or update
    try {
      return await db
          .into(db.monthlyIncomes)
          .insert(mic); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updatMonthlyIncome(MonthlyIncomesCompanion mic) async {
    // mic holds row data
    try {
      return await db.update(db.monthlyIncomes).replace(mic);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteMonthlyIncome(int id) async {
    try {
      return await (db.delete(db.monthlyIncomes)..where(
        (monthlyincome) => monthlyincome.monthly_income_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
