import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_cubit.dart';
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/screens/auth/auth/auth_screen.dart';
import 'package:order_app/screens/auth/boarding/boarding_screen.dart';
import 'package:order_app/screens/auth/sign_in/sign_in_screen.dart';
import 'package:order_app/screens/auth/sign_up/sign_up_screen.dart';
import 'package:order_app/screens/auth/splash/splash_screen.dart';
import 'package:order_app/screens/main/admin/add_food/add_food_screen.dart';
import 'package:order_app/screens/main/admin/home/admin_home_screen.dart';
import 'package:order_app/screens/main/admin/update_food/update_food_screen.dart';
import 'package:order_app/screens/main/order_detail.dart';
import 'package:order_app/screens/main/order_staff/food_detail/food_detail_screen.dart';
import 'package:order_app/screens/main/order_staff/home/home_screen.dart';
import 'package:order_app/screens/main/order_staff/notification/notification_screen.dart';
import 'package:order_app/screens/main/order_staff/order/order_screen.dart';
import 'package:order_app/screens/main/order_staff/pre_order/pre_order_screen.dart';
import 'package:order_app/screens/main/prep_staff/notification/notification_screen.dart';

class MyRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return _wrapWithWillPopScope(context, const SplashScreen());
        },
        routes: <RouteBase>[
          GoRoute(
            name: BoardingScreen.path,
            path: BoardingScreen.path,
            builder: (BuildContext context, GoRouterState state) {
              return _wrapWithWillPopScope(context, const BoardingScreen());
            },
          ),
          GoRoute(
            name: AuthScreen.path,
            path: AuthScreen.path,
            builder: (BuildContext context, GoRouterState state) {
              return  const AuthScreen();
            },
          ),
          GoRoute(
            name: SignInScreen.path,
            path: SignInScreen.path,
            builder: (BuildContext context, GoRouterState state) {
              return _wrapWithWillPopScope(
                context,
                BlocProvider(
                  create: (_) => SignInCubit(),
                  child: const SignInScreen(),
                ),
              );
            },
            routes: [
              GoRoute(
                name: HomeScreen.path,
                path: HomeScreen.path,
                builder: (BuildContext context, GoRouterState state) {
                  return _wrapWithWillPopScope(context, const HomeScreen());
                },
                routes: [
                  GoRoute(
                    name: PreOrderScreen.path,
                    path: PreOrderScreen.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return PreOrderScreen(orderItems: state.extra as List<Map<FoodModel, int>>,);
                    },
                    routes: [
                      GoRoute(
                        name: FoodDetailScreen.path,
                        path: FoodDetailScreen.path,
                        builder: (BuildContext context, GoRouterState state) {
                          final extra = state.extra as Map<String, dynamic>;
                          final food = extra['food'] as FoodModel;
                          final orderItemId = extra['orderItemId'] as String;
                          return FoodDetailScreen(food: food, orderItemId: orderItemId);
                        },
                      ),
                      GoRoute(
                        name: OrderScreen.path,
                        path: OrderScreen.path,
                        builder: (BuildContext context, GoRouterState state) {
                          return OrderScreen(orderItems: state.extra as List<Map<FoodModel, int>>,);
                        },
                      ),
                    ]
                  ),
                  GoRoute(
                    name: NotificationScreen.path,
                    path: NotificationScreen.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return const NotificationScreen();
                    },
                  ),
                  GoRoute(
                    name: SignUpScreen.path,
                    path: SignUpScreen.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return const SignUpScreen();
                    },
                  ),
                  GoRoute(
                    name: PrepNotificationScreen.path,
                    path: PrepNotificationScreen.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return const PrepNotificationScreen();
                    },
                  ),
                  GoRoute(
                    name: OrderDetailScreen.path,
                    path: OrderDetailScreen.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return OrderDetailScreen(orderItems: state.extra as OrderModel);
                    },
                  )
                ]
              ),
              GoRoute(
                name: AdminHomeScreen.path,
                path: AdminHomeScreen.path,
                builder: (BuildContext context, GoRouterState state) {
                  return _wrapWithWillPopScope(context, const AdminHomeScreen());
                },
                routes: [
                  GoRoute(
                    path: UpdateFoodScreen.path, 
                    name: UpdateFoodScreen.path,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      final food = extra['food'] as FoodModel;
                      return UpdateFoodScreen(food: food);
                    },
                  ),
                  GoRoute(
                    path: AddFoodScreen.path, 
                    name: AddFoodScreen.path,
                    builder: (context, state) {
                      return AddFoodScreen();
                    },
                  ),
                ]
              ),
            ]
          ),
          
        ],
      ),
    ],
  );

  static Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to exit this application?"),
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
                SystemNavigator.pop();  // Exits the app
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  // Helper function to wrap screens with WillPopScope
  static Widget _wrapWithWillPopScope(BuildContext context, Widget screen) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: screen,
    );
  }
}
