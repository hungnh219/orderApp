import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:order_app/domain/entities/auth/create_user_req.dart';
import 'package:order_app/domain/repository/auth/auth_repository.dart';
import 'package:order_app/screens/auth/sign_up/cubit/sign_up_state.dart';
import 'package:order_app/services/service_locator.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  void signup(BuildContext context, GlobalKey<FormState> formKey,
      SignUpUserReq signUpUserReq) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(SignUpLoading());
        await serviceLocator<AuthRepository>().signUp(signUpUserReq);
        emit(SignUpSuccess());
        _showAlertDialog(context, "Success",
            "An email has just been sent to you, click the link provided to complete registration");
      }
    } catch (e) {
      emit(SignUpFailure());
      _showAlertDialog(context, "Error", e.toString());
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
              child: const Text("Cancel"),
            )
          ],
        );
      },
    );
  }
}
