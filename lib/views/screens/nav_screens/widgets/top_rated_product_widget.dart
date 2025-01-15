import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/controls/product_controller.dart';
import 'package:untitled/providers/product_provider.dart';
import 'package:untitled/providers/top_rated_product_provider.dart';
import 'package:untitled/views/screens/nav_screens/widgets/product_item_widget.dart';

class TopRatedProductWidget extends ConsumerStatefulWidget {
  const TopRatedProductWidget({super.key});

  @override
  ConsumerState<TopRatedProductWidget> createState() =>
      _TopRatedProductWidgetState();
}

class _TopRatedProductWidgetState extends ConsumerState<TopRatedProductWidget> {
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
      final topRatedProducts = await productController.loadTopRatedProduct();
      ref
          .read(topRatedProductProvider.notifier)
          .setProducts(topRatedProducts); // Store products in provider
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
    final topRatedProducts = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 200,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: topRatedProducts.length,
              itemBuilder: (context, index) {
                final topRatedProduct = topRatedProducts[index];
                return ProductItemWidget(product: topRatedProduct);
              }),
    );
  }
}
