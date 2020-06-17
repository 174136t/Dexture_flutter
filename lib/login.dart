import 'dart:io';

import 'package:dexture/BuyerPages/buyerhome.dart';
import 'package:dexture/FarmerPages/farmerhome.dart';
import 'package:dexture/_models/Buyer.dart';
import 'package:dexture/_models/Farmer.dart';
import 'package:dexture/_services/UserService.dart';
import 'package:dexture/adminHome.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'createnewaccount.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int farmerId;
  int buyerId;
  String email;
  String password;
  String userType;
  String invalidMsg = "";
  bool _loading = false;

  //String email = "";

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        //   backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.blue[300], Colors.black],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
          ),
          //padding: EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      children: <Widget>[
                        SizedBox(height: 100.0),
                        Container(
                          color: Colors.pink[600],
                          child: SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'Dexture',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //  welcomeText(),
                        typeSelector(),
                        SizedBox(height: 20.0),
                        emailField(),
                        SizedBox(height: 10.0),
                        passwordField(),
                        SizedBox(height: 40.0),
                        loginButton(),
                        SizedBox(height: 60.0),
                        // forgetPasswordButton(),
                        //createAccountButton(),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              '   Don\'t have an account yet? ',
                              style: new TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, right: 10.0, top: 0.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateAccountPage(),
                                      ));
                                },
                                child: new Container(
                                    alignment: Alignment.center,
                                    height: 40.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            new BorderRadius.circular(9.0)),
                                    child: new Text("Create one",
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.blue))),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    // if (now.difference(currentBackPressTime) > Duration(seconds: 2))
    //   currentBackPressTime = now;
    return showDialog(
      context: context,
      builder: (context) => new Theme(
        data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.grey[100],
            backgroundColor: Colors.white),
        child: AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit from this App?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => exit(0),
              child: new Text('Yes'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeSelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          
          child: new RadioListTile<String>(
              dense: false,
              title: new Text( 
                'Farmer',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              value: 'Farmer',
              groupValue: userType,
              onChanged: (String value) {
                setState(() {
                  userType = value;
                  this.userType = userType;
                });
              }),
        ),
        Expanded(
          
          child: new RadioListTile<String>(
              dense: false,
              title: new Text(
                'Buyer',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              value: 'Buyer',
              groupValue: userType,
              onChanged: (String value) {
                setState(() {
                  userType = value;
                  this.userType = userType;
                });
              }),
        ),
        // Expanded(
          
        //   child: new RadioListTile<String>(
        //       title: new Text(
        //         'Admin',
        //         style: TextStyle(fontSize: 14),
        //       ),
        //       value: 'Admin',
        //       groupValue: userType,
        //       onChanged: (String value) {
        //         setState(() {
        //           userType = value;
        //           this.userType = userType;
        //         });
        //       }),
        // ),
      ],
    );
  }

  Widget emailField() {
    return Container(
        width: 300,
        child: TextFormField(
          autofocus: false,
          decoration: InputDecoration(
              // icon: Icon(Icons.email),

              contentPadding:
                  new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              // icon: Icon(Icons.email),
              prefixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(
                  Icons.email,
                  color: Colors.black,
                ), // icon is 48px widget.
              ),
              hintText: 'E-Mail',
              hintStyle: TextStyle(color: Colors.black),
              errorStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white70
              //border: OutlineInputBorder(
              //  borderRadius: const BorderRadius.all(Radius.circular(20.0))),
              ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return 'Please enter a valid email';
            }
          },
          onSaved: (String value) {
            this.email = value;
          },
        ));
  }

  Widget passwordField() {
    return Container(
        width: 300,
        child: TextFormField(
          autofocus: false,
          obscureText: true,
          decoration: InputDecoration(
              // icon: Icon(Icons.keyboard),
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              // enabledBorder:  OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(color: Colors.white)
              // ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              //icon: Icon(Icons.keyboard),
              prefixIcon: Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(
                  Icons.vpn_key,
                  color: Colors.black,
                ), // icon is 48px widget.
              ),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black),
              errorStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white70
              //border: OutlineInputBorder(
              //   borderRadius: const BorderRadius.all(Radius.circular(20.0))),
              ),
          validator: (value) {
            if (value.isEmpty || value.length < 6) {
              return 'Password length must be at least 6';
            }
          },
          onSaved: (String value) {
            this.password = value;
          },
        ));
  }

  Widget loginButton() {
    return SizedBox(
        height: 40.0,
        width: 200,
        child: RaisedButton(
          color: Colors.amber[600],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          textColor: Colors.white,
          onPressed: () {
            if (userType == null) {
              _showSnackBar('Select User type.');
              return;
            }
            if (_formKey.currentState.validate()) {
              this._login();
            }
          },
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Icon(
                Icons.lightbulb_outline,
                color: Colors.black,
              ),
              Text(
                '  Sign in',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ));
  }

  void _login() {
    setState(() {
      this._loading = true;
    });
    _formKey.currentState.save();

    UserService.userLogin(email, password, userType).then((response) {
      setState(() {
        this._loading = false;
      });


      print(response.body);



      if (response == null) {
        _showSnackBar('Error occurred.');
        return;
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if(userType=='Farmer')
        farmerId=responseData['farmer']['farmerId'];
        
        if(userType=='Buyer')
        buyerId=responseData['buyer']['buyerId'];
       // userType=responseData['farmer'];
       _savePreference();
       _read();
        
        if (responseData['accepted'] == false) {
          this._showSnackBar('Not Accepted Yet.');
          return;
        } else {
          String token = responseData['token'];
          if (userType == 'Farmer') {
            Farmer farmer = Farmer.fromMapForSpringBoot(responseData['farmer']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(farmer)),
            );
          } else if (userType == 'Admin') {
            //Farmer farmer = Farmer.fromMap(responseData['admin']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHome()),
            );
          }
          else if (userType == 'Buyer') {
            Buyer buyer = Buyer.fromMap(responseData['buyer']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BuyerHome(buyer)),
            );
          }
        }
      } else if (response.statusCode == 400) {
        this._showSnackBar('Invalid Username or Password.');
      } else {
        this._showSnackBar('Error Occurred.');
      }
    });
  }

_savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('fid', farmerId );
    //prefs.setString('userType', userType);
    //prefs.setString('email', email);
  }
  _read() async {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final farmerid = prefs.getInt('fid') ?? 0;
    print(farmerid);
    // final token = prefs.getString('token') ?? " ";
    // print(token);
    // final userType = prefs.getString('userType') ?? " ";
    // print(userType);
    // final email = prefs.getString('email') ?? " ";
    // print(email);
   
  }
  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget forgetPasswordButton() {
    return FlatButton(
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget createAccountButton() {
    return FlatButton(
      child: Text(
        'Create new Account',
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()),
        );
      },
    );
  }
}
