import 'dart:convert';
import 'package:untitled/global_variables.dart';
import 'package:untitled/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> loadPopularProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/popular-products"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data
            .map(
                (products) => Product.fromMap(products as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        throw Exception("Popular products failed to load");
      }
    } catch (e) {
      throw Exception("Request Error: $e");
    }
  }

  Future<List<Product>> loadProductsByCategory(String category) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/products-by-category/$category'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data
            .map(
                (products) => Product.fromMap(products as Map<String, dynamic>))
            .toList();
        return products;
      } else {
        throw Exception("Popular products failed to load");
      }
    } catch (e) {
      throw Exception("Request Error: $e");
    }
  }
}
