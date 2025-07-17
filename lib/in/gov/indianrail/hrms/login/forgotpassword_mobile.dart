import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/textField_UI.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import '../util/apiurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'chnagepasswordforforgot.dart';
import 'security/hrmstokenplugin.dart';

class Forgotpassword_Mobile extends StatefulWidget {
  @override
  Forgotpassword_MobileState createState() => Forgotpassword_MobileState();
}

class Forgotpassword_MobileState extends State<Forgotpassword_Mobile> {
  bool passwordVisible = false;
  bool _obsureText = true;
  bool visibilityotp = false;
  bool visibilityhrmsid = true;
  bool _hasBeenPressed = false;
  bool _firstclick_getotp = true;
  bool _firstclick_passset = true;
  String buttonText = "Send OTP";
  String msg = "";
  late String HrmsId, Otp;
  TextEditingController hrmsidController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  dispose() {
    _hasBeenPressed = false;

    super.dispose();
  }

  Future getotp() async {
    String basicAuth;
    String url =
        new UtilsFromHelper().getValueFromKey("forgot_password_details");

    basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsId': hrmsidController.text.trim(),
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON['status']) {
      setState(() {
        HrmsId = responseJSON['userid'];
        Otp = responseJSON['otp_final'];
        var mobileno = responseJSON['replacemobileno'];

        msg = 'A 5 digit OTP sent to $mobileno Successfully for $HrmsId';
        visibilityotp = true;
        visibilityhrmsid = false;
        if (visibilityhrmsid != true) {
          buttonText = "Password Reset";
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: responseJSON['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    setState(() {
      _hasBeenPressed = false;
      _firstclick_getotp = true;
    });
  }

  Future passwordReset() async {
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("match_transaction_otp");

    basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Map map = {
      'otp': otpController.text,
      'hrmsId': hrmsidController.text.trim(),
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON['otp_match'] == "Y") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePasswordforgot(HrmsId)));
      setState(() {
        visibilityotp = false;
        visibilityhrmsid = true;
        buttonText = "Send OTP";
      });
    }

    setState(() {
      _hasBeenPressed = false;
      hrmsidController.text = "";
      _firstclick_passset = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginButon1 = FilledButton(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        style: FilledButton.styleFrom(
            backgroundColor:
                _hasBeenPressed ? Colors.black38 : Colors.lightBlueAccent),
        onPressed: () {
          if (buttonText == "Send OTP") {
            if (hrmsidController.text == "") {
              Fluttertoast.showToast(
                  msg: "Enter HRMS Employee Id",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 14.0);
            } else {
              setState(() {
                _hasBeenPressed = true;
              });
              if (_firstclick_getotp == true) {
                setState(() {
                  _firstclick_getotp = false;
                });
                getotp();
              }
            }
          } else if (buttonText == "Password Reset") {
            if (otpController.text == "") {
              Fluttertoast.showToast(
                  msg: "Enter 5 digit OTP",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 14.0);
            } else if (Otp != otpController.text) {
              Fluttertoast.showToast(
                  msg: "Enter Correct 5 digit OTP",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 14.0);
            } else {
              setState(() {
                _hasBeenPressed = true;
                _firstclick_passset = false;
              });
              passwordReset();
            }
          }
        });

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Forgot Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              )),
        ),
        body: new Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/rail.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            SafeArea(
              child: Align(
                child: SingleChildScrollView(
                  child: Align(
                      child: Container(
                    alignment: Alignment(0, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: 310,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  end: Alignment.bottomRight,
                                  begin: Alignment.topLeft,
                                  colors: [
                                    Color(0xfff9A825).withOpacity(0.9),
                                    Color(0xfff9A825).withOpacity(0.9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1, color: HexColor("#1976D2")),
                              ),
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                Text("Forgot Password",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#200B10"),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    "Please Enter Your HRMS ID. After You Press Submit A temporary 5 digit OTP will be send to your Registered Mobile Number.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: HexColor("#200B10"),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                visibilityotp
                                    ? Container(
                                        color: HexColor("#d2f2e1"),
                                        height: 60,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Text(
                                          msg,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : new Container(),
                                Visibility(
                                  visible: visibilityhrmsid,
                                  child: TextFieldUI(
                                      "HRMS ID",
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      hrmsidController,
                                      200,
                                      300,
                                      TextInputType.text,
                                      6),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Visibility(
                                  visible: visibilityotp,
                                  child: TextFieldUI(
                                      "Enter OTP",
                                      Icon(
                                        Icons.dialpad,
                                        color: Colors.white,
                                      ),
                                      otpController,
                                      200,
                                      300,
                                      TextInputType.text,
                                      15),
                                ),
                                new Container(
                                  height: 45.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 75.0),
                                  child: loginButon1,
                                ),
                                SizedBox(height: 20.0),
                              ]),
                            ),
                          ),
                        ] //main
                        ),
                  )),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    //getDetails();
    super.initState();
  }
}
