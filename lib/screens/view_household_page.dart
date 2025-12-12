import 'package:brims/database/app_db.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/lookup%20providers/question_lookup_provider.dart';
import 'package:brims/screens/edit_household_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/tables/enums.dart';

class ViewHouseholdPage extends StatefulWidget {
  final int householdId;

  const ViewHouseholdPage({super.key, required this.householdId});

  @override
  State<ViewHouseholdPage> createState() => _ViewHouseholdPageState();
}

class _ViewHouseholdPageState extends State<ViewHouseholdPage> {
  // Map to store QuestionID -> Answer Text for display
  final Map<int, String> _utilityDisplay = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = context.read<HouseholdProvider>();
    final qProvider = context.read<QuestionLookupProvider>();

    // FIXED: Added <void> to Future.wait to fix the type error
    await Future.wait<void>([
      provider.getAllHouseholds(),
      provider.getAllAddresses(),
      provider.getAllServices(),
      provider.getAllPrimaryNeeds(),
      provider.getAllFemaleMortalities(),
      provider.getAllChildMortalities(),
      provider.getAllFutureResidencies(),
      provider.getAllHouseholdVisits(),
      qProvider.getAllQuestions(),
      qProvider.getAllQuestionChoices(),
    ]);

    // Fetch Utilities Answers for this household
    final answers = await qProvider.getHouseholdResponses(widget.householdId);

    // Process answers into a display map
    for (var ans in answers) {
      // Find the choice text based on choice_id
      try {
        final choice = qProvider.allQuestionChoices
            .firstWhere((c) => c.choice_id == ans.choice_id);
        _utilityDisplay[ans.question_id] = choice.choice;
      } catch (e) {
        // Choice ID not found
      }
    }

