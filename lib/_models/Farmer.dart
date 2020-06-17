class Farmer {
  int _farmerId;
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _nic;
  String _contactNo;
  String _personalAddress;
  String _gramaNiladariDivision;
  bool _isAccepted;

  Farmer();

  Farmer.fromMapForSpringBoot(Map<String, dynamic> map) {
    this._farmerId = map['farmerId'];
    this._email = map['email'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._password = map['password'];
    this._nic = map['nic'];
    this._contactNo = map['contactNo'];
    this._personalAddress = map['personalAddress'];
    this._gramaNiladariDivision = map['gramaNiladariDivision'];
    this._isAccepted = map['isAccepted'];
  }

  Map toMapForSpringBoot() {
    Map map = Map();
    map['farmerId'] = this._farmerId;
    map['email'] = this._email;
    map['password'] = this._password;
    map['firstName'] = this._firstName;
    map['lastName'] = this._lastName;
    map['nic'] = this._nic;
    map['contactNo'] = this._contactNo;
    map['personalAddress'] = this._personalAddress;
    map['gramaNiladariDivision'] = this._gramaNiladariDivision;
    map['isAccepted'] = this._isAccepted;
    return map;
  }

  Map toMapForDotNet() {
    Map map = Map();
    map['FarmerId'] = this._farmerId;
    map['Email'] = this._email;
    map['Password'] = this._password;
    map['FirstName'] = this._firstName;
    map['LastName'] = this._lastName;
    map['Nic'] = this._nic;
    map['ContactNo'] = this._contactNo;
    map['PersonalAddress'] = this._personalAddress;
    map['GramaNiladariDivision'] = this._gramaNiladariDivision;
    map['IsAccepted'] = this._isAccepted;
    return map;
  }

  bool get isAccepted => _isAccepted;

  set isAccepted(bool value) {
    _isAccepted = value;
  }

  String get gramaNiladariDivision => _gramaNiladariDivision;

  set gramaNiladariDivision(String value) {
    _gramaNiladariDivision = value;
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

  int get farmerId => _farmerId;

  set farmerId(int value) {
    _farmerId = value;
  }
}
