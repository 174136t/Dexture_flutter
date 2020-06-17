import 'dart:convert';

import 'package:dexture/_models/Bid.dart';
import 'package:dexture/_models/Buyer.dart';
import 'package:dexture/_services/BuyerService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BidsList extends StatefulWidget {
  final int buyerId;
  BidsList(this.buyerId);
  @override
  _BidsListState createState() => _BidsListState();
}

class _BidsListState extends State<BidsList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<http.Response> httpResponse;
  _viewBids() {
    setState(() {
      this.httpResponse = BuyerService.viewBids(widget.buyerId);
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
            future: this.httpResponse,
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                http.Response res = snapshot.data;
                if (res.statusCode == 200) {
                  Iterable list = json.decode(res.body);
                  print(res.body);
                  list.forEach((ele) {
                    print(ele['id']);
                  });
                  List<Bid> bidList =
                      list.map((model) => Bid.fromMap(model)).toList();

                  return ListView.builder(
                    itemCount: bidList.length,
                    itemBuilder: (context, index) {
                      print(bidList.length);

                      return ViewBidList(
                        bidList[index].bidId,
                          bidList[index].bidPrice,
                          bidList[index].harvest.type,
                          bidList[index].harvest.unitPrice,
                          bidList[index].harvest.sellingQuantity,
                          _viewBids,
                          _scaffoldKey);
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

class ViewBidList extends StatefulWidget {
  final int id;
  final double bidUnitPrice;
  final String type;
  final double unitPrice;
  final int quantity;
  final Function _viewBids;
  final GlobalKey<ScaffoldState> scafkey;
  ViewBidList(this.id,this.bidUnitPrice, this.type, this.unitPrice, this.quantity,this._viewBids,this.scafkey);
  @override
  _ViewBidListState createState() => _ViewBidListState();
}

class _ViewBidListState extends State<ViewBidList> {
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
          content: new Text("Do you want to delete this bid item"),
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
    
    BuyerService.deleteBid(widget.id).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        _showSnackBar('Successfully deleted.');
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
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ListTile(
            title: Center(child: Text(widget.type)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Unit price: Rs: ' + widget.unitPrice.toStringAsFixed(2)),
                Text('Bid Unit price: Rs: ' +
                    widget.bidUnitPrice.toStringAsFixed(2)),
                Text('Quantity: ' + widget.quantity.toString() + 'kg'),
                SizedBox(
                  height: 10,
                ),
                _delBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
