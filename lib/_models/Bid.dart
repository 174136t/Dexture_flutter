import 'package:dexture/_models/Buyer.dart';
import 'package:dexture/_models/Harvest.dart';

class Bid {
  int _bidId;
  int _status;
  double _bidPrice;
  int _buyerId;
  int _harvestId;
  Harvest _harvest;
  Buyer _buyer;


Bid(this._bidPrice,this._buyerId,this._harvestId);

Bid.fromMap(Map json) {
    this._bidId = json['id'];
    this._status = json['status'];
    this._bidPrice = (json['bidUnitPrice']);
    this._buyerId =(json['buyerId']);
    this._harvestId = json['harvestId'];
    this._harvest = Harvest.fromMap(json['harvest']);
    this._buyer = Buyer.fromMap(json['buyer']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['id'] = this._bidId;
    map['status'] = this._status;
    map['bidUnitPrice'] = this._bidPrice;
    map['buyerId'] = this._buyerId;
    map['harvestId'] = this._harvestId;
    return map;
  }

int get harvestId => _harvestId;
set harvestId(int value){
  _harvestId=value;
}

int get buyerId => _buyerId;
set buyerId(int value){
  _buyerId=value;
}
double get bidPrice => _bidPrice;
set bidPrice(double value){
  _bidPrice=value;
}
int get bidId => _bidId;
set bidId(int value){
  _bidId=value;
}

int get status => this._status;

set status(int value){
  this._status = value;
}

Harvest get harvest => this._harvest;

Buyer get buyer => this._buyer;
}