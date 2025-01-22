import 'package:get_it/get_it.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/domain/repository/image/image_repository.dart';
import 'package:order_app/domain/repository_impl/auth/auth_repository_impl.dart';
import 'package:order_app/domain/repository_impl/food/food_repository_impl.dart';
import 'package:order_app/domain/repository_impl/image/image_repository_impl.dart';
import 'package:order_app/domain/repository_impl/user/user_repository_impl.dart';
import 'package:order_app/domain/sources/auth/auth_firebase_service.dart';
import 'package:order_app/domain/sources/firestore/firestore_service.dart';
import 'package:order_app/domain/sources/storage/storage_service.dart';
import 'package:order_app/domain/repository/auth/auth_repository.dart';
import 'package:order_app/domain/repository/user/user_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  serviceLocator
      .registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  serviceLocator.registerSingleton<FirestoreService>(FirestoreServiceImpl());
  serviceLocator.registerSingleton<StorageService>(StorageServiceImpl());

  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  serviceLocator.registerSingleton<UserRepository>(UserRepositoryImpl());

  serviceLocator.registerSingleton<FoodRepository>(FoodRepositoryImpl());

  serviceLocator.registerSingleton<ImageRepository>(ImageRepositoryImpl());
}


