import 'package:brims/database/tables/enums.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/models/profile_table_row.dart';
import 'package:brims/provider/profiling%20providers/profile_provider.dart';
import 'package:brims/screens/components/profile_filter_dialog.dart';
import 'package:brims/screens/view_household_page.dart';
import 'package:brims/screens/view_person_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilesPage extends StatelessWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    // --- 1. Define Dynamic Columns ---
    List<DataColumn> tableColumns = [
      DataColumn(
        label: const Text("Full Name"),
        onSort: (index, _) => provider.sort(SortColumn.name),
      ),
      DataColumn(
        label: const Text("Age"),
        numeric: true,
        onSort: (index, _) => provider.sort(SortColumn.age),
      ),
      const DataColumn(label: Text("Sex")),
      const DataColumn(label: Text("Civil Status")),
      const DataColumn(label: Text("Address")),
      const DataColumn(label: Text("Household")),
      const DataColumn(label: Text("Contact")),
      const DataColumn(label: Text("Reg. Status")),
    ];

    // Conditionally add columns if filtered
    if (provider.filters.nationalityIds.isNotEmpty) {
      tableColumns.add(const DataColumn(label: Text("Nationality")));
    }
    if (provider.filters.ethnicityIds.isNotEmpty) {
      tableColumns.add(const DataColumn(label: Text("Ethnicity")));
    }
    if (provider.filters.religionIds.isNotEmpty) {
      tableColumns.add(const DataColumn(label: Text("Religion")));
    }
    if (provider.filters.educationIds.isNotEmpty) {
      tableColumns.add(const DataColumn(label: Text("Education")));
    }
    if (provider.filters.bloodTypeIds.isNotEmpty) {
      tableColumns.add(const DataColumn(label: Text("Blood Type")));
    }

    return Scaffold(
      // FIX: Use Column directly (No SingleChildScrollView wrapper around the body)
      body: Column(
        children: [
          // --- Top Bar: Search & Filter ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search by Name...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => provider.search(val),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ProfileFilterDialog(
                            currentFilters: provider.filters,
                            onApply: (newFilters) {
                              provider.updateFilters(newFilters);
                            },
                          ),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filters"),
                ),
              ],
            ),
          ),

          // --- Table Section ---
          // ... inside ProfilesPage build method ...

          // --- Table Section ---
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: PaginatedDataTable(
                    // FIX: Add a Key that depends on the current page index.
                    // This forces the widget to refresh its internal state when the provider resets the page to 0.
                    key: ValueKey(provider.currentPageIndex),

                    header: const Text("Citizen Profiles"),
                    showCheckboxColumn: false,
                    rowsPerPage: provider.rowsPerPage,
                    availableRowsPerPage: const [10, 25, 50],

                    initialFirstRowIndex:
                        provider.currentPageIndex * provider.rowsPerPage,

                    onRowsPerPageChanged:
                        (val) => provider.onRowsPerPageChanged(val ?? 10),

                    onPageChanged:
                        (firstRowIndex) =>
                            provider.onPageChanged(firstRowIndex),

                    sortColumnIndex:
                        provider.sortColumn == SortColumn.name
                            ? 0
                            : provider.sortColumn == SortColumn.age
                            ? 1
                            : null,
                    sortAscending: provider.sortDirection == SortDirection.asc,
                    columns: tableColumns,

                    source: ProfileDataSource(
                      context: context,
                      profiles: provider.profiles,
                      totalCount: provider.totalRows,
                      filters: provider.filters,
                      currentPage: provider.currentPageIndex,
                      rowsPerPage: provider.rowsPerPage,
                    ),
                  ),
                ),

                if (provider.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDataSource extends DataTableSource {
  final BuildContext context;
  final List<ProfileTableRow> profiles;
  final int totalCount;
  final ProfileFilterOptions filters;
  final int currentPage;
  final int rowsPerPage;

  ProfileDataSource({
    required this.context,
    required this.profiles,
    required this.totalCount,
    required this.filters,
    required this.currentPage,
    required this.rowsPerPage,
  });

  @override
  DataRow? getRow(int index) {
    // --- 1. Calculate Local Index ---
    // The table asks for absolute index (e.g., 20).
    // Our 'profiles' list only contains the 10 items for the current page.
    // The starting index of the current page is (page * size).
    final int startIndex = currentPage * rowsPerPage;
    final int localIndex = index - startIndex;

    // --- 2. Validation Fix ---
    // If the table asks for index 20, but our page starts at 20, localIndex is 0.
    // If localIndex is outside the bounds of our *loaded* list, return null.
    // This stops the data from repeating or showing errors.
    if (localIndex < 0 || localIndex >= profiles.length) {
      return null;
    }

    final row = profiles[localIndex];

    // Build standard cells
    List<DataCell> cells = [
      DataCell(Text(row.fullName)),
      DataCell(Text(row.age?.toString() ?? 'N/A')),
      DataCell(Text(row.sex?.name ?? 'N/A')),
      DataCell(Text(row.civilStatus?.name ?? 'N/A')),
      DataCell(Text(row.address)),
      DataCell(
        row.householdId != null
            ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ViewHouseholdPage(householdId: row.householdId!),
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
      DataCell(Text(row.contactNumber)),
      DataCell(Text(row.registrationStatus.name)),
    ];

    // Build dynamic cells (MUST match order in main widget)
    if (filters.nationalityIds.isNotEmpty) {
      cells.add(DataCell(Text(row.nationality ?? 'N/A')));
    }
    if (filters.ethnicityIds.isNotEmpty) {
      cells.add(DataCell(Text(row.ethnicity ?? 'N/A')));
    }
    if (filters.religionIds.isNotEmpty) {
      cells.add(DataCell(Text(row.religion ?? 'N/A')));
    }
    if (filters.educationIds.isNotEmpty) {
      cells.add(DataCell(Text(row.education ?? 'N/A')));
    }
    if (filters.bloodTypeIds.isNotEmpty) {
      cells.add(DataCell(Text(row.bloodType ?? 'N/A')));
    }

    return DataRow(
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
      cells: cells,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}
