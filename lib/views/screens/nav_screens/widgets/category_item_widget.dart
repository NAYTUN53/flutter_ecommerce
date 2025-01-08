import 'package:flutter/material.dart';
import 'package:untitled/views/screens/details/screens/inner_category_screen.dart';
import 'package:untitled/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import '../../../../controls/category_controller.dart';
import '../../../../models/category.dart';

class CategoryItemWidget extends StatefulWidget {
  const CategoryItemWidget({super.key});

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  late Future<List<Category>> futureCategory;

  @override
  void initState() {
    futureCategory = CategoryController().loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ReusableTextWidget(title: "Categories", subtitle: "View all>>"),
        FutureBuilder(
            future: futureCategory,
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
                final categories = snapshot.data!;
                return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return InnerCategoryScreen(category: category);
                          }));
                        },
                        child: Column(
                          children: [
                            Image.network(
                              category.image,
                              height: 46,
                              width: 46,
                            ),
                            Text(
                              category.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      );
                    });
              }
            }),
      ],
    );
  }
}
