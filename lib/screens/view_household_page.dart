import 'package:brims/database/app_db.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:brims/provider/lookup%20providers/question_lookup_provider.dart';
import 'package:brims/screens/edit_household_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for consistent typography
import '../database/tables/enums.dart';

class ViewHouseholdPage extends StatefulWidget {
  final int householdId;

  const ViewHouseholdPage({super.key, required this.householdId});

  @override
  State<ViewHouseholdPage> createState() => _ViewHouseholdPageState();
}

class _ViewHouseholdPageState extends State<ViewHouseholdPage> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color navBackground = Color(0xFF40C4FF);
  static const Color navBackgroundDark = Color(0xFF29B6F6); // Accent color
  static const Color actionGreen = Color(0xFF00C853);
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
  static const Color secondaryText = Color(0xFF555555); // Secondary text/border
  static const Color dividerColor = Color(0xFFE0E0E0); // Light divider

  final Map<int, String> _utilityDisplay = {};

  // List to store formatted member data
  List<Map<String, dynamic>> _householdMembers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final hProvider = context.read<HouseholdProvider>();
    final pProvider = context.read<PersonProvider>();
    final qProvider = context.read<QuestionLookupProvider>();
    final lProvider = context.read<HouseholdLookupProvider>();

    // 1. FETCH ALL DATA
    await Future.wait<void>([
      hProvider.getAllHouseholds(),
      hProvider.getAllAddresses(),
      hProvider.getAllServices(),
      hProvider.getAllPrimaryNeeds(),
      hProvider.getAllFemaleMortalities(),
      hProvider.getAllChildMortalities(),
      hProvider.getAllFutureResidencies(),
      hProvider.getAllHouseholdVisits(),
      hProvider.getAllHouseholdMembers(),
      pProvider.getAllPersons(),
      lProvider.getAllBuildingTypes(),
      qProvider.getAllQuestions(),
      qProvider.getAllQuestionChoices(),
    ]);

    // 2. PROCESS UTILITIES
    final answers = await qProvider.getHouseholdResponses(widget.householdId);
    _utilityDisplay.clear();
    for (var ans in answers) {
      try {
        final choice = qProvider.allQuestionChoices
            .firstWhere((c) => c.choice_id == ans.choice_id);
        _utilityDisplay[ans.question_id] = choice.choice;
      } catch (e) {}
    }

    // 3. PROCESS MEMBERS
    _householdMembers.clear();

    // Get current household to find the Head's name
    final currentHousehold = hProvider.allHouseholds
        .where((h) => h.household_id == widget.householdId)
        .firstOrNull;

    if (currentHousehold != null) {
      // A. Add Head of Household
      if (currentHousehold.head != null) {
        _householdMembers.add({
          'name': currentHousehold.head,
          'role': "Head of Household",
          'isHead': true,
        });
      }

      // B. Add Other Members
      final links = hProvider.allHouseholdMembers
          .where((m) => m.household_id == widget.householdId)
          .toList();

      for (var link in links) {
        try {
          final person = pProvider.allPersons
              .firstWhere((p) => p.person_id == link.person_id);

          String fullName = "${person.first_name} ${person.last_name}";

          // Only add if name doesn't match Head (to avoid duplication if Head is also linked in members table)
          if (fullName != currentHousehold.head) {
            _householdMembers.add({
              'name': fullName,
              'role':
                  "Household Member", // Default role since relationship table isn't fully utilized yet
              'isHead': false,
            });
          }
        } catch (e) {}
      }
    }

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

    // 1. Fetch Main Household
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
        backgroundColor: primaryBackground,
        appBar: AppBar(
            title:
                Text("Error", style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: navBackgroundDark,
            foregroundColor: Colors.white),
        body: Center(
            child: Text("Household not found.",
                style: GoogleFonts.poppins(color: primaryText))),
      );
    }

    // 2. Fetch Related Records
    final address = household.address_id != null
        ? householdProvider.allAddresses
            .where((a) => a.address_id == household!.address_id)
            .firstOrNull
        : null;

    final service = householdProvider.allServices
        .where((s) => s.household_id == widget.householdId)
        .firstOrNull;

    final visit = householdProvider.allHouseholdVisits
        .where((v) => v.household_id == widget.householdId)
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
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Text("Household Details",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [navBackground, navBackgroundDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: navBackgroundDark, // Blue Circle
                        child: const Icon(Icons.group,
                            size: 30, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        household.head ?? "Unknown Head",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryText),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: navBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: navBackgroundDark.withOpacity(0.5)),
                        ),
                        child: Text(
                          _formatEnum(household.registration_status),
                          style: GoogleFonts.poppins(
                              color: navBackgroundDark,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // --- CARD 1: HOUSEHOLD MEMBERS ---
                _buildCard(
                  title: "Household Members",
                  children: [
                    if (_householdMembers.isEmpty)
                      Text("No members found.",
                          style: GoogleFonts.poppins(color: secondaryText))
                    else
                      ..._householdMembers.map((m) {
                        bool isHead = m['isHead'] == true;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(isHead ? Icons.star : Icons.person_outline,
                                  size: 18,
                                  color: isHead ? Colors.amber : secondaryText),
                              const SizedBox(width: 12),
                              Text(m['name'],
                                  style: GoogleFonts.poppins(
                                      color: primaryText,
                                      fontWeight: isHead
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 15)),
                              const Spacer(),
                              Text(m['role'],
                                  style: GoogleFonts.poppins(
                                      color: isHead
                                          ? Colors.amber.shade700
                                          : secondaryText,
                                      fontSize: 12,
                                      fontWeight: isHead
                                          ? FontWeight.w600
                                          : FontWeight.normal)),
                            ],
                          ),
                        );
                      }),
                  ],
                ),

                const SizedBox(height: 24),

                // --- CARD 2: ADDRESS & CLASSIFICATION ---
                _buildCard(
                  title: "Address & Classification",
                  children: [
                    _buildRowPair(
                        "Zone", address?.zone, "Street", address?.street),
                    const SizedBox(height: 12),
                    _buildRowPair("Block", address?.block, "Lot", address?.lot),
                    const Divider(color: dividerColor, height: 32),
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

                // --- CARD 3: UTILITIES ---
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

                // --- CARD 4: COMMUNITY ---
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
                                  style: GoogleFonts.poppins(
                                      color: secondaryText, fontSize: 14)),
                              Text(
                                  "Cause: ${femaleMortality?.death_cause ?? 'N/A'}",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText, fontSize: 14)),
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
                                  style: GoogleFonts.poppins(
                                      color: secondaryText, fontSize: 14)),
                              Text("Sex: ${_formatEnum(childMortality?.sex)}",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText, fontSize: 14)),
                              Text(
                                  "Cause: ${childMortality?.death_cause ?? 'N/A'}",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText, fontSize: 14)),
                            ]),
                      ),
                    const Divider(color: dividerColor, height: 32),
                    _buildSectionHeader("Primary Needs"),
                    _buildInfoRow(
                        "Priority 1", needs.isNotEmpty ? needs[0].need : "N/A"),
                    _buildInfoRow(
                        "Priority 2", needs.length > 1 ? needs[1].need : "N/A"),
                    _buildInfoRow(
                        "Priority 3", needs.length > 2 ? needs[2].need : "N/A"),
                    const Divider(color: dividerColor, height: 32),
                    _buildSectionHeader("Future Residency (5 Years)"),
                    _buildInfoRow("Intended Barangay",
                        futureResidency?.barangay ?? "N/A"),
                    _buildInfoRow("Intended Municipality",
                        futureResidency?.municipality ?? "N/A"),
                  ],
                ),

                const SizedBox(height: 24),

                // --- CARD 5: SURVEY INFO ---
                _buildCard(
                  title: "Survey Info",
                  children: [
                    _buildRowPair(
                      "No. of Visits",
                      service?.ave_client_num?.toString() ??
                          visit?.visit_num?.toString() ??
                          "N/A",
                      "Client Type",
                      _formatEnum(service?.client_type_id),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        "Barangay Position", _formatEnum(visit?.brgy_position)),
                    const Divider(color: dividerColor, height: 32),
                    _buildSectionHeader("Registration"),
                    _buildInfoRow(
                        "Status", _formatEnum(household.registration_status)),
                    _buildInfoRow(
                        "Date", _formatDate(household.registration_date)),
                  ],
                ),

                // --- ACTION BUTTONS ---
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // DELETE Confirmation Dialog (Styled)
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: cardBackground,
                              title: Text("Delete Household?",
                                  style: GoogleFonts.poppins(
                                      color: primaryText,
                                      fontWeight: FontWeight.bold)),
                              content: Text("This action cannot be undone.",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText)),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text("Cancel",
                                        style: GoogleFonts.poppins(
                                            color: navBackgroundDark))),
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        foregroundColor: Colors.white),
                                    child: Text("Delete",
                                        style: GoogleFonts.poppins())),
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
                          foregroundColor: Colors.red.shade600,
                          side: BorderSide(color: Colors.red.shade600),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: Text("Delete",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditHouseholdPage(
                                  householdId: widget.householdId),
                            ),
                          );
                          if (mounted) await _loadData(); // REFRESH ON RETURN
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navBackgroundDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.edit),
                        label: Text("Edit",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
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

  // --- HELPERS ---
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: GoogleFonts.poppins(
                  color: navBackgroundDark, // Use accent color for titles
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1)),
          const Divider(color: dividerColor, height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(title,
          style: GoogleFonts.poppins(
              color: navBackground, // Use primary blue for sub-headers
              fontWeight: FontWeight.w600,
              fontSize: 14)),
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
                  style:
                      GoogleFonts.poppins(color: secondaryText, fontSize: 14))),
          Expanded(
              child: Text(value.isEmpty ? "N/A" : value,
                  style: GoogleFonts.poppins(
                      color: primaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildRowPair(
      String label1, String? value1, String label2, String? value2) {
    return Row(
      children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label1,
                style: GoogleFonts.poppins(color: secondaryText, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value1 ?? "N/A",
                style: GoogleFonts.poppins(
                    color: primaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label2,
                style: GoogleFonts.poppins(color: secondaryText, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value2 ?? "N/A",
                style: GoogleFonts.poppins(
                    color: primaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
          ]),
        ),
      ],
    );
  }
}
