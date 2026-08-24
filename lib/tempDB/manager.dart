import 'package:begir/models/group.dart';
import 'package:begir/models/order.dart';
import 'package:begir/tempDB/relator.dart';

class Manager {
  final List<Relator> _records = [];

  void add({
    required Group group,
    required Order order,
  }) {
    final relation = Relator(
      group: group,
      order: order,
    );

    _records.add(relation);
  }

  List<Relator> getRelations() {
    return List.unmodifiable(_records);
  }

  List<Order> getOrdersForGroup(Group group) {
    final result = <Order>[];

    for (final relation in _records) {
      if (relation.group == group) {
        result.add(relation.order);
      }
    }

    return List.unmodifiable(result);
  }
}