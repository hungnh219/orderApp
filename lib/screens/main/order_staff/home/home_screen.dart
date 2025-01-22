import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_cubit.dart';
import 'package:order_app/commons/functions/image_helper.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/domain/repository/auth/auth_repository.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/domain/repository/image/image_repository.dart';
import 'package:order_app/screens/auth/sign_in/sign_in_screen.dart';
import 'package:order_app/screens/main/order_staff/food_detail/food_detail_screen.dart';
import 'package:order_app/screens/main/order_staff/notification/notification_screen.dart';
import 'package:order_app/screens/main/order_staff/pre_order/pre_order_screen.dart';
import 'package:order_app/services/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:multicast_dns/multicast_dns.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const path = 'home_screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const String discoveryService = "_http._tcp";

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<List<Map<FoodModel, int>>> _selectedFoods = ValueNotifier([]);
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
                  child: Text('DANH SÁCH MÓN ĂN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                IconButton(onPressed: () {
                  context.goNamed(NotificationScreen.path);
                }, icon: Icon(Icons.notifications, color: Colors.white,)),
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
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 8 / 11,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final food = snapshot.data![index];
                                                
                              return ValueListenableBuilder<List<Map<FoodModel, int>>>( 
                                valueListenable: _selectedFoods,
                                builder: (context, selectedFoods, _) {
                                  final selectedFoodIndex = selectedFoods.indexWhere(
                                    (item) => item.keys.first.foodId == food.foodId,
                                  );
                                  
                                  final isSelected = selectedFoodIndex != -1;
                                  final quantity = isSelected ? selectedFoods[selectedFoodIndex][food] : 0;
                                                
                                  return GestureDetector(
                                    onTap: ()  {
                                      if (isSelected) {
                                        _selectedFoods.value = List.from(selectedFoods)
                                          ..removeAt(selectedFoodIndex);
                                      } else {
                                        _selectedFoods.value = List.from(selectedFoods)
                                          ..add({food: 1});
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            side: isSelected
                                                ? const BorderSide(
                                                    color: Colors.green, width: 2)
                                                : BorderSide.none,
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
                                                  if (isSelected) 
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            if (quantity! > 1) {
                                                              _selectedFoods.value = List.from(selectedFoods)
                                                                ..[selectedFoodIndex][food] = quantity - 1;
                                                            }
                                                          },
                                                          icon: const Icon(Icons.remove, color: Colors.black,),
                                                        ),
                                                        Text('$quantity'),
                                                        IconButton(
                                                          onPressed: () {
                                                            _selectedFoods.value = List.from(selectedFoods)
                                                              ..[selectedFoodIndex][food] = quantity! + 1;
                                                          },
                                                          icon: const Icon(Icons.add, color: Colors.black,),
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ValueListenableBuilder<List<Map<FoodModel, int>>>( 
                        valueListenable: _selectedFoods,
                        builder: (context, selectedFood, _) {
                          if (selectedFood.isNotEmpty) {
                            return Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                // color: AppColors.orochimaru,
                                color: Colors.transparent,
                              ),
                              padding: const EdgeInsets.fromLTRB(100, 0, 100, 20),
                              child: GestureDetector(
                                onTap: () {
                                  context.goNamed(PreOrderScreen.path, extra: selectedFood);
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppTheme.primary
                                  ),
                                  child: const Center(
                                    child: const Text(
                                      'Tạo đơn',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                    )
                                  ),
                                ),
                              )
                            );
                          }
                          return const SizedBox.shrink();
                        },
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
