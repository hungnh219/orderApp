import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/screens/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:order_app/routers/app_routes.dart';
import 'package:order_app/services/firebase_options.dart';
import 'package:order_app/commons/cubits/auth/auth_cubit.dart';
import 'package:order_app/commons/cubits/auth/theme_cubit.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_cubit.dart';
import 'package:order_app/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'order app',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await initializeDependencies();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => SignInCubit()),
        BlocProvider(create: (_) => SignUpCubit()),
        // BlocProvider(create: (_) => ForgotPasswordCubit()),
        // BlocProvider(create: (_) => EditPageCubit()),

      ],
      child: SafeArea(
        child:  BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              // darkTheme:
              // themeMode: mode,
              // home: const SplashPage()
              routerConfig: MyRouter.router,
              // home: const SplashScreen(),
            ),
          ),
      ),
    );
  }
}
