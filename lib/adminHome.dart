import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dexture/_models/Farmer.dart';
import 'package:dexture/_services/AdminService.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();
  Future<List<Farmer>> farmers;

  @override
  void initState() {
    super.initState();
    farmers = _fetchFarmers();
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2))
      currentBackPressTime = now;
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

  _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => new Theme(
        data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.grey[100],
            backgroundColor: Colors.white),
        child: AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to log out from this account?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                print('successfully logout');
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Farmer>> _fetchFarmers() async {
    var response = await AdminService.getFarmers();

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Farmer> listOfUsers = items.map<Farmer>((json) {
        return Farmer.fromMapForSpringBoot(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  void accept(Farmer farmer) {
    farmer.isAccepted = true;
    AdminService.approveFarmer(farmer).then((res) {
      if (res.statusCode == 200) {
        _showSnackBar('Accepted');
        setState(() {
          farmers = _fetchFarmers();
        });
      } else {
        _showSnackBar('Error Occurred.');
      }
    });
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Dexture Admin'),
          centerTitle: true,
          backgroundColor: Colors.blue[600],
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  _showWarningDialog(context);
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(230.0))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
                    child: FutureBuilder(
                        future: farmers,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Farmer>> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Container(
                                child: Text('Error Occurred'),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data
                                  .map((farmer) => Card(
                                        child: ListTile(
                                            leading:
                                                Icon(Icons.album, size: 50),
                                            title: Text(farmer.firstName +
                                                ' ' +
                                                farmer.lastName),
                                            subtitle: Text(farmer.email),
                                            trailing: farmer.isAccepted == false
                                                ? RaisedButton(
                                                    onPressed: () {
                                                      accept(farmer);
                                                    },
                                                    child: Text('Accept'),
                                                  )
                                                : null),
                                      ))
                                  .toList(),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
