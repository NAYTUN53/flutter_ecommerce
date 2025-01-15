import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/controls/order_controller.dart';
import 'package:untitled/services/manage_http_response.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider() : super(0);

  Future<void> fetchDeliveredOrderCount(String buyerId, context) async {
    try {
      OrderController orderController = OrderController();
      int count =
          await orderController.getDeliveredOrderCount(buyerId: buyerId);
      state = count;
    } catch (e) {
      showSnackBar(context, "Error fetching in delivered order count: $e");
    }
  }

  // reset completed delivered order count because after signing out and sign in with new user account
  // count still remain the same. So we need to reset it.
  void resetCount() {
    state = 0;
  }
}

final delveredOrderCountProvider =
    StateNotifierProvider<DeliveredOrderCountProvider, int>((ref) {
  return DeliveredOrderCountProvider();
});
