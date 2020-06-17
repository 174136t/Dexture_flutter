class Harvest {
  int _id;
  String _type;
  int _quantity;
  int _farmerId;
  double _unitPrice;
  int _status;
  int _landId;

  Harvest(this._farmerId,this._type, this._quantity, this._unitPrice,this._landId,this._status);


  Harvest.fromMap(Map map) {
    this._id = map['id'];
    this._type = map['type'];
    this._quantity = map['quantity'];
    this._farmerId = map['farmerId'];
    this._unitPrice = map['unitPrice'];
    this._status=map['status'];
    this._landId=map['landId'];
  }

  Map toMap() {
    Map map = Map();
    map['id'] = this._id;
    map['type'] = this._type;
    map['quantity'] = this._quantity;
    map['farmerId'] = this._farmerId;
    map['unitPrice'] = this._unitPrice;
    map['status'] =this._status;
    map['landId'] =this._landId;
    return map;
  }

  int get farmerId => _farmerId;

  set farmerId(int value) {
    _farmerId = value;
  }

  int get sellingQuantity => _quantity;

  set sellingQuantity(int value) {
    _quantity = value;
  }

  int get id => _id;

  set id(int value){
    _id = value;
  }

  String get type => _type;

  set type(String value){
    _type = value;
  }

  double get unitPrice =>_unitPrice;
  set unitPrice(double value){
    _unitPrice=value;
  }

  int get status => _status;
  set status(int value){
    _status=value;
  }

  int get landId => _landId;
  set landId(int value){
    _landId=value;
  }
}
