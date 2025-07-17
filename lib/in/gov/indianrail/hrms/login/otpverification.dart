import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/textField_UI.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/new_homepage.dart';
import '../util/apiurl.dart';
import '../local_shared_pref/sharedpreferencemanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'security/hrmstokenplugin.dart';
import 'security/securityoption.dart';

class Otpverification extends StatefulWidget {
  @override
  Otpverification1 createState() => Otpverification1();
}

class Otpverification1 extends State<Otpverification> {
  TextEditingController hrmsidController = TextEditingController();
  var mobileNo = "",
      date = "",
      validupto = "",
      userName = "",
      hrmsid = "",
      userMobile = "",
      pinNo = "";
  bool _hasBeenPressed = false;
  bool _hasBeenPressed_resend = false;
  bool _firstclick_otpvery = true;

  TextEditingController otpController = TextEditingController();

  final String url =
      new UtilsFromHelper().getValueFromKey("last_login_message");
  final String url_otp_verification =
      new UtilsFromHelper().getValueFromKey("otp_verification");
  final String url_resend_otp =
      new UtilsFromHelper().getValueFromKey("resend_otp");
  sharedpreferencemanager pref = sharedpreferencemanager();

  Future getNpsDetails() async {
    String basicAuth;
    hrmsid = (await pref.getEmployeeHrmsid())!;
    String url = new UtilsFromHelper().getValueFromKey("check_nps");

    basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsId': hrmsid,
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    await pref.nps_flag(responseJSON['covered_under_nps_scheme']);
  }

  Future getDetails() async {
    hrmsid = (await pref.getEmployeeHrmsid())!;
    userName = (await pref.getEmployeeName())!;
    userMobile = (await pref.getEmployeeMobileno())!;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Map map = {
      'userId': hrmsid,
    };

    String basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    List list = responseJSON['lastLoginDetails'];
    print(responseJSON);
    setState(() {
      date = list[0]['valid_from'];
      mobileNo = list[0]['mobile_number'];
      validupto = list[0]['valid_to'];
    });
  }

  Future otpvarification_fun(String otppin) async {
    setState(() {
      _hasBeenPressed = true;
    });

    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      'hrmsEmployeeId': hrmsid,
      'mobileNumber': userMobile,
      'otp': otppin,
    };

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.postUrl(Uri.parse(url_otp_verification));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    var status = responseJSON['status'];
    if (status == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SecurityOption(userName, hrmsid, userMobile)),
        //MaterialPageRoute(builder: (context) => HomeProfile(userName)),
      );
      await pref.otppin(otpController.text);
    } else if (status == "0") {
      Fluttertoast.showToast(
          msg: "Invalid OTP.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    setState(() {
      _hasBeenPressed = false;
      otpController.text = "";
      _firstclick_otpvery = true;
    });
  }

  Future resend_otp() async {
    setState(() {
      _hasBeenPressed_resend = true;
    });
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      'userId': hrmsid,
      'mobileno': userMobile,
    };
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url_resend_otp));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON['otp_final'] != null && responseJSON['otp_final'] != "") {
      Fluttertoast.showToast(
          msg: "OTP will resend at your registered mobile no. $userMobile",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: "Please try later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    setState(() {
      _hasBeenPressed_resend = false;
    });
  }

  @override
  void initState() {
    getDetails();
    getNpsDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("OTP Verification",
              style: TextStyle(
                fontFamily: 'Roboto',
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
                          Container(
                            margin: EdgeInsets.all(45),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                end: Alignment.bottomRight,
                                begin: Alignment.topLeft,
                                colors: [
                                  Color(0xffF6E1D3).withOpacity(0.8),
                                  Color(0xff1E8FD5).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: HexColor("#1976D2")),
                            ),
                            child: Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(0, 20.0, 0.0, 0.0),
                                child: Text(userName ?? "",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(0, 15.0, 0.0, 20.0),
                                child: Text("Your last login OTP was sent on :",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.5, horizontal: 30.0),
                                padding: EdgeInsets.only(left: 5),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Container(
                                      child: Text(
                                        "Mobile No :",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      child: Text(
                                        mobileNo ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 30.0),
                                padding: EdgeInsets.only(left: 5),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Container(
                                      child: Text(
                                        "Date :",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      child: Text(
                                        date ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.5, horizontal: 30.0),
                                padding: EdgeInsets.only(left: 5),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Container(
                                      child: Text(
                                        "valid Upto :",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      child: Text(
                                        validupto ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFieldUI(
                                  "Enter OTP",
                                  Icon(
                                    Icons.dialpad,
                                    color: Colors.white,
                                  ),
                                  otpController,
                                  200,
                                  300,
                                  TextInputType.number,
                                  6),
                              Container(
                                height: 45.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 50.0),
                                child: Center(
                                  child: FilledButton(
                                      child: Text(
                                        'Verify OTP',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      style: FilledButton.styleFrom(
                                          backgroundColor: _hasBeenPressed
                                              ? Colors.black38
                                              : Color(0xFF0C3A57)),
                                      onPressed: () {
                                        if (otpController.text == "") {
                                          Fluttertoast.showToast(
                                              msg: "Please enter otp",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              // timeInSecForIos: 5,
                                              backgroundColor: Colors.pink,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                        } else {
                                          pinNo = otpController.text;
                                          if (_firstclick_otpvery == true) {
                                            setState(() {
                                              _firstclick_otpvery = false;
                                            });
                                            otpvarification_fun(pinNo);
                                          }
                                        }
                                      }),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 45.0),
                                child: Center(
                                  child: GestureDetector(
                                      child: Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Color(0xFF001440),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onTap: () {
                                        EasyLoading.show(status: "Please wait...");
                                        resend_otp();
                                      }),
                                ),
                              ),
                              SizedBox(height: 15.0),
                            ]),
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
}
