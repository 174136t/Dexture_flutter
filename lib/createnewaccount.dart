import 'package:dexture/_services/UserService.dart';
import 'package:dexture/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'main.dart';

main() {
  runApp(CreateAccountPage());
}

class Dexture1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dexture',
      debugShowCheckedModeBanner: false,
      // Set Raleway as the default app font

      home: CreateAccountPage(),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateAccountPageState();
  }
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String invalidMsg = "";
  String email;
  String nic;
  String password;
  String userType;
  String firstName;
  String lastName;
  String phone;
  String address;
  String gramaNiladari;
  String confirmPassword;
  String radioValue = '';
  final Map<String, dynamic> _formData = {
    'acceptTerms': false,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //var passKey = GlobalKey<FormFieldState>();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _buildEmailTextField() {
    return Container(
        // width: 300,
        child: TextFormField(
      autofocus: false,
      decoration: InputDecoration(
          // icon: Icon(Icons.email),

          contentPadding:
              new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          // icon: Icon(Icons.email),
          prefixIcon: Padding(
            padding: EdgeInsets.all(0.0),
            child: Icon(
              Icons.email,
              color: Colors.black,
            ), // icon is 48px widget.
          ),
          hintText: 'E-Mail',
          errorStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(fontSize: 14, color: Colors.black),
          filled: true,
          fillColor: Colors.white70
          //border: OutlineInputBorder(
          //  borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        this.email = value;
        //_formData['email'] = value;
      },
    ));
  }

  Widget _buildNicTextField() {
    return Container(
        // width: 300,
        child: TextFormField(
      autofocus: false,
      decoration: InputDecoration(
          // icon: Icon(Icons.email),

          contentPadding:
              new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          // icon: Icon(Icons.email),
          prefixIcon: Padding(
            padding: EdgeInsets.all(0.0),
            child: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ), // icon is 48px widget.
          ),
          hintText: 'Nic',
          errorStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(fontSize: 14, color: Colors.black),
          filled: true,
          fillColor: Colors.white70
          //border: OutlineInputBorder(
          //  borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid NIC';
        }
      },
      onSaved: (String value) {
        this.nic = value;
        //_formData['email'] = value;
      },
    ));
  }

  Widget _buildPasswordTextField() {
    return Container(
        // width: 300,
        child: TextFormField(
      autofocus: false,
      obscureText: true,
      //controller: _password,
      decoration: InputDecoration(
          // icon: Icon(Icons.keyboard),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          //icon: Icon(Icons.keyboard),
          prefixIcon: Padding(
            padding: EdgeInsets.all(0.0),
            child: Icon(
              Icons.vpn_key,
              color: Colors.black,
            ), // icon is 48px widget.
          ),
          hintText: 'Password',
          errorStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(fontSize: 14, color: Colors.black),
          filled: true,
          fillColor: Colors.white70
          //border: OutlineInputBorder(
          //   borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          ),
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password length must be at least 6';
        }
      },
      onSaved: (String value) {
        this.password = value;
        //_formData['password'] = value;
      },
    ));
  }

  Widget _buildfirstnameTextField() {
    return Container(
      // width: 300,
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            //icon: Icon(Icons.keyboard),
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.person_pin,
                color: Colors.black,
              ), // icon is 48px widget.
            ),
            hintText: 'First Name',
            errorStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            filled: true,
            fillColor: Colors.white70),
        validator: (String value) {
          if (value.isEmpty) {
            return "First name can't be empty ";
          }
        },
        onSaved: (String value) {
          this.firstName = value;
          //_formData['first_name'] = value;
        },
      ),
    );
  }

  Widget _buildlastnameTextField() {
    return Container(
      // width: 300,
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            //icon: Icon(Icons.keyboard),
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.person_pin,
                color: Colors.black,
              ), // icon is 48px widget.
            ),
            hintText: 'Last Name',
            errorStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            filled: true,
            fillColor: Colors.white70),
        validator: (String value) {
          if (value.isEmpty) {
            return " Last name can't be empty ";
          }
        },
        onSaved: (String value) {
          this.lastName = value;
          // _formData['last_name'] = value;
        },
      ),
    );
  }

  Widget _buildtpnoTextField() {
    return Container(
      // width: 300,
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            //icon: Icon(Icons.keyboard),
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.phone_android,
                color: Colors.black,
              ), // icon is 48px widget.
            ),
            hintText: 'Phone number ',
            errorStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            filled: true,
            fillColor: Colors.white70),
        validator: (String value) {
          if (value.isEmpty ||
              value.length != 10 ||
              !RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$")
                  .hasMatch(value)) {
            return ' Invalid phone number';
          }
        },
        keyboardType: TextInputType.numberWithOptions(),
        onSaved: (String value) {
          this.phone = value;
          //_formData['contact_no'] = value;
        },
      ),
    );
  }

  Widget _buildAddressTextField() {
    return Container(
      // width: 300,
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            //icon: Icon(Icons.keyboard),
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.home,
                color: Colors.black,
              ), // icon is 48px widget.
            ),
            hintText: 'Your address',
            errorStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            filled: true,
            fillColor: Colors.white70),
        validator: (String value) {
          // var password = passKey.currentState.value;

          if (value.isEmpty) {
            return 'Address can\'t be empty';
          }
        },
        onSaved: (String value) {
          this.address = value;
          // _formData['last_name'] = value;
        },
      ),
    );
  }

  Widget _buildGramaNiladariDivisionField() {
    return Container(
      // width: 300,
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            //icon: Icon(Icons.keyboard),
            prefixIcon: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.location_city,
                color: Colors.black,
              ), // icon is 48px widget.
            ),
            hintText: 'Your Grama Niladari Division',
            errorStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            filled: true,
            fillColor: Colors.white70),
        validator: (String value) {
          // var password = passKey.currentState.value;

          if (value.isEmpty) {
            return 'Grama Niladari Division can\'t be empty';
          }
        },
        onSaved: (String value) {
          this.gramaNiladari = value;
          // _formData['last_name'] = value;
        },
      ),
    );
  }

