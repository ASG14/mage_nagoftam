import 'package:begir/models/group.dart';
import 'package:begir/models/order.dart';

class Relator {
  final Group group;
  final Order order;

  const Relator({
    required this.group,
    required this.order,
  });
}