
class ToppingModel {
  final String toppingId;
  final String name;
  final int price;

  ToppingModel({
    required this.toppingId,
    required this.name,
    required this.price,
  });

  factory ToppingModel.fromMap(Map<String, dynamic> map) {
    return ToppingModel(
      toppingId: map['toppingId'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toppingId': toppingId,
      'name': name,
      'price': price,
    };
  }

}