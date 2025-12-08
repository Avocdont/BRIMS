import 'package:brims/screens/barangay_page.dart';
import 'package:brims/screens/farming_page.dart';
import 'package:brims/screens/home_page.dart';
import 'package:brims/screens/households_page.dart';
import 'package:brims/screens/login_management_page.dart';
import 'package:brims/screens/lookups_page.dart';
import 'package:brims/screens/medical_page.dart';
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
    HomePage(),
    ProfilesPage(),
    HouseholdsPage(),
    MedicalPage(),
    FarmingPage(),
    StatisticsPage(),
    BarangayPage(),
    LookupsPage(),
    LoginManagementPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BRIMS"), centerTitle: true),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            onDestinationSelected:
                (i) => setState(() {
                  _index = i;
                }),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text("Home"),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text("Profiles"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group),
                label: Text("Households"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_hospital_outlined),
                selectedIcon: Icon(Icons.local_hospital),
                label: Text("Medical"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.agriculture_outlined),
                selectedIcon: Icon(Icons.agriculture),
                label: Text("Farming"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text("Statistics"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.location_city_outlined),
                selectedIcon: Icon(Icons.location_city),
                label: Text("Barangay"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: Text("Lookups"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.lock_outlined),
                selectedIcon: Icon(Icons.lock),
                label: Text("Login Management"),
              ),
            ],
            selectedIndex: _index,
          ),

          Expanded(child: _pages[_index]),
        ],
      ),
    );
  }
}
