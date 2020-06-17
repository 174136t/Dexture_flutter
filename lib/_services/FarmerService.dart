import 'dart:async';
import 'dart:convert';

import 'package:dexture/_models/Bid.dart';
import 'package:dexture/_models/Harvest.dart';
import 'package:dexture/_models/Land.dart';
import 'package:dexture/_utils/Constants.dart';
import 'package:http/http.dart' as http;

class FarmerService {
  static Future<http.Response> addLand(Land land) {
    return http.post(Constants.BASE_URL + Constants.ADD_LAND,
        body: json.encode(land.toMap()),
        headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> viewLands(int farmerId) {
    return http.get(Constants.BASE_URL + Constants.GET_LANDS + '/$farmerId',
        headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> addHarvest(Harvest harvest) {
    return http.post(Constants.BASE_URL + Constants.ADD_HARVEST,
        body: json.encode(harvest.toMap()),
        headers: {"Content-Type": "application/json"});
  }
 static Future<http.Response> sellHarvest(Harvest harvest) {
   print(harvest.toMap());
    return http.put(Constants.BASE_URL + Constants.ADD_HARVEST,
        body: json.encode(harvest.toMap()),
        headers: {"Content-Type": "application/json"});
  }
  static Future<http.Response> getHarvest(int farmerId) {
    print(farmerId.toString() + '***********************');
    return http.get(Constants.BASE_URL +Constants.GET_FARMERS + '/$farmerId'+ Constants.GET_HARVEST,
        headers: {"Content-Type": "application/json"});
  }
  static Future<http.Response> deleteHarvest(int harvestId) {
    return http.delete(Constants.BASE_URL +Constants.ADD_HARVEST + '/$harvestId',
        headers: {"Content-Type": "application/json"});
  }
  static Future<http.Response> getLandHarvest(int landId) {
    return http.get(Constants.BASE_URL +Constants.GET_LANDS + '/$landId'+ Constants.GET_HARVEST,
        headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> getBids(int farmerId) {
    return http.get(Constants.BASE_URL + Constants.GET_FARMERS + '/$farmerId'+ Constants.GET_BID,
        headers: {"Content-Type": "application/json"});
  }
  static Future<http.Response> updateBid(Bid bid) {
    return http.put(Constants.BASE_URL + Constants.GET_FARMERS+Constants.ADD_BID,
        body: json.encode(bid.toMap()),
        headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> deleteLand(int landId) {
    return http.delete(Constants.BASE_URL +Constants.GET_LANDS + '/$landId',
        headers: {"Content-Type": "application/json"});
  }
}
