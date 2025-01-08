import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final double productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String fullName;
  final String subCategory;
  final List<dynamic> images;

  Product(
      {required this.id,
      required this.productName,
      required this.productPrice,
      required this.quantity,
      required this.description,
      required this.category,
      required this.vendorId,
      required this.fullName,
      required this.subCategory,
      required this.images});

  // Convert user object to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "_id": id,
      "productName": productName,
      "productPrice": productPrice,
      "quantity": quantity,
      "description": description,
      "category": category,
      "vendorId": vendorId,
      "fullName": fullName,
      "images": images,
    };
  }

  // Convert Map to Json
  String toJson() => json.encode(toMap());

  // Convert a Map to a User Object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String? ?? "",
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as double,
      quantity: map['quantity'] as int,
      description: map['description'] as String,
      category: map['category'] as String,
      vendorId: map['vendorId'] as String,
      fullName: map['fullName'] as String,
      subCategory: map['subCategory'] as String,
      images: map['images'] as List<dynamic>,
    );
  }

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
