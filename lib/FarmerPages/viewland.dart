import 'dart:convert';

import 'package:dexture/FarmerPages/ontapLandCard.dart';
import 'package:dexture/_models/Land.dart';
import 'package:dexture/_services/FarmerService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewLand extends StatefulWidget {
  final int farmerId;

  ViewLand(this.farmerId);

  @override
  _ViewLandState createState() => _ViewLandState();
}

class _ViewLandState extends State<ViewLand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(230.0)),
        ),
        child: FutureBuilder(
            future: FarmerService.viewLands(widget.farmerId),
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                http.Response res = snapshot.data;
                if (res.statusCode == 200) {
                  Iterable list = json.decode(res.body);
                  print(res.body);
                  List<Land> lands = list
                      .map((model) => Land.fromMap(model))
                      .toList();
                      
                  return ListView.builder(
                    itemCount: lands.length,
                    itemBuilder: (context, index) {
                      return LandCard(
                          lands[index].latitude, lands[index].longitude, lands[index].size,lands[index].landId);
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

class LandCard extends StatefulWidget {
  final double lat;
  final double longi;
  final double size;
   int landId;
  LandCard(this.lat, this.longi, this.size, int id){
    this.landId = id;
    print(id);
    print('//');
  }

  @override
  _LandCardState createState() => _LandCardState();
}

class _LandCardState extends State<LandCard> {
  String _address = 'Land Address';

  cordsToAddress() async {
    Uri geocodeUri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${widget.lat},${widget.longi}',
        'key': 'AIzaSyBjTh5fhWEMqiDEtMYmmQyVfNYdvNcB39A'
      },
    );

    http.get(geocodeUri.toString()).then((response) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        _address = decodedResponse['results'][0]['formatted_address'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print('set');
    this.cordsToAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OntapLandCard(widget.landId)));
              print(widget.landId.toString()+'landdddddddddddddddd');
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListTile(
              title: Text(_address),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Latitude: ' + widget.lat.toStringAsFixed(4)),
                  Text('Longitude: ' + widget.longi.toStringAsFixed(4)),
                  Text('Size: ' + widget.size.toString()+' perches'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
