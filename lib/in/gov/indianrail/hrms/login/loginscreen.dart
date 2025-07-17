import 'dart:convert';
import 'dart:async';
import 'dart:io';
//import 'package:device_id/device_id.dart';
//import 'package:device_info/device_info.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/textField_UI.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/apar/aparProfile.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/contactus.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/forgotpassword_mobile.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/helpvideolink.dart';

//import 'package:url_launcher/url_launcher.dart';
import '../util/apiurl.dart';
import '../config/BuildConfig.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../local_shared_pref/sharedpreferencemanager.dart';

import 'otpverification.dart';
import 'registration.dart';
import 'security/hrmstokenplugin.dart';

class LoginPage extends StatefulWidget {
  @override
  // TODO: implement createState
  DetailsLogin createState() => DetailsLogin();
}

class DetailsLogin extends State<LoginPage> {
  String connectivity_check="";
  String deviceId = "";
  String deviceIMEI = "";
  String deviceName = "";
  bool _hasBeenPressed = false;
  bool _firstclick = true;
  bool unRegisteredVisibility = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Map sourceConn = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  final String urlfp =
      new UtilsFromHelper().getValueFromKey("forgotpassword_url");
  final String url = new UtilsFromHelper().getValueFromKey("login_url");
  final String versionType =
      new UtilsFromHelper().getValueFromKey("versiontype");

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  sharedpreferencemanager pref = sharedpreferencemanager();
  TextEditingController hrmsidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  bool _obsureText = true;
  late List data;
  var check_offier;

