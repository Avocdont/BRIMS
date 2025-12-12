import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:brims/database/app_db.dart';
import 'package:brims/repository/profiling repositories/person_repository.dart';

class PersonProvider extends ChangeNotifier {
  PersonProvider() {
    getAllPersons();
  }
  final PersonRepository _personRepository = PersonRepository();

  List<PersonData> _allPersons = [];
  List<PersonData> get allPersons => _allPersons;

  List<PersonData> _currentPersons = [];
  List<PersonData> get currentPersons => _currentPersons;

  getAllPersons() async {
    _allPersons = await _personRepository.allPersons();
    _currentPersons = _allPersons;
    notifyListeners();
  }

  getPersonById(int id) async {
    return await _personRepository.getPersonByID(id);
  }

  addPerson(PersonsCompanion p) async {
    int personId = await _personRepository.addPerson(p);
    getAllPersons();
    log("Person Details: $p");
    return personId;
  }

  updatePerson(PersonsCompanion p) async {
    await _personRepository.updatePerson(p);
    getAllPersons();
  }

  deletePerson(int id) async {
    await _personRepository.deletePerson(id);
    getAllPersons();
  }

  // Variable to hold selected person details
  Map<String, dynamic> _selectedPersonDetails = {};
  Map<String, dynamic> get selectedPersonDetails => _selectedPersonDetails;

  Future<void> loadPersonDetails(int id) async {
    _selectedPersonDetails = await _personRepository.getFullPersonDetails(id);
    notifyListeners();
  }
}
