import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/screens/auth/auth/auth_screen.dart';
import 'package:order_app/screens/auth/boarding/boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:order_app/screens/auth/splash/splash_background.dart';
import 'package:order_app/screens/auth/splash/splash_image_group.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SplashBackground(
        center: Center(
          child: SplashImageGroup(),
        ),
      ),
    );
  }

  void initialization() async {
    FlutterNativeSplash.remove();
    await Future.delayed(const Duration(seconds: 2));

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        await prefs.setBool('isFirstLaunch', false);
        // context.go("/boarding");
        context.pushNamed(BoardingScreen.path);
      } else {
        // context.go("/auth");
        context.pushNamed(AuthScreen.path);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi: $e");
      }
    }
  }
}
