import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/views/screens/details/screens/checkout_screen.dart';
import 'package:untitled/views/screens/main_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final cartProviderData = ref.read(cartProvider.notifier);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/icons/cartb.png",
            ),
            fit: BoxFit.cover,
          )),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/icons/not.png",
                      width: 25,
                      height: 25,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.yellow.shade800),
                        child: Center(
                          child: Text(
                            cartData.length.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  "My Cart",
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your shopping cart is empty.\nYou can add product to your cart from the buttom below.",
                  style: GoogleFonts.roboto(fontSize: 16, letterSpacing: 1.7),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const MainScreen();
                        }),
                      );
                    },
                    child: const Text("Shop Now"))
              ],
            ))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 49,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 49,
                            clipBehavior: Clip.hardEdge,
                            decoration:
                                const BoxDecoration(color: Color(0xFFD7DDFF)),
                          ),
                        ),
                        Positioned(
                          left: 44,
                          top: 19,
                          child: Container(
                            width: 10,
                            height: 10,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black),
                          ),
                        ),
                        Positioned(
                            left: 69,
                            top: 14,
                            child: Text(
                              "You have ${cartData.length} items",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartData.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartData.values.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(cartItem.image[0]),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.productName,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        cartItem.category,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "${cartItem.productPrice.toString()} Ks",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          cartProviderData.increamentCartItem(
                                              cartItem.productId);
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Text(
                                              "+",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${cartItem.quantity}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          cartProviderData.decrementCartItem(
                                              cartItem.productId);
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        cartProviderData
                                            .removeCartItem(cartItem.productId);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 71,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC4C4C4)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 71,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFC4C4C4),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.83, -0.05),
              child: Text(
                "Subtotal :",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFA1A1A1),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.39, -0.05),
              child: Text(
                "${totalAmount.toString()} Ks",
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6464)),
              ),
            ),
            Align(
              alignment: const Alignment(1, -1),
              child: InkWell(
                onTap: totalAmount == 0.0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const CheckoutScreen();
                          }),
                        );
                      },
                child: Container(
                  width: 150,
                  height: 71,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: totalAmount == 0.0
                          ? Colors.grey
                          : const Color(0xFF1532E7)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Check Out",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
