import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/domain/repository/auth/auth_repository.dart';
import 'package:order_app/domain/repository/user/user_repository.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_state.dart';
import 'package:order_app/screens/main/admin/home/admin_home_screen.dart';
import 'package:order_app/services/service_locator.dart';

import '../../../domain/entities/auth/sign_in_user_req.dart';
import '../../../domain/sources/firestore/firestore_service.dart';
// import '../../../../domain/repository/user/user.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  void reset() {
    emit(SignInInitial()); // Reset to initial state
  }

  void loginWithEmailAndPassword(BuildContext context,
      GlobalKey<FormState> formKey, SignInUserReq signInUserReq) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(SignInLoading());
        await serviceLocator<AuthRepository>().signInWithEmailAndPassword(signInUserReq);
        await serviceLocator<UserRepository>().getCurrentUserData();
        emit(SignInSuccess());
        print('admin home screen');
        context.pushNamed(AdminHomeScreen.path);
      }
    } catch (e) {
      if (e is CustomFirestoreException) {
        if (e.code == 'new-user') {
          emit(SignInSuccess());
        // remove data
        context.pushNamed(AdminHomeScreen.path);
        }
      } else {
        emit(SignInFailure());
        _showAlertDialog(context, "Error", e.toString());
      }
    }
  }

  void loginWithGoogle(BuildContext context) async {
    try {
      await serviceLocator<AuthRepository>().signInWithGoogle();
      await serviceLocator<UserRepository>().getCurrentUserData();
      emit(SignInSuccess());
      // context.go("/signin/navigator");
        context.pushNamed(AdminHomeScreen.path);
    } catch (e) {
      if (e is CustomFirestoreException) {
        if (e.code == 'new-user') {
          emit(SignInSuccess());
        context.pushNamed(AdminHomeScreen.path);
        }
      } else {
        emit(SignInFailure());
        throw Exception(e);
      }
    }
  }

  void _showAlertDialog(BuildContext context, String? title, String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "$title",
            textAlign: TextAlign.center,
          ),
          content: Text("$message"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}
