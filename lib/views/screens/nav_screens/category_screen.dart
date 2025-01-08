import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controls/subcategory_controller.dart';
import 'package:untitled/models/subcategory.dart';
import 'package:untitled/views/screens/nav_screens/widgets/header_widget.dart';
import '../../../controls/category_controller.dart';
import '../../../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategory;
  Category? _selectedCategory;
  List<Subcategory> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    futureCategory = CategoryController().loadCategories();
    futureCategory.then((categories){
      for (var category in categories){
        if(category.name == "Electronics"){
          setState(() {
            _selectedCategory = category;
          });
          _loadSubcategories(category.name);
        }
      }
    });
    super.initState();
  }

  Future<void> _loadSubcategories(String categoryName) async {
    final subcategories = await _subcategoryController
        .getSubCategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder(
                  future: futureCategory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Connection Failed."),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No Item Found"),
                      );
                    } else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _loadSubcategories(category.name);
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
                          });
                    }
                  }),
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
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.7,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(_selectedCategory!.banner))),
                          ),
                        ),
                        _subcategories.isNotEmpty
                            ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: _subcategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 4,
                                ),
                                itemBuilder: (context, index) {
                                  final subcategory = _subcategories[index];
                                  return Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            subcategory.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(subcategory.subCategoryName,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  );
                                })
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
