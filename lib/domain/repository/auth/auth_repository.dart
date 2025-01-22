import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_app/domain/entities/auth/create_user_req.dart';
import 'package:order_app/domain/entities/auth/sign_in_user_req.dart';


abstract class AuthRepository {
  Future<void> signUp(SignUpUserReq signUpUserReq);

  Future<void> signInWithEmailAndPassword(SignInUserReq signInUserReq);

  Future<void> signInWithGoogle();

  Future<User?> getCurrentUser();

  Future<void> signOut();

  Future<void> reAuthenticationAndChangeEmail(String email, String newEmail, String password);

  Future<void> updateCurrentUserAvatarUrl(String avatarUrl);
}
