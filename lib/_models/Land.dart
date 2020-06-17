class Land {
  int _landId;
  double _size;
  double _latitude;
  double _longitude;
  int _farmerId;

  Land(this._size, this._latitude, this._longitude, this._farmerId);

  Land.fromMap(Map json) {
    this._landId = json['id'];
    this._size = json['size'];
    this._latitude = (json['latitude']);
    this._longitude =(json['longitude']);
    this._farmerId = json['farmerId '];
  }


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['id'] = this._landId;
    map['size'] = this._size;
    map['latitude'] = this._latitude;
    map['longitude'] = this._longitude;
    map['farmerId'] = this._farmerId;
    return map;
  }

  int get farmerId => _farmerId;

  set farmerId(int value) {
    _farmerId = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  double get size => _size;

  set size(double value) {
    _size = value;
  }

  int get landId => _landId;

  set landId(int value) {
    _landId = value;
  }
}
