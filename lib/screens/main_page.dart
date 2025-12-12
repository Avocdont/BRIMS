import 'package:brims/screens/home_page.dart';
import 'package:brims/screens/households_page.dart';
import 'package:brims/screens/lookups_page.dart';
import 'package:brims/screens/profiles_page.dart';
import 'package:brims/screens/statistics_page.dart';
import 'package:flutter/material.dart';

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
              _index = i;
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
