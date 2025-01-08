import 'dart:convert';
class Category {
  final String id;
  final String name;
  final String image;
  final String banner;

  Category(
      {required this.id,
        required this.name,
        required this.image,
        required this.banner});

  // Convert user object to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "image": image,
      "banner": banner,
    };
  }

  // Convert Map to Json
  String toJson() => json.encode(toMap());

  // Convert a Map to a User Object
  factory Category.fromJson(Map<String, dynamic> map) {
    return Category(
      id: map['_id'] as String? ?? "",
      name: map['name'] as String? ?? "",
      image: map['image'] as String? ?? "",
      banner: map['banner'] as String? ?? "",
    );
  }
}
