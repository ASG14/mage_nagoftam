import 'package:begir/objects/order_item.dart';
import 'package:begir/objects/user.dart';

enum Role { creator, admin, member }

class Group {
  final String id;
  final User creator;
  final DateTime _createdAt;

  late String _groupTitle;
  late String? _groupDescription;

  late final Map<String, Role> _members;

  final List<OrderItem> _orderItems = [];

  Group({
    required this.id,
    required this.creator,
    required this._createdAt,
    required this._groupTitle,
    this._groupDescription,
    Map<String, Role>? members,
  }) : _members = members ?? {};

  // Setter

  void setGroupTitle(String newTitle) {
    _groupTitle = newTitle;
  }

  void setGroupDescription(String newGroupDescription) {
    _groupDescription = newGroupDescription;
  }

  // Getter

  String getId() {
    return id;
  }

  User getCreator() {
    return creator;
  }

  DateTime getCreatedAt() {
    return _createdAt;
  }

  String getGroupTitle() {
    return _groupTitle;
  }

  String? getGroupDescription() {
    return _groupDescription;
  }

  Map<String, Role> getMembers() {
    return Map.unmodifiable(_members);
  }

  List<OrderItem> getOrderItems() {
    return List.unmodifiable(_orderItems);
  }

  // Members

  void addMember(String userId, Role role) {
    _members[userId] = role;
  }

  void removeMember(String userId) {
    _members.remove(userId);
  }

  void setMemberRole(String userId, Role role) {
    if (_members.containsKey(userId)) {
      _members[userId] = role;
    }
  }

  // Order Items

  void addOrderItem(OrderItem orderItem) {
    _orderItems.add(orderItem);
  }

  bool removeOrderItem(String itemId) {
    final initialLength = _orderItems.length;

    _orderItems.removeWhere((item) => item.getItemId() == itemId);

    return _orderItems.length < initialLength;
  }

  OrderItem? getOrderItem(String itemId) {
    for (final orderItem in _orderItems) {
      if (orderItem.getItemId() == itemId) {
        return orderItem;
      }
    }

    return null;
  }

  void clearOrderItems() {
    _orderItems.clear();
  }
}
