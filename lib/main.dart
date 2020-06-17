import 'package:dexture/introduction.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'createnewaccount.dart';
import 'package:dexture/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(Dexture());

class Dexture extends StatefulWidget {
  @override
  _DextureState createState() => _DextureState();
}

class _DextureState extends State<Dexture> {
  @override
  final MainModel _model = MainModel();

  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'Dexture',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            accentColor: Colors.indigo,
            buttonColor: Colors.brown),
        routes: {
          '/login': (BuildContext context) => LoginScreen(),
          '/account': (BuildContext context) => CreateAccountPage(),
        },
        home: App(),
      ),
    );
  }
}
