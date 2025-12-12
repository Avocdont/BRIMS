import 'package:brims/database/tables/enums.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/models/profile_table_row.dart';
import 'package:brims/provider/profiling%20providers/profile_provider.dart';
import 'package:brims/screens/components/profile_filter_dialog.dart';
import 'package:brims/screens/view_household_page.dart';
import 'package:brims/screens/view_person_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  final TextEditingController _searchController = TextEditingController();

  // --- Consistent Color Palette (Preserved from Original UI) ---
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
      context.read<ProfileProvider>().loadProfiles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profilesOnPage = provider.profiles;
    final totalCount = provider.totalRows;
    final currentPageIndex = provider.currentPageIndex;
    final rowsPerPage = provider.rowsPerPage;
    final filters = provider.filters;

    final int startIndex = currentPageIndex * rowsPerPage;
    final int endIndex = (startIndex + rowsPerPage).clamp(0, totalCount);
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
            // 1. Header
            // -------------------------
            Text(
              "Citizen Profiles",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),

            // -------------------------
            // 2. Search & Filter Bar
            // -------------------------
            Row(
              children: [
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
                      onChanged: (val) {
                        // Logic from new code: search on provider
                        provider.search(val);
                      },
                      style: GoogleFonts.poppins(
                        color: primaryText,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search by Name...",
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
                            vertical: 16, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: selectedAccent, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ProfileFilterDialog(
                        currentFilters: provider.filters,
                        onApply: (newFilters) =>
                            provider.updateFilters(newFilters),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filters"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // -------------------------
            // 3. Table Container
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
                    // Custom Table Headers (Dynamic)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: const BoxDecoration(
                        color: tableHeaderBg,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell("Full Name",
                              flex: 3, sortCol: SortColumn.name),
                          _buildHeaderCell("Age",
                              flex: 1,
                              align: TextAlign.center,
                              sortCol: SortColumn.age),
                          _buildHeaderCell("Sex", flex: 1),
                          _buildHeaderCell("Civil Status", flex: 2),
                          _buildHeaderCell("Address", flex: 4),
                          _buildHeaderCell("Household", flex: 2),
                          _buildHeaderCell("Contact", flex: 2),
                          _buildHeaderCell("Reg. Status", flex: 2),

                          // Dynamic Headers based on Filters
                          if (filters.nationalityIds.isNotEmpty)
                            _buildHeaderCell("Nationality", flex: 2),
                          if (filters.ethnicityIds.isNotEmpty)
                            _buildHeaderCell("Ethnicity", flex: 2),
                          if (filters.religionIds.isNotEmpty)
                            _buildHeaderCell("Religion", flex: 2),
                          if (filters.educationIds.isNotEmpty)
                            _buildHeaderCell("Education", flex: 2),
                          if (filters.bloodTypeIds.isNotEmpty)
                            _buildHeaderCell("Blood Type", flex: 2),

                          const SizedBox(width: 40), // Space for action arrow
                        ],
                      ),
                    ),

                    // Divider
                    Container(
                      height: 1,
                      color: dividerColor,
                    ),

                    // List Content
                    Expanded(
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : totalCount == 0
                              ? _buildEmptyState()
                              : ListView.builder(
                                  itemCount: profilesOnPage.length,
                                  itemBuilder: (context, index) {
                                    final profile = profilesOnPage[index];
                                    return _buildProfileRow(
                                        context, profile, filters);
                                  },
                                ),
                    ),

                    // Pagination Controls
                    if (totalCount > 0)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: dividerColor, width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Rows per page:",
                                style: GoogleFonts.poppins(
                                    color: secondaryText, fontSize: 14)),
                            const SizedBox(width: 8),

                            // Rows per page Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: dividerColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: rowsPerPage,
                                  items: const [10, 25, 50].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('$value',
                                          style: GoogleFonts.poppins(
                                              color: primaryText,
                                              fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      provider.onRowsPerPageChanged(val);
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: secondaryText),
                                  style: GoogleFonts.poppins(
                                      color: primaryText, fontSize: 14),
                                ),
                              ),
                            ),

                            const SizedBox(width: 24),
                            Text(rangeText,
                                style: GoogleFonts.poppins(
                                    color: secondaryText, fontSize: 14)),
                            const SizedBox(width: 16),

                            // Previous Button
                            _buildPaginationBtn(
                              icon: Icons.chevron_left,
                              enabled: currentPageIndex > 0,
                              onTap: () =>
                                  provider.onPageChanged(currentPageIndex - 1),
                            ),
                            const SizedBox(width: 8),

                            // Next Button
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

  Widget _buildHeaderCell(
    String title, {
    int flex = 1,
    TextAlign align = TextAlign.left,
    SortColumn? sortCol,
  }) {
    final provider = context.watch<ProfileProvider>();
    final isSorted = provider.sortColumn == sortCol && sortCol != null;
    final isAsc = provider.sortDirection == SortDirection.asc;

    Widget child = Row(
      mainAxisAlignment: align == TextAlign.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: isSorted ? selectedAccent : secondaryText,
            fontWeight: FontWeight.w600,
            fontSize: 13,
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
    );

    // Wrap in InkWell if sorting is enabled for this column
    if (sortCol != null) {
      child = InkWell(
        onTap: () => provider.sort(sortCol),
        child: child,
      );
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: child,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No citizen profiles found.",
            style: GoogleFonts.poppins(
              color: secondaryText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(
    BuildContext context,
    ProfileTableRow row,
    ProfileFilterOptions filters,
  ) {
    // Base Cells
    List<Widget> cells = [
      _buildDataCell(row.fullName, flex: 3, isPrimary: true),
      _buildDataCell(row.age?.toString() ?? 'N/A',
          flex: 1, align: TextAlign.center),
      _buildDataCell(row.sex?.name ?? 'N/A', flex: 1),
      _buildDataCell(row.civilStatus?.name ?? 'N/A', flex: 2),
      _buildDataCell(row.address, flex: 4),
      // Household Link Cell
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: row.householdId != null
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ViewHouseholdPage(householdId: row.householdId!),
                      ),
                    );
                  },
                  child: Text(
                    row.householdInfo,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: navBackground,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: navBackground,
                    ),
                  ),
                )
              : _buildTextCell(row.householdInfo, secondaryText),
        ),
      ),
      _buildDataCell(row.contactNumber, flex: 2),
      _buildDataCell(row.registrationStatus.name, flex: 2),
    ];

    // Dynamic Cells (Logic from new code injected here)
    if (filters.nationalityIds.isNotEmpty) {
      cells.add(_buildDataCell(row.nationality ?? 'N/A', flex: 2));
    }
    if (filters.ethnicityIds.isNotEmpty) {
      cells.add(_buildDataCell(row.ethnicity ?? 'N/A', flex: 2));
    }
    if (filters.religionIds.isNotEmpty) {
      cells.add(_buildDataCell(row.religion ?? 'N/A', flex: 2));
    }
    if (filters.educationIds.isNotEmpty) {
      cells.add(_buildDataCell(row.education ?? 'N/A', flex: 2));
    }
    if (filters.bloodTypeIds.isNotEmpty) {
      cells.add(_buildDataCell(row.bloodType ?? 'N/A', flex: 2));
    }

    // Final action icon
    cells.add(
      const Icon(
        Icons.chevron_right,
        color: secondaryText,
        size: 20,
      ),
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewPersonDetailsPage(personId: row.personId),
          ),
        ).then((_) {
          if (context.mounted) {
            context.read<ProfileProvider>().loadProfiles();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: cells,
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

  Widget _buildTextCell(String text, Color color) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: 14,
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
