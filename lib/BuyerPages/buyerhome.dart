import 'dart:async';
import 'dart:io';


import 'package:dexture/BuyerPages/bidsList.dart';
import 'package:dexture/BuyerPages/harvestList.dart';
import 'package:dexture/_models/Buyer.dart';
import 'package:flutter/material.dart';

class BuyerHome extends StatefulWidget {
  final Buyer buyer;
  BuyerHome(this.buyer);
  @override
  _BuyerHomeState createState() => new _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();


  
  // saveLogout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   prefs.remove('id');
  //   prefs.remove('email');
  //   prefs.remove('token');
  //   prefs.remove('userType');
  // }

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
                    // Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => LoginScreen()
                    //             )
                    //             );
                    //saveLogout();
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
            )));
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

  @override
  Widget build(BuildContext context) {
    // textStyle() {
    //   return new TextStyle(color: Colors.black, fontSize: 30.0);
    // }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new DefaultTabController(
          length: 2,
          child: new Scaffold(
            //  key: scaffoldKey,
            drawer: Drawer(
                child: Container(
              color: Colors.grey[100],
              child: ListView(
                children: <Widget>[
                  /* AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),*/
                  new UserAccountsDrawerHeader(
                    accountName: new Text('Buyer home page'),
                    accountEmail:
                        new Text('Predictions'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: new ExactAssetImage("assets/b.jpg"),
                      minRadius: 30,
                      maxRadius: 60,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Edit profile'),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => EditClientprofile()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('View feedbacks'),
                    onTap: () {},
                  ),
 
                  // ListTile(
                  //   leading: Icon(Icons.settings),
                  //   title: Text('Settings'),
                  //   onTap: () {},
                  // ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help'),
                    onTap: () {},
                  ),
 
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About us'),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AboutUsScreen()));
                    },
                  ), 

                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Log out'),
                    onTap: () => _showWarningDialog(context),
                  ),
                ],
              ),
            )),
            appBar: new AppBar(
              
              // leading: _isSearching ? const BackButton() : null,
              title:Text('Dexture'),
              centerTitle: true,
              // actions: _buildActions(),
              // title: Text('uDevs'),
              backgroundColor: Colors.blue[600],
              bottom: new TabBar(
                indicatorColor: Colors.amber,
                tabs: <Widget>[
                  new Tab(
                    icon: new Icon(Icons.line_style),
                    text: "Harvest list",
                  ),
                  new Tab( 
                    text: 'Bids list',
                    icon: new Icon(Icons.monetization_on),
                  ),
                ],
              ),
            ),

            body: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(),
                  Expanded(
                    child: new TabBarView(
                      children: <Widget>[
                        HarvestList(widget.buyer.buyerId),
                        BidsList(widget.buyer.buyerId),
                        // ClientNotifyScreen(),
                        //RatingBar(
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}