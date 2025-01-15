import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/views/screens/details/screens/product_details_screen.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../providers/favourite_provider.dart';
import '../../../../services/manage_http_response.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final favouriteProviderData = ref.read(favouriteProvider.notifier);
    ref.watch(favouriteProvider);
    final cartProviderData = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(product: widget.product)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.product.images[0],
                      width: 160,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
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
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.product.productName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121)),
                  ),
                  widget.product.averageRating == 0
                      ? const SizedBox()
                      : Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            Text(
                              widget.product.averageRating.toStringAsFixed(1),
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.product.productPrice.toString()} Ks",
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
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

                                showSnackBar(
                                    context, widget.product.productName);
                              },
                        child: Image.asset(
                          'assets/icons/cart.png',
                          width: 25,
                          height: 25,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
