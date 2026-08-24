import 'package:begir/models/group.dart';

class Groups {
  final List<Group> _groupsList = [];

  //Setter
  void setGroupToList(Group newGroup)
  {
    _groupsList.add(newGroup);
  }
  //Getter
  List<Group> getGroupsList()
  {
    return _groupsList;
  }
}