import 'package:brims/database/app_db.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:brims/screens/add_household_page.dart';
import 'package:brims/screens/view_household_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HouseholdsPage extends StatefulWidget {
  const HouseholdsPage({super.key});

  @override
  State<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends State<HouseholdsPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HouseholdProvider>();
      provider.getAllHouseholds();
      provider.getAllAddresses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper to find address object by ID from the loaded list
  AddressData? _getAddress(int? addressId, List<AddressData> addresses) {
    if (addressId == null) return null;
    try {
      return addresses.firstWhere((a) => a.address_id == addressId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final householdProvider = context.watch<HouseholdProvider>();
    final households = householdProvider.allHouseholds;
    final addresses = householdProvider.allAddresses;

    // Filter logic (Basic search by Head Name)
    final filteredHouseholds = households.where((h) {
      final query = _searchController.text.toLowerCase();
      final head = h.head?.toLowerCase() ?? '';
      return head.contains(query);
    }).toList();

    return Scaffold(
      // Dark background to match the image style
      backgroundColor: const Color(0xFF18181B),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------
            // 1. Header & Search
            // -------------------------
            Text(
              "Household Profiles",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by Household Head...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF27272A), // Slightly lighter dark
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // -------------------------
            // 2. Table Headers
            // -------------------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  _buildHeaderCell("Household Head", flex: 3),
                  _buildHeaderCell("Street", flex: 2),
                  _buildHeaderCell("Zone", flex: 1),
                  _buildHeaderCell("Block", flex: 1),
                  _buildHeaderCell("Lot", flex: 1),
                  _buildHeaderCell("Members", flex: 1, align: TextAlign.center),
                  const SizedBox(width: 40), // Spacing for arrow icon
                ],
              ),
            ),

            // -------------------------
            // 3. List Content or Empty State
            // -------------------------
            Expanded(
              child: filteredHouseholds.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: filteredHouseholds.length,
                      itemBuilder: (context, index) {
                        final household = filteredHouseholds[index];
                        final address = _getAddress(
                          household.address_id,
                          addresses,
                        );

                        return _buildHouseholdRow(
                          context,
                          household,
                          address,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // -------------------------
      // 4. Floating Action Button
      // -------------------------
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHouseholdPage()),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text("Add Household"),
      ),
    );
  }

  // Widget for Table Headers
  Widget _buildHeaderCell(
    String title, {
    int flex = 1,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  // Widget for Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            "No households recorded yet",
            style: TextStyle(color: Colors.grey[500], fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Widget for a Single Data Row
  Widget _buildHouseholdRow(
    BuildContext context,
    HouseholdData household,
    AddressData? address,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to Details Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ViewHouseholdPage(householdId: household.household_id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF3F3F46), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            _buildDataCell(household.head ?? "N/A", flex: 3),
            _buildDataCell(address?.street ?? "N/A", flex: 2),
            _buildDataCell(address?.zone ?? "N/A", flex: 1),
            _buildDataCell(address?.block ?? "N/A", flex: 1),
            _buildDataCell(address?.lot ?? "N/A", flex: 1),
            _buildDataCell(
              (household.household_members_num ?? 0).toString(),
              flex: 1,
              align: TextAlign.center,
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    int flex = 1,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
