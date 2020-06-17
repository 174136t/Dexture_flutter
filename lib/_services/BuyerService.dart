import 'package:dexture/_models/Bid.dart';
import 'package:http/http.dart' as http;
import 'package:dexture/_utils/Constants.dart';
import 'dart:async';
import 'dart:convert';

class BuyerService{
  static Future<http.Response> getHarvestList(int buyerId) {
    return http.get(Constants.BASE_URL + Constants.BUYER_REG_URL+'/$buyerId'+Constants.GET_HARVEST ,
        headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> viewBids(int buyerId) {
    return http.get(Constants.BASE_URL + Constants.BUYER_REG_URL + '/$buyerId'+ Constants.GET_BID,
        headers: {"Content-Type": "application/json"});
  }


  static Future<http.Response> addbid(Bid bid) {
    return http.post(Constants.BASE_URL + Constants.BUYER_REG_URL+Constants.ADD_BID,
        body: json.encode(bid.toMap()),
        headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> deleteBid(int bidId) {
    return http.delete(Constants.BASE_URL +Constants.BUYER_REG_URL +Constants.ADD_BID+ '/$bidId',
        headers: {"Content-Type": "application/json"});
  }
}