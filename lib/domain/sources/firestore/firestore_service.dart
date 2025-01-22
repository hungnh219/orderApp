import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:order_app/domain/entities/food.dart';
import 'package:order_app/domain/entities/order.dart';
import 'package:order_app/domain/entities/order_item.dart';
import 'package:order_app/domain/entities/topping.dart';
import 'package:order_app/domain/sources/storage/storage_service.dart';

import '../../entities/user.dart';
import '../../entities/user_firestore/add_user_data.dart';


abstract class FirestoreService {
  Future<UserModel?>? getUserData(String userID);

  Future<UserModel?>? getCurrentUserData();

  Future<UserModel?> fetchUserData(String userID);

  Future<void> addCurrentUserData(AddUserReq addUserReq);

  Future<List<FoodModel>> getFoods();

  Stream<List<FoodModel>> listenFoods();

  Future<void> uploadImageToFirebase(String assetPath);

  Future<List<ToppingModel>> getToppings();

  Stream<int> getTotalOrder(List<OrderItemModel> orderItems);

  Future<List<Map<FoodModel, String>>> createOrderItem(List<Map<FoodModel, int>> orderItems);

  Future<void> createOrder(List<Map<FoodModel, int>> orderItems, int number);

  Stream<List<OrderModel>> listenOrders();

  Future<String> checkRoleUser();

  Future<void> updateOrderStatus(String orderId, String status);

}

class FirestoreServiceImpl extends FirestoreService {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final StorageService _storage = StorageServiceImpl();

  User? get currentUser => _auth.currentUser;

  // CollectionReference get _usersCollection => _firestoreDB.collection('User');
  // ToDo : Reference Define
  CollectionReference get _usersRef => _firestoreDB.collection('User');

  CollectionReference get _foodRef => _firestoreDB.collection('Food');

  CollectionReference get _imageRef => _firestoreDB.collection('Image');

  CollectionReference get _toppingRef => _firestoreDB.collection('Topping');

  CollectionReference get _orderItemRef => _firestoreDB.collection('OrderItem');

  CollectionReference get _orderRef => _firestoreDB.collection('Order');

