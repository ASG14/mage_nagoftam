import 'package:begir/models/user.dart';

enum Status { pending, reserved, complete }

enum Priority { low, medium, high }

class Order {
  final String itemId;
  final User _createdBy;
  final DateTime _createdAt;

  late String _title;
  late String _quantity;
  late DateTime _deadline;

  late User? _reservedBy;
  late DateTime? _reservedAt;

  Status _itemStatus = Status.pending;
  Priority _itemPriority = Priority.medium;

  Order({
    required this.itemId,
    required this._createdBy,
    required this._title,
    required this._quantity,
    required this._createdAt,
    required this._deadline,
    this._itemPriority = Priority.medium,
  });

  // Setter

  void setTitle(String newTitle) {
    _title = newTitle;
  }

  void setQuantity(String newQuantity) {
    _quantity = newQuantity;
  }

  void setDeadline(DateTime newDeadline) {
    _deadline = newDeadline;
  }

  void setReservedBy(User newReservedBy) {
    _reservedBy = newReservedBy;
  }

  void setReservedAt(DateTime newReservedAt) {
    _reservedAt = newReservedAt;
  }

  void setItemStatus(Status newItemStatus) {
    _itemStatus = newItemStatus;
  }

  void setItemPriority(Priority newItemPriority) {
    _itemPriority = newItemPriority;
  }

  // Getter

  String getItemId() {
    return itemId;
  }

  String getTitle() {
    return _title;
  }

  String getQuantity() {
    return _quantity;
  }

  User getCreatedBy() {
    return _createdBy;
  }

  DateTime getCreatedAt() {
    return _createdAt;
  }

  DateTime getDeadline() {
    return _deadline;
  }

  User? getReservedBy() {
    return _reservedBy;
  }

  DateTime? getReservedAt() {
    return _reservedAt;
  }

  Status getItemStatus() {
    return _itemStatus;
  }

  Priority getItemPriority() {
    return _itemPriority;
  }

  // Other

  bool isReserved() {
    return _itemStatus == Status.reserved;
  }

  bool isComplete() {
    return _itemStatus == Status.complete;
  }
}
