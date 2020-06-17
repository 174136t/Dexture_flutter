import 'dart:convert';

import 'package:dexture/_models/Bid.dart';
import 'package:dexture/_models/Farmer.dart';
import 'package:dexture/_services/FarmerService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageBids extends StatefulWidget {
  final int farmerId;

  ManageBids(this.farmerId);
  @override
  _ManageBidsState createState() => _ManageBidsState();
}

class _ManageBidsState extends State<ManageBids> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<http.Response> httpResponse;
  _viewBids() {
    setState(() {
      this.httpResponse = FarmerService.getBids(widget.farmerId);
    });
  }

  @override
  void initState() {
    super.initState();
    this._viewBids();
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
            future: FarmerService.getBids(widget.farmerId),
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                http.Response res = snapshot.data;
                print(res);
                if (res.statusCode == 200) {
                  Iterable bid = json.decode(res.body);
                  List<Bid> bids =
                      bid.map((model) => Bid.fromMap(model)).toList();
                  return ListView.builder(
                    itemCount: bids.length,
                    itemBuilder: (context, index) {
                      return BidCard(
                          bids[index].bidId,
                          bids[index].bidPrice,
                          bids[index].buyerId,
                          bids[index].harvestId,
                          bids[index].status,
                          bids[index].harvest.type,
                          bids[index].harvest.unitPrice,
                          bids[index].harvest.sellingQuantity,
                          _viewBids,
                          _scaffoldKey);
                    },
                  );
                } else {
                  return Center(
                    child: Container(
                      child: Text('No bids to show !'),
                    ),
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

class BidCard extends StatefulWidget {
  final int id;
  final double bidUnitPrice;
  final int buyerId;
  final int harvestId;
  final int status;
  final String type;
  final double unitPrice;
  final int quantity;
  final Function _viewBids;
  final GlobalKey<ScaffoldState> scafkey;
  BidCard(this.id, this.bidUnitPrice, this.buyerId, this.harvestId, this.status,
      this.type, this.unitPrice, this.quantity, this._viewBids, this.scafkey);
  @override
  _BidCardState createState() => _BidCardState();
}

class _BidCardState extends State<BidCard> {
  Widget _cancelBtn() {
    return Container(
      child: RaisedButton(
        color: Colors.pink[600],
        textColor: Colors.white,
        onPressed: () {
          print('delete');
          _showDialog();
        },
        child: Text('Cancel'),
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
          content: new Text("Do you want to cancel this bid"),
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
                cancel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _acceptBtn() {
    return Container(
      child: RaisedButton(
        color: widget.status == 0 ? Colors.indigo[600] : Colors.green[600],
        textColor: Colors.white,
        onPressed: widget.status == 0
            ? () {
                _showDialo();
              }
            : null,
        child: widget.status == 0
            ? Text('Accept')
            : widget.status == 1 ? Text('Accepted') : Text('Rejected'),
      ),
    );
  }

  void _showDialo() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("Do you want to accept this bid"),
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
                accept();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void accept() {
    Bid harvest = Bid(
      widget.bidUnitPrice,
      widget.buyerId,
      widget.harvestId,
    );
    harvest.status = 1;
    harvest.bidId = widget.id;
    FarmerService.updateBid(harvest).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Bid accepted.');
        setState(() {
          widget._viewBids();
        });
        Future.delayed(const Duration(seconds: 1), () {
          //Navigator.pop(context);
        });
      } else {
        _showSnackBar('Error Occurred.');
      }
    });
  }

  void cancel() {
    Bid harvest = Bid(
      widget.bidUnitPrice,
      widget.buyerId,
      widget.harvestId,
    );
    harvest.status = 2;
    harvest.bidId = widget.id;
    FarmerService.updateBid(harvest).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Bid rejected.');
        setState(() {
          widget._viewBids();
        });
        Future.delayed(const Duration(seconds: 1), () {
          //Navigator.pop(context);
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
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => OntapLandCard()));
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListTile(
              // title: Text(_address),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Type: ' + widget.type),
                  Text(
                      'Unit price: Rs: ' + widget.unitPrice.toStringAsFixed(2)),
                  Text('Bid Unit price: Rs: ' +
                      widget.bidUnitPrice.toStringAsFixed(2)),
                  Text('Quantity: ' + widget.quantity.toString() + 'kg'),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: widget.status == 0
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      _acceptBtn(),
                      widget.status == 0 ? _cancelBtn() : Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
