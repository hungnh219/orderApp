import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/domain/entities/topping.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/domain/sources/firestore/firestore_service.dart';
import 'package:order_app/services/service_locator.dart';

class FoodRepositoryImpl extends FoodRepository {
  @override
  Future<List<FoodModel>> getFoods() {
    return serviceLocator.get<FirestoreService>().getFoods();
  }

  @override
  Stream<List<FoodModel>> listenFoods() {
    return serviceLocator.get<FirestoreService>().listenFoods();
  }

  @override
  Future<List<ToppingModel>> getToppings() {
    return serviceLocator.get<FirestoreService>().getToppings();
  }

  @override
  Stream<int> getTotalOrder(List<OrderItemModel> orderItems) {
    return serviceLocator.get<FirestoreService>().getTotalOrder(orderItems);
  }

  @override
  Future<List<Map<FoodModel, String>>> createOrderItem(List<Map<FoodModel, int>> orderItems) {
    return serviceLocator.get<FirestoreService>().createOrderItem(orderItems);
  }

  @override
  Future<void> createOrder(List<Map<FoodModel, int>> orderItems, int number) {
    return serviceLocator.get<FirestoreService>().createOrder(orderItems, number);
  }

  @override
  Stream<List<OrderModel>> listenOrders() {
    return serviceLocator.get<FirestoreService>().listenOrders();
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return serviceLocator.get<FirestoreService>().updateOrderStatus(orderId, status);
  }
}