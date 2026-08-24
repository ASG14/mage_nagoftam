import 'package:begir/models/group.dart';

class Groups {
  final List<Group> _groupsList = [];

  void add(Group group) {
    _groupsList.add(group);
  }

  void remove(Group group) {
    _groupsList.remove(group);
  }

  List<Group> getAll() {
    return List.unmodifiable(_groupsList);
  }

  Group? getById(String id) {
    for (final group in _groupsList) {
      if (group.getId() == id) {
        return group;
      }
    }

    return null;
  }

  bool contains(Group group) {
    return _groupsList.contains(group);
  }

  void clear() {
    _groupsList.clear();
  }
}