import 'package:brims/database/app_db.dart';
import 'package:brims/repository/lookup repositories/question_lookup_repository.dart';
import 'package:flutter/material.dart';

class QuestionLookupProvider extends ChangeNotifier {
  QuestionLookupProvider() {
    loadAllLookups();
  }

  final QuestionLookupRepository _lookupRepository = QuestionLookupRepository();

  List<QuestionData> _allQuestions = [];
  List<QuestionData> get allQuestions => _allQuestions;

  List<QuestionData> _currentQuestions = [];
  List<QuestionData> get currentQuestions => _currentQuestions;

  List<QuestionChoiceData> _allQuestionChoices = [];
  List<QuestionChoiceData> get allQuestionChoices => _allQuestionChoices;

  List<QuestionChoiceData> _currentQuestionChoices = [];
  List<QuestionChoiceData> get currentQuestionChoices =>
      _currentQuestionChoices;

  List<HouseholdResponseData> _allHouseholdResponses = [];
  List<HouseholdResponseData> get allHouseholdResponses =>
      _allHouseholdResponses;

  List<HouseholdResponseData> _currentHouseholdResponses = [];
  List<HouseholdResponseData> get currentHouseholdResponses =>
      _currentHouseholdResponses;

  Future<void> loadAllLookups() async {
    await getAllQuestions();
    await getAllQuestionChoices();
    await getAllHouseholdResponses();
  }

  // ------------ Questions ------------

  getAllQuestions() async {
    _allQuestions = await _lookupRepository.allQuestions();
    _currentQuestions = _allQuestions;
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

  // ------------ Question Choices ------------

  getAllQuestionChoices() async {
    _allQuestionChoices = await _lookupRepository.allQuestionChoices();
    _currentQuestionChoices = _allQuestionChoices;
    notifyListeners();
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

  // ------------ Household Responses ------------

  getAllHouseholdResponses() async {
    _allHouseholdResponses = await _lookupRepository.allHouseholdResponses();
    _currentHouseholdResponses = _allHouseholdResponses;
    notifyListeners();
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
