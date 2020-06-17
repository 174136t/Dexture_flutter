import 'dart:convert';

import 'package:dexture/_models/Bid.dart';
import 'package:dexture/_models/Harvest.dart';
import 'package:dexture/_services/BuyerService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HarvestList extends StatefulWidget {
  final int buyerId;
  HarvestList(this.buyerId);
  @override
  _HarvestListState createState() => _HarvestListState();
}

class _HarvestListState extends State<HarvestList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<http.Response> httpResponse;

  _getHarvestList(){
    setState(() {
     this.httpResponse = BuyerService.getHarvestList(widget.buyerId); 
    });
  }

  @override
  void initState() {
    super.initState();
    this._getHarvestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(230.0))),
        child: FutureBuilder(
            future: this.httpResponse,
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                http.Response res = snapshot.data;
                if (res.statusCode == 200) {
                  Iterable list = json.decode(res.body);
                  print(res.body);
                  List<Harvest> harvests =
                      list.map((model) => Harvest.fromMap(model)).toList();

                  return ListView.builder(
                    itemCount: harvests.length,
                    itemBuilder: (context, index) {
                      return HarvestCardList(
                          harvests[index].type,
                          harvests[index].unitPrice,
                          harvests[index].sellingQuantity,
                          widget.buyerId,
                          harvests[index].id,
                          _scaffoldKey,
                          this._getHarvestList);
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
            }),
      ),
    );
  }
}

class HarvestCardList extends StatefulWidget {
  final String type;
  final double unitPrice;
  final int quantity;
  final int buyerId;
  final int harvestId;
  final GlobalKey<ScaffoldState> scafkey;
  final Function getHarvestList;
  HarvestCardList(
      this.type, this.unitPrice,this.quantity, this.buyerId, this.harvestId, this.scafkey, this.getHarvestList);
  @override
  _HarvestCardListState createState() => _HarvestCardListState();
}

class _HarvestCardListState extends State<HarvestCardList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController bidAmount = TextEditingController();

  double bid;
  Widget _buildbidTextField() {
    return Container(
      // width: 300,
      child: TextFormField(
        controller: bidAmount,
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            //icon: Icon(Icons.keyboard),
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.monetization_on,
                color: Colors.black,
              ), // icon is 48px widget.
            ),
            hintText: 'bid value ',
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Colors.white70),
        validator: (String value) {
          if (value.isEmpty) {
            return ' Invalid bid amount';
          }
        },
        keyboardType: TextInputType.numberWithOptions(),
        onSaved: (String value) {
          this.bid = double.parse(value);
          bidAmount.clear();
          //_formData['contact_no'] = value;
        },
      ),
    );
  }

  Widget submitBidButton() {
    return SizedBox(
        height: 40.0,
        width: 250,
        child: RaisedButton(
          color: Colors.pink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          textColor: Colors.white,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              submitBid();
            }
          },
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Icon(Icons.money_off),
              Text(
                '  Submit Bid',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }

  void submitBid() {
    Bid bids = Bid(bid, widget.buyerId, widget.harvestId);
    print(bid);
    print(widget.harvestId);
    BuyerService.addbid(bids).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Bid Added.');
        widget.getHarvestList();
        Future.delayed(const Duration(seconds: 1), () {
          
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
      child: Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListTile(
              title: Center(child: Text(widget.type)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'Unit price: Rs: ' + widget.unitPrice.toStringAsFixed(2)),
                      Text(
                      'Quantity: ' + widget.quantity.toString()+'kg'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Put your bid here:'),
                  SizedBox(
                    height: 5,
                  ),
                  _buildbidTextField(),
                  SizedBox(
                    height: 10,
                  ),
                  submitBidButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
