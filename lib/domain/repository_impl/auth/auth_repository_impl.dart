

import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_app/domain/entities/auth/create_user_req.dart';
import 'package:order_app/domain/entities/auth/sign_in_user_req.dart';
import 'package:order_app/domain/repository/auth/auth_repository.dart';
import 'package:order_app/domain/sources/auth/auth_firebase_service.dart';
import 'package:order_app/services/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<void> signInWithEmailAndPassword(SignInUserReq signInUserReq) async {
    return await serviceLocator<AuthFirebaseService>()
        .signInWithEmailAndPassword(signInUserReq);
  }

  @override
  Future<void> signUp(SignUpUserReq signUpUserReq) async {
    return await serviceLocator<AuthFirebaseService>().signUp(signUpUserReq);
  }

  @override
  Future<void> signInWithGoogle() async {
    return await serviceLocator<AuthFirebaseService>().signInWithGoogle();
  }

  @override
  Future<User?> getCurrentUser() async {
    return serviceLocator<AuthFirebaseService>().getCurrentUser();}
  Future<void> sendPasswordResetEmail(String email) async {
    return await serviceLocator<AuthFirebaseService>()
        .sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() async {
    return await serviceLocator<AuthFirebaseService>().signOut();
  }

  @override
  Future<void> reAuthenticationAndChangeEmail(String email, String newEmail, String password) async{
    return await serviceLocator<AuthFirebaseService>().reAuthenticationAndChangeEmail(email,newEmail, password);
  }

  @override
  Future<void> updateCurrentUserAvatarUrl(String avatarUrl) async{
    return await serviceLocator<AuthFirebaseService>().updateAvatarUrl(avatarUrl);
  }

}
