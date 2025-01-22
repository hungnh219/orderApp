
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/topping.dart';

// class OrderItemModel {
//   final String orderItemId;
//   final FoodModel food;
//   List<ToppingModel> toppings;
//   String? note;
//   int get price {
//     int totalPrice = food.price;
//     for (var topping in toppings) {
//       totalPrice += topping.price;
//     }
//     return totalPrice;
//   }

//   OrderItemModel({
//     required this.orderItemId,
//     required this.food,
//     required this.toppings,
//     required this.note,
//   });

//   factory OrderItemModel.fromMap(Map<String, dynamic> map) {
//     return OrderItemModel(
//       orderItemId: map['orderItemId'] ?? '',
//       food: FoodModel.fromMap(map['food']),
//       toppings: map['toppings'] ?? [],
//       note: map['note'] ?? '',
//     );
//   }
// }
class OrderItemModel {
  final String orderItemId;
  final String foodId;
  List<String> toppings;
  String? note;
  

  OrderItemModel({
    required this.orderItemId,
    required this.foodId,
    required this.toppings,
    required this.note,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      orderItemId: map['orderItemId'] ?? '',
      foodId: map['foodId'],
      toppings: map['toppings'] ?? [],
      note: map['note'] ?? '',
    );
  }
}