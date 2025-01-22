import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:order_app/commons/cubits/auth/auth_state.dart';
import 'package:order_app/domain/repository_impl/auth/auth_repository_impl.dart';
import 'package:order_app/domain/sources/auth/auth_firebase_service.dart';
import 'package:order_app/domain/sources/firestore/firestore_service.dart';
import 'package:order_app/services/service_locator.dart';

import '../../../domain/repository/auth/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository = AuthRepositoryImpl();

  AuthCubit() : super(AuthInitial()) {
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    try {
      User? user = serviceLocator<AuthFirebaseService>().getCurrentUser();
      if (user != null) {
        // password
        if (!user.emailVerified) {
          emit(Unauthenticated());
        }
        await serviceLocator<FirestoreService>().getCurrentUserData();
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      if (e is CustomFirestoreException) {
        emit(Unauthenticated());
      } else {
        emit(Unauthenticated());
        if (kDebugMode) {
          print("Error: $e");
        }
      }
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}
