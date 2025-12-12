import 'package:brims/database/app_db.dart';
import 'package:brims/database/tables/extensions.dart'; // Ensure .label extension is imported
import 'package:brims/provider/profiling%20providers/person_provider.dart';
import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:brims/screens/edit_person_page.dart';
import 'package:brims/screens/view_household_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/tables/enums.dart';

class ViewPersonDetailsPage extends StatefulWidget {
  final int personId;

  const ViewPersonDetailsPage({super.key, required this.personId});

  @override
  State<ViewPersonDetailsPage> createState() => _ViewPersonDetailsPageState();
}

class _ViewPersonDetailsPageState extends State<ViewPersonDetailsPage> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background (for Scaffold)
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color navBackground = Color(0xFF40C4FF);
  static const Color navBackgroundDark = Color(0xFF29B6F6); // Accent color
  static const Color actionGreen = Color(0xFF00C853);
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
  static const Color secondaryText = Color(0xFF555555); // Secondary text/border
  static const Color dividerColor = Color(0xFFE0E0E0); // Light divider

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final personProvider = context.read<PersonProvider>();
    final lookupProvider = context.read<ProfileLookupProvider>();

    // Load lookups for ID resolution
    await lookupProvider.loadAllLookups();
    // Load person data
    await personProvider.loadPersonDetails(widget.personId);

    if (mounted) setState(() => _isLoading = false);
  }

  // --- Helpers ---
  String _formatEnum(Object? enumValue) {
    if (enumValue == null) return "N/A";
    String raw = enumValue.toString().split('.').last;
    return raw.split('_').map((word) {
      if (word.isEmpty) return "";
      return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
    }).join(' ');
  }

  // Helper for Boolean: Returns N/A if null, Yes/No otherwise
  String _formatBool(bool? value) {
    if (value == null) return "N/A";
    return value ? "Yes" : "No";
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  String _getLookupName(List<dynamic> list, int? id,
      String Function(dynamic) nameGetter, int Function(dynamic) idGetter) {
    if (id == null) return "N/A";
    final item = list.where((e) => idGetter(e) == id).firstOrNull;
    return item != null ? nameGetter(item) : "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = context.watch<PersonProvider>();
    final lookupProvider = context.watch<ProfileLookupProvider>();
    final data = personProvider.selectedPersonDetails;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: primaryBackground,
        body:
            Center(child: CircularProgressIndicator(color: navBackgroundDark)),
      );
    }

    if (data.isEmpty || data['person'] == null) {
      return Scaffold(
        backgroundColor: primaryBackground,
        appBar: AppBar(
            title:
                Text("Error", style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: navBackgroundDark,
            foregroundColor: Colors.white),
        body: Center(
            child: Text("Person not found.",
                style: GoogleFonts.poppins(color: primaryText))),
      );
    }

    // --- 1. EXTRACT DATA OBJECTS ---
    final PersonData person = data['person'];
    final AddressData? address = data['address'];
    final OccupationData? occupation = data['occupation'];
    final EmailData? email = data['email'];
    final PhoneNumberData? phone = data['phone'];
    final HouseholdMemberData? householdMember = data['householdMember'];
    final DisabilityData? disability = data['disability'];
    final VoterRegistryData? voter = data['voter'];
    final EnrolledData? enrolled = data['enrolled'];
    final CTCRecordData? ctc = data['ctc'];

    // Singular Data Class for Registered Senior
    final RegisteredSeniorData? senior = data['senior'];

    // Gadgets List (Singular GadgetData)
    final List<GadgetData> gadgets = data['gadgets'] != null
        ? (data['gadgets'] as List<dynamic>).cast<GadgetData>()
        : [];

    // --- 2. RESOLVE LOOKUPS ---
    final String nationality = _getLookupName(lookupProvider.allNationalities,
        person.nationality_id, (i) => i.name, (i) => i.nationality_id);
    final String religion = _getLookupName(lookupProvider.allReligions,
        person.religion_id, (i) => i.name, (i) => i.religion_id);
    final String ethnicity = _getLookupName(lookupProvider.allEthnicities,
        person.ethnicity_id, (i) => i.name, (i) => i.ethnicity_id);
    final String education = _getLookupName(lookupProvider.allEducation,
        person.education_id, (i) => i.level, (i) => i.education_id);
    final String bloodType = _getLookupName(lookupProvider.allBloodTypes,
        person.blood_type_id, (i) => i.type, (i) => i.blood_type_id);
    final String monthlyIncome = _getLookupName(
        lookupProvider.allMonthlyIncomes,
        person.monthly_income_id,
        (i) => i.range,
        (i) => i.monthly_income_id);
    final String dailyIncome = _getLookupName(lookupProvider.allDailyIncomes,
        person.daily_income_id, (i) => i.range, (i) => i.daily_income_id);

    // --- FIX: Safely map gadgets handling null .gadget property ---
    String gadgetsList = gadgets.isEmpty
        ? "None"
        // We use ?.label because 'gadget' enum field might be nullable in DB definition
        : gadgets.map((g) => g.gadget?.label ?? "Unknown").join(", ");

    // --- 3. SENIOR CITIZEN LOGIC (N/A if Age Unknown) ---
    String seniorStatus = "N/A";
    if (person.age != null) {
      seniorStatus = person.age! >= 60 ? "Yes" : "No";
    }

    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        title: Text("Person Profile",
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
                        radius: 40,
                        backgroundColor: navBackgroundDark,
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${person.first_name} ${person.last_name}",
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryText),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${person.middle_name ?? ''} ${person.suffix ?? ''}",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: secondaryText),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: navBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: navBackgroundDark.withOpacity(0.5)),
                        ),
                        child: Text(
                          _formatEnum(person.registration_status),
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

                // --- CARD 1: PERSONAL & RESIDENCY ---
                _buildCard(
                  title: "Personal & Residency",
                  children: [
                    _buildRowPair("Age", "${person.age ?? 'N/A'}", "Sex",
                        _formatEnum(person.sex)),
                    const SizedBox(height: 12),
                    _buildRowPair("Birth Date", _formatDate(person.birth_date),
                        "Birth Place", person.birth_place),
                    const SizedBox(height: 12),
                    _buildRowPair("Civil Status",
                        _formatEnum(person.civil_status), "Religion", religion),
                    const SizedBox(height: 12),
                    _buildRowPair(
                        "Nationality", nationality, "Ethnicity", ethnicity),
                    const SizedBox(height: 12),
                    _buildInfoRow("Blood Type", bloodType),
                    const Divider(color: dividerColor, height: 32),

                    // Residency Fields
                    _buildRowPair(
                        "Residency Status",
                        _formatEnum(person.residency),
                        "Years of Residency",
                        person.years_of_residency?.toString()),
                    Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildInfoRow("Transient Type",
                            _formatEnum(person.transient_type))),
                    if (person.registration_place != null)
                      _buildInfoRow(
                          "Place of Registration", person.registration_place!),
                  ],
                ),

                const SizedBox(height: 24),

                // --- CARD 2: CONTACT & ADDRESS ---
                _buildCard(
                  title: "Contact & Address",
                  children: [
                    _buildInfoRow(
                        "Address",
                        address != null
                            ? "Blk ${address.block ?? ''} Lot ${address.lot ?? ''}, ${address.street ?? ''}, ${address.zone ?? ''}"
                            : "N/A"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 140,
                              child: Text("Household:",
                                  style: GoogleFonts.poppins(
                                      color: secondaryText, fontSize: 14))),
                          // Clickable Household Link
                          Expanded(
                            child: householdMember != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ViewHouseholdPage(
                                                householdId: householdMember
                                                    .household_id)),
                                      );
                                    },
                                    child: Text(
                                        "Household #${householdMember.household_id} (View)",
                                        style: GoogleFonts.poppins(
                                            color: navBackgroundDark,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : Text("Not assigned",
                                    style: GoogleFonts.poppins(
                                        color: primaryText, fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRowPair("Phone", phone?.phone_num.toString(), "Email",
                        email?.email_address),
                    const SizedBox(height: 12),
                    _buildInfoRow("Owned Gadgets", gadgetsList),
                  ],
                ),

                const SizedBox(height: 24),

                // --- CARD 3: SOCIO-ECONOMIC ---
                _buildCard(
                  title: "Socio-Economic & Education",
                  children: [
                    _buildInfoRow(
                        "Occupation", occupation?.occupation ?? "Unemployed"),
                    if (occupation != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 140),
                        child: Text(
                          "${_formatEnum(occupation.occupation_status)} (${_formatEnum(occupation.occupation_type)})",
                          style: GoogleFonts.poppins(
                              color: secondaryText, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _buildRowPair("Monthly Income", monthlyIncome,
                        "Daily Income", dailyIncome),
                    const Divider(color: dividerColor, height: 32),

                    _buildInfoRow("Highest Education", education),
                    _buildInfoRow("Currently Enrolled",
                        _formatEnum(person.currently_enrolled)),
                    if (enrolled != null)
                      _buildInfoRow("School", enrolled.school),

                    const SizedBox(height: 12),
                    _buildRowPair("Literate", _formatBool(person.literate),
                        "OFW", _formatBool(person.ofw)),

                    // --- SENIOR LOGIC ---
                    _buildRowPair(
                        "Solo Parent",
                        _formatEnum(person.solo_parent),
                        "Senior Citizen",
                        seniorStatus),

                    // Show "Registered Senior" ONLY if qualified (60+)
                    if (person.age != null && person.age! >= 60)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildInfoRow(
                            "Registered Senior", senior != null ? "Yes" : "No"),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- CARD 4: LEGAL & MEDICAL ---
                _buildCard(
                  title: "Legal & Medical Registries",
                  children: [
                    _buildInfoRow("Registered Voter",
                        _formatBool(person.registered_voter)),
                    if (voter != null)
                      _buildInfoRow(
                          "Polling Place", voter.place_of_vote_registry),
                    const SizedBox(height: 12),
                    if (ctc != null) ...[
                      _buildSectionHeader("Community Tax Certificate (CTC)"),
                      _buildRowPair("CTC No.", ctc.issue_num.toString(), "Date",
                          _formatDate(ctc.date_of_issue)),
                      _buildInfoRow(
                          "Place Issued", ctc.place_of_issue ?? "N/A"),
                      const SizedBox(height: 16),
                    ],
                    _buildInfoRow("PWD Status", _formatBool(person.pwd)),
                    if (disability != null) ...[
                      _buildInfoRow("Disability Name", disability.name),
                      _buildInfoRow("Type", disability.type ?? "N/A"),
                    ],
                    const SizedBox(height: 12),
                    _buildInfoRow("Deceased", _formatBool(person.deceased)),
                    if (person.deceased == true)
                      _buildInfoRow(
                          "Date of Death", _formatDate(person.death_date)),
                  ],
                ),

                const SizedBox(height: 40),

                // --- ACTION BUTTONS ---
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
                              title: Text("Delete Person?",
                                  style: GoogleFonts.poppins(
                                      color: primaryText,
                                      fontWeight: FontWeight.bold)),
                              content: Text(
                                  "This action cannot be undone. They will be removed from any associated household.",
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
                            await personProvider.deletePerson(widget.personId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Person deleted successfully")));
                              Navigator.pop(context);
                            }
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPersonPage(personId: widget.personId),
                            ),
                          ).then((_) {
                            _refreshData(); // Refresh details on return
                          });
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- SHARED WIDGETS ---
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground, // White card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title.toUpperCase(),
            style: GoogleFonts.poppins(
                color: navBackgroundDark, // Accent color for titles
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1)),
        const Divider(color: dividerColor, height: 24),
        ...children,
      ]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: GoogleFonts.poppins(
              color: navBackground, // Primary blue for sub-headers
              fontWeight: FontWeight.w600,
              fontSize: 13)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 140,
            child: Text("$label:",
                style: GoogleFonts.poppins(
                    color: secondaryText,
                    fontSize: 14))), // Secondary text for label
        Expanded(
            child: Text(value.isEmpty ? "N/A" : value,
                style: GoogleFonts.poppins(
                    color: primaryText, // Primary text for value
                    fontWeight: FontWeight.w500,
                    fontSize: 14))),
      ]),
    );
  }

  Widget _buildRowPair(
      String label1, String? value1, String label2, String? value2) {
    return Row(children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label1,
            style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 12)), // Secondary text for label
        const SizedBox(height: 2),
        Text(value1 ?? "N/A",
            style: GoogleFonts.poppins(
                color: primaryText, // Primary text for value
                fontWeight: FontWeight.w500,
                fontSize: 14)),
      ])),
      const SizedBox(width: 16),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label2,
            style: GoogleFonts.poppins(
                color: secondaryText,
                fontSize: 12)), // Secondary text for label
        const SizedBox(height: 2),
        Text(value2 ?? "N/A",
            style: GoogleFonts.poppins(
                color: primaryText, // Primary text for value
                fontWeight: FontWeight.w500,
                fontSize: 14)),
      ])),
    ]);
  }
}
