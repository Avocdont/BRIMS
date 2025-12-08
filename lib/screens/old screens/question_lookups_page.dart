import 'package:brims/database/app_db.dart';
import 'package:brims/provider/lookup%20providers/question_lookup_provider.dart';
import 'package:brims/screens/components/add_lookup.dart';
import 'package:brims/screens/components/lookup_table.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as scn;

class QuestionLookups extends StatefulWidget {
  const QuestionLookups({super.key});

  @override
  State<QuestionLookups> createState() => _QuestionLookupsState();
}

class _QuestionLookupsState extends State<QuestionLookups> {
  @override
  void initState() {
    super.initState();

    // Load all lookup data when the screen opens
    final lookupProvider = context.read<QuestionLookupProvider>();
    lookupProvider.loadAllLookups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<QuestionLookupProvider>(
        builder: (_, lookupProvider, __) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // ------------ Questions ------------
                Text("Questions").h4,
                LookupTable<QuestionData>(
                  columns: ["Question"],
                  items: lookupProvider.allQuestions,
                  buildRow: (item) => [item.question],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      question: db.Value(newValues[0]),
                    );
                    lookupProvider.updateQuestion(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteQuestion(item.question_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Question'],
                            onInsert: (values) async {
                              final companion = QuestionsCompanion(
                                question: db.Value(values[0]),
                              );
                              await lookupProvider.addQuestion(companion);
                              setState(() {}); // refresh table
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 15),

                // ------------ Question Choices ------------
                Text("Question Choices").h4,
                LookupTable<QuestionChoiceData>(
                  columns: ["Choice", "Question ID"],
                  items: lookupProvider.allQuestionChoices,
                  buildRow:
                      (item) => [item.choice, item.question_id.toString()],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      choice: db.Value(newValues[0]),
                      question_id: db.Value(int.tryParse(newValues[1]) ?? 0),
                    );
                    lookupProvider.updateQuestionChoice(updated);
                  },
                  onDelete:
                      (item) =>
                          lookupProvider.deleteQuestionChoice(item.choice_id),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Choice', 'Question ID'],
                            onInsert: (values) async {
                              final companion = QuestionChoicesCompanion(
                                choice: db.Value(values[0]),
                                question_id: db.Value(
                                  int.tryParse(values[1]) ?? 0,
                                ),
                              );
                              await lookupProvider.addQuestionChoice(companion);
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
                SizedBox(height: 15),

                // ------------ Household Responses ------------
                Text("Household Responses").h4,
                LookupTable<HouseholdResponseData>(
                  columns: ["Choice ID", "Question ID"],
                  items: lookupProvider.allHouseholdResponses,
                  buildRow:
                      (item) => [
                        item.choice_id.toString(),
                        item.question_id.toString(),
                      ],
                  onEdit: (item, newValues) {
                    final companion = item.toCompanion(true);
                    final updated = companion.copyWith(
                      choice_id: db.Value(int.tryParse(newValues[0]) ?? 0),
                      question_id: db.Value(int.tryParse(newValues[1]) ?? 0),
                    );
                    lookupProvider.updateHouseholdResponse(updated);
                  },
                  onDelete:
                      (item) => lookupProvider.deleteHouseholdResponse(
                        item.response_id,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddLookup(
                            columns: ['Choice ID', 'Question ID'],
                            onInsert: (values) async {
                              final companion = HouseholdResponsesCompanion(
                                choice_id: db.Value(
                                  int.tryParse(values[0]) ?? 0,
                                ),
                                question_id: db.Value(
                                  int.tryParse(values[1]) ?? 0,
                                ),
                              );
                              await lookupProvider.addHouseholdResponse(
                                companion,
                              );
                              setState(() {});
                            },
                          ),
                    );
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
