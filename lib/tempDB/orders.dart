/*import 'package:begir/models/order.dart';

class Orders {
  final List<Order> _ordersList = [];

  void add(Order order) {
    _ordersList.add(order);
  }

  void remove(Order order) {
    _ordersList.remove(order);
  }

  List<Order> getAll() {
    return List.unmodifiable(_ordersList);
  }

  Order? getById(String id) {
    for (final order in _ordersList) {
      if (order.getItemId() == id) {
        return order;
      }
    }

    return null;
  }

  void clear() {
    _ordersList.clear();
  }
}*/