import 'package:brims/screens/add_address_page.dart';
import 'package:brims/screens/add_household_page.dart';
import 'package:brims/screens/add_person_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background (Scaffold background)
  static const Color cardBackground =
      Color(0xFFFFFFFF); // White cards (Card containers/Input background)
  static const Color navBackground =
      Color(0xFF40C4FF); // Sky Blue (Lighter - Search Icon/Active Accent)
  static const Color selectedAccent =
      Color(0xFF0288D1); // Deep Blue (Focus border)
  static const Color actionGreen =
      Color(0xFF00C853); // Success green - Action card text/icon
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black
  static const Color secondaryText = Color(0xFF555555); // Dark Grey
  static const Color dividerColor = Color(0xFFE0E0E0); // Light Grey Border

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          // Removed the Enhanced Search Bar Section

          // Enhanced Action Cards Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Card 1: Add Person
              _buildActionCard(
                icon: Icons.person_add,
                label: "Add Person",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPersonPage()),
                  );
                },
              ),

              const SizedBox(width: 40),

              // Card 2: Add Household
              _buildActionCard(
                icon: Icons.group_add,
                label: "Add Household",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddHouseholdPage()),
                  );
                },
              ),

              const SizedBox(width: 40),

              // Card 3: Add Address
              _buildActionCard(
                icon: Icons.add_location,
                label: "Add Address",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAddressPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      color: cardBackground, // Consistent White Card Background
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 260,
          height: 280,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with circular background (using actionGreen for focus)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      actionGreen.withOpacity(0.12), // Light green background
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 56,
                  color: actionGreen, // Action Green Icon
                ),
              ),

              const SizedBox(height: 24),

              // Label
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: primaryText, // Near-Black Text
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtle subtitle
              Text(
                "Quick action",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: secondaryText, // Dark Gray Subtitle
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
