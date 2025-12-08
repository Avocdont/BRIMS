// lib/provider/profiling providers/profile_provider.dart

import 'package:brims/models/profile_table_row.dart';
import 'package:brims/repository/profiling%20repositories/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  // State Variables
  List<ProfileTableRow> _profiles = [];
  bool _isLoading = false;
  int _totalRows = 0;

  // Pagination State
  int _currentPageIndex = 0; // 0, 1, 2...
  int _rowsPerPage = 10;
  String? _searchQuery;

  // Getters
  List<ProfileTableRow> get profiles => _profiles;
  bool get isLoading => _isLoading;
  int get totalRows => _totalRows;
  int get currentPageIndex => _currentPageIndex;
  int get rowsPerPage => _rowsPerPage;

  ProfileProvider() {
    loadProfiles();
  }

  /// Main function to fetch data based on current state
  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();

    // 1. Get the data
    _profiles = await _repository.getProfileTableData(
      page: _currentPageIndex,
      limit: _rowsPerPage,
      searchQuery: _searchQuery,
    );

    // 2. Get total count (for the pagination footer "1-10 of 500")
    // Note: If searching, this count logic might need adjustment to count filtered results
    _totalRows = await _repository.getTotalProfileCount();

    _isLoading = false;
    notifyListeners();
  }

  /// Update Page
  void onPageChanged(int newPageIndex) {
    _currentPageIndex = newPageIndex;
    loadProfiles();
  }

  /// Update Rows Per Page
  void onRowsPerPageChanged(int newRowsPerPage) {
    _rowsPerPage = newRowsPerPage;
    _currentPageIndex = 0; // Reset to first page
    loadProfiles();
  }

  /// Handle Search
  void search(String query) {
    _searchQuery = query;
    _currentPageIndex = 0; // Reset to first page results
    loadProfiles();
  }
}
