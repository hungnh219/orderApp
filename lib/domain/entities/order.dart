import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_app/domain/entities/food.dart';

class OrderModel {
  final String orderId;
  final int number;
  final List<Map<FoodModel, int>> orderItems;
  String status;
  final Timestamp createdAt;

  OrderModel({
    required this.orderId,
    required this.number,
    required this.orderItems,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
  return OrderModel(
    orderId: map['orderId'] ?? '',
    number: map['number'] ?? 0,
    orderItems: map['orderItems'] ?? [],
    status: map['status'] ?? '',
    createdAt: map['createdAt'] ?? Timestamp.now(),
  );
}

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'number': number,
      'orderItems': orderItems,
      'status': status,
      'createdAt': createdAt,
    };
  }
}