import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/subcategory.dart';

class SubcategoryProvider extends StateNotifier<List<Subcategory>> {
  SubcategoryProvider() : super([]);

  void setSubcategories(List<Subcategory> subcategories) {
    state = subcategories;
  }
}

final subcategoryProvider =
    StateNotifierProvider<SubcategoryProvider, List<Subcategory>>((ref) {
  return SubcategoryProvider();
});
