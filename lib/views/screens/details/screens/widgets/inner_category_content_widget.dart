import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controls/product_controller.dart';
import 'package:untitled/controls/subcategory_controller.dart';
import 'package:untitled/models/category.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/models/subcategory.dart';
import 'package:untitled/views/screens/details/screens/widgets/inner_banner_widget.dart';
import 'package:untitled/views/screens/details/screens/widgets/inner_header_widget.dart';
import 'package:untitled/views/screens/details/screens/widgets/subcategory_tile_widget.dart';
import 'package:untitled/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:untitled/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
  late Future<List<Subcategory>> _subcategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();
  final ProductController productControllerData = ProductController();

  @override
  void initState() {
    super.initState();
    _subcategories = _subcategoryController
        .getSubCategoriesByCategoryName(widget.category.name);
    futureProducts =
        ProductController().loadProductsByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const InnerHeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Search by subcategories",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.7),
                ),
              ),
            ),
            FutureBuilder(
                future: _subcategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Categories not found"),
                    );
                  } else {
                    final subcategories = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: List.generate(
                            (subcategories.length / 7).ceil(), (setIndex) {
                          // calculate the starting and ending indices for each row
                          final start = setIndex * 7;
                          final end = (setIndex + 1) * 7;

                          //create a padding widget and add spacing around the row
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: subcategories
                                  .sublist(
                                      start,
                                      end > subcategories.length
                                          ? subcategories.length
                                          : end)
                                  .map((subcategory) => SubcategoryTileWidget(
                                      image: subcategory.image,
                                      title: subcategory.subCategoryName))
                                  .toList(),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                }),
            const ReusableTextWidget(
                title: "Popular products", subtitle: 'View all>>'),

            // Get the popular products and show in the subcategories screen after pressing the category
            FutureBuilder(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Popular product is not found."),
                    );
                  } else {
                    final products = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItemWidget(product: product);
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
