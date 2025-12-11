import 'package:brims/models/profile_filter_options.dart';
import 'package:brims/models/profile_table_row.dart';
import 'package:brims/repository/profiling%20repositories/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  // Data State
  List<ProfileTableRow> _profiles = [];
  bool _isLoading = false;
  int _totalRows = 0;

  // Pagination State
  int _currentPageIndex = 0;
  int _rowsPerPage = 10;
  String? _searchQuery;

  // Sorting State
  SortColumn _sortColumn = SortColumn.none;
  SortDirection _sortDirection = SortDirection.asc;

  // Filter State
  ProfileFilterOptions _filters = ProfileFilterOptions();

  // Getters
  List<ProfileTableRow> get profiles => _profiles;
  bool get isLoading => _isLoading;
  int get totalRows => _totalRows;
  int get currentPageIndex => _currentPageIndex;
  int get rowsPerPage => _rowsPerPage;
  SortColumn get sortColumn => _sortColumn;
  SortDirection get sortDirection => _sortDirection;
  ProfileFilterOptions get filters => _filters;

  ProfileProvider() {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();

    _profiles = await _repository.getProfileTableData(
      page: _currentPageIndex,
      limit: _rowsPerPage,
      searchQuery: _searchQuery,
      filters: _filters,
      sortColumn: _sortColumn,
      sortDirection: _sortDirection,
    );

    // Get count specifically for these filters so the paginator knows the real limit
    _totalRows = await _repository.getTotalProfileCount(
      searchQuery: _searchQuery,
      filters: _filters,
    );

    _isLoading = false;
    notifyListeners();
  }

  // --- Actions ---

  void onPageChanged(int firstRowIndex) {
    // PaginatedDataTable gives us the index of the first row (e.g., 0, 10, 20).
    // We convert that to a page index (0, 1, 2).
    _currentPageIndex = firstRowIndex ~/ _rowsPerPage;
    loadProfiles();
  }

  void onRowsPerPageChanged(int newRowsPerPage) {
    _rowsPerPage = newRowsPerPage;
    _currentPageIndex = 0;
    loadProfiles();
  }

  void search(String query) {
    _searchQuery = query;
    _currentPageIndex = 0;
    loadProfiles();
  }

  // Logic: First tap -> Asc, Second -> Desc, Third -> Unsorted
  void sort(SortColumn column) {
    if (_sortColumn != column) {
      // New column, start Ascending
      _sortColumn = column;
      _sortDirection = SortDirection.asc;
    } else {
      // Same column, toggle
      if (_sortDirection == SortDirection.asc) {
        _sortDirection = SortDirection.desc;
      } else {
        // Was descending, now reset to None
        _sortColumn = SortColumn.none;
        _sortDirection = SortDirection.asc; // Default
      }
    }
    loadProfiles();
  }

  void updateFilters(ProfileFilterOptions newFilters) {
    _filters = newFilters;
    _currentPageIndex = 0;
    loadProfiles();
  }
}
