import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/constants/icon_path.dart';
import 'package:order_app/domain/entities/auth/sign_in_user_req.dart';
import 'package:order_app/mixin/validators/validators.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_cubit.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_state.dart';
import 'package:order_app/screens/auth/sign_up/sign_up_screen.dart';
import 'package:order_app/screens/main/order_staff/home/home_screen.dart';
import 'package:order_app/screens/main/prep_staff/notification/notification_screen.dart';
import 'package:order_app/screens/widgets/auth/auth_body.dart';
import 'package:order_app/screens/widgets/auth/auth_elevated_button.dart';
import 'package:order_app/screens/widgets/auth/auth_header_image.dart';
import 'package:order_app/screens/widgets/auth/auth_text_form_field.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/commons/styles/themes.dart';

// import '../../../presentation/widgets/auth/auth_body.dart';
// import '../../../presentation/widgets/auth/auth_elevated_button.dart';
// import '../../../presentation/widgets/auth/auth_header_image.dart';
// import '../../../presentation/widgets/auth/auth_text_form_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const path = 'sign_in_screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with Validator {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late ValueNotifier<bool> _obscureText;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _obscureText = ValueNotifier<bool>(true);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscureText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope.new(
      onWillPop: _onWillPop,
      child: Material(
        child: Stack(
          children: [
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
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Đăng nhập vai trò admin",
                          style: AppTheme.authSignUpStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (validateEmpty(value)) {
                                  return "Nhập mật khẩu của bạn";
                                }
                                return null;
                              },
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<SignInCubit, SignInState>(
                    builder: (context, state) {
                      return AuthElevatedButton(
                        width: double.infinity,
                        height: 45,
                        inputText: "ĐĂNG NHẬP",
                        onPressed: () => context
                            .read<SignInCubit>()
                            .loginWithEmailAndPassword(
                              context,
                              _formKey,
                              SignInUserReq(
                                email: _emailController.text,
                                password: _passwordController.text),
                            ),
                        isLoading: (state is SignInLoading ? true : false),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                 
                  IconButton(
                    onPressed: () =>
                        context.read<SignInCubit>().loginWithGoogle(context),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lavenderMist,
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return AppTheme.mainGradient.createShader(bounds);
                        },
                        child: SvgPicture.asset(
                          AppIcons.googleLogo,
                          width: 20.0,
                          height: 20.0,
                          color: const Color.fromARGB(255, 89, 28, 219),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Chưa có tài khoản?",
                        style: AppTheme.authSignUpStyle
                            .copyWith(color: AppColors.kettleman),
                      ),
                      TextButton(
                        onPressed: () => context.pushNamed(SignUpScreen.path),
                        child: Text(
                          "Đăng ký",
                          style: AppTheme.authSignUpStyle,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: AppColors.kettleman,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Đăng nhập vai trò nhân viên",
                    style: AppTheme.authSignUpStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed(HomeScreen.path),
                        child: const Text(
                        "ORDER",
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed(PrepNotificationScreen.path),
                        child: const Text(
                        "PREP",
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you want to exit this application"),
              actions: <Widget>[
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    SystemNavigator.pop();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
