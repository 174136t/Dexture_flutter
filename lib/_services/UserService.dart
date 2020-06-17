import 'dart:convert';

import 'package:dexture/_utils/Constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class UserService {
  static void test() {
    http.get(Constants.BASE_URL + Constants.TEST_URL).then((res) {
      print('*********');
      print(res.body);
    });
  }

  static Future<http.Response> userLogin(
      String email, String password, String userType) {
    var body = {
      "email": "$email",
      "password": "$password",
    };
    if (userType == 'Farmer')
      return http.post(Constants.BASE_URL + Constants.FARMER_LOGIN_URL,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
    if (userType == 'Buyer')
      return http.post(Constants.BASE_URL + Constants.BUYER_LOGIN_URL,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
    if (userType == 'Admin') {
      return http.post(Constants.BASE_URL + Constants.ADMIN_LOGIN_URL,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
    } // usertype =='buyer ekk danna'
  }

  static Future<http.Response> userRegister(
      Map<String, dynamic> userData, String userType) {
    if (userType == 'Farmer')
      return http.post(Constants.BASE_URL + Constants.FARMER_REG_URL,
          body: json.encode(userData),
          headers: {"Content-Type": "application/json"});
    else
      return http.post(Constants.BASE_URL + Constants.BUYER_REG_URL,
          body: json.encode(userData),
          headers: {"Content-Type": "application/json"});
  }
}
