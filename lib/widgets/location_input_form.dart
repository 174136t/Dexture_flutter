import 'dart:convert';
import '../scoped_models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as geoLoc;
import '../models/location.dart';

class LocationInputFormField extends StatefulWidget {
  final MainModel _model;

  LocationInputFormField(this._model);

  @override
  _LocationInputFormFieldState createState() => _LocationInputFormFieldState();
}

class _LocationInputFormFieldState extends State<LocationInputFormField> {
  Uri mapImageUri;
  Uri geocodeUri;

  final TextEditingController _locationInputController =
      TextEditingController();

  Widget _buildLocationInputFormField() {
    return TextFormField(
      maxLines: null,
      controller: _locationInputController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _addressToCords(_locationInputController.text);
          },
        ),
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(),
        ),
        filled: true,
        hintText: 'Enter address here',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Location Cannot be empty';
        }
        return null;
      },
    );
  }

  void _addressToCords(String address) async {
    if (address.isEmpty) {
      return;
    }

    geocodeUri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'address': address, 'key': 'AIzaSyBjTh5fhWEMqiDEtMYmmQyVfNYdvNcB39A'},
    );

    final http.Response response = await http.get(geocodeUri.toString());
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final cords = decodedResponse['results'][0]['geometry']['location'];

    setState(() {
      widget._model.currentLocation = Location(
        address: formattedAddress,
        lat: cords['lat'],
        lng: cords['lng'],
      );
      _locationInputController.text = widget._model.currentLocation.address;
      _buildStaticMap();
    });
  }

  void _getUserLocation() async {
    final location = geoLoc.Location();
    final userLocation = await location.getLocation();
    print(userLocation.latitude);
    print(userLocation.longitude);
    _cordsToAddress(userLocation.latitude, userLocation.longitude);
  }

  void _cordsToAddress(double lat, double lng) async {
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
      _locationInputController.text = widget._model.currentLocation.address;
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
        _buildLocationInputFormField(),
        SizedBox(
          height: 10.0,
        ),
        Stack(
          children: <Widget>[
            _buildCapturedMapImage(),
            Positioned(
              bottom: 5,
              left: 5,
              child: IconButton(
                icon: Icon(Icons.my_location),
                onPressed: () {
                  _getUserLocation();
                  print('pressed');
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation(); //live location
  }

  @override
  void dispose() {
    super.dispose();
    widget._model.currentLocation = null;
    _locationInputController.dispose();
  }
}
