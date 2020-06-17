
import 'dart:convert';

import 'package:dexture/_models/Farmer.dart';
import 'package:dexture/_utils/Constants.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

class AdminService {
  static Future<http.Response> getFarmers() {
    return http.get(Constants.BASE_URL + Constants.GET_FARMERS);
  }

  static Future<http.Response> approveFarmer(Farmer farmer) {
    return http.put(
        Constants.BASE_URL + Constants.APPROVE + '/${farmer.farmerId}',
        body: json.encode(farmer.toMapForSpringBoot()),
        headers: {"Content-Type": "application/json"});
  }
}
