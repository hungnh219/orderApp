
class FoodModel {
  final String foodId;
  final String name;
  final String image;
  final int price;

  FoodModel({
    required this.foodId,
    required this.name,
    required this.image,
    required this.price,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      foodId: map['foodId'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'name': name,
      'image': image,
      'price': price,
    };
  }

}