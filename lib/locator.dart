import 'package:get_it/get_it.dart';
import 'package:brims/database/app_db.dart';

GetIt locator =
    GetIt
        .instance; // Makes a global single instance that will serve as an accessor to GetIt services

void setUp() {
  locator.registerLazySingleton(
    () => AppDatabase(),
  ); //only a single instance of this object will be made but only when someone asks for it
}
