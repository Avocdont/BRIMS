import 'package:brims/database/tables/enums.dart';
import 'package:drift/drift.dart';

@DataClassName('LoginCredentialData')
class LoginCredentials extends Table {
  IntColumn get login_id => integer().autoIncrement()();
  TextColumn get user_type => textEnum<UserType>()();
  TextColumn get username => text().unique()();
  TextColumn get password => text().nullable().withLength(min: 8, max: 20)();
}
