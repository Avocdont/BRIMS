import 'package:brims/screens/old%20screens/farming_lookups_page.dart';
import 'package:brims/screens/old%20screens/household_lookups_page.dart';
import 'package:brims/screens/old%20screens/medinfo_lookups_page.dart';
import 'package:brims/screens/old%20screens/profile_lookups_page.dart';
import 'package:brims/screens/old%20screens/question_lookups_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:brims/provider/profiling%20providers/profile_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/medical%20providers/medinfo_lookup_provider.dart';
import 'package:brims/provider/lookup%20providers/farming_lookup_provider.dart';
import 'package:brims/provider/lookup%20providers/question_lookup_provider.dart';

class LookupsPage extends StatefulWidget {
  const LookupsPage({super.key});

  @override
  State<LookupsPage> createState() => _LookupsPageState();
}

class _LookupsPageState extends State<LookupsPage> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background (for Scaffold)
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards/dropdown
  static const Color navBackground = Color(0xFF40C4FF); // Primary blue
  static const Color navBackgroundDark =
      Color(0xFF29B6F6); // Darker accent/button
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black for content
  static const Color secondaryText = Color(0xFF555555); // Secondary text
  static const Color dividerColor = Color(0xFFE0E0E0); // Light divider

  // Style for the main ExpansionTile title
  final TextStyle _tileTitleStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.bold, fontSize: 16, color: navBackgroundDark);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileLookupProvider()),
        ChangeNotifierProvider(create: (_) => HouseholdLookupProvider()),
        ChangeNotifierProvider(create: (_) => MedInfoLookupProvider()),
        ChangeNotifierProvider(create: (_) => FarmingLookupProvider()),
        ChangeNotifierProvider(create: (_) => QuestionLookupProvider()),
      ],
      child: Scaffold(
        backgroundColor: primaryBackground,
        appBar: AppBar(
          title: Text("Lookups",
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
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLookupBox("Profile Lookups", const ProfileLookups()),
            _buildLookupBox("Household Lookups", const HouseholdLookups()),
            _buildLookupBox("Medical Info Lookups", const MedInfoLookups()),
            _buildLookupBox("Farming Lookups", const FarmingLookups()),
            _buildLookupBox("Question Lookups", const QuestionLookups()),
          ],
        ),
      ),
    );
  }

  Widget _buildLookupBox(String title, Widget child) {
    return Center(
      child: Container(
        width: 400,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBackground, // White card background
          border: Border.all(color: dividerColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ExpansionTile(
          // Text color should be dark (primaryText), title should be accent (navBackgroundDark)
          title: Text(title, style: _tileTitleStyle),
          iconColor: navBackgroundDark,
          collapsedIconColor: secondaryText,
          // Set tile color to white (cardBackground)
          backgroundColor: cardBackground,
          collapsedBackgroundColor: cardBackground,

          children: [
            // Use a Divider to separate the header from the content
            const Divider(height: 1, thickness: 1, color: dividerColor),
            // The content child area
            SizedBox(
              // The height constraint ensures content fits nicely; adjust as needed
              height: 350,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: child,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
