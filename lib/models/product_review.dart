import 'dart:convert';

class ProductReview {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;

  ProductReview(
      {required this.id,
      required this.buyerId,
      required this.email,
      required this.fullName,
      required this.productId,
      required this.rating,
      required this.review});

  // Convert user object to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "buyerId": buyerId,
      "email": email,
      "fullName": fullName,
      "productId": productId,
      "rating": rating,
      "review": review,
    };
  }

  // Convert Map to Json
  String toJson() => json.encode(toMap());

  // Convert a Map (User Object) to Json
  factory ProductReview.fromJson(Map<String, dynamic> map) {
    return ProductReview(
      id: map['_id'] as String? ?? "",
      buyerId: map['buyerId'] as String? ?? "",
      email: map['email'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      productId: map['productId'] as String? ?? "",
      rating: map['rating'] as double? ?? 0.0,
      review: map['review'] as String? ?? "",
    );
  }
}
