class User {
  final String id;
  late int _phoneNumber;
  late String? _firstName;
  late String? _lastName;
  final DateTime _registeredAt;

  User({
    required this.id,
    required this._phoneNumber,
    this._firstName,
    this._lastName,
    required this._registeredAt,
  });

  //Setter
  void setNewPhoneNumber(int newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
  }

  void setNewFirstName(String newFirstname) {
    _firstName = newFirstname;
  }

  void setNewlastName(String newLastName) {
    _lastName = newLastName;
  }

  //Getter
  String getId() {
    return id;
  }

  int getPhoneNumber() {
    return _phoneNumber;
  }

  String getFirstName() {
    return _firstName!;
  }

  String getLastName() {
    return _lastName!;
  }

  DateTime getRegisteredAt() {
    return _registeredAt;
  }
}
