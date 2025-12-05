import 'dart:developer';

import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';

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
        ..where((question) => question.question_id.equals(id))).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addQuestion(QuestionsCompanion qc) async {
    try {
      return await db
          .into(db.questions)
          .insert(qc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateQuestion(QuestionsCompanion qc) async {
    try {
      return await db.update(db.questions).replace(qc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteQuestion(int id) async {
    try {
      return await (db.delete(db.questions)
        ..where((question) => question.question_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Questions Choices ------------
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
      return await (db.select(db.questionChoices)..where(
        (questionChoice) => questionChoice.choice_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addQuestionChoice(QuestionChoicesCompanion qcc) async {
    try {
      return await db
          .into(db.questionChoices)
          .insert(qcc); // Returns id of the inserted row
    } catch (e) {
      log(e.toString());
    }
  }

  updateQuestionChoice(QuestionChoicesCompanion qcc) async {
    try {
      return await db.update(db.questionChoices).replace(qcc);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteQuestionChoice(int id) async {
    try {
      return await (db.delete(db.questionChoices)
        ..where((questionChoice) => questionChoice.choice_id.equals(id))).go();
    } catch (e) {
      log(e.toString());
    }
  }

  // ------------ Household Responses ------------
  Future<List<HouseholdResponseData>> allHouseholdResponses() async {
    try {
      return await db.select(db.householdResponses).get();
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  getHouseholdResponseByID(int id) async {
    try {
      return await (db.select(db.householdResponses)..where(
        (householdResponse) => householdResponse.response_id.equals(id),
      )).getSingle();
    } catch (e) {
      log(e.toString());
    }
  }

  addHouseholdResponse(HouseholdResponsesCompanion hrc) async {
    try {
      return await db
          .into(db.householdResponses)
          .insert(hrc); // Returns id of the inserted row
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
      return await (db.delete(db.householdResponses)..where(
        (householdResponse) => householdResponse.response_id.equals(id),
      )).go();
    } catch (e) {
      log(e.toString());
    }
  }
}
