import 'package:brims/provider/profiling%20providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brims/models/profile_table_row.dart';
import 'package:brims/screens/view_household_page.dart'; // Create this later
import 'package:brims/screens/view_person_details_page.dart'; // Create this later

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar Integration
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search by Name...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => provider.search(val),
              ),
            ),

            // The Paginated Table
            PaginatedDataTable(
              header: const Text("Citizen Profiles"),
              rowsPerPage: provider.rowsPerPage,
              availableRowsPerPage: const [10, 25, 50],
              onRowsPerPageChanged:
                  (val) => provider.onRowsPerPageChanged(val ?? 10),
              // This is the core data source logic
              source: ProfileDataSource(context, provider.profiles),
              columns: const [
                DataColumn(label: Text("Full Name")),
                DataColumn(label: Text("Age")),
                DataColumn(label: Text("Sex")),
                DataColumn(label: Text("Address")),
                DataColumn(label: Text("Household")),
                DataColumn(label: Text("Occupation")),
                DataColumn(label: Text("Registration")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The logic to populate rows and handle clicks
class ProfileDataSource extends DataTableSource {
  final BuildContext context;
  final List<ProfileTableRow> profiles;

  ProfileDataSource(this.context, this.profiles);

  @override
  DataRow? getRow(int index) {
    if (index >= profiles.length) return null;
    final row = profiles[index];

    return DataRow(
      // Make the entire Person row clickable
      onSelectChanged: (selected) {
        if (selected == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewPersonDetailsPage(personId: row.personId),
            ),
          );
        }
      },
      cells: [
        DataCell(Text(row.fullName)),
        DataCell(Text(row.age?.toString() ?? 'N/A')),
        DataCell(Text(row.sex?.name ?? 'N/A')),
        DataCell(Text(row.address)),

        // Clickable Household Cell
        DataCell(
          row.householdId != null
              ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              ViewHouseholdPage(householdId: row.householdId!),
                    ),
                  );
                },
                child: Text(
                  row.householdInfo,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
              : Text(row.householdInfo),
        ),

        DataCell(Text(row.occupation)),
        DataCell(Text(row.registrationStatus.name)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => profiles.length;

  @override
  int get selectedRowCount => 0;
}
