import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/cart.dart';

// Make the data in the provider accessible in entire application
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

  void addProductToCart({
    required String productName,
    required double productPrice,
    required String category,
    required List<dynamic> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    // Check if the product is in the cart, then update the quantity of the product
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: Cart(
            productName: state[productId]!.productName,
            productPrice: state[productId]!.productPrice,
            category: state[productId]!.category,
            image: state[productId]!.image,
            vendorId: state[productId]!.vendorId,
            productQuantity: state[productId]!.productQuantity,
            quantity: state[productId]!.quantity + 1,
            productId: state[productId]!.productId,
            description: state[productId]!.description,
            fullName: state[productId]!.fullName)
      };
    }
    // if the product isn't in the cart, add the product to the cart with provided details
    else {
      state = {
        ...state,
        productId: Cart(
            productName: productName,
            productPrice: productPrice,
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName)
      };
    }
  }

  // Method to increase the quantity of a product in the cart
  void increamentCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      // Notify the lisners that the state is changed
      state = {...state};
    }
  }

  // Method to decrease the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      if (state[productId]!.quantity > 0) {
        state[productId]!.quantity--;
      }

      // Notify the listener that the quantity of a product is changed
      state = {...state};
    }
  }

  // Method to remove the item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    state = {...state};
  }

  // Method to calculate the total amount of items in the cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }
}
