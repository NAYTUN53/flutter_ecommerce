import 'dart:convert';

class Favourite {
  final String productName;
  final int productPrice;
  final String category;
  final List<String> image;
  final String vendorId;
  final int productQuantity;
  int quantity;
  final String productId;
  final String description;
  final String fullName;

  Favourite(
      {required this.productName,
      required this.productPrice,
      required this.category,
      required this.image,
      required this.vendorId,
      required this.productQuantity,
      required this.quantity,
      required this.productId,
      required this.description,
      required this.fullName});

  // Convert user object to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "productName": productName,
      "productPrice": productPrice,
      "category": category,
      "image": image,
      "vendorId": vendorId,
      "productQuantity": productQuantity,
      "quantity": quantity,
      "productId": productId,
      "description": description,
      "fullName": fullName,
    };
  }

  // Convert Map to Json
  String toJson() => json.encode(toMap());

  // Convert a Map to a User Object
  factory Favourite.fromMap(Map<String, dynamic> map) {
    return Favourite(
      productName: map['productName'] as String? ?? "",
      productPrice: map['productPrice'] as int? ?? 0,
      category: map['category'] as String? ?? "",
      image: List<String>.from(map['image'] as List<dynamic>? ?? []),
      vendorId: map['vendorId'] as String? ?? "",
      productQuantity: map['productQuantity'] as int? ?? 0,
      quantity: map['quantity'] as int? ?? 0,
      productId: map['productId'] as String? ?? "",
      description: map['description'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
    );
  }

  factory Favourite.fromJson(String source) =>
      Favourite.fromMap(json.decode(source) as Map<String, dynamic>);
}
