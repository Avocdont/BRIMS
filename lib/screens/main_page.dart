import 'package:brims/provider/profiling%20providers/profile_provider.dart';
import 'package:brims/screens/home_page.dart';
import 'package:brims/screens/households_page.dart';
import 'package:brims/screens/lookups_page.dart';
import 'package:brims/screens/profiles_page.dart';
import 'package:brims/screens/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BRIMS"), centerTitle: true),
      body: Row(
        children: [
          NavigationRail(
            minWidth: 100,
            groupAlignment: 0.0,
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

            // 👇 Logo placed above Home icon
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 80, // adjust size as needed
                ),
              ),
            ),

            destinations: const [
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text("Profiles"),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group),
                label: Text("Households"),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text("Statistics"),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: Text("Lookups"),
              ),
            ],
          ),
          Expanded(child: _pages[_index]),
        ],
      ),
    );
  }
}
