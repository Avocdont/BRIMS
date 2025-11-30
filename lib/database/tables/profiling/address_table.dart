import 'package:drift/drift.dart';

@DataClassName('AddressData')
class Addresses extends Table {
  IntColumn get address_id => integer().autoIncrement()();
  TextColumn get brgy => text()();
  TextColumn get zone => text()();
  TextColumn get street => text()();
  IntColumn get block => integer()();
  IntColumn get lot => integer()();
}
