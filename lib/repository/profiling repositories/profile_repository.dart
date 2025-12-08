// lib/repository/profiling repositories/profile_repository.dart

import 'dart:developer';
import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:brims/models/profile_table_row.dart';
import 'package:drift/drift.dart';

class ProfileRepository {
  AppDatabase db = locator.get<AppDatabase>();

  Future<List<ProfileTableRow>> getProfileTableData({
    int page = 0,
    int limit = 10,
    String? searchQuery,
  }) async {
    try {
      final query = db.select(db.persons).join([
        // 1. Join Address
        leftOuterJoin(
          db.addresses,
          db.addresses.address_id.equalsExp(db.persons.address_id),
        ),
        // 2. Join HouseholdMembers (Link)
        leftOuterJoin(
          db.householdMembers,
          db.householdMembers.person_id.equalsExp(db.persons.person_id),
        ),
        // 3. Join Households (Actual Data)
        leftOuterJoin(
          db.households,
          db.households.household_id.equalsExp(
            db.householdMembers.household_id,
          ),
        ),
        // 4. Join Occupation
        leftOuterJoin(
          db.occupations,
          db.occupations.person_id.equalsExp(db.persons.person_id),
        ),
        // 5. Join Phone Number
        leftOuterJoin(
          db.phoneNumbers,
          db.phoneNumbers.person_id.equalsExp(db.persons.person_id),
        ),
      ]);

      // --- Search ---
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query.where(
          db.persons.last_name.contains(searchQuery) |
              db.persons.first_name.contains(searchQuery),
        );
      }

      // --- Pagination ---
      query.limit(limit, offset: page * limit);
      query.groupBy([db.persons.person_id]);

      final rows = await query.get();

      return rows.map((row) {
        final person = row.readTable(db.persons);
        final address = row.readTableOrNull(db.addresses);
        final household = row.readTableOrNull(db.households);
        final occupation = row.readTableOrNull(db.occupations);
        final phone = row.readTableOrNull(db.phoneNumbers);

        // Name
        final String fullName = [
          person.last_name,
          person.first_name,
          person.middle_name ?? '',
          person.suffix ?? '',
        ].where((s) => s.isNotEmpty).join(' ');

        // Address
        final String fullAddress =
            address != null
                ? '${address.block ?? ''} ${address.lot ?? ''} ${address.street ?? ''} ${address.zone ?? ''}'
                    .trim()
                : 'N/A';

        // Household Formatting
        String householdString = 'No Household';
        int? hhId;

        if (household != null) {
          hhId = household.household_id;
          householdString = 'HH #$hhId';
          // Optional: Add head of household name if available
          // if (household.head != null) householdString += ' (${household.head})';
        }

        return ProfileTableRow(
          personId: person.person_id,
          fullName: fullName,
          age: person.age,
          sex: person.sex,
          civilStatus: person.civil_status,
          address: fullAddress.isEmpty ? 'N/A' : fullAddress,
          householdId: hhId, // <--- Assign raw ID here
          householdInfo: householdString,
          occupation: occupation?.occupation ?? 'N/A',
          contactNumber: phone?.phone_num.toString() ?? 'N/A',
          registrationStatus: person.registration_status,
        );
      }).toList();
    } catch (e) {
      log("Error fetching profile table data: ${e.toString()}");
      return [];
    }
  }

  // Helper to get total count for pagination calculations
  Future<int> getTotalProfileCount() async {
    final countExp = db.persons.person_id.count();
    final result = await db.selectOnly(db.persons)
      ..addColumns([countExp]);
    return await result.map((row) => row.read(countExp)).getSingle() ?? 0;
  }
}
