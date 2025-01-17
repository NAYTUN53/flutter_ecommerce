import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controls/subcategory_controller.dart';
import 'package:untitled/providers/category_provider.dart';
import 'package:untitled/providers/subcategory_provider.dart';
import 'package:untitled/views/screens/details/screens/subcategory_product_screen.dart';
import 'package:untitled/views/screens/details/screens/widgets/subcategory_tile_widget.dart';
import 'package:untitled/views/screens/nav_screens/widgets/header_widget.dart';
import '../../../controls/category_controller.dart';
import '../../../models/category.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await CategoryController().loadCategories();
    try {
      ref.read(categoryProvider.notifier).setCategory(categories);
      for (var category in categories) {
        if (category.name == "Electronic Devices") {
          setState(() {
            _selectedCategory = category;
          });
          _fetchSubcategories(category.name);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _fetchSubcategories(String categoryName) async {
    final subcategories = await SubcategoryController()
        .getSubCategoriesByCategoryName(categoryName);

    ref.read(subcategoryProvider.notifier).setSubcategories(subcategories);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final subCategories = ref.watch(subcategoryProvider);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 20),
          child: const HeaderWidget()),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _fetchSubcategories(category.name);
                    },
                    title: Text(
                      category.name,
                      style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedCategory == category
                              ? Colors.blue
                              : Colors.black),
                    ),
                  );
                },
              ),
            ),
          ),

          // Right side display
          Expanded(
              flex: 5,
              child: _selectedCategory != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCategory!.name,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.7,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      NetworkImage(_selectedCategory!.banner),
                                ),
                              ),
                            ),
                          ),
                        ),
                        subCategories.isNotEmpty
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: subCategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 4,
                                ),
                                itemBuilder: (context, index) {
                                  final subcategory = subCategories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SubcategoryProductScreen(
                                                subcategory: subcategory);
                                          },
                                        ),
                                      );
                                    },
                                    child: SubcategoryTileWidget(
                                        image: subcategory.image,
                                        title: subcategory.subCategoryName),
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "No Subcategories found",
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    )
                  : Container(
                      color: Colors.white,
                    )),
        ],
      ),
    );
  }
}
