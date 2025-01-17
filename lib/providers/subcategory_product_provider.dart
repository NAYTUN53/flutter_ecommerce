import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/product.dart';

class SubcategoryProductProvider extends StateNotifier<List<Product>> {
  SubcategoryProductProvider() : super([]);

  void setSubcategoryProduct(List<Product> products) {
    state = products;
  }

  void clearProviderState() {
    state = [];
  }
}

final subcategoryProductProvider =
    StateNotifierProvider<SubcategoryProductProvider, List<Product>>((ref) {
  return SubcategoryProductProvider();
});
