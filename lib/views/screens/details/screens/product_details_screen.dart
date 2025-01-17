import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/providers/favourite_provider.dart';
import 'package:untitled/providers/related_product_provider.dart';
import 'package:untitled/services/manage_http_response.dart';
import 'package:untitled/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import '../../../../controls/product_controller.dart';
import '../../nav_screens/widgets/product_item_widget.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final relatedProducts = ref.read(relatedProductProvider);
    if (relatedProducts.isEmpty) {
      _fetchProduct();
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController
          .loadRelatedProductsBySubcategory(widget.product.id);
      ref
          .read(relatedProductProvider.notifier)
          .setProducts(products); // Store products in provider
    } catch (e) {
      throw Exception("Error in provider $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);
    final favouriteProviderData = ref.read(favouriteProvider.notifier);
    ref.watch(favouriteProvider);
    final relatedProduct = ref.watch(relatedProductProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Prodcut Details",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            onPressed: () {
              favouriteProviderData.addProductToFavourite(
                productName: widget.product.productName,
                productPrice: widget.product.productPrice,
                category: widget.product.category,
                image: widget.product.images,
                vendorId: widget.product.vendorId,
                productQuantity: widget.product.quantity,
                quantity: 1,
                productId: widget.product.id,
                description: widget.product.description,
                fullName: widget.product.fullName,
              );
              showSnackBar(context,
                  '${widget.product.productName} has been added to favourite list');
            },
            icon: favouriteProviderData.getFavouriteItems
                    .containsKey(widget.product.id)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 260,
                height: 275,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 50,
                      child: Container(
                        width: 260,
                        height: 260,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(130),
                            color: const Color(0XFFD8DDFF)),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 22,
                      child: Container(
                        width: 216,
                        height: 274,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9CA8FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.product.images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.product.images[index],
                                  width: 198,
                                  height: 225,
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.productName,
                    style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: const Color(0xFF3C55Ef)),
                  ),
                  Text(
                    "${widget.product.productPrice.toString()} Ks",
                    style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: const Color(0xFF3C55Ef)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.category,
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Colors.grey),
              ),
            ),
            widget.product.totalRatings == 0
                ? const Text('')
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 17,
                      ),
                      Text(
                        widget.product.averageRating.toStringAsFixed(2),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("(${widget.product.totalRatings})")
                    ]),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: GoogleFonts.lato(
                        fontSize: 17,
                        letterSpacing: 1.7,
                        color: const Color(0xFF363330)),
                  ),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        letterSpacing: 1.0,
                        color: const Color(0xFF363330)),
                  )
                ],
              ),
            ),
            const ReusableTextWidget(title: 'Related Products', subtitle: ''),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: relatedProduct.length,
                  itemBuilder: (context, index) {
                    final product = relatedProduct[index];
                    return ProductItemWidget(product: product);
                  }),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: isInCart
              ? null
              : () {
                  cartProviderData.addProductToCart(
                      productName: widget.product.productName,
                      productPrice: widget.product.productPrice,
                      category: widget.product.category,
                      image: widget.product.images,
                      vendorId: widget.product.vendorId,
                      productQuantity: widget.product.quantity,
                      quantity: 1,
                      productId: widget.product.id,
                      description: widget.product.description,
                      fullName: widget.product.fullName);

                  showSnackBar(context, widget.product.productName);
                },
          child: Container(
            width: MediaQuery.of(context).size.width * 80,
            height: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isInCart ? Colors.grey : const Color(0xFF3B54EE)),
            child: Center(
              child: Text(
                "ADD TO CART",
                style: GoogleFonts.mochiyPopOne(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
