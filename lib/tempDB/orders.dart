import 'package:begir/models/order.dart';

class Orders {
  final List<Order> _ordersList = [];

  //Setter
  void setOrderToList(Order newOrder)
  {
    _ordersList.add(newOrder);
  }
  //Getter
  List<Order> getOrdersList()
  {
    return _ordersList;
  }
}