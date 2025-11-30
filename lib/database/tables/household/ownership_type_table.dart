import 'package:drift/drift.dart';

class OwnershipTypes extends Table {
  IntColumn get ownership_type_id => integer().autoIncrement()();
  TextColumn get name => text()();
}
