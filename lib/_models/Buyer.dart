class Buyer {
  int _buyerId;
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _nic;
  String _contactNo;
  String _personalAddress;


  Buyer();

  Buyer.fromMap(Map<String, dynamic> map) {
    this._buyerId = map['buyerId'];
    this._email = map['email'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._password = map['password'];
    this._nic = map['nic'];
    this._contactNo = map['contactNo'];
    this._personalAddress = map['personalAddress'];
  }

  Map toMap() {
    Map map = Map();
    map['buyerId'] = this._buyerId;
    map['email'] = this._email;
    map['password'] = this._password;
    map['firstName'] = this._firstName;
    map['lastName'] = this._lastName;
    map['nic'] = this._nic;
    map['contactNo'] = this._contactNo;
    map['personalAddress'] = this._personalAddress;
    return map;
  }


  String get personalAddress => _personalAddress;

  set personalAddress(String value) {
    _personalAddress = value;
  }

  String get contactNo => _contactNo;

  set contactNo(String value) {
    _contactNo = value;
  }

  String get nic => _nic;

  set nic(String value) {
    _nic = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  int get buyerId => _buyerId;

  set buyerId(int value) {
    _buyerId = value;
  }
}