//method for accept terms
  Widget _buildAcceptCheck() {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.white),
      child: CheckboxListTile(
        //activeColor: Colors.white,

        value: _formData['acceptTerms'],
        onChanged: (bool value) {
          setState(() {
            _formData['acceptTerms'] = value;
          });
        },
        title: Text(
          'Accept terms',
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _registerForm() async {
    if (!_formKey.currentState.validate() ||
        !_formData['acceptTerms'] ||
        radioValue == '') {
      _showSnackBar('Check again you have miss something !');
      return;
    }
    _formKey.currentState.save();
    String role = userType == 'Farmer' ? '1' : '2';
    List<String> keys = [
      'FirstName',
      'LastName',
      'Email',
      'ContactNo',
      'Nic',
      'Password',
      'PersonalAddress',
      'role',
      'GramaNiladariDivision'
    ];
    List<String> springBootkeys = [
      'firstName',
      'lastName',
      'email',
      'contactNo',
      'nic',
      'password',
      'personalAddress',
      'role',
      'gramaNiladariDivision'
    ];
    List<dynamic> values = [
      firstName,
      lastName,
      email,
      phone,
      nic,
      password,
      address,
      role,
      gramaNiladari
    ];
    //todo change here for dotnet
    Map<String, dynamic> data = Map.fromIterables(springBootkeys, values);

    http.Response response = await UserService.userRegister(data, userType);
    print(response.statusCode);
    if (response.statusCode == 200) {
      _showSnackBar('Wait for Confirmation');
      Navigator.pop(context);
    } else {
      _showSnackBar('User Email already used.');
    }
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
//   void registerRequest() async {
//     var url = 'http://192.168.1.8:3000/users/cli_register';
// // print(firstName);
// // print(lastName);
//     var body = {
//       'first_name': "$firstName",
//       'last_name': "$lastName",
//       'user_type': "Client",
//       'email': "$email",
//       'password': "$password",
//       'gender': "$gender",
//       'contact_no': "$phone",
//     };
//     // final Map<String, dynamic> userdata = {
//     //   'first_name': firstName,
//     //   'last_name': lastName,
//     //   'email': email,
//     //   'contact_no': phone,
//     //   'password': password,
//     // };
//     // showDialog(
//     //     context: context,
//     //     builder: (BuildContext context) {
//     //       return buildLoadingDialog();
//     //     });

//     //print(body);

//     http.post(url, body: body).then((http.Response response) {
//       // print("***********");
//       // print(response.body);
//       // print('${response.statusCode}');
//       Map<String, dynamic> res = json.decode(response.body);
// print(response.body);
// print('fuckkkkkkkkkkkkk');
//       if (res['success'] == 1) {
//         //print(res['msg']);
//         // Navigator.of(context).pushNamedAndRemoveUntil(
//         //   '/login',
//         //   ModalRoute.withName('/user'),
//         // );
//         _showDialog();
//       } else {
//       //  Navigator.of(context).pop();
//         _shoDialog();
//       }
//     });
//   }
// void _shoDialog() {
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: new Text("Something went wrong!"),
//           // content: new Text("Alert Dialog body"),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("ok"),
//               onPressed: () {
//                 Navigator.of(context).pop();

//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 // );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create new account'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue[300], Colors.black],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          ),

          //image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // _usertype(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //  SizedBox(width: 12,),
                        //   Icon(Icons.wc),
                        //   SizedBox(width: 12,),
                        // Text('Gender'),
                        Flexible(
                          fit: FlexFit.loose,
                          child: new RadioListTile<String>(
                              dense: false,
                              title: new Text(
                                'Farmer',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              value: 'Farmer',
                              groupValue: radioValue,
                              onChanged: (String value) {
                                setState(() {
                                  radioValue = value;
                                  // _formData['gender']=radioValue;
                                  this.userType = radioValue;
                                });
                              }),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: new RadioListTile<String>(
                              title: new Text(
                                'Buyer',
                                style: TextStyle(fontSize: 14),
                              ),
                              value: 'Buyer',
                              groupValue: radioValue,
                              onChanged: (String value) {
                                setState(() {
                                  radioValue = value;
                                  //_formData['userType']=radioValue;
                                  this.userType = radioValue;
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildfirstnameTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildlastnameTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildEmailTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildNicTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildtpnoTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildAddressTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    this.userType == 'Farmer'
                        ? _buildGramaNiladariDivisionField()
                        : Container(),
                    this.userType == 'Farmer'
                        ? SizedBox(
                            height: 5.0,
                          )
                        : Container(),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),

                    _buildAcceptCheck(),
                    SizedBox(
                      width: 200,
                      child: RaisedButton(
                        color: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        textColor: Colors.white,
                        onPressed: () {
                          print('reg');
                          _registerForm();
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            //new Text('Button with text and icon!'),
                            Center(child: new Icon(Icons.lock_open)),
                            Center(child: Text('   Register')),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
