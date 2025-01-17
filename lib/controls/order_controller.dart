import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/global_variables.dart';
import 'package:untitled/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/services/manage_http_response.dart';

class OrderController {
  uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      final Order order = Order(
          id: id,
          fullName: fullName,
          email: email,
          state: state,
          city: city,
          locality: locality,
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          category: category,
          image: image,
          buyerId: buyerId,
          vendorId: vendorId,
          processing: processing,
          delivered: delivered);

      http.Response response = await http.post(Uri.parse("$uri/api/orders"),
          body: order.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token!,
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your orders have successfully placed.");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get orders by buyerId
  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");

      // Send an http request to get the orders by buyerId
      http.Response response = await http
          .get(Uri.parse("$uri/api/orders/$buyerId"), headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!,
      });
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Error found in loading orders");
      }
    } catch (e) {
      throw Exception('Failed to load orders');
    }
  }

  // Delete Order by Id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http
          .delete(Uri.parse("$uri/api/orders/$id"), headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!,
      });

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your order was successfully deleted.");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // method to get the order count that is completed
  Future<int> getDeliveredOrderCount({required String buyerId}) async {
    try {
      List<Order> orders = await loadOrders(buyerId: buyerId);
      int deliveredOrderCount = orders.where((order) => order.delivered).length;
      return deliveredOrderCount;
    } catch (e) {
      throw Exception("Error: error fetching in delivered order count");
    }
  }

  // Make payment intent

  Future<Map<String, dynamic>> createPaymentIntent(
      {required int amount, required String currency}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");

      http.Response response =
          await http.post(Uri.parse("$uri/api/payment-intent"),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
                "x-auth-token": token!,
              },
              body: jsonEncode({
                "amount": amount,
                "currency": currency,
              }));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {};
      } else {
        throw Exception("Error in creating payment intent");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
