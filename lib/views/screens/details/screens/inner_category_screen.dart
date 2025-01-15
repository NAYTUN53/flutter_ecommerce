import 'package:flutter/material.dart';
import 'package:untitled/views/screens/details/screens/widgets/inner_category_content_widget.dart';
import 'package:untitled/views/screens/nav_screens/account_screen.dart';
import 'package:untitled/views/screens/nav_screens/cart_screen.dart';
import 'package:untitled/views/screens/nav_screens/category_screen.dart';
import 'package:untitled/views/screens/nav_screens/favourite_screen.dart';
import 'package:untitled/views/screens/nav_screens/stores_screen.dart';
import '../../../../models/category.dart';

class InnerCategoryScreen extends StatefulWidget {
  final Category category;

  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      InnerCategoryContentWidget(
        category: widget.category,
      ),
      const FavouriteScreen(),
      const CategoryScreen(),
      const StoresScreen(),
      const CartScreen(),
      const AccountScreen()
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/home.png",
                  width: 25,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/love.png",
                  width: 25,
                ),
                label: "Favourite"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined), label: "Categories"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/mart.png",
                  width: 25,
                ),
                label: "Stores"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/cart.png",
                  width: 25,
                ),
                label: "Cart"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/user.png",
                  width: 25,
                ),
                label: "Account"),
          ]),
      body: pages[pageIndex],
    );
  }
}
