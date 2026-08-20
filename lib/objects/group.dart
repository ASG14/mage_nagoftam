import 'package:begir/objects/user.dart';

enum Role { creator, admin, member }

class Group {
  final String id;              // شناسه یکتا
  final User creator;           // سازنده گروه (با Role.creator)
  final DateTime _createdAt;     // تاریخ ایجاد
  late String _groupTitle;           // عنوان گروه (قابل تغییر)
  late String? _groupDescription;    // توضیحات گروه (اختیاری)
  late Map<String, Role> _members; // key: userId, value: Role
  
  Group({required this.id,required this.creator,required this._createdAt,required this._groupTitle,this._groupDescription});


 //Setter
 void setGroupTitle(String newTitle)
 {
    _groupTitle = newTitle;
 }
 void setGroupDescription(String newgroupdescription)
 {
    _groupDescription =newgroupdescription;
 }
 //Getter
 String getId()
 {
  return id;
 } 
 User getCreator()
 {
  return creator;
 } 
 DateTime getCreatedAt()
 {
  return _createdAt;
 } 
 String getGroupTitle()
 {
  return _groupTitle;
 }
 String getGroupDescription()
 {
  return _groupDescription!;
 }
 Map<String,Role> getMembers()
 {
  return _members;
 }
}