import 'package:begir/models/group.dart';
import 'package:begir/models/order.dart';
import 'package:begir/tempDB/relator.dart';

class Manager {
  final List<Relator> _records = [];

  void addOrderToGroup({
    required Group group,
    required Order order,
  }) {
    final relation = Relator(
      group: group,
      order: order,
    );

    _records.add(relation);
  }

  void removeOrderFromGroup({
    required Group group,
    required Order order,
  }) {
    _records.removeWhere(
      (relation) =>
          relation.group == group && relation.order == order,
    );
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

  List<Relator> getRelations() {
    return List.unmodifiable(_records);
  }

  void clear() {
    _records.clear();
  }
}