import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'loginscreen.dart';

class ChangePasswordforgot extends StatefulWidget {
  var hrmsId;

  ChangePasswordforgot(this.hrmsId);
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordforgot> {
  var msg_lastpass = "";

  bool _newshowPassword = false;
  bool _confirmshowPassword = false;
  bool _hasBeenPressed = false;
  bool _firstclick = true;
  var eightChar = false, oneSpecialChar = false, requiredAt = false;

  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  Future<void> changepassword() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    var passUser = await pref.getPassword();
    final String url = new UtilsFromHelper().getValueFromKey("change_password");

    if (newpasswordController.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Your New Password',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (eightChar == false ||
        oneSpecialChar == false ||
        requiredAt == false) {
      Fluttertoast.showToast(
          msg: 'Your New Password Is Weak',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (confirmpasswordController.text != newpasswordController.text) {
      Fluttertoast.showToast(
          msg: 'Your Confirm Password Is Not Match',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      setState(() {
        _hasBeenPressed = true;
        _firstclick = false;
      });

      String basicAuth = await Hrmstokenplugin.hrmsToken;
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Map map = {
        'hrmsId': widget.hrmsId,
        'password': confirmpasswordController.text,
        'userType_flag': "U"
      };
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Accept', "application/json");
      request.headers.set('authorization', basicAuth);
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      String value = await response.transform(utf8.decoder).join();
      var responseJSON = json.decode(value) as Map;
      bool result = responseJSON['result'];
      String message = responseJSON['message'];
      if (result) {
        changepasswordhistory();
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

        setState(() {
          _hasBeenPressed = false;
          newpasswordController.text = "";
          confirmpasswordController.text = "";
        });
      }else
        {
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      setState(() {
        _firstclick = true;
      });
    }
  }

  Future<void> changepasswordhistory() async {
    //
    final String url = new UtilsFromHelper()
        .getValueFromKey("forgot_get_change_password_history");
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsId': widget.hrmsId,
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON["result"]) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    newpasswordController.addListener(() {
      setState(() {
        eightChar = newpasswordController.text.length > 7;
        oneSpecialChar = newpasswordController.text.isNotEmpty &&
            !newpasswordController.text.contains(RegExp(r'^[\w.-]+$'), 0);
        requiredAt = newpasswordController.text.contains(RegExp(r'\d'), 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Change Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(children: <Widget>[
            SizedBox(height: 10),
            Card(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: HexColor("#2874A6")),
                    ),
                  ),
                  child: Column(children: <Widget>[
                    SizedBox(height: 10),
                    Align(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "PASSWORD\nPOLICY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: HexColor("#536c79")),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: 1.0,
                        color: HexColor("#d3d3d3"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "1.Your password should be minimum 8 characters and maximum 15 characters long.",
                          style: TextStyle(color: HexColor("#2d98da")),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    Align(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "2. Maximum length For Password Should be 15 long.",
                          style: TextStyle(color: HexColor("#2d98da")),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    Align(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "2. Your password should contain at least 1 upper case letter, 1 lower case letter , 1 digit/number and 1 special character (out of !,@,#,%,&,*).",
                          style: TextStyle(color: HexColor("#2d98da")),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    Align(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "3. You can not repeat previously used 2 passwords",
                          style: TextStyle(color: HexColor("#2d98da")),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    Align(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "4. Following cannot be part of your password :'HRMS','IRHRMS','TEST','123','1234,'12345'.",
                          style: TextStyle(color: HexColor("#2d98da")),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                  ])),
            ),
            SizedBox(height: 20),
            Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    msg_lastpass,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "New Password",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: newpasswordController,
                      obscureText: !this._newshowPassword,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _newshowPassword = !_newshowPassword;
                            });
                          },
                          child: Icon(
                            _newshowPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Column(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: confirmpasswordController,
                      obscureText: !this._confirmshowPassword,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _confirmshowPassword = !_confirmshowPassword;
                            });
                          },
                          child: Icon(
                            _confirmshowPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                  Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(10, 25, 0, 20),
                    child: FilledButton(
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: _hasBeenPressed
                                ? Colors.black38
                                : Colors.lightBlueAccent),
                        onPressed: () {
                          if (_firstclick == true) {
                            changepassword();
                          }
                        }),
                  ),
                ]),
              ),
            ),
          ]),
        )),
      ),
    );
  }
}
