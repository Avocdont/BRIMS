import 'package:drift/drift.dart';

@DataClassName('QuestionData')
class Questions extends Table {
  IntColumn get question_id => integer().autoIncrement()();
  TextColumn get question => text()();
}

@DataClassName('QustionChoiceData')
class QuestionChoices extends Table {
  IntColumn get choice_id => integer().autoIncrement()();
  TextColumn get choice => text()();
  IntColumn get question_id =>
      integer().references(
        Questions,
        #question_id,
        onDelete: KeyAction.restrict,
      )();
}

@DataClassName('HouseholdResponseData')
class HouseholdResponses extends Table {
  IntColumn get response_id => integer().autoIncrement()();
  IntColumn get choice_id =>
      integer().references(
        QuestionChoices,
        #choice_id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get question_id =>
      integer().references(
        Questions,
        #question_id,
        onDelete: KeyAction.restrict,
      )();
}
