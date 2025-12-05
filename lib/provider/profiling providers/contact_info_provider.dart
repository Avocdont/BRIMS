import 'dart:developer';

import 'package:brims/repository/profiling%20repositories/contact_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:brims/database/app_db.dart';

class ContactInfoProvider extends ChangeNotifier {
  ContactInfoProvider() {
    loadAllContactInfo();
  }

  final ContactInfoRepository _contactInfoRepository = ContactInfoRepository();

  List<EmailData> _allEmails = [];
  List<EmailData> get allEmails => _allEmails;

  List<EmailData> _currentEmails = [];
  List<EmailData> get currentEmails => _currentEmails;

  List<PhoneNumberData> _allPhoneNumbers = [];
  List<PhoneNumberData> get allPhoneNumbers => _allPhoneNumbers;

  List<PhoneNumberData> _currentPhoneNumbers = [];
  List<PhoneNumberData> get currentPhoneNumbers => _currentPhoneNumbers;

  List<GadgetData> _allGadgets = [];
  List<GadgetData> get allGadgets => _allGadgets;

  List<GadgetData> _currentGadgets = [];
  List<GadgetData> get currentGadgets => _currentGadgets;

  Future<void> loadAllContactInfo() async {
    await getAllEmails();
    await getAllPhoneNumbers();
    await getAllGadgets();
  }

  // ------------ Emails ------------
  getAllEmails() async {
    _allEmails = await _contactInfoRepository.allEmails();
    _currentEmails = _allEmails;
    notifyListeners();
  }

  addEmail(EmailsCompanion ec) async {
    await _contactInfoRepository.addEmail(ec);
    getAllEmails();
    log("Email Details: $ec");
  }

  updateEmail(EmailsCompanion ec) async {
    await _contactInfoRepository.updateEmail(ec);
    getAllEmails();
  }

  deleteEmail(int id) async {
    await _contactInfoRepository.deleteEmail(id);
    getAllEmails();
  }

  // ------------ Phone Numbers ------------
  getAllPhoneNumbers() async {
    _allPhoneNumbers = await _contactInfoRepository.allPhoneNumbers();
    _currentPhoneNumbers = _allPhoneNumbers;
    notifyListeners();
  }

  addPhoneNumber(PhoneNumbersCompanion pnc) async {
    await _contactInfoRepository.addPhoneNumber(pnc);
    getAllPhoneNumbers();
    log("Phone Number Details: $pnc");
  }

  updatePhoneNumber(PhoneNumbersCompanion pnc) async {
    await _contactInfoRepository.updatePhoneNumber(pnc);
    getAllPhoneNumbers();
  }

  deletePhoneNumber(int id) async {
    await _contactInfoRepository.deletePhoneNumber(id);
    getAllPhoneNumbers();
  }

  // ------------ Gadgets ------------
  getAllGadgets() async {
    _allGadgets = await _contactInfoRepository.allGadgets();
    _currentGadgets = _allGadgets;
    notifyListeners();
  }

  addGadget(GadgetsCompanion gc) async {
    await _contactInfoRepository.addGadget(gc);
    getAllGadgets();
    log("Gadget Details: $gc");
  }

  updateGadget(GadgetsCompanion gc) async {
    await _contactInfoRepository.updateGadget(gc);
    getAllGadgets();
  }

  deleteGadget(int id) async {
    await _contactInfoRepository.deleteGadget(id);
    getAllGadgets();
  }
}
