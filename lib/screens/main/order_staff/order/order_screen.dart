import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/cubits/sigin_in/sign_in_cubit.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/screens/main/order_staff/home/home_screen.dart';
import 'package:order_app/services/service_locator.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key, required this.orderItems});

  List<Map<FoodModel, int>> orderItems;

  static const path = 'order_screen';
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ValueNotifier<int> _selectedNumber = ValueNotifier(1);
  List<int> numberList = List.generate(100, (index) => index + 1);

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
                  child: Text('ĐƠN ĐẶT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                IconButton(onPressed: () {
                }, icon: Icon(Icons.notifications, color: Colors.transparent,)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderItems.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.memory(
                              base64Decode(widget.orderItems[index].keys.first.image),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.orderItems[index].keys.first.name, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(widget.orderItems[index].keys.first.price.toString() + 'd' + ' x ' + widget.orderItems[index].values.first.toString()),
                              ],
                            ),
                          ),
                          Text(
                            (widget.orderItems[index].values.first * widget.orderItems[index].keys.first.price).toString() + 'd',
                            style: TextStyle(color: AppTheme.primary),  
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                    // height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                      const Text(
                        'Xác nhận đơn',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: ValueListenableBuilder(
                          valueListenable: _selectedNumber,
                          builder: (context, value, child) {
                            return Center(
                              child: DropdownButton<int>(
                                value: value,
                                hint: const Text('Chọn số thẻ'),
                                isExpanded: false,
                                items: numberList.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Center(child: Text(value.toString())),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  _selectedNumber.value = newValue!;
                                },
                              ),
                            );
                          },
                        ),
                      ),
            
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 16,),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // print("Order confirmed with ${_selectedNumber.value}");
                                  await serviceLocator.get<FoodRepository>().createOrder(widget.orderItems, _selectedNumber.value);
                                  context.pushNamed(HomeScreen.path);
                                },
                                child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                    );
                  },
                );
              },
              child: const Text('Tạo đơn', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}