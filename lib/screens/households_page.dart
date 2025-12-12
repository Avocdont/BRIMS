import 'package:brims/database/app_db.dart';
import 'package:brims/models/household_models.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/screens/add_household_page.dart';
import 'package:brims/screens/components/household_filter_dialog.dart';
import 'package:brims/screens/view_household_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HouseholdsPage extends StatefulWidget {
  const HouseholdsPage({super.key});

  @override
  State<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends State<HouseholdsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load table data and lookups
      context.read<HouseholdProvider>().loadHouseholdTable();
      context.read<HouseholdLookupProvider>().getAllBuildingTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HouseholdProvider>();

    // --- Define Columns ---
    List<DataColumn> columns = [
      DataColumn(
        label: const Text("Head of Household"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.head),
      ),
      DataColumn(
        label: const Text("Street"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.street),
      ),
      DataColumn(
        label: const Text("Zone"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.zone),
      ),
      DataColumn(
        label: const Text("Block"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.block),
      ),
      DataColumn(
        label: const Text("Lot"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.lot),
      ),
      DataColumn(
        label: const Text("Members"),
        numeric: true,
        onSort: (index, _) => provider.sort(HouseholdSortColumn.members),
      ),
    ];

    // --- Dynamic Columns based on Filters ---
    if (provider.filters.householdTypes.isNotEmpty) {
      columns.add(DataColumn(
        label: const Text("Household Type"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.householdType),
      ));
    }
    if (provider.filters.ownershipTypes.isNotEmpty) {
      columns.add(DataColumn(
        label: const Text("Ownership"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.ownershipType),
      ));
    }
    if (provider.filters.buildingTypeIds.isNotEmpty) {
      columns.add(DataColumn(
        label: const Text("Building Type"),
        onSort: (index, _) => provider.sort(HouseholdSortColumn.buildingType),
      ));
    }

    return Scaffold(
      body: Column(
        children: [
          // --- Top Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search by Head Name...",
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
                      builder: (_) => HouseholdFilterDialog(
                        currentFilters: provider.filters,
                        onApply: (newFilters) =>
                            provider.updateFilters(newFilters),
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filters"),
                ),
                const SizedBox(width: 10),
                // Add Button here for convenience
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AddHouseholdPage()),
                    ).then((val) {
                      if (val == true || context.mounted) {
                        provider.loadHouseholdTable();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
              ],
            ),
          ),

          // --- Table ---
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: PaginatedDataTable(
                    key: ValueKey(provider.currentPageIndex), // Force refresh
                    header: const Text("Households Registry"),
                    showCheckboxColumn: false,
                    rowsPerPage: provider.rowsPerPage,
                    availableRowsPerPage: const [10, 25, 50],
                    onRowsPerPageChanged: (val) =>
                        provider.onRowsPerPageChanged(val ?? 10),
                    onPageChanged: (idx) => provider.onPageChanged(idx),
                    sortColumnIndex: _getSortIndex(provider.sortColumn),
                    sortAscending: provider.sortDirection == SortDirection.asc,
                    columns: columns,
                    source: HouseholdDataSource(
                      context: context,
                      households: provider.tableHouseholds,
                      totalCount: provider.totalRows,
                      currentPage: provider.currentPageIndex,
                      rowsPerPage: provider.rowsPerPage,
                      filters: provider.filters,
                    ),
                  ),
                ),
                if (provider.isTableLoading)
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

  // Helper to map Enum to Column Index for UI highlighting
  int? _getSortIndex(HouseholdSortColumn col) {
    switch (col) {
      case HouseholdSortColumn.head:
        return 0;
      case HouseholdSortColumn.street:
        return 1;
      case HouseholdSortColumn.zone:
        return 2;
      case HouseholdSortColumn.block:
        return 3;
      case HouseholdSortColumn.lot:
        return 4;
      case HouseholdSortColumn.members:
        return 5;
      case HouseholdSortColumn.householdType:
        return 6; // Dynamic, simplistic mapping
      case HouseholdSortColumn.ownershipType:
        return 7;
      case HouseholdSortColumn.buildingType:
        return 8;
      default:
        return null;
    }
  }
}

class HouseholdDataSource extends DataTableSource {
  final BuildContext context;
  final List<HouseholdTableRow> households;
  final int totalCount;
  final int currentPage;
  final int rowsPerPage;
  final HouseholdFilterOptions filters;

  HouseholdDataSource({
    required this.context,
    required this.households,
    required this.totalCount,
    required this.currentPage,
    required this.rowsPerPage,
    required this.filters,
  });

  @override
  DataRow? getRow(int index) {
    final int startIndex = currentPage * rowsPerPage;
    final int localIndex = index - startIndex;

    if (localIndex < 0 || localIndex >= households.length) return null;

    final row = households[localIndex];

    List<DataCell> cells = [
      DataCell(Text(row.headName)),
      DataCell(Text(row.street)),
      DataCell(Text(row.zone)),
      DataCell(Text(row.block)),
      DataCell(Text(row.lot)),
      DataCell(Text(row.memberCount.toString())),
    ];

    // Dynamic Cells (Must match order in Main Widget)
    if (filters.householdTypes.isNotEmpty) {
      cells.add(DataCell(Text(row.householdType ?? 'N/A')));
    }
    if (filters.ownershipTypes.isNotEmpty) {
      cells.add(DataCell(Text(row.ownershipType ?? 'N/A')));
    }
    if (filters.buildingTypeIds.isNotEmpty) {
      cells.add(DataCell(Text(row.buildingType ?? 'N/A')));
    }

    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewHouseholdPage(householdId: row.householdId),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<HouseholdProvider>().loadHouseholdTable();
            }
          });
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
