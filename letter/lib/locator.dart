import 'package:get_it/get_it.dart';
import 'package:letter/repository/user_repository.dart';
import 'package:letter/services/firebase_auth_service.dart';
import 'package:letter/services/firebase_store_services.dart';
import 'package:letter/services/firestore_db_services.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDBBase());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseStoreServices());
}