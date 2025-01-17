import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/controls/product_controller.dart';
import 'package:untitled/providers/subcategory_product_provider.dart';
import 'package:untitled/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:untitled/views/screens/nav_screens/widgets/product_item_widget.dart';
import '../../../../models/product.dart';
import '../../../../models/subcategory.dart';

class SubcategoryProductScreen extends ConsumerStatefulWidget {
  final Subcategory subcategory;

  const SubcategoryProductScreen({super.key, required this.subcategory});

  @override
  ConsumerState<SubcategoryProductScreen> createState() =>
      _SubcategoryProductScreenState();
}

class _SubcategoryProductScreenState
    extends ConsumerState<SubcategoryProductScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // List<Product> products = ref.read(subcategoryProductProvider);
    // if (products.isEmpty) {
    //   _fetchProducts();
    // } else {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    ProductController productController = ProductController();
    try {
      List<Product> products = await productController
          .loadProductBySubcategory(widget.subcategory.subCategoryName);

      if (products.isNotEmpty) {
        ref
            .read(subcategoryProductProvider.notifier)
            .setSubcategoryProduct(products);
      }
    } catch (e) {
      throw Exception("Failed to load subcategory products $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = ref.watch(subcategoryProductProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : 4;
    // final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4 / 5;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: const HeaderWidget(),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: childAspectRatio,
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductItemWidget(product: product),
                );
              }),
    );
  }
}
