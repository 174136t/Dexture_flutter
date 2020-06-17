import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../scoped_models/main_model.dart';
import '../models/location.dart';

class MapImageWindow extends StatefulWidget {
  final MainModel _model;
  final double lat;
  final double lng;

  MapImageWindow(this._model, this.lat, this.lng);

  @override
  _MapImageWindowState createState() => _MapImageWindowState();
}

class _MapImageWindowState extends State<MapImageWindow> {
  Uri mapImageUri;
  Uri geocodeUri;

  void cordsToAddress(double lat, double lng) async {
    geocodeUri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'latlng': '$lat,$lng', 'key': 'AIzaSyBjTh5fhWEMqiDEtMYmmQyVfNYdvNcB39A'},
    );

    final http.Response response = await http.get(geocodeUri.toString());
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];

    setState(() {
      widget._model.currentLocation = Location(
        address: formattedAddress,
        lat: lat,
        lng: lng,
      );
      _buildStaticMap();
    });
  }

  void _buildStaticMap() {
    mapImageUri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/staticmap',
      {
        'size': '1280x720',
        'zoom': '16',
        'markers':
            'color:0xd20000|label:default|${widget._model.currentLocation.lat.toString()},${widget._model.currentLocation.lng.toString()}',
        'center':
            '${widget._model.currentLocation.lat.toString()},${widget._model.currentLocation.lng.toString()}',
        'maptype': 'roadmap',
        'key': 'AIzaSyBjTh5fhWEMqiDEtMYmmQyVfNYdvNcB39A'
      },
    );
  }

  Widget _buildCapturedMapImage() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: widget._model.currentLocation == null
              ? Container()
              : FadeInImage(
                  image: NetworkImage(
                    mapImageUri.toString(),
                  ),
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  placeholder: AssetImage('assets/android.jpg'),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildCapturedMapImage(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    cordsToAddress(widget.lat, widget.lng);
  }

  @override
  void dispose() {
    super.dispose();
    widget._model.currentLocation = null;
  }


}
