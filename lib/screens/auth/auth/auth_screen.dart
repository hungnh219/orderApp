import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/screens/main/admin/home/admin_home_screen.dart';
import 'package:order_app/screens/main/order_staff/home/home_screen.dart';
import '../sign_in/sign_in_screen.dart';
import '../../../commons/cubits/auth/auth_cubit.dart';
import '../../../commons/cubits/auth/auth_state.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const path = 'auth_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is Authenticated) {
            context.pushNamed(AdminHomeScreen.path);
          } 
          else if (state is Unauthenticated) {
            context.pushNamed(SignInScreen.path);
          }
        });
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
