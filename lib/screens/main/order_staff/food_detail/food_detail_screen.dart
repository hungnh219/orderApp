import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/services/service_locator.dart';

class FoodDetailScreen extends StatefulWidget {
  FoodDetailScreen({super.key, required this.food, required this.orderItemId});

  static const path = 'food_detail_screen';

  FoodModel food;
  String orderItemId;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late ValueNotifier<List<bool>> selectedToppings;

  @override
  void initState() {
    super.initState();
    selectedToppings = ValueNotifier<List<bool>>([]);
  }

  @override
  void dispose() {
    selectedToppings.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
      ),

      body: Column(
        children: [
          Image.memory(base64Decode(widget.food.image), height: 300, width: double.infinity, fit: BoxFit.cover,),
          Text(widget.food.name, style: TextStyle(fontWeight: FontWeight.bold),),
          Text(widget.food.price.toString() + 'd'),

          Expanded(
            child: FutureBuilder(
              future: serviceLocator.get<FoodRepository>().getToppings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == []) {
                  return const Center(child: Text('No data'));
                } else {
                  if (selectedToppings.value.isEmpty) {
                    selectedToppings.value = List.filled(snapshot.data!.length, false);
                  }

                  return ValueListenableBuilder<List<bool>>(
                    valueListenable: selectedToppings,
                    builder: (context, selectedToppingsList, child) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].name),
                            subtitle: Text(snapshot.data![index].price.toString()),
                            trailing: Checkbox(
                              value: selectedToppingsList[index],
                              onChanged: (value) {
                                selectedToppings.value[index] = value!;
                              },
                            ),
                          );
                        },
                      );
                    }
                  );
                }
              }
            )
          ),  
        ],
      ),
    );
  }
}