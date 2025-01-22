import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/screens/auth/splash/splash_background.dart';
import 'package:order_app/screens/auth/splash/splash_image_group.dart';
import 'package:order_app/screens/auth/sign_in/sign_in_screen.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  static const path = 'boarding_screen';

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      column: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SplashImageGroup(),
          const SizedBox(
            height: 20,
          ),
          // const Text(
          //   "SHARE - INSPIRE - CONNECT",
          //   style: TextStyle(
          //     color: AppColors.white,
          //     fontSize: 14,
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    AppColors.ancestralWater.withOpacity(0.3)),
              ),
              onPressed: () => context.pushNamed(SignInScreen.path),
              child: const Text(
                "BẮT ĐẦU",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
