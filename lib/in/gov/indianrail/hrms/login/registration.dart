import 'dart:io';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/textField_UI.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import '../local_shared_pref//sharedpreferencemanager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../util/apiurl.dart';
import 'loginscreen.dart';
import 'dart:async';
import 'dart:convert';

class Registration extends StatefulWidget {
  @override
  Registration1 createState() => Registration1();
}

class Registration1 extends State<Registration> {
  String connectivity_check="";
  bool _hasBeenPressed = false;
  bool _firstClick_pro = true;
  bool _firstClick_reg = true;
  bool _visible = true;
  var ipasid = "",
      empname = "",
      mobilenovisible = "",
      desig = "",
      depart = "",
      railwayunit = "",
      hrmsemployeeid = "",
      employeeNumber = "",
      gender = "",
      mobilenumbersent = "",
      departmentnumber = "",
      railwayunitcode = "",
      createdBy = "",
      password = "";
  TextEditingController empId = TextEditingController();
  TextEditingController otpedittext = TextEditingController();
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  late StreamSubscription<List<ConnectivityResult>> _subscription;


  final String url = new UtilsFromHelper().getValueFromKey("registration");

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      } else {
        _updateConnectionStatus(ConnectivityResult.none);
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    var results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results.first); // If result is List
    // OR if you're using older version:
    // _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      if (result == ConnectivityResult.mobile) {
        connectivity_check = "Online";
      } else if (result == ConnectivityResult.wifi) {
        connectivity_check = "Online";
      } else {
        connectivity_check = "Offline";
      }
    });
    print('sourceConn: $connectivity_check'); // Print the current connection status
  }
  Future getEmployeeDetails() async {
    if (empId.text.length == 0) {
      setState(() {
        _firstClick_pro = true;
      });

      Fluttertoast.showToast(
          msg: 'Please Enter Your IPAS ID',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      setState(() {
        _hasBeenPressed = true;
        _firstClick_pro = false;
      });
      String basicAuth = await Hrmstokenplugin.hrmsToken;
      // print('basicAuth $basicAuth');
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      Map map = {
        'ipasEmployeeId': empId.text,
      };

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Accept', "application/json");
      request.headers.set('authorization', basicAuth);
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();

      String value = await response.transform(utf8.decoder).join();
      var responseJSON = json.decode(value) as Map;
      print('responseJSON $responseJSON');
      if (responseJSON['status'] == "1") {
        setState(() {
          ipasid = responseJSON['registrationDetails']['ipasemployeeid'];
          empname = responseJSON['registrationDetails']['employeename'];

          mobilenumbersent =
              responseJSON['registrationDetails']['mobilenumber'];
          if (mobilenumbersent == "NOT PRESENT" || mobilenumbersent == "") {
            mobilenovisible = "Not Available";
          } else {
            mobilenovisible =
                responseJSON['lastOtpTransactionMessage']['mobileNumber'];
          }
          desig = responseJSON['registrationDetails']['designationdescription'];
          depart = responseJSON['registrationDetails']['departmentdescription'];
          railwayunit =
              responseJSON['registrationDetails']['railwayunitdescription'];
          departmentnumber =
              responseJSON['registrationDetails']['departmentnumber'];
          hrmsemployeeid =
              responseJSON['registrationDetails']['hrmsemployeeid'];
          gender = responseJSON['registrationDetails']['gender'];
          //employeeNumber =
            //  responseJSON['registrationDetails']['employeeNumber'];
          _visible = !_visible;
        });
      }
      if (responseJSON['status'] == "0") {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //  timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (responseJSON['status'] == "2") {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
    setState(() {
      _hasBeenPressed = false;
      _firstClick_pro = true;
    });
  }

  Future registerUser() async {
    sharedpreferencemanager pref = sharedpreferencemanager();

    String url_registrationOTP =
        new UtilsFromHelper().getValueFromKey("registrationOTPVerification");

    if (otpedittext.text.length == 0) {
      setState(() {
        _firstClick_reg = true;
      });
      Fluttertoast.showToast(
          msg: 'Please Enter OTP',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      setState(() {
        _firstClick_reg = false;
      });
      var otpText = otpedittext.text;

      String basicAuth = await Hrmstokenplugin.hrmsToken;
      Map map = {
        "otp": otpedittext.text,
        "ipasemployeeid": ipasid,
        "hrmsemployeeid": hrmsemployeeid,
        "employeeNumber": hrmsemployeeid,
        "employeename": empname,
        "gender": gender,
        "mobilenumber": mobilenumbersent,
        "railwayunitcode": railwayunit,
        "createdBy": hrmsemployeeid,
      };

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.postUrl(Uri.parse(url_registrationOTP));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Accept', "application/json");
      request.headers.set('authorization', basicAuth);
      request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();

      String value = await response.transform(utf8.decoder).join();
      var responseJSON = json.decode(value) as Map;

      if (responseJSON['status'] == "2") {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
              title: "THANK YOU",
              hrmsId: hrmsemployeeid,
              description:
                  "*Note:Please Note down your Login HRMS Id and Password for Login",
              buttonText: "Login"),
        );
      } else if (responseJSON['status'] == "3") {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      }
      if (responseJSON['status'] == "0") {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      }

      setState(() {
        _firstClick_reg = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        connectivity_check = "Offline";
        break;
      case ConnectivityResult.mobile:
        connectivity_check = "Online";
        break;
      case ConnectivityResult.wifi:
        connectivity_check = "Online";
    }*/

    // TODO: implement build
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold);
    final registerButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Color(0xFF00A3E1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () {
          if (_firstClick_reg == true) {
            setState(() {
              _firstClick_reg = false;
            });
            registerUser();
          }
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
      ),
    );

    final registration = FilledButton(
        child: Text(
          'Proceed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        style: FilledButton.styleFrom(
            backgroundColor:
                _hasBeenPressed ? Colors.black38 : Color(0xFF0C3A57)),
        onPressed: () {
          if (connectivity_check == "Online") {
            if (_firstClick_pro == true) {
              setState(() {
                _firstClick_pro = false;
              });

              getEmployeeDetails();
            }
          } else {
            Fluttertoast.showToast(
                msg: "No Internet Connection",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                // timeInSecForIos: 5,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        });

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Registration",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: new Stack(children: <Widget>[
        Image.asset(
          'assets/images/rail.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,

            child: SingleChildScrollView(
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(children: <Widget>[
                      Container(
                        height: 45,
                        child: TextFieldUI(
                            "IPASS ID",
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            empId,
                            150,
                            210,
                            TextInputType.text,
                            15),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.5, horizontal: 8.5),
                          child: registration,
                        ),
                      ),
                    ]),
                    Offstage(
                      offstage: _visible,
                      child: Column(children: <Widget>[
                        Container(
                            width: 320,
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: Text(
                              "* Note:- To update your mobile no,Please contact your establishment clerk",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.blue,
                                ),
                                bottom: BorderSide(
                                  color: Colors.blue,
                                ),
                                right: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              )),
                          child: Column(
                            children: <Widget>[
                              Align(
                                child: Container(
                                  padding: EdgeInsets.only(left: 6),
                                  height: 30,
                                  color: Color(0xFF0C3A57),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "EMPLOYEE DETAILS",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'HRMS ID:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(hrmsemployeeid,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.blue),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'EMPLOYEE NAME:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(empname,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.blue),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'MOBILE NO:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        mobilenovisible ?? "Not Available",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.blue),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'DESIGNATION:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(desig ?? "Not Available",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.blue),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'DEPARTMENT:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(depart ?? "Not Available",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.blue),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(5,5,5,10),
                                        child: Text(
                                          'RAILWAY UNIT:',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(railwayunit ?? "Not Available",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.blue,
                                ),
                                bottom: BorderSide(
                                  color: Colors.blue,
                                ),
                                right: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              )),
                          child: Column(children: <Widget>[
                            Align(
                              child: Container(
                                padding: EdgeInsets.only(left: 6),
                                height: 30,
                                color: Color(0xFF0C3A57),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ENTER OTP TO REGISTER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 50.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                              height: 30,
                                              margin: EdgeInsets.fromLTRB(
                                                  5, 15, 0, 0),
                                              child: Text(
                                                'Enter OTP :',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 45.0,
                                              width: 200.0,
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: TextField(
                                                maxLength: 5,
                                                controller: otpedittext,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black),
                                                ),
                                                keyboardType:
                                                    TextInputType.phone,
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                          ]),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 30.0),
                          child: registerButon,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              "Designed and Developed By CRIS ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),
                            )),
                      ]),
                    ),
                  ])),
            ),
            //  ]
          ),
        ),
      ]),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, hrmsId;
  //final Image image;

  CustomDialog({
    required this.title,
    required this.hrmsId,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 25.0,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: HexColor("#757171")),
              ),
              SizedBox(height: 5.0),
              Text(
                "your Registration was Successful",
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    color: HexColor("#125688")),
              ),
              SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                child: Text(
                  "Login HRMS ID",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: HexColor("#00796B"),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                  width: double.infinity,
                  child: Text(
                    hrmsId,
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  )),
              SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: HexColor("#00796B"),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                  width: double.infinity,
                  child: Text(
                    "Test@123",
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  )),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.0, color: Colors.red),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(buttonText,
                      style: TextStyle(color: HexColor("#14598e"))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyConnectivity {
  MyConnectivity._internal();
  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;
  //Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();
  Stream get myStream => controller.stream;

  void initialise() async {
   /* ConnectivityResult result = (await connectivity.checkConnectivity()) as ConnectivityResult;
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result as ConnectivityResult);
    });*/
  }

  /*void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }*/

  void disposeStream() => controller.close();
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
