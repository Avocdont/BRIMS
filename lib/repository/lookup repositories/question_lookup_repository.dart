import 'dart:developer';
import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:drift/drift.dart';

class QuestionLookupRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // ------------ Questions ------------
  Future<List<QuestionData>> allQuestions() async {
    try {
      return await db.select(db.questions).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getQuestionByID(int id) async {
    try {
      return await (db.select(db.questions)
            ..where((q) => q.question_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  // FIXED: Added missing method
  addQuestion(QuestionsCompanion qc) async {
    try {
      return await db.into(db.questions).insert(qc);
    } catch (e) {
      log(e.toString());
    }
  }

  // FIXED: Added missing method
  updateQuestion(QuestionsCompanion qc) async {
    try {
      return await db.update(db.questions).replace(qc);
    } catch (e) {
      log(e.toString());
    }
  }

  // FIXED: Added missing method
  deleteQuestion(int id) async {
    try {
      return await (db.delete(db.questions)
            ..where((q) => q.question_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Question Choices ------------
  Future<List<QuestionChoiceData>> allQuestionChoices() async {
    try {
      return await db.select(db.questionChoices).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  getQuestionChoiceByID(int id) async {
    try {
      return await (db.select(db.questionChoices)
            ..where((c) => c.choice_id.equals(id)))
          .getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  // FIXED: Added missing method
  addQuestionChoice(QuestionChoicesCompanion qcc) async {
    try {
      return await db.into(db.questionChoices).insert(qcc);
    } catch (e) {
      log(e.toString());
    }
  }

  // FIXED: Added missing method
  updateQuestionChoice(QuestionChoicesCompanion qcc) async {
    try {
      return await db.update(db.questionChoices).replace(qcc);
    } catch (e) {
      log(e.toString());
    }
  }

  // FIXED: Added missing method
  deleteQuestionChoice(int id) async {
    try {
      return await (db.delete(db.questionChoices)
            ..where((c) => c.choice_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Household Responses ------------
  // FIXED: Added missing method
  Future<List<HouseholdResponseData>> allHouseholdResponses() async {
    try {
      return await db.select(db.householdResponses).get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<HouseholdResponseData>> getResponsesByHouseholdId(int id) async {
    try {
      return await (db.select(db.householdResponses)
            ..where((tbl) => tbl.household_id.equals(id)))
          .get();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  addHouseholdResponse(HouseholdResponsesCompanion hrc) async {
    try {
      return await db.into(db.householdResponses).insert(hrc);
    } catch (e) {
      log(e.toString());
    }
  }

  updateHouseholdResponse(HouseholdResponsesCompanion hrc) async {
    try {
      return await db.update(db.householdResponses).replace(hrc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteHouseholdResponse(int id) async {
    try {
      return await (db.delete(db.householdResponses)
            ..where((r) => r.response_id.equals(id)))
          .go();
    } catch (e) {
      log(e.toString());
    }
  }
}
