import 'package:brims/database/app_db.dart';
import 'package:brims/models/household_models.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/provider/household%20providers/household_lookup_provider.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/screens/add_household_page.dart';
import 'package:brims/screens/components/household_filter_dialog.dart';
import 'package:brims/screens/view_household_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HouseholdsPage extends StatefulWidget {
  const HouseholdsPage({super.key});

  @override
  State<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends State<HouseholdsPage> {
  final TextEditingController _searchController = TextEditingController();

  // --- Enhanced Color Palette (Preserved from Original UI) ---
  static const Color primaryBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color navBackground = Color(0xFF40C4FF);
  static const Color selectedAccent = Color(0xFF0288D1);
  static const Color actionGreen = Color(0xFF00C853);
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color secondaryText = Color(0xFF555555);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color tableHeaderBg = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Logic from new code: Load table data and lookups
      context.read<HouseholdProvider>().loadHouseholdTable();
      context.read<HouseholdLookupProvider>().getAllBuildingTypes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logic from new code: Watch the provider state
    final provider = context.watch<HouseholdProvider>();

    // Data source from provider
    final householdsOnPage = provider.tableHouseholds;
    final int totalCount = provider.totalRows;
    final int rowsPerPage = provider.rowsPerPage;
    final int currentPageIndex = provider.currentPageIndex;

    // Calculate range text logic
    final int startIndex = currentPageIndex * rowsPerPage;
    final int endIndex =
        (startIndex + householdsOnPage.length).clamp(0, totalCount);

    final bool isLastPage = endIndex >= totalCount;
    final String rangeText = totalCount > 0
        ? "${startIndex + 1} – $endIndex of $totalCount"
        : "0 of 0";

    return Container(
      color: primaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------
            // 1. Header & Controls
            // -------------------------
            Text(
              "Household Profiles",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar + Actions Row
            Row(
              children: [
                // Expanded Search Bar
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      // Logic update: use provider search
                      onChanged: (value) => provider.search(value),
                      style: GoogleFonts.poppins(
                        color: primaryText,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search by Household Head...",
                        hintStyle: GoogleFonts.poppins(
                          color: secondaryText,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: navBackground,
                          size: 22,
                        ),
                        filled: true,
                        fillColor: cardBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: selectedAccent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Filter Button
                _buildActionButton(
                  icon: Icons.filter_list,
                  label: "Filters",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => HouseholdFilterDialog(
                        currentFilters: provider.filters,
                        onApply: (newFilters) =>
                            provider.updateFilters(newFilters),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),

                // Add Button
                _buildActionButton(
                  icon: Icons.add,
                  label: "Add New",
                  isPrimary: true,
                  onTap: () {
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
                ),
              ],
            ),

            const SizedBox(height: 24),

            // -------------------------
            // 2. Table Container
            // -------------------------
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Headers (With Sort Logic)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: tableHeaderBg,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell("Household Head",
                              col: HouseholdSortColumn.head, flex: 3),
                          _buildHeaderCell("Street",
                              col: HouseholdSortColumn.street, flex: 2),
                          _buildHeaderCell("Zone",
                              col: HouseholdSortColumn.zone, flex: 1),
                          _buildHeaderCell("Block",
                              col: HouseholdSortColumn.block, flex: 1),
                          _buildHeaderCell("Lot",
                              col: HouseholdSortColumn.lot, flex: 1),
                          _buildHeaderCell("Members",
                              col: HouseholdSortColumn.members,
                              flex: 1,
                              align: TextAlign.center),

                          // Dynamic Headers based on Filters
                          if (provider.filters.householdTypes.isNotEmpty)
                            _buildHeaderCell("Type",
                                col: HouseholdSortColumn.householdType,
                                flex: 1),
                          if (provider.filters.ownershipTypes.isNotEmpty)
                            _buildHeaderCell("Ownership",
                                col: HouseholdSortColumn.ownershipType,
                                flex: 1),
                          if (provider.filters.buildingTypeIds.isNotEmpty)
                            _buildHeaderCell("Building",
                                col: HouseholdSortColumn.buildingType, flex: 1),

                          const SizedBox(width: 40), // Spacer for chevron arrow
                        ],
                      ),
                    ),

                    // Divider
                    Container(
                      height: 1,
                      color: dividerColor,
                    ),

                    // List Content (Using Provider Data)
                    Expanded(
                      child: provider.isTableLoading
                          ? const Center(child: CircularProgressIndicator())
                          : householdsOnPage.isEmpty && totalCount == 0
                              ? _buildEmptyState()
                              : ListView.builder(
                                  itemCount: householdsOnPage.length,
                                  itemBuilder: (context, index) {
                                    final row = householdsOnPage[index];
                                    return _buildHouseholdRow(
                                        context, row, provider.filters);
                                  },
                                ),
                    ),

                    // Pagination Controls (Using Provider Logic)
                    if (totalCount > 0)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: dividerColor, width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Rows per page:",
                              style: GoogleFonts.poppins(
                                color: secondaryText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Rows Per Page Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: dividerColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: rowsPerPage,
                                  items: [10, 25, 50].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        '$value',
                                        style: GoogleFonts.poppins(
                                          color: primaryText,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      provider.onRowsPerPageChanged(val);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: secondaryText,
                                  ),
                                  style: GoogleFonts.poppins(
                                    color: primaryText,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 24),
                            Text(
                              rangeText,
                              style: GoogleFonts.poppins(
                                color: secondaryText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Prev/Next Buttons
                            _buildPaginationBtn(
                              icon: Icons.chevron_left,
                              enabled: currentPageIndex > 0,
                              onTap: () =>
                                  provider.onPageChanged(currentPageIndex - 1),
                            ),
                            const SizedBox(width: 8),
                            _buildPaginationBtn(
                              icon: Icons.chevron_right,
                              enabled: !isLastPage,
                              onTap: () =>
                                  provider.onPageChanged(currentPageIndex + 1),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? selectedAccent : cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isPrimary ? Colors.white : navBackground, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isPrimary ? Colors.white : primaryText,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    String title, {
    required HouseholdSortColumn col,
    int flex = 1,
    TextAlign align = TextAlign.left,
  }) {
    final provider = context.watch<HouseholdProvider>();
    final isSorted = provider.sortColumn == col;
    final isAsc = provider.sortDirection == SortDirection.asc;

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => provider.sort(col),
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  textAlign: align,
                  style: GoogleFonts.poppins(
                    color: isSorted ? selectedAccent : secondaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              if (isSorted) ...[
                const SizedBox(width: 4),
                Icon(
                  isAsc ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: selectedAccent,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No households found",
            style: GoogleFonts.poppins(
              color: secondaryText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdRow(
    BuildContext context,
    HouseholdTableRow row,
    HouseholdFilterOptions filters,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ViewHouseholdPage(householdId: row.householdId),
          ),
        ).then((_) {
          if (context.mounted) {
            context.read<HouseholdProvider>().loadHouseholdTable();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            _buildDataCell(row.headName, flex: 3, isPrimary: true),
            _buildDataCell(row.street, flex: 2),
            _buildDataCell(row.zone, flex: 1),
            _buildDataCell(row.block, flex: 1),
            _buildDataCell(row.lot, flex: 1),
            _buildDataCell(
              row.memberCount.toString(),
              flex: 1,
              align: TextAlign.center,
            ),

            // Dynamic Cells based on filters
            if (filters.householdTypes.isNotEmpty)
              _buildDataCell(row.householdType ?? 'N/A', flex: 1),
            if (filters.ownershipTypes.isNotEmpty)
              _buildDataCell(row.ownershipType ?? 'N/A', flex: 1),
            if (filters.buildingTypeIds.isNotEmpty)
              _buildDataCell(row.buildingType ?? 'N/A', flex: 1),

            Icon(
              Icons.chevron_right,
              color: secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    int flex = 1,
    TextAlign align = TextAlign.left,
    bool isPrimary = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          text,
          textAlign: align,
          style: GoogleFonts.poppins(
            color: isPrimary ? primaryText : secondaryText,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildPaginationBtn(
      {required IconData icon,
      required bool enabled,
      required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: enabled ? dividerColor : dividerColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: enabled ? primaryText : secondaryText.withOpacity(0.5),
        onPressed: enabled ? onTap : null,
      ),
    );
  }
}
