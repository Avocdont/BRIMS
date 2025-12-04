import 'package:drift/drift.dart';
import 'package:brims/database/tables/profiling/person_table.dart';
import 'package:brims/database/tables/enums.dart';

@DataClassName('EmailData')
class Emails extends Table {
  IntColumn get email_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get email_address => text().unique()();
}

@DataClassName('PhoneNumberData')
class PhoneNumbers extends Table {
  IntColumn get phone_number_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  IntColumn get phone_num => integer().unique()();
}

@DataClassName('GadgetData')
class Gadgets extends Table {
  IntColumn get gadget_id => integer().autoIncrement()();
  IntColumn get person_id =>
      integer().references(Persons, #person_id, onDelete: KeyAction.cascade)();
  TextColumn get gadget => textEnum<Gadget>().nullable()();
}
