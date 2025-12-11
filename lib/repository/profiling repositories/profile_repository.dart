import 'dart:developer';
import 'package:brims/database/app_db.dart';
import 'package:brims/locator.dart';
import 'package:brims/models/profile_table_row.dart';
import 'package:brims/models/profile_filter_options.dart';
import 'package:drift/drift.dart';

class ProfileRepository {
  AppDatabase db = locator.get<AppDatabase>();

  // --- QUERY BUILDER (Updated with string mapping fix) ---
  SimpleSelectStatement<$PersonsTable, PersonData> _buildQuery(
    String? searchQuery,
    ProfileFilterOptions filters,
  ) {
    var query = db.select(db.persons);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.last_name.contains(searchQuery) |
            tbl.first_name.contains(searchQuery),
      );
    }

    query.where((tbl) {
      Expression<bool> predicate = const Constant(true);

      if (filters.sex.isNotEmpty) {
        predicate &= tbl.sex.isIn(filters.sex.map((e) => e.name));
      }
      if (filters.civilStatus.isNotEmpty) {
        predicate &= tbl.civil_status.isIn(
          filters.civilStatus.map((e) => e.name),
        );
      }
      if (filters.nationalityIds.isNotEmpty) {
        predicate &= tbl.nationality_id.isIn(filters.nationalityIds);
      }
      if (filters.ethnicityIds.isNotEmpty) {
        predicate &= tbl.ethnicity_id.isIn(filters.ethnicityIds);
      }
      if (filters.religionIds.isNotEmpty) {
        predicate &= tbl.religion_id.isIn(filters.religionIds);
      }
      if (filters.educationIds.isNotEmpty) {
        predicate &= tbl.education_id.isIn(filters.educationIds);
      }
      if (filters.bloodTypeIds.isNotEmpty) {
        predicate &= tbl.blood_type_id.isIn(filters.bloodTypeIds);
      }
      if (filters.registrationStatus.isNotEmpty) {
        predicate &= tbl.registration_status.isIn(
          filters.registrationStatus.map((e) => e.name),
        );
      }
      if (filters.hasDisability != null) {
        predicate &= tbl.pwd.equals(filters.hasDisability!);
      }
      if (filters.currentlyEnrolled != null) {
        predicate &= tbl.currently_enrolled.equals(
          filters.currentlyEnrolled!.name,
        );
      }
      if (filters.registeredVoter != null) {
        predicate &= tbl.registered_voter.equals(filters.registeredVoter!);
      }
      if (filters.minAge != null) {
        predicate &= tbl.age.isBiggerOrEqualValue(filters.minAge!);
      }
      if (filters.maxAge != null) {
        predicate &= tbl.age.isSmallerOrEqualValue(filters.maxAge!);
      }

      return predicate;
    });

    return query;
  }

  // --- MAIN FETCH FUNCTION ---
  Future<List<ProfileTableRow>> getProfileTableData({
    int page = 0,
    int limit = 10,
    String? searchQuery,
    required ProfileFilterOptions filters,
    SortColumn sortColumn = SortColumn.none,
    SortDirection sortDirection = SortDirection.asc,
  }) async {
    try {
      final baseQuery = _buildQuery(searchQuery, filters);

      // Massive Join to get everything needed for display
      final joinedQuery = baseQuery.join([
        // Core
        leftOuterJoin(
          db.addresses,
          db.addresses.address_id.equalsExp(db.persons.address_id),
        ),
        leftOuterJoin(
          db.householdMembers,
          db.householdMembers.person_id.equalsExp(db.persons.person_id),
        ),
        leftOuterJoin(
          db.households,
          db.households.household_id.equalsExp(
            db.householdMembers.household_id,
          ),
        ),
        leftOuterJoin(
          db.phoneNumbers,
          db.phoneNumbers.person_id.equalsExp(db.persons.person_id),
        ),

        // Lookups (for dynamic columns)
        leftOuterJoin(
          db.nationalities,
          db.nationalities.nationality_id.equalsExp(db.persons.nationality_id),
        ),
        leftOuterJoin(
          db.ethnicities,
          db.ethnicities.ethnicity_id.equalsExp(db.persons.ethnicity_id),
        ),
        leftOuterJoin(
          db.religions,
          db.religions.religion_id.equalsExp(db.persons.religion_id),
        ),
        leftOuterJoin(
          db.education,
          db.education.education_id.equalsExp(db.persons.education_id),
        ),
        leftOuterJoin(
          db.bloodTypes,
          db.bloodTypes.blood_type_id.equalsExp(db.persons.blood_type_id),
        ),
      ]);

      // --- Sorting ---
      if (sortColumn == SortColumn.name) {
        joinedQuery.orderBy([
          OrderingTerm(
            expression: db.persons.last_name,
            mode:
                sortDirection == SortDirection.asc
                    ? OrderingMode.asc
                    : OrderingMode.desc,
          ),
          OrderingTerm(
            expression: db.persons.first_name,
            mode:
                sortDirection == SortDirection.asc
                    ? OrderingMode.asc
                    : OrderingMode.desc,
          ),
        ]);
      } else if (sortColumn == SortColumn.age) {
        joinedQuery.orderBy([
          OrderingTerm(
            expression: db.persons.age,
            mode:
                sortDirection == SortDirection.asc
                    ? OrderingMode.asc
                    : OrderingMode.desc,
          ),
        ]);
      }

      // --- Pagination & Grouping ---
      joinedQuery.limit(limit, offset: page * limit);
      joinedQuery.groupBy([db.persons.person_id]);

      final rows = await joinedQuery.get();

      return rows.map((row) {
        final person = row.readTable(db.persons);
        final address = row.readTableOrNull(db.addresses);
        final household = row.readTableOrNull(db.households);
        final phone = row.readTableOrNull(db.phoneNumbers);

        // Read Lookup Tables
        final nat = row.readTableOrNull(db.nationalities);
        final eth = row.readTableOrNull(db.ethnicities);
        final rel = row.readTableOrNull(db.religions);
        final edu = row.readTableOrNull(db.education);
        final blo = row.readTableOrNull(db.bloodTypes);

        final String fullName = [
          person.last_name,
          person.first_name,
          person.middle_name ?? '',
          person.suffix ?? '',
        ].where((s) => s.isNotEmpty).join(' ');

        final String fullAddress =
            address != null
                ? '${address.block ?? ''} ${address.lot ?? ''} ${address.street ?? ''} ${address.zone ?? ''}'
                    .trim()
                : 'N/A';

        String householdString = 'No Household';
        int? hhId;
        if (household != null) {
          hhId = household.household_id;
          householdString = 'HH #$hhId';
        }

        return ProfileTableRow(
          personId: person.person_id,
          fullName: fullName,
          age: person.age,
          sex: person.sex,
          civilStatus: person.civil_status,
          address: fullAddress.isEmpty ? 'N/A' : fullAddress,
          householdId: hhId,
          householdInfo: householdString,
          contactNumber: phone?.phone_num.toString() ?? 'N/A',
          registrationStatus: person.registration_status,

          // Populate dynamic fields
          nationality: nat?.name,
          ethnicity: eth?.name,
          religion: rel?.name,
          education: edu?.level,
          bloodType: blo?.type,
        );
      }).toList();
    } catch (e) {
      log("Error fetching profile table data: ${e.toString()}");
      return [];
    }
  }

  Future<int> getTotalProfileCount({
    String? searchQuery,
    required ProfileFilterOptions filters,
  }) async {
    final baseQuery = _buildQuery(searchQuery, filters);
    final countExp = db.persons.person_id.count();
    final result =
        await baseQuery
            .addColumns([countExp])
            .map((row) => row.read(countExp))
            .getSingle();
    return result ?? 0;
  }
}
