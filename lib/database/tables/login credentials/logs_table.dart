import 'package:brims/database/tables/enums.dart';
import 'package:brims/database/tables/login%20credentials/login_table.dart';
import 'package:drift/drift.dart';

@DataClassName('LogInformationData')
class LogInformation extends Table {
  IntColumn get log_information_id => integer().autoIncrement()();
  DateTimeColumn get change_date =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get login_id =>
      integer().references(
        LoginCredentials,
        #login_id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get page_changed => textEnum<PageChanged>()();
  TextColumn get change_type => textEnum<ChangeType>()();
}
