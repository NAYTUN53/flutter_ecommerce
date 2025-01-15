import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favourite.dart';

class FavouriteNotifier extends StateNotifier<Map<String, Favourite>> {
  FavouriteNotifier() : super({}) {
    _loadFavourites();
  }

  // fetch favourite items from sharedPreferences that save in local
  Future<void> _loadFavourites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final favouriteString = preferences.getString('favourites');

    if (favouriteString != null) {
      final Map<String, dynamic> favouriteMap = jsonDecode(favouriteString);
      final favourites = favouriteMap
          .map((key, value) => MapEntry(key, Favourite.fromJson(value)));
      state = favourites;
    }
  }

  // Private method that saves the current list of favourite items to sharedPreferences
  Future<void> _saveFavourites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final favouriteJson = jsonEncode(state);
    await preferences.setString('favourites', favouriteJson);
  }

  void addProductToFavourite({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    state[productId] = Favourite(
        productName: productName,
        productPrice: productPrice,
        category: category,
        image: image,
        vendorId: vendorId,
        productQuantity: productQuantity,
        quantity: quantity,
        productId: productId,
        description: description,
        fullName: fullName);

    //Notify the listner that the state has changed
    state = {...state};

    // save the favourite items to local
    _saveFavourites();
  }

  // Method to remove the favourite item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    state = {...state};
  }

  Map<String, Favourite> get getFavouriteItems => state;
}

// Make the data in the provider accessible in entire application
final favouriteProvider =
    StateNotifierProvider<FavouriteNotifier, Map<String, Favourite>>((ref) {
  return FavouriteNotifier();
});