    // Trigger rebuild to show answers
    if (mounted) setState(() {});
  }

  String _formatEnum(Object? enumValue) {
    if (enumValue == null) return "N/A";
    String raw = enumValue.toString().split('.').last;
    return raw.split('_').map((word) {
      if (word.isEmpty) return "";
      return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
    }).join(' ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final householdProvider = context.watch<HouseholdProvider>();
    final lookupProvider = context.watch<HouseholdLookupProvider>();
    final questionProvider = context.watch<QuestionLookupProvider>();

    // 1. Fetch Household (Safe)
    HouseholdData? household;
    try {
      household = householdProvider.allHouseholds
          .where((h) => h.household_id == widget.householdId)
          .firstOrNull;
    } catch (e) {
      household = null;
    }

    if (household == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF18181B),
        appBar: AppBar(
            title: const Text("Error"),
            backgroundColor: const Color(0xFF18181B)),
        body: const Center(
            child: Text("Household not found.",
                style: TextStyle(color: Colors.white))),
      );
    }

    // 2. Fetch Related Data
    final address = household.address_id != null
        ? householdProvider.allAddresses
            .where((a) => a.address_id == household!.address_id)
            .firstOrNull
        : null;

    final service = householdProvider.allServices
        .where((s) => s.household_id == widget.householdId)
        .firstOrNull;

    final needs = householdProvider.allPrimaryNeeds
        .where((n) => n.household_id == widget.householdId)
        .toList();
    needs.sort((a, b) => (a.priority ?? 99).compareTo(b.priority ?? 99));

    final femaleMortality = householdProvider.allFemaleMortalities
        .where((f) => f.household_id == widget.householdId)
        .firstOrNull;
    final childMortality = householdProvider.allChildMortalities
        .where((c) => c.household_id == widget.householdId)
        .firstOrNull;
    final futureResidency = householdProvider.allFutureResidencies
        .where((f) => f.household_id == widget.householdId)
        .firstOrNull;

    final buildingType = household.building_type_id != null
        ? lookupProvider.allBuildingTypes
            .where((b) => b.building_type_id == household!.building_type_id)
            .firstOrNull
            ?.type
        : "N/A";

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        title: const Text("Household Details"),
        centerTitle: true,
        backgroundColor: const Color(0xFF18181B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white10,
                        child:
                            Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        household.head ?? "Unknown Head",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                        child: Text(
                          _formatEnum(household.registration_status),
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // CARD 1: ADDRESS & DETAILS
                _buildCard(
                  title: "Address & Classification",
                  children: [
                    _buildRowPair(
                        "Zone", address?.zone, "Street", address?.street),
                    const SizedBox(height: 12),
                    _buildRowPair("Block", address?.block, "Lot", address?.lot),
                    const Divider(color: Colors.white24, height: 32),
                    _buildInfoRow("Household Type",
                        _formatEnum(household.household_type_id)),
                    _buildInfoRow("Building Type", buildingType ?? "N/A"),
                    _buildInfoRow("Ownership Type",
                        _formatEnum(household.ownership_type_id)),
                    _buildInfoRow("Members Count",
                        household.household_members_num?.toString() ?? "0"),
                  ],
                ),

                const SizedBox(height: 24),

                // CARD: UTILITIES (Dynamic)
                if (questionProvider.allQuestions.isNotEmpty) ...[
                  _buildCard(
                    title: "Utilities",
                    children: [
                      ...questionProvider.allQuestions.map((q) {
                        String answer = _utilityDisplay[q.question_id] ?? "N/A";
                        return _buildInfoRow(q.question, answer);
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // CARD 2: COMMUNITY
                _buildCard(
                  title: "Community",
                  children: [
                    _buildSectionHeader("Mortality (Last 6 Months)"),
                    _buildInfoRow("Female Mortality",
                        household.female_mortality == true ? "Yes" : "No"),
                    if (household.female_mortality == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Age: ${femaleMortality?.age ?? 'N/A'}",
                                  style:
                                      const TextStyle(color: Colors.white54)),
                              Text(
                                  "Cause: ${femaleMortality?.death_cause ?? 'N/A'}",
                                  style:
                                      const TextStyle(color: Colors.white54)),
                            ]),
                      ),
                    _buildInfoRow("Child Mortality (<=5)",
                        household.child_mortality == true ? "Yes" : "No"),
                    if (household.child_mortality == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Age: ${childMortality?.age ?? 'N/A'}",
                                  style:
                                      const TextStyle(color: Colors.white54)),
                              Text("Sex: ${_formatEnum(childMortality?.sex)}",
                                  style:
                                      const TextStyle(color: Colors.white54)),
                              Text(
                                  "Cause: ${childMortality?.death_cause ?? 'N/A'}",
                                  style:
                                      const TextStyle(color: Colors.white54)),
                            ]),
                      ),
                    const SizedBox(height: 16),
                    _buildSectionHeader("Primary Needs"),
                    _buildInfoRow(
                        "Priority 1", needs.length > 0 ? needs[0].need : "N/A"),
                    _buildInfoRow(
                        "Priority 2", needs.length > 1 ? needs[1].need : "N/A"),
                    _buildInfoRow(
                        "Priority 3", needs.length > 2 ? needs[2].need : "N/A"),
                    const SizedBox(height: 16),
                    _buildSectionHeader("Future Residency (5 Years)"),
                    _buildInfoRow("Intended Barangay",
                        futureResidency?.barangay ?? "N/A"),
                    _buildInfoRow("Intended Municipality",
                        futureResidency?.municipality ?? "N/A"),
                  ],
                ),

                const SizedBox(height: 24),

                // CARD 3: SURVEY INFO
                _buildCard(
                  title: "Survey Info",
                  children: [
                    _buildRowPair(
                      "No. of Visits",
                      service?.ave_client_num?.toString() ?? "N/A",
                      "Client Type",
                      _formatEnum(service?.client_type_id),
                    ),
                    const SizedBox(height: 12),
                    _buildSectionHeader("Registration"),
                    _buildInfoRow(
                        "Status", _formatEnum(household.registration_status)),
                    _buildInfoRow(
                        "Date", _formatDate(household.registration_date)),
                  ],
                ),

                // ACTION BUTTONS
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete Household?"),
                              content:
                                  const Text("This action cannot be undone."),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Delete",
                                        style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await householdProvider
                                .deleteHousehold(widget.householdId);
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Delete"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditHouseholdPage(
                                    householdId: widget.householdId)),
                          ).then((_) {
                            // Refresh data on return
                            householdProvider.getAllHouseholds();
                            // Re-fetch local data to update view immediately if you stay on page,
                            // though usually this pops back to list. If you want live update here:
                            _loadData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1)),
          const Divider(color: Colors.white24, height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w600,
            fontSize: 14),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text("$label:",
                style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "N/A" : value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowPair(
      String label1, String? value1, String label2, String? value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              const SizedBox(height: 2),
              Text(value1 ?? "N/A",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              const SizedBox(height: 2),
              Text(value2 ?? "N/A",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
