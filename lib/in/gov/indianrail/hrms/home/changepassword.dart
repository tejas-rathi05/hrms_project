import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/new_homepage.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';


class ChangePassword extends StatefulWidget {
  var hrmsId;

  var profilename;
  ChangePassword(this.hrmsId, this.profilename);
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  var msg_lastpass = "";
  bool _showPassword = false;
  bool _newshowPassword = false;
  bool _confirmshowPassword = false;

  bool _hasBeenPressed = false;
  bool _firstclick = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  var eightChar = false, oneSpecialChar = false, requiredAt = false;
  Future<void> changepassword() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    var passUser = await pref.getPassword();
    final String url = new UtilsFromHelper().getValueFromKey("change_password");
    // var url="http://203.176.112.80/webservice/changePassword";
    if (passwordController.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Your Current Password',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (passUser != passwordController.text) {
      Fluttertoast.showToast(
          msg: 'Please Enter Correct Current Password',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (newpasswordController.text.length == 0) {
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
      String basicAuth = await Hrmstokenplugin.hrmsToken;
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Map map = {
        'hrmsId': widget.hrmsId,
        'currentPassword':passwordController.text,
        'newPassword':newpasswordController.text,
        'confirmPassword': confirmpasswordController.text,
        'passwordType': "U"
      };
      print('map $map');
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Accept', "application/json");
      request.headers.set('authorization', basicAuth);
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();

      String value = await response.transform(utf8.decoder).join();
      var responseJSON = json.decode(value) as Map;
      print('response $responseJSON');
      bool result = responseJSON['result'];
      String message = responseJSON['message'];
      if (result) {
        setState(() {
          changepasswordhistory();
        });

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
          //,widget.hrmsId
          MaterialPageRoute(
              builder: (context) => HomeProfile(widget.profilename)),
        );
        passwordController.text = "";
        newpasswordController.text = "";
        confirmpasswordController.text = "";
      }else
      {
        alertify(context, message);
      }
      setState(() {
        _firstclick = true;
      });
    }
  }

  void alertify(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  Future<void> changepassword_details() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("last_change_password_datetime");

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
    if (responseJSON != null || responseJSON != "") {
      DateTime todayDateExp = DateTime.parse(responseJSON["last_password_changed"]);
      String change_password_date = DateFormat('dd/MM/yyyy HH:mm:ss').format(todayDateExp);
            setState(() {
        msg_lastpass = "*Previous activity of Password Change done on: " +
            change_password_date;
      });
    }
  }

  Future<void> changepasswordhistory() async {
    //last_change_password_datetime
    final String url =
        new UtilsFromHelper().getValueFromKey("get_change_password_history");
    // var url="http://203.176.112.80/webservice/getlast_password";
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
    json.decode(value) as Map;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      changepassword_details();
    });
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
                          "1. Your password should be minimum 8 characters and maximum 15 characters long.",
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
                          "2.Your password should contain at least 1 upper case letter, 1 lower case letter, 1 digit/number and 1 special character (out of !, @, #, \$, %, &, *).",
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
                          "3. You can not repeat previously used 2 passwords.",
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
                          "4. Following cannot be part of your password : 'HRMS', 'IRHRMS', 'TEST', '123', '1234', '12345'.",
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
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Employee Name",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          enabled: false,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("#a4b7c1"),
                            hintText: widget.profilename,
                            border: InputBorder.none,
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Employee ID",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          enabled: false,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("#a4b7c1"),
                            hintText: widget.hrmsId,
                            border: InputBorder.none,
                          ),
                        ),
//                  TextFormField(
//
//                    enabled: false,
//                    decoration: new InputDecoration(
//
//                          labelText: "Enter Email",
//                          border: new OutlineInputBorder(
//                            borderRadius: new BorderRadius.circular(2.0),
//                          ),
//                      ),
//                  )
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                "Current Password",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: !this._showPassword,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              // onPressed: () {
                              //   setState(() {
                              //     passwordVisible =
                              //     !passwordVisible;
                              //     _obsureText = !_obsureText;
                              //   });
                              // },
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
                          // onPressed: () {
                          //   setState(() {
                          //     passwordVisible =
                          //     !passwordVisible;
                          //     _obsureText = !_obsureText;
                          //   });
                          // },
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

//                  TextFormField(
//
//                    enabled: false,
//                    decoration: new InputDecoration(
//
//                          labelText: "Enter Email",
//                          border: new OutlineInputBorder(
//                            borderRadius: new BorderRadius.circular(2.0),
//                          ),
//                      ),
//                  )
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
                          // onPressed: () {
                          //   setState(() {
                          //     passwordVisible =
                          //     !passwordVisible;
                          //     _obsureText = !_obsureText;
                          //   });
                          // },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

//                  TextFormField(
//
//                    enabled: false,
//                    decoration: new InputDecoration(
//
//                          labelText: "Enter Email",
//                          border: new OutlineInputBorder(
//                            borderRadius: new BorderRadius.circular(2.0),
//                          ),
//                      ),
//                  )
                  ]),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 25, 0, 20),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.lightBlueAccent,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: _hasBeenPressed
                                ? Colors.black38
                                : Colors.lightBlueAccent),
                        onPressed: () {
                          if (_firstclick == true) {
                            changepassword();
                          }
                        },
                        child: Text(
                          "Change",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
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
