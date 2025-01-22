
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/entities/auth/create_user_req.dart';
import 'package:order_app/mixin/validators/validators.dart';
import 'package:order_app/screens/auth/sign_in/sign_in_screen.dart';
import 'package:order_app/screens/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:order_app/screens/auth/sign_up/cubit/sign_up_state.dart';
import 'package:order_app/screens/widgets/auth/auth_body.dart';
import 'package:order_app/screens/widgets/auth/auth_elevated_button.dart';
import 'package:order_app/screens/widgets/auth/auth_header_image.dart';
import 'package:order_app/screens/widgets/auth/auth_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const path = 'sign_up_screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Validator {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late ValueNotifier<bool> _obscureText;
  late ValueNotifier<bool> _obscureConfirmText;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _obscureText = ValueNotifier<bool>(true);
    _obscureConfirmText = ValueNotifier<bool>(true);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscureText.dispose();
    _obscureConfirmText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        AuthHeaderImage(
          height: 0.42,
          childAspectRatio: 1.41,
          positioned: Positioned.fill(
            top: -45,
            child: Center(
              child: Text(
                "WELCOME",
                style: AppTheme.authHeaderStyle,
              ),
            ),
          ),
        ),
        AuthBody(
          marginTop: MediaQuery.of(context).size.height * 0.28,
          height: double.infinity,
          column: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextFormField(
                      textEditingController: _emailController,
                      hintText: "Email",
                      textInputAction: TextInputAction.next,
                      validator: (value) => validateEmail(value),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ValueListenableBuilder(
                      valueListenable: _obscureText,
                      builder: (context, value, child) {
                        return AuthTextFormField(
                          textEditingController: _passwordController,
                          hintText: "Mật khẩu",
                          obscureText: value,
                          textInputAction: TextInputAction.next,
                          validator: (value) => validatePassword(value),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _obscureText.value = !value;
                            },
                            icon: Icon(value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ValueListenableBuilder(
                      valueListenable: _obscureConfirmText,
                      builder: (context, value, child) {
                        return AuthTextFormField(
                          textEditingController: _confirmPasswordController,
                          hintText: "Mật khẩu",
                          obscureText: value,
                          textInputAction: TextInputAction.done,
                          validator: (value) => validateConfirmPassword(
                              _passwordController.text, value),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _obscureConfirmText.value = !value;
                            },
                            icon: Icon(value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) => AuthElevatedButton(
                  width: double.infinity,
                  height: 45,
                  inputText: "Đăng ký",
                  onPressed: () => context.read<SignUpCubit>().signup(
                      context,
                      _formKey,
                      SignUpUserReq(
                          email: _emailController.text,
                          password: _passwordController.text)),
                  isLoading: (state is SignUpLoading ? true : false),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Có tài khoản rồi?",
                    style: AppTheme.authSignUpStyle
                        .copyWith(color: AppColors.kettleman),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed(SignInScreen.path),
                    child: Text(
                      "ĐĂNG NHẬP",
                      style: AppTheme.authSignUpStyle,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
