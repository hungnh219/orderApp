import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/domain/entities/topping.dart';

abstract class FoodRepository {
  Future<List<FoodModel>> getFoods();

  Stream<List<FoodModel>> listenFoods();

  Future<List<ToppingModel>> getToppings();

  Stream<int> getTotalOrder(List<OrderItemModel> orderItems);

  Future<List<Map<FoodModel, String>>> createOrderItem(List<Map<FoodModel, int>> orderItems);

  Future<void> createOrder(List<Map<FoodModel, int>> orderItems, int number);

  Stream<List<OrderModel>> listenOrders();

  Future<void> updateOrderStatus(String orderId, String status);
}