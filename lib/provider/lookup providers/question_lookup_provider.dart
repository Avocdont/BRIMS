import 'package:brims/database/app_db.dart';
import 'package:brims/repository/lookup repositories/question_lookup_repository.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

class QuestionLookupProvider extends ChangeNotifier {
  QuestionLookupProvider() {
    loadAllLookups();
  }

  final QuestionLookupRepository _lookupRepository = QuestionLookupRepository();

  List<QuestionData> _allQuestions = [];
  List<QuestionData> get allQuestions => _allQuestions;

  List<QuestionChoiceData> _allQuestionChoices = [];
  List<QuestionChoiceData> get allQuestionChoices => _allQuestionChoices;

  List<HouseholdResponseData> _allHouseholdResponses = [];
  List<HouseholdResponseData> get allHouseholdResponses =>
      _allHouseholdResponses;

  Future<void> loadAllLookups() async {
    await getAllQuestions();
    await getAllQuestionChoices();
    await getAllHouseholdResponses();
  }

  // ------------ QUESTIONS ------------
  getAllQuestions() async {
    _allQuestions = await _lookupRepository.allQuestions();
    notifyListeners();
  }

  addQuestion(QuestionsCompanion qc) async {
    await _lookupRepository.addQuestion(qc);
    await getAllQuestions();
  }

  updateQuestion(QuestionsCompanion qc) async {
    await _lookupRepository.updateQuestion(qc);
    await getAllQuestions();
  }

  deleteQuestion(int id) async {
    await _lookupRepository.deleteQuestion(id);
    await getAllQuestions();
  }

  // ------------ CHOICES ------------
  getAllQuestionChoices() async {
    _allQuestionChoices = await _lookupRepository.allQuestionChoices();
    notifyListeners();
  }

  // HELPER: Filter choices for UI Dropdowns
  List<QuestionChoiceData> getChoicesForQuestion(int questionId) {
    return _allQuestionChoices
        .where((c) => c.question_id == questionId)
        .toList();
  }

  addQuestionChoice(QuestionChoicesCompanion qcc) async {
    await _lookupRepository.addQuestionChoice(qcc);
    await getAllQuestionChoices();
  }

  updateQuestionChoice(QuestionChoicesCompanion qcc) async {
    await _lookupRepository.updateQuestionChoice(qcc);
    await getAllQuestionChoices();
  }

  deleteQuestionChoice(int id) async {
    await _lookupRepository.deleteQuestionChoice(id);
    await getAllQuestionChoices();
  }

  // ------------ RESPONSES ------------
  getAllHouseholdResponses() async {
    _allHouseholdResponses = await _lookupRepository.allHouseholdResponses();
    notifyListeners();
  }

  // HELPER: Fetch answers for Edit Page
  Future<List<HouseholdResponseData>> getHouseholdResponses(
      int householdId) async {
    return await _lookupRepository.getResponsesByHouseholdId(householdId);
  }

  addHouseholdResponse(HouseholdResponsesCompanion hrc) async {
    await _lookupRepository.addHouseholdResponse(hrc);
    await getAllHouseholdResponses();
  }

  updateHouseholdResponse(HouseholdResponsesCompanion hrc) async {
    await _lookupRepository.updateHouseholdResponse(hrc);
    await getAllHouseholdResponses();
  }

  deleteHouseholdResponse(int id) async {
    await _lookupRepository.deleteHouseholdResponse(id);
    await getAllHouseholdResponses();
  }
}