  void check_officer_gazetted() async {
    final String url = new UtilsFromHelper().getValueFromKey("check_officer");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsId': hrmsidController.text.trim(),
    };
    String id = hrmsidController.text.trim();
    //
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    sharedpreferencemanager pref = sharedpreferencemanager();
    setState(() {
      check_offier = responseJSON['result']['nos'].toString();
      pref.checkOfficer(check_offier);
    });
  }

  Future get_fin_year() async {
    final String url = new UtilsFromHelper().getValueFromKey("get_fin_year");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"yr_flag": 2020};

    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON != null || responseJSON != "") {
      sharedpreferencemanager pref = sharedpreferencemanager();
      setState(() {
        pref.finyear(responseJSON['result'].toString());
      });
    }
  }

  @override
  @override
  void initState() {
    super.initState();

    String descryptedData = '{"key":"CHP", "hrmsId": "HOGBQI", "referId":13048}';
    Map<String, dynamic> decodedData = json.decode(descryptedData);
    var referId = decodedData['referId'].toString();
    print(referId);

    _checkInitialConnectivity();

    // Updated listener for List<ConnectivityResult>
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> resultList) {
      if (resultList.isNotEmpty) {
        _updateConnectionStatus(resultList.first);
      }
    });

    getVersion();
  }

  @override
  void dispose() {
    hrmsidController.dispose();
    passwordController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
  Future<void> _checkInitialConnectivity() async {
    var results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results.first);
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
  /*Future<void> getDeviceInfo() async {
    deviceId = await DeviceId.getID;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      //deviceIMEI = await UniqueIdentifier.serial;
      print('Running on ${androidInfo.model}');
      deviceName = androidInfo.model;
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      print('device name ${iosDeviceInfo.name}');
      deviceName = iosDeviceInfo.model;
      //deviceIMEI =iosDeviceInfo.identifierForVendor;
    }
    //deviceIMEI = await DeviceId.getIMEI;
    //print('deviceIMEI $deviceIMEI');
    if (!mounted) return;
    print('DeviceID $deviceId');
  }*/

  Future doPostRequest() async {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    if (hrmsidController.text.length == 0 ||
        passwordController.text.length == 0) {
      userCredentailsValidation(hrmsidController.text, passwordController.text);
    } else {
      setState(() {
        _hasBeenPressed = true;
        _firstclick = false;
      });
      // check_officer_gazetted();

      String basicAuth = await Hrmstokenplugin.hrmsToken;

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Map map = {
        'userId': hrmsidController.text.trim(),
        'password': passwordController.text.trim(),
        'deviceId': deviceId,
        'deviceName': deviceName
      };
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.headers.set('Accept', "application/json");
      request.headers.set('authorization', basicAuth);
      request.add(utf8.encode(json.encode(map)));
      print('map $map');
      HttpClientResponse response = await request.close();
      String value = await response.transform(utf8.decoder).join();
      var responseJSON = json.decode(value) as Map;

      String msgtext = responseJSON['message'];
      if (responseJSON['status'] == "1") {
        setState(() {
          _hasBeenPressed = false;
        });
        String ServiceStatus = "";

        if (responseJSON['userProfile']['profile']['servicestatus'] == "CR" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "DS" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "MI" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "RT" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "RE" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "TR" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "VR" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "VM" ||
            responseJSON['userProfile']['profile']['servicestatus'] == "CO") {
          ServiceStatus = "RT";
        } else {
          if (responseJSON['userProfile']['profile']['servicestatus'] != null &&
              responseJSON['userProfile']['profile']['servicestatus']
                      .toString() ==
                  "SR") {
            DateTime valEnd = DateTime.parse(
                responseJSON['userProfile']['profile']['superannuationDate']);
            DateTime date = DateTime.now();
            bool valDate = date.isBefore(valEnd);
            if (valDate) {
              ServiceStatus =
                  responseJSON['userProfile']['profile']['servicestatus'];
            } else {
              ServiceStatus = "RT";
            }
          } else {
            ServiceStatus =
                responseJSON['userProfile']['profile']['servicestatus'];
          }
        }
        try {
          sharedpreferencemanager pref = sharedpreferencemanager();

          await pref.userlogin(hrmsidController.text, passwordController.text);
          print('reponse12 $responseJSON');
          String paylevel="";
          if(responseJSON['userProfile']['profile']['subpaylevel']!=null){
            paylevel=responseJSON['userProfile']['profile']['subpaylevel'];
          }
          if(responseJSON['userProfile']['profile']['offpaylevel']!=null){
            paylevel=responseJSON['userProfile']['profile']['offpaylevel'];
          }

          pref.employeeProfile(
              responseJSON['userProfile']['profile']['emailAddress']??'',
              responseJSON['userProfile']['profile']['employeeName']??'',
              responseJSON['userProfile']['profile']['gender']??'',
              responseJSON['userProfile']['profile']['designationDescription']??'',
              responseJSON['userProfile']['profile']['designationCode'].toString()??'',
              responseJSON['userProfile']['profile']['autype']??'',
              responseJSON['userProfile']['profile']['railwayUnitName']??'',
              responseJSON['userProfile']['profile']['autype_desc']??'',
              responseJSON['userProfile']['profile']['railwayUnitCode']??'',
              responseJSON['userProfile']['profile']['dateOfBirth']??'',
              responseJSON['userProfile']['profile']['departmentDescription']??'',
              responseJSON['userProfile']['profile']['departmentCode'].toString()??'',
              responseJSON['userProfile']['profile']['mobileNo']??'',
              responseJSON['userProfile']['profile']['billunit']??'',
              responseJSON['userProfile']['profile']['userId']??'',
              responseJSON['userProfile']['profile']['ipasEmployeeId']??'',
              responseJSON['userProfile']['profile']['stationCode']??'',
              responseJSON['userProfile']['profile']['AU_NO']??'',
              responseJSON['userProfile']['profile']['lienUnit']??'',
              paylevel ??'',
              responseJSON['userProfile']['profile']['hrmsEmployeeId']??'',
              responseJSON['userProfile']['profile']['railwayZone']??'',
              responseJSON['userProfile']['profile']['userType']??'',
              ServiceStatus,
              responseJSON['userProfile']['profile']['prcpWidowFlag']??'',
              responseJSON['userProfile']['profile']['superannuationDate']??'',
              responseJSON['userProfile']['profile']['appointmentDate']??'',
              responseJSON['userProfile']['profile']['railwayGroup']??'');
          print('reponse12232 $responseJSON');
          if (await getDeviceID() == true) {
            //if same device id
            print('AFTER DEVICE CHECK SUCCESSFUL');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Otpverification()),
            );
          } else {
            setState(() {
              //unregistry
              unRegisteredVisibility = true;
            });
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Try later",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              //  timeInSecForIos: 5,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);
          throw Exception(e);
        }
      } else if (responseJSON['status'] == "0") {
        Fluttertoast.showToast(
            msg: msgtext,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (responseJSON['status'] == "2") {
        Fluttertoast.showToast(
            msg: msgtext,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //  timeInSecForIos: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (responseJSON['status'] == "3") {
        Fluttertoast.showToast(
            msg: msgtext,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //  timeInSecForIos: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
    setState(() {
      _hasBeenPressed = false;
      _firstclick = true;
    });
  }

  void userCredentailsValidation(String hrmsId, String password) {
    if (hrmsidController.text.length == 0) {
      setState(() {
        _hasBeenPressed = false;
        _firstclick = true;
      });
      Fluttertoast.showToast(
          msg: 'Please Enter HRMS ID',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      setState(() {
        _hasBeenPressed = false;
        _firstclick = true;
      });
      Fluttertoast.showToast(
          msg: 'Please Enter Password',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  Future getVersion() async {

    String descryptedData = "{\"key\":\"CHP\", \"hrmsId\": \"HOGBQI\", \"referId\":13048}";
    // Map<String, dynamic> decodedData = json.decode(responseJSON['descryptedData']);
    Map<String, dynamic> decodedData = json.decode(descryptedData);

    var referId = decodedData['referId'].toString();
    print(referId);

    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("mobile_app_version");
    print("url $url");
     descryptedData = '{"key":"CHP", "hrmsId": "HOGBQI", "referId":13048}';
    // Map<String, dynamic> decodedData = json.decode(responseJSON['descryptedData']);
     decodedData = json.decode(descryptedData);

     referId = decodedData['referId'].toString();
    print(referId);
    basicAuth = await Hrmstokenplugin.hrmsToken;
    print("basicAuth123 $basicAuth");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'name': "anything",
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = await json.decode(value) as Map;
    print('reponse $responseJSON');
    if (int.parse(responseJSON['mobileAppData']['utility_value']) >
        BuildConfig.VERSION_CODE) {
      _showDialog(responseJSON['mobileAppData']['remarks']);
    }
  }

  Future savePreviousDeviceDetails(String hrmsId, String password) async {
    var hrmsId = hrmsidController.text.toString();
    String basicAuth;
    String url =
        new UtilsFromHelper().getValueFromKey("save_previous_mobile_details");
    print('save_previous_mobile_details $url');
    basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {'hrmsId': hrmsId, 'password': password};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON $responseJSON');
    if (responseJSON['result'] == true) {
      print('responseJSON True $responseJSON');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                title: new Text(
                    "You have Successful unregistered from HRMS Application",
                    style: TextStyle(fontSize: 15.0)),
                actions: <Widget>[
                  new TextButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        //unregistry
                        unRegisteredVisibility = false;
                        _hasBeenPressed = false;
                      });
                    },
                  ),
                ],
              ));
        },
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                title: new Text("Some Error Occurred please try later",
                    style: TextStyle(fontSize: 15.0)),
                actions: <Widget>[
                  new TextButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
        },
      );
    }
  }

  Future<bool> getDeviceID() async {
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("mobile_device_id");
    print('device id url $url');
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
    print('real deviceId $deviceId');
    String userLoginDeviceId =
        responseJSON['mobileDeviceData']['device_id'].toString();
    print('userLoginDeviceId deviceId $userLoginDeviceId');
    if (userLoginDeviceId != deviceId) {
      _showDialogMobile(responseJSON['mobileDeviceData']['device_name']);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _showDialog(String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              title:
                  new Text("Update Required", style: TextStyle(fontSize: 15.0)),
              content: new Text(title, style: TextStyle(fontSize: 13.0)),
              actions: <Widget>[
                new TextButton(
                  child: new Text("UPGRADE"),
                  onPressed: () {
                    // _playstorelaunchURL();
                  },
                ),
              ],
            ));
      },
    );
  }

  void _showDialogUnRegistry(String hrmsId, String password) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              title: new Text(
                  "You are going to unregister from the Old device You will have to register & login again to use HRMS Application ",
                  style: TextStyle(fontSize: 15.0)),
              // content: new Text(title, style: TextStyle(fontSize: 13.0)),
              actions: <Widget>[
                new TextButton(
                  child: new Text("YES"),
                  onPressed: () {
                    Navigator.pop(context);
                    savePreviousDeviceDetails(hrmsId, password);
                  },
                ),
                new TextButton(
                  child: new Text("NO"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
      },
    );
  }

  void _showDialogMobile(String title) {
    var hrmsId = hrmsidController.text.toString();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              title: new Text(
                  "User with HRMS ID $hrmsId is already registered on other device. "
                  "Please unregister from that device before using HRMS Applicaion on this device",
                  style: TextStyle(fontSize: 15.0)),
              // content: new Text(title, style: TextStyle(fontSize: 13.0)),
              actions: <Widget>[
                new TextButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*switch (sourceConn.keys.toList()[0]) {
      case ConnectivityResult.none:
        connectivity_check = "Offline";
        break;
      case ConnectivityResult.mobile:
        connectivity_check = "Online";
        break;
      case ConnectivityResult.wifi:
        connectivity_check = "Online";
    }
    print('connnectivity $connectivity_check');*/
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold);
    // TODO: implement build

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: new Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/rail.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            // alignment: Alignment.topCenter,
            Align(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 60.0,
                            width: 60.0,
                            margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image: new AssetImage(
                                  'assets/images/railway.png',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                  'assets/images/cris_logo_blue.png'),
                              backgroundColor: Colors.transparent,
                            ),
                            height: 60.0,
                            width: 60.0,
                            margin: EdgeInsets.fromLTRB(0, 0, 35, 0),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        'HRMS',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Employee's Mobile Application",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              /*colors:[
                                Color(0xffEDE6D6).withOpacity(0.8),
                                Color(0xffEDE6D6).withOpacity(0.8),
                              ],*/
                              colors: [
                                Color(0xfff9A825).withOpacity(0.8),
                                Color(0xfff9A825).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(0),
                            border: Border.all(
                                width: 2, color: Color(0xFF0C3A57)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage('assets/images/logo.png'),
                                    height: 75.0,
                                    width: 75.0,
                                  ),
                                  Text("LOGIN",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text("Login to your Account",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Colors.black,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFieldUI(
                                      "HRMS ID",
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      hrmsidController,
                                      200,
                                      260,
                                      TextInputType.text,
                                      6),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    width: 260,
                                    height: 50,
                                    child: Material(
                                      elevation: 10.0,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Color(0xFF0C3A57),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 9, 15, 10),
                                            child: Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: TextField(
                                                controller: passwordController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Password",
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        passwordVisible =
                                                            !passwordVisible;
                                                      });
                                                    },
                                                    child: Icon(
                                                      passwordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    ),
                                                  ),
                                                ),
                                                obscureText: !passwordVisible,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        new Container(
                                          height: 60,
                                          width: 110,
                                          child: FilledButton(
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: FilledButton.styleFrom(
                                                  backgroundColor:
                                                      _hasBeenPressed
                                                          ? Colors.black38
                                                          : Color(0xFF0C3A57)),
                                              onPressed: () {
                                                setState(() {
                                                  _hasBeenPressed = true;
                                                });
                                                if (connectivity_check == "Online") {
                                                  if (_firstclick) {
                                                    doPostRequest();
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "No Internet Connection",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      //  timeInSecForIos: 5,
                                                      backgroundColor:
                                                          Colors.pink,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                }
                                              }),
                                        ),
                                        /* unRegisteredVisibility
                                              ? new Container(
                                                  height: 50,
                                                  width: 110,
                                                  child: TwinkleButton(
                                                      buttonTitle: Text(
                                                        'UnRegister old device',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      buttonColor: _hasBeenPressed
                                                          ? Colors.black38
                                                          : Colors
                                                              .lightBlueAccent,
                                                      onclickButtonFunction: () {
                                                        setState(() {
                                                          _hasBeenPressed = true;
                                                        });
                                                        if (string == "Online") {
                                                          if (_firstclick) {
                                                            // only allow click if it is false
                                                            if (hrmsidController
                                                                        .text
                                                                        .length ==
                                                                    0 ||
                                                                passwordController
                                                                        .text
                                                                        .length ==
                                                                    0) {
                                                              userCredentailsValidation(
                                                                  hrmsidController
                                                                      .text
                                                                      .trim(),
                                                                  passwordController
                                                                      .text
                                                                      .trim());
                                                            } else {
                                                              _showDialogUnRegistry(
                                                                  hrmsidController
                                                                      .text
                                                                      .trim(),
                                                                  passwordController
                                                                      .text
                                                                      .trim());
                                                            }
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "No Internet Connection",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIos: 5,
                                                              backgroundColor:
                                                                  Colors.pink,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0);
                                                        }
                                                      }),
                                                )
                                              : new Container(),*/
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.5, horizontal: 25.0),
                                    padding: EdgeInsets.only(left: 5),
                                    child: Center(
                                      child: new Row(
                                        /*mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,*/
                                        children: <Widget>[
                                          /*new GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (string == "Online") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Forgotpassword_Mobile()),
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "No Internet Connection",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIos: 5,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0);
                                                  }
                                                });
                                              },
                                              child: Text(
                                                "Forgot Password ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.underline,
                                                    color: HexColor("#200B10"),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                            ),*/
                                          new GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Registration()),
                                                );
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                "Register Now",
                                                textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: HexColor("#200B10"),
                                                    decoration: TextDecoration.underline,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14.0,
                                                  ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1.0, horizontal: 25.0),
                                      padding: EdgeInsets.only(left: 5),
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HelpVideoLink()));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Click Here For Help Videos",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: HexColor("#0b13af"),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            unRegisteredVisibility
                                                ? new Container(
                                                    height: 45,
                                                    width: 180,
                                                    child: FilledButton(
                                                        child: Text(
                                                          'UnRegister old device',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                        style: FilledButton.styleFrom(
                                                            backgroundColor:
                                                                _hasBeenPressed
                                                                    ? Colors
                                                                        .black38
                                                                    : Color(0xFF0C3A57)),
                                                        onPressed: () {
                                                          setState(() {
                                                            _hasBeenPressed =
                                                                true;
                                                          });
                                                          if (connectivity_check ==
                                                              "Online") {
                                                            if (_firstclick) {
                                                              // only allow click if it is false
                                                              if (hrmsidController
                                                                          .text
                                                                          .length ==
                                                                      0 ||
                                                                  passwordController
                                                                          .text
                                                                          .length ==
                                                                      0) {
                                                                userCredentailsValidation(
                                                                    hrmsidController
                                                                        .text
                                                                        .trim(),
                                                                    passwordController
                                                                        .text
                                                                        .trim());
                                                              } else {
                                                                _showDialogUnRegistry(
                                                                    hrmsidController
                                                                        .text
                                                                        .trim(),
                                                                    passwordController
                                                                        .text
                                                                        .trim());
                                                              }
                                                            }
                                                          } else {
                                                            Fluttertoast
                                                                .showToast(
                                                                    msg:
                                                                        "No Internet Connection",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .BOTTOM,
                                                                    //  timeInSecForIos:
                                                                    //      5,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .pink,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        14.0);
                                                          }
                                                        }),
                                                  )
                                                : new Container(),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      )),
                                ]),
                          ),
                        ),

                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 25),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Contact_us()),
                                  );
                                });
                              },
                              child: Text(
                                "Contact Us",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            new Container(
                              child: Text(
                                "Version ${BuildConfig.VERSION_NAME} $versionType",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        child: Text(
                          "Designed And Developed By CRIS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        )));
  }

  /*_playstorelaunchURL() async {
    var url = "https://play.google.com/store/apps/details?id=" +
        BuildConfig.APPLICATION_ID;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL() async {
    var urlvideolink = "https://youtu.be/ZVES5D8oB24";
    if (await canLaunch(urlvideolink)) {
      await launch(urlvideolink);
    }
  }*/
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
