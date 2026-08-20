import 'package:begir/objects/user.dart';

enum Status{pending, reserved, complete,}
enum Priority{low, medium, high,}

class OrderItem 
{
  final String itemId;
  late String _title;
  final User _createdBy;
  late User? _reservedBy;
  final DateTime _createdAt;
  late DateTime _reservedAt;

  Status _itemStatus = Status.pending;
  Priority? _itemPriority = Priority.medium;

  OrderItem({required this.itemId, required this._createdBy, required this._title, required this._createdAt, this._itemPriority});

  //Setter
  void setTitle(String newTitle) // تنظیم عنوان جدید سفارش
  {
    _title = newTitle;
  }
  void setReservedBy(User newReservedBy) // تنظیم کاربر جدید رزرو کننده سفارش
  {
    _reservedBy = newReservedBy;
  }
  void setReservedAt(DateTime newReservedAt) // تنظیم تاریخ جدید رزرو سفارش
  {
    _reservedAt = newReservedAt;
  }
  void setItemStatus(Status newItemStatus) // تنظیم وضعیت جدید سفارش
  {
    _itemStatus = newItemStatus;
  }
  void setItemPriority(Priority newItemPriority)
  {
    _itemPriority = newItemPriority;
  }

  //Getter
  String getItemId() //دریافت آیدی سفارش
  {
    return itemId;
  }
  String getTitle() // دریافت عنوان سفارش
  {
    return _title;
  }
  User getCreatedBy() // دریافت کاربر ایجاد کننده سفارش
  {
    return _createdBy;
  }
  User getReservedBy() // دریافت آخرین کاربر رزرو کننده سفارش
  {
    return _reservedBy!;
  }
  DateTime getCreatedAt() // دریافت تاریخ ایجاد سفارش
  {
    return _createdAt;
  }
  DateTime getReservedAt() // دریافت تاریخ آخرین رزرو سفارش
  {
    return _reservedAt;
  }
  Status getItemStatus() // دریافت وضعیت فعلی سفارش
  {
    return _itemStatus;
  }
  Priority getItemPriority() // دریافت اولویت انجام سفارش
  {
    return _itemPriority!;
  }
  
  //Other
  bool isReserved()
  {
    if(_itemStatus == Status.reserved){return true;} else {return false;}
  }
}