import 'dart:async';
import 'dart:convert';

import 'package:dexture/_models/Harvest.dart';
import 'package:dexture/_services/FarmerService.dart';
import 'package:dexture/scoped_models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OntapLandCard extends StatefulWidget {
  final int landId;

  OntapLandCard(this.landId) {
    print(this.landId.toString() + '/////////////////');
  }

  @override
  _OntapLandCardState createState() => _OntapLandCardState();
}

class _OntapLandCardState extends State<OntapLandCard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<http.Response> harvestResponse;

  int farmerId;
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      farmerId = prefs.getInt('fid');
    });
    print('ggggggggg');
    print(farmerId);
  }

  getLandHarvest() {
    setState(() {
      this.harvestResponse = FarmerService.getLandHarvest(widget.landId);
    });
  }

  @override
  void initState() {
    super.initState();
    _read();
    getLandHarvest();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue[600],
        appBar: AppBar(
          title: Text('Land'),
          centerTitle: true,
          backgroundColor: Colors.blue[600],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Center(child: _addharvestButton(model)),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 220,
                  child: FutureBuilder(
                    future: harvestResponse,
                    builder: (BuildContext context,
                        AsyncSnapshot<http.Response> snapshot) {
                      if (snapshot.hasData) {
                        http.Response res = snapshot.data;
                        print(res.body);
                        print(farmerId);
                        print('5555555555555');
                        print(res.statusCode);
                        if (res.statusCode == 200) {
                          Iterable list = json.decode(res.body);
                          if (list.length == 0) {
                            return Center(
                              child:
                                  Text("No harvest added on this land so far"),
                            );
                          }
                          List<Harvest> harvests = list
                              .map((model) => Harvest.fromMap(model))
                              .toList();

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: harvests.length,
                            itemBuilder: (context, index) {
                              print(farmerId.toString() +
                                  'fffffffffffffffffffffff');
                              print(widget.landId.toString() +
                                  'llllllllllllllllllllllllll');

                              return GetHarvestCard(
                                  farmerId,
                                  widget.landId,
                                  harvests[index].id,
                                  harvests[index].type,
                                  harvests[index].sellingQuantity,
                                  harvests[index].unitPrice,
                                  harvests[index].status,
                                  _scaffoldKey,
                                  getLandHarvest);
                            },
                          );
                        } else {
                          return Center(
                            child: Text('Error Occurred.'),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Container(
                            child: Text('Error Occurred'),
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _deleteLandButton(model)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _addharvestButton(MainModel model) {
    return Container(
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HarvestCard(widget.landId)))
              .then(getLandHarvest());
        },
        child: Text('Add harvest'),
      ),
    );
  }

  Widget _deleteLandButton(MainModel model) {
    return Container(
      child: RaisedButton(
        color: Colors.red[600],
        textColor: Colors.white,
        onPressed: () {
          _showDialog();
        },
        child: Text('Delete land !'),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("Do you want to delete this land"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                delHarvest();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void delHarvest() {
    FarmerService.deleteLand(widget.landId).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Land deleted.');
        // setState(() {
        //   getLandHarvest();
        // });
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
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
}

class HarvestCard extends StatefulWidget {
  final int landId;

  HarvestCard(this.landId) {
    print(this.landId.toString() + '888888888888888');
  }
  @override
  _HarvestCardState createState() => _HarvestCardState();
}

class _HarvestCardState extends State<HarvestCard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  int _sellingQuantity;
  int farmerId;
  double _unitPrice;
  int landId;
  int status = 0;
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      farmerId = prefs.getInt('fid');
      landId = widget.landId;
    });
  }

  void addHarvest() {
    _read();
    print(farmerId);
    print(_name);
    print(_sellingQuantity);
    print(_unitPrice);
    print(landId);
    print(status);

    Harvest harvest = Harvest(
        farmerId, _name, _sellingQuantity, _unitPrice, widget.landId, status);
    FarmerService.addHarvest(harvest).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Harvest Added.');
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pop(context);
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
  void initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Add Harvest'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40),
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   color: Colors.blue[100],
          //   borderRadius: BorderRadius.only(topLeft: Radius.circular(230.0)),
          // ),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        //icon: Icon(Icons.keyboard),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.folder_open,
                            color: Colors.black,
                          ), // icon is 48px widget.
                        ),
                        hintText: 'Name',
                        filled: true,
                        fillColor: Colors.white70),
                    validator: (value) {
                      if (value.isEmpty || value.length < 3) {
                        return 'name length must be at least 3';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      this._name = value;
                    },
                  )),
              Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.line_weight,
                            color: Colors.black,
                          ), // icon is 48px widget.
                        ),
                        hintText: 'Quantity from kg',
                        filled: true,
                        fillColor: Colors.white70),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill this field';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      this._sellingQuantity = int.parse(value);
                    },
                  )),
              Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.black,
                          ), // icon is 48px widget.
                        ),
                        hintText: 'Unit price in LKR',
                        filled: true,
                        fillColor: Colors.white70),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill this field';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      this._unitPrice = double.parse(value);
                    },
                  )),
              Container(
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    print(landId);
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      addHarvest();
                    }
                  },
                  child: Text('Ok'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class GetHarvestCard extends StatefulWidget {
  final int farmerId;
  final int landId;
  final int id;
  final String type;
  final int sellingQuantity;
  final double unitPrice;
  final int status;
  final GlobalKey<ScaffoldState> scafkey;
  final Function getLandHarvest;

  GetHarvestCard(
      this.farmerId,
      this.landId,
      this.id,
      this.type,
      this.sellingQuantity,
      this.unitPrice,
      this.status,
      this.scafkey,
      this.getLandHarvest);

  @override
  _GetHarvestCardState createState() => _GetHarvestCardState();
}

class _GetHarvestCardState extends State<GetHarvestCard> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String type;
  int sellingQuantity;
  double unitPrice;

  @override
  void initState() {
    super.initState();
    print('set');
    setState(() {
      type = widget.type;
      sellingQuantity = widget.sellingQuantity;
      unitPrice = widget.unitPrice;
    });
  }

  void sellHarvest() {
    print(widget.farmerId);
    print(type);
    print(sellingQuantity);
    print(unitPrice);
    print(widget.landId);

    Harvest harvest = Harvest(
        widget.farmerId, type, sellingQuantity, unitPrice, widget.landId, 1);
    harvest.id = (widget.id);
    FarmerService.sellHarvest(harvest).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Successfull.');
        setState(() {
          widget.getLandHarvest();
        });
        Future.delayed(const Duration(seconds: 1), () {
          //Navigator.pop(context);
        });
      } else {
        _showSnackBar('Error Occurred.');
      }
    });
  }

  void cancelSell() {
    print(widget.farmerId);
    print(type);
    print(sellingQuantity);
    print(unitPrice);
    print(widget.landId);

    Harvest harvest = Harvest(
        widget.farmerId, type, sellingQuantity, unitPrice, widget.landId, 0);
    harvest.id = (widget.id);
    FarmerService.sellHarvest(harvest).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Successfull.');
        setState(() {
          widget.getLandHarvest();
        });
        Future.delayed(const Duration(seconds: 1), () {
          //Navigator.pop(context);
        });
      } else {
        _showSnackBar('Error Occurred.');
      }
    });
  }

  void delHarvest() {
    Harvest harvest = Harvest(
        widget.farmerId, type, sellingQuantity, unitPrice, widget.landId, 1);
    harvest.id = (widget.id);
    FarmerService.deleteHarvest(harvest.id).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Successfully deleted.');
        setState(() {
          widget.getLandHarvest();
        });
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
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
    widget.scafkey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width *0.55,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: GestureDetector(
        // onTap: () {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => OntapLandCard()));
        // },
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10, 
                ),

                Text('Type:' + type),
                Text('Unit Price: Rs:' + unitPrice.toStringAsFixed(2)),
                Text('Quantity: ' + sellingQuantity.toString() + 'kg'),
                SizedBox(
                  height: 20,
                ),
                _sellButton(),
                SizedBox(
                  height: 5,
                ),
                _delBtn(),
                // Text('Longitude: ' + widget.longi.toStringAsFixed(4)),
                // Text('Size: ' + widget.size.toString()+' perches'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sellButton() {
    return Container(
      child: RaisedButton(
        color: widget.status == 0 ? Colors.indigo[600] : Colors.green[600],
        textColor: Colors.white,
        onPressed: () {
          widget.status == 0 ? sellHarvest() : cancelSell();
        },
        child: widget.status == 0 ? Text('Sell') : Text('Selling'),
      ),
    );
  }

  Widget _delBtn() {
    return Container(
      child: RaisedButton(
        color: Colors.red[600],
        textColor: Colors.white,
        onPressed: () {
          print('delete');
          _showDialog();
        },
        child: Text('Delete!'),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("Do you want to delete this item"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                delHarvest();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
