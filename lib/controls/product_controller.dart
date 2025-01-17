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
      } else if (response.statusCode == 404) {
        return [];
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
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Popular products failed to load");
      }
    } catch (e) {
      throw Exception("Request Error: $e");
    }
  }

  // Display related product by subcategory
  Future<List<Product>> loadRelatedProductsBySubcategory(
      String productId) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/related-products-by-subcategory/$productId'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> relatedProducts = data
            .map(
                (products) => Product.fromMap(products as Map<String, dynamic>))
            .toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load related products ");
      }
    } catch (e) {
      throw Exception("Request Error: $e");
    }
  }

  // Get the top 10 highest rated products
  Future<List<Product>> loadTopRatedProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/top-related-products'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> topRatedProducts = data
            .map(
                (products) => Product.fromMap(products as Map<String, dynamic>))
            .toList();
        return topRatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load top related products ");
      }
    } catch (e) {
      throw Exception("Request Error: $e");
    }
  }

  // fetch api for displaying subcategory products
  Future<List<Product>> loadProductBySubcategory(String subCategory) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/prducts-by-subcategory/$subCategory"),
          headers: <String, String>{
            "Content-Type": "application/json; charset = UTF-8"
          });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data.map((product) {
          return Product.fromMap(product as Map<String, dynamic>);
        }).toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load subcategory products");
      }
    } catch (e) {
      throw Exception("Error fetching in subcategory products");
    }
  }

  // Search Products
  Future<List<Product>> searchProducts(String query) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/search-products?query=$query"),
          headers: <String, String>{
            "Content-Type": "application/json; charset = UTF-8"
          });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> searchedProducts = data.map((product) {
          return Product.fromMap(product as Map<String, dynamic>);
        }).toList();
        return searchedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load searched products");
      }
    } catch (e) {
      throw Exception("Error fetching in searched products");
    }
  }
}
