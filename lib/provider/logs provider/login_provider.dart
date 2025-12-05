import 'package:brims/database/app_db.dart';
import 'package:brims/repository/logs%20repositories/login_repository.dart';

import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    loadAllLoginCredentials();
  }

  final LoginRepository _loginRepository = LoginRepository();

  List<LoginCredentialData> _allLoginCredentials = [];
  List<LoginCredentialData> get allLoginCredentials => _allLoginCredentials;

  List<LoginCredentialData> _currentLoginCredentials = [];
  List<LoginCredentialData> get currentLoginCredentials =>
      _currentLoginCredentials;

  Future<void> loadAllLoginCredentials() async {
    await getAllLoginCredentials();
  }

  // ------------ Login Credentials ------------
  getAllLoginCredentials() async {
    _allLoginCredentials = await _loginRepository.allLoginCredential();
    _currentLoginCredentials = _allLoginCredentials;
    notifyListeners();
  }

  addLoginCredential(LoginCredentialsCompanion lcc) async {
    await _loginRepository.addLoginCredential(lcc);
    await getAllLoginCredentials();
  }

  updateLoginCredential(LoginCredentialsCompanion lcc) async {
    await _loginRepository.updateLoginCredential(lcc);
    await getAllLoginCredentials();
  }

  deleteLoginCredential(int id) async {
    await _loginRepository.deleteLoginCredential(id);
    await getAllLoginCredentials();
  }
}
