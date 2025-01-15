import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/product.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);

  //Set the list of products
  void setProducts(List<Product> products) {
    state = products;
  }
}

final productProvider =
    StateNotifierProvider<ProductProvider, List<Product>>((ref) {
  return ProductProvider();
});