  // ToDo: Service Functions
  @override
  Future<UserModel?> getUserData(String userID) async {
    try {
      return await fetchUserData(userID);
    } on CustomFirestoreException catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return null;
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      return await fetchUserData(currentUser!.uid);
    } on CustomFirestoreException catch (error) {
      if (error.code == 'new-user') {
        rethrow;
      }
      if (kDebugMode) {
        print(error.toString());
      }
      return null;
    }
  }

  // No need add to repository
  @override
  Future<UserModel?> fetchUserData(String userID) async {
    try {
      DocumentSnapshot userDoc = await _usersRef.doc(userID).get();

      if (!userDoc.exists) {
        throw CustomFirestoreException(
          code: 'new-user',
          message: 'User data does not exist in Firestore',
        );
      }

      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addCurrentUserData(AddUserReq addUserReq) async {
    if (currentUser == null) {
      if (kDebugMode) {
        print("No user is currently signed in.");
      }
      return;
    }

    Map<String, dynamic> userData = addUserReq.newUserData.toMap();
    await _usersRef
        .doc(currentUser?.uid)
        .set(userData)
        .then((value) => print("User Added"))
        .catchError((error) => print("Error pushing user data: $error"));
  }

  @override
  Future<List<FoodModel>> getFoods() async {
    List<FoodModel> foods = [];

    try {
      QuerySnapshot foodSnapshot = await _foodRef.get();
      for (var doc in foodSnapshot.docs) {
        Map<String, dynamic> foodData = doc.data() as Map<String, dynamic>;
        foodData['foodId'] = doc.id;  
        
        foods.add(FoodModel.fromMap(foodData));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching collection data: $e");
      }
    }

    return foods;
  }

  @override
  Stream<List<FoodModel>> listenFoods() {
    return _foodRef
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) {
      Map<String, dynamic> foodData = doc.data() as Map<String, dynamic>;
      foodData['foodId'] = doc.id;
      return FoodModel.fromMap(foodData);
    }).toList());
  }

  @override
  Future<void> uploadImageToFirebase(String assetPath) async {
    try {
      ByteData byteData = await rootBundle.load(assetPath);

      Uint8List imageBytes = byteData.buffer.asUint8List();

      String base64Image = base64Encode(imageBytes);
      await _imageRef.add({
        "path": base64Image
      });
    } catch(e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Future<List<ToppingModel>> getToppings() async {
    List<ToppingModel> toppings = [];

    try {
      QuerySnapshot toppingSnapshot = await _toppingRef.get();
      for (var doc in toppingSnapshot.docs) {
        Map<String, dynamic> toppingData = doc.data() as Map<String, dynamic>;
        toppingData['toppingId'] = doc.id;
        
        toppings.add(ToppingModel.fromMap(toppingData));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching collection data: $e");
      }
    }

    return toppings;
  }

  @override
  Stream<int> getTotalOrder(List<OrderItemModel> orderItems) {
    int totalPrice = 0;
    for (OrderItemModel orderItem in orderItems) {
      String foodId = orderItem.foodId;

      _foodRef.doc(foodId).get().then((doc) {
        if (doc.exists) {
          FoodModel food = FoodModel.fromMap(doc.data() as Map<String, dynamic>);
          totalPrice += food.price;
        }
      });
    }

    return Stream.value(totalPrice);
  }

  @override
  Future<List<Map<FoodModel, String>>> createOrderItem(List<Map<FoodModel, int>> orderItems) async {
    List<Map<FoodModel, String>> orderItemIds = [];
    try {
      for (Map<FoodModel, int> orderItem in orderItems) {
        FoodModel food = orderItem.keys.first;
        int quantity = orderItem.values.first;

        if (quantity == 1) {
          DocumentReference docRef = await _orderItemRef.add({
            'foodId': food.foodId,
            'topping': [],
            'note': '',
          });
          orderItemIds.add({food: docRef.id});
        } else {
          for (int i = 0; i < quantity; i++) {
            DocumentReference docRef = await _orderItemRef.add({
              'foodId': food.foodId,
              'topping': [],
              'note': '',
            });
            orderItemIds.add({food: docRef.id});
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating order item: $e");
      }
    }
    return orderItemIds;
  }
  
  @override
  Future<void> createOrder(List<Map<FoodModel, int>> orderItems, int number) async {
    List<Map<String, int>> orderItemIds = [];
    try {
      for (Map<FoodModel, int> orderItem in orderItems) {
        FoodModel food = orderItem.keys.first;
        int quantity = orderItem.values.first;

        orderItemIds.add({food.foodId: quantity});
      }

      await _orderRef.add({
        'orderItems': orderItemIds,
        'number': number,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error creating order: $e");
      }
    }
  }

  @override
  Stream<List<OrderModel>> listenOrders() {
    return _orderRef.snapshots().asyncMap((snapshot) async {
      final List<OrderModel> orders = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
        orderData['orderId'] = doc.id;
        List<Map<FoodModel, int>> orderItems = [];
        for (var item in orderData['orderItems']) {
          String foodId = item.keys.first;
          int quantity = item.values.first;

          FoodModel food = await _foodRef.doc(foodId).get().then((doc) {
            if (doc.exists) {
              Map<String, dynamic> foodData = doc.data() as Map<String, dynamic>;
              foodData['foodId'] = doc.id;
              return FoodModel.fromMap(foodData);
            } else {
              throw CustomFirestoreException(
                code: 'food-not-found',
                message: 'Food not found in Firestore',
              );
            }
          });
          

          orderItems.add({food: quantity});
        }

        orderData['orderItems'] = orderItems;

        orders.add(OrderModel.fromMap({
          'orderId': orderData['orderId'],
          'number': orderData['number'],
          'orderItems': orderData['orderItems'],
          'status': orderData['status'],
          'createdAt': orderData['createdAt'],
        }));
      }
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    });
  }

  @override
  Future<String> checkRoleUser() async {
    return _usersRef.doc(currentUser!.uid).get().then((value) {
      if (value.exists) {
        return value['role'];
      } else {
        throw CustomFirestoreException(
          code: 'role-not-found',
          message: 'User role not found in Firestore',
        );
      }
    });
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _orderRef.doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error updating order status: $e");
      }
    }
  }
}

class CustomFirestoreException implements Exception {
  final String code;
  final String message;

  CustomFirestoreException({required this.code, required this.message});

  @override
  String toString() {
    return 'CustomFirestoreException($code): $message';
  }
}

