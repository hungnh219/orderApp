import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_cubit.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/screens/main/order_staff/food_detail/food_detail_screen.dart';
import 'package:order_app/screens/main/order_staff/order/order_screen.dart';
import 'package:order_app/services/service_locator.dart';

class PreOrderScreen extends StatefulWidget {
  PreOrderScreen({super.key, required this.orderItems});

  static const path = 'pre_order_screen';

  List<Map<FoodModel, int>> orderItems;
  @override
  State<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen> {
  // late List<OrderItemModel> orderItems;
  late Future<List<Map<FoodModel, String>>> createOrderItem;
  @override
  void initState() {
    super.initState();
    createOrderItem = serviceLocator.get<FoodRepository>().createOrderItem(widget.orderItems);
    // orderItems = widget.orderItems.map((e) => OrderItemModel(food: e.keys.first, quantity: e.values.first)).toList();
  }
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
                IconButton(onPressed: () {
                  context.pop();
                }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
                const Center(
                  child: Text('KIỂM TRA ĐƠN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                IconButton(onPressed: () {
                }, icon: Icon(Icons.notifications, color: Colors.transparent,)),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: createOrderItem,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == []) {
                  return const Center(child: Text('No data'));
                } else {
                  return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          FoodModel food = snapshot.data![index].keys.first;
                          String orderItemId = snapshot.data![index].values.first;
                      
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Image.memory(
                                        base64Decode(food.image),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(food.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text('${food.price}d'),
                                        ],
                                      ),
                                    ),
                                    IconButton(onPressed: () async {
                                      await context.pushNamed(FoodDetailScreen.path, extra: {
                                        'food': food,
                                        'orderItemId': orderItemId
                                      });
                                    }, icon: Icon(Icons.add, color: AppTheme.primary,))
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
                }
              }),
          ),

          Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${calculateTotalPrice(widget.orderItems)}d', style: TextStyle(fontSize: 20, color: AppTheme.primary),),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                    ),
                    onPressed: () {
                      context.pushNamed(OrderScreen.path, extra: widget.orderItems);
                    },
                    child: const Text('Đặt', style: TextStyle(color: Colors.white),), 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int calculateTotalPrice(List<Map<FoodModel, int>> orderItems) {
    int totalPrice = 0;
    for (var food in orderItems) {
      totalPrice += food.keys.first.price * food.values.first;
    }
    return totalPrice;
  }
}

class FoodItem extends StatelessWidget {
  const FoodItem({Key? key, required this.food, required this.orderItemId}) : super(key: key);

  final FoodModel food;
  final String orderItemId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name),
                Text(food.price.toString()),
              ],
            ),
          ),
          IconButton(onPressed: () {
            context.pushNamed(FoodDetailScreen.path, extra: {
              'food': food,
              'orderItemId': orderItemId
            });
          }, icon: Icon(Icons.add, color: AppTheme.primary,))
        ],
      ),
    );
  }
}