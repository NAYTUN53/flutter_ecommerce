import 'package:flutter/material.dart';
import 'package:untitled/controls/product_controller.dart';
import 'package:untitled/views/screens/nav_screens/widgets/product_item_widget.dart';

import '../../../../models/product.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  TextEditingController searchProductController = TextEditingController();
  ProductController productController = ProductController();
  List<Product> searchProducts = [];
  bool isLoading = false;

  searchProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      String query = searchProductController.text.trim();
      if (query.isNotEmpty) {
        List<Product> products = await productController.searchProducts(query);
        setState(() {
          searchProducts = products;
        });
      }
    } catch (e) {
      throw Exception("Error loading in searched products");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    final childAspectRatio = screenWidth < 600 ? 4 / 5 : 4 / 5;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: TextField(
          controller: searchProductController,
          decoration: InputDecoration(
            label: const Text("Search Product"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              onPressed: () {
                searchProduct();
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : searchProducts.isEmpty
              ? const Center(
                  child: Text("No Product Found"),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: GridView.builder(
                            itemCount: searchProducts.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: childAspectRatio,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    crossAxisCount: crossAxisCount),
                            itemBuilder: (context, index) {
                              final searchedProduct = searchProducts[index];
                              return ProductItemWidget(
                                  product: searchedProduct);
                            }))
                  ],
                ),
    );
  }
}
