import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/repository/auth/auth_repository.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/screens/auth/sign_in/sign_in_screen.dart';
import 'package:order_app/screens/main/admin/add_food/add_food_screen.dart';
import 'package:order_app/screens/main/admin/update_food/update_food_screen.dart';
import 'package:order_app/screens/main/order_staff/notification/notification_screen.dart';
import 'package:order_app/services/service_locator.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  static const path = 'admin_home_screen';
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 48,
            color: AppTheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () async {
                  await serviceLocator.get<AuthRepository>().signOut();
                  context.goNamed(SignInScreen.path);
                }, icon: Icon(Icons.logout, color: Colors.white,)),
                const Center(
                  child: Text('ADMIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                IconButton(onPressed: () {
                  context.goNamed(NotificationScreen.path);
                }, icon: Icon(Icons.add, color: Colors.transparent,)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: serviceLocator.get<FoodRepository>().listenFoods(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('There is no food'),
                  );
                } else {
                  return Stack(
                    children: [
                      Container(
                        color: AppColors.orochimaru,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 8 / 11,
                            ),
                            itemCount: snapshot.data!.length + 1,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data!.length) {
                                return GestureDetector(
                                  onTap: () {
                                    context.goNamed(AddFoodScreen.path);
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color: AppTheme.primary,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.add, color: Colors.white, size: 36),
                                          SizedBox(height: 8),
                                          Text(
                                            'Thêm sản phẩm',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final food = snapshot.data![index];
                      
                              return GestureDetector(
                                onTap: ()  {
                                  context.goNamed(UpdateFoodScreen.path, extra: {'food': food});
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Image.memory(
                                                  base64Decode(food.image),
                                                  height: 120,
                                                  width: 160,
                                                  fit: BoxFit.cover,
                                                                                                 ),
                                              ),
                                              Text(
                                                food.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '${food.price}d',
                                                style:
                                                    const TextStyle(fontSize: 10),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ]
                  );
                }
              },
            ),
          ),
          
        ],
      ),
    );
  }
}
