import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/controls/product_controller.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/providers/product_provider.dart';
import 'package:untitled/views/screens/nav_screens/widgets/product_item_widget.dart';

class PopularProductWidget extends ConsumerStatefulWidget {
  const PopularProductWidget({super.key});

  @override
  ConsumerState<PopularProductWidget> createState() =>
      _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<PopularProductWidget> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      List<Product> products = await productController.loadPopularProduct();

      ref
          .read(productProvider.notifier)
          .setProducts(products); // Store products in provider
    } catch (e) {
      throw Exception("Error in provider $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    return SizedBox(
      height: 200,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItemWidget(product: product);
              }),
    );
  }
}
