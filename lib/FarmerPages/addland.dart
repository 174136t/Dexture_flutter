import 'package:dexture/_models/Farmer.dart';
import 'package:dexture/_models/Land.dart';
import 'package:dexture/_services/FarmerService.dart';
import 'package:dexture/models/location.dart';
import 'package:dexture/scoped_models/main_model.dart';
import 'package:dexture/widgets/location_input_form.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AddLand extends StatefulWidget {
  final Farmer farmer;

  AddLand(this.farmer); 

  @override
  _AddLandState createState() => _AddLandState();
}

class _AddLandState extends State<AddLand> {
  TextEditingController _landSize = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.blue,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(230.0))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
                child: Column(
                  children: <Widget>[
                    LocationInputFormField(model),
                    _sizeInputField(),
                    _addLandButton(model),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sizeInputField() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: TextFormField(
          controller: _landSize,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Land Size in Perch',
            prefixIcon: Icon(Icons.crop_landscape),
            fillColor: Colors.white,
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter size of land!';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _addLandButton(MainModel model) {
    return Container(
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () {
          if (_formKey.currentState.validate()) this._add(model);
        },
        child: this._loading == true ? CircularProgressIndicator() : Text('Ok'),
      ),
    );
  }

  void _add(MainModel model) async {
    Location addedLoc = model.currentLocation;
    if (addedLoc == null) {
      this._showSnackBar('Location is not Seleted.');
      return;
    }
    if (_landSize.text == null) {
      this._showSnackBar('Please add land size.');
      return;
    }
    setState(() {
      this._loading = true;
    });
    Land newLand = Land(double.parse(this._landSize.text), addedLoc.lat,
        addedLoc.lng, widget.farmer.farmerId);
    FarmerService.addLand(newLand).then((res) {
      setState(() {
        this._loading = false;
      });
      if (res.statusCode == 200) {
        _showSnackBar('Land Added successfully.');
        _landSize.clear();
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
