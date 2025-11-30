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
    log("PersonProvider: Loaded all $_allPersons person records");
    notifyListeners();
  }

  addPerson(PersonsCompanion p) async {
    await _personRepository.addPerson(p);
    getAllPersons();
  }

  updatePerson(PersonsCompanion p) async {
    await _personRepository.updatePerson(p);
    getAllPersons();
  }

  deletePerson(int id) async {
    await _personRepository.deletePerson(id);
    getAllPersons();
  }
}
