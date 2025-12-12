import 'package:brims/provider/profiling%20providers/profile_provider.dart';
import 'package:brims/screens/home_page.dart';
import 'package:brims/screens/households_page.dart';
import 'package:brims/screens/lookups_page.dart';
import 'package:brims/screens/profiles_page.dart';
import 'package:brims/screens/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // For consistent typography

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = [
    const HomePage(),
    const ProfilesPage(),
    const HouseholdsPage(),
    const StatisticsPage(),
    const LookupsPage(),
  ];

  // --- Consistent Color Palette ---
  static const Color primaryBackground =
      Color(0xFFF5F7FA); // Soft gray background
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color navBackground =
      Color(0xFF40C4FF); // Sky Blue navigation (Lighter)
  static const Color navBackgroundDark =
      Color(0xFF29B6F6); // Slightly darker blue
  static const Color selectedAccent = Color(
      0xFF0288D1); // Deep blue for selected (Not directly used here, but kept for context)
  static const Color actionGreen = Color(0xFF00C853); // Success green
  static const Color primaryText = Color(0xFF1A1A1A); // Near-black
  static const Color secondaryText = Color(0xFF555555);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color hoverOverlay = Color(0x1A000000); // 10% black overlay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground, // Apply Soft Gray background
      appBar: AppBar(
        title: const Text("BRIMS"),
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [navBackground, navBackgroundDark], // Blue Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: Row(
        children: [
          // Navigation Rail Container with Gradient/Shadow
          Container(
            width: 110, // Explicit width for consistent UI
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [navBackground, navBackgroundDark], // Blue Gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: NavigationRail(
              extended: false,
              minWidth: 110,
              groupAlignment: -0.8,
              labelType: NavigationRailLabelType.all,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() {
                // 1. Check if the user clicked the Profiles tab (Index 1)
                if (i == 1) {
                  final provider = context.read<ProfileProvider>();

                  // 2. Reset the table to the first page
                  provider.onPageChanged(0);

                  // 3. Force a reload of the data to get the new person
                  provider.loadProfiles();
                }

                // 4. Update the UI tab selection
                setState(() {
                  _index = i;
                });
              }),

              // Transparent background since the container has the gradient
              backgroundColor: Colors.transparent,

              // Selected items styled white for contrast against blue gradient
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
                size: 30,
              ),
              selectedLabelTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),

              // Unselected items styled with a subtle white tint
              unselectedIconTheme: IconThemeData(
                color: Colors.white.withOpacity(0.7),
                size: 28,
              ),
              unselectedLabelTextStyle: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),

              // Indicator uses a translucent white for a subtle glow effect
              indicatorColor: Colors.white.withOpacity(0.25),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              // 👇 Logo placed above Home icon
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color:
                          cardBackground, // White background for logo contrast
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 70, // adjust size as needed
                      width: 70,
                    ),
                  ),
                ),
              ),

              destinations: const [
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text("Profiles"),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  icon: Icon(Icons.group_outlined),
                  selectedIcon: Icon(Icons.group),
                  label: Text("Households"),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text("Statistics"),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: Text("Lookups"),
                ),
              ],
            ),
          ),
          Expanded(child: _pages[_index]),
        ],
      ),
    );
  }
}
