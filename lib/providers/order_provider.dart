import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  // Set the list of orders
  void setOrders(List<Order> orders) {
    state = orders;
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>(
  (ref) {
    return OrderProvider();
  },
);
