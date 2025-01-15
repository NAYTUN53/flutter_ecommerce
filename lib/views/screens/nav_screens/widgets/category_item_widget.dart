import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/providers/category_provider.dart';
import 'package:untitled/views/screens/details/screens/inner_category_screen.dart';
import 'package:untitled/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import '../../../../controls/category_controller.dart';

class CategoryItemWidget extends ConsumerStatefulWidget {
  const CategoryItemWidget({super.key});

  @override
  ConsumerState<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends ConsumerState<CategoryItemWidget> {
  bool isLoading = true;
  @override
  void initState() {
    final categories = ref.read(categoryProvider);
    if (categories.isEmpty) {
      _fetchCategory();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    super.initState();
  }

  Future<void> _fetchCategory() async {
    final CategoryController categoryController = CategoryController();
    try {
      final categories = await categoryController.loadCategories();
      ref.read(categoryProvider.notifier).setCategory(categories);
    } catch (e) {
      throw Exception("Error saving in provider $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Column(
      children: [
        const ReusableTextWidget(title: "Categories", subtitle: "View all>>"),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 8),
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                })
      ],
    );
  }
}
