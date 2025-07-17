import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/BuildConfig.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/home/new_homepage.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'package:local_auth/local_auth.dart';

//import 'package:url_launcher/url_launcher.dart';
import 'loginscreen.dart';
import '../local_shared_pref//sharedpreferencemanager.dart';

class Fingerprintmain extends StatefulWidget {
  var userName = "";

  Fingerprintmain(this.userName);

  @override
  Fingerprintmain1 createState() => Fingerprintmain1();
}

class Fingerprintmain1 extends State<Fingerprintmain> {
  var HrmsEmployeeId;

  bool isPasswordChanged = false;

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  sharedpreferencemanager pref = sharedpreferencemanager();
  TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold);
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    popupFingerPrint();
    getVersion();
  }

  Future getUserdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("user_details");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await pref.getUsername(),
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    String ServiceStatus = "";
    print(responseJSON);

    if (responseJSON['status'] == "1") {
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
        //String UserID=await pref.getUsername();
        //await pref.userlogin(UserID,UserID);
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
            paylevel??'',
            responseJSON['userProfile']['profile']['hrmsEmployeeId']??'',
            responseJSON['userProfile']['profile']['railwayZone']??'',
            responseJSON['userProfile']['profile']['userType']??'',
            ServiceStatus,
            responseJSON['userProfile']['profile']['prcpWidowFlag']??'',
            responseJSON['userProfile']['profile']['superannuationDate']??'',
            responseJSON['userProfile']['profile']['appointmentDate']??'',
            responseJSON['userProfile']['profile']['railwayGroup']??'');
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Try later ${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
        throw Exception(e);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeProfile(widget.userName),
        ),
      );
    }
  }

  Future getVersion() async {
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("mobile_app_version");

    basicAuth = await Hrmstokenplugin.hrmsToken;

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
    var responseJSON = json.decode(value) as Map;

    if (int.parse(responseJSON['mobileAppData']['utility_value']) >
        BuildConfig.VERSION_CODE) {
      _showDialog(responseJSON['mobileAppData']['remarks']);
    }
  }

  late BuildContext dialogContext;

  void _showDialog(String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
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
                    //  _playstorelaunchURL();
                  },
                ),
              ],
            ));
      },
    );
  }

  /*_playstorelaunchURL() async {
    var url = "https://play.google.com/store/apps/details?id=" +
        BuildConfig.APPLICATION_ID;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

  Future userfingerPrint() async {
    HrmsEmployeeId = await pref.getEmployeeHrmsid();
    pref.userfingerPrint("true");
    // getlogindetails();
  }

  Future checkPasswordChanged() async {
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    final String url = new UtilsFromHelper().getValueFromKey("login_url");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String? hrmsEmployeeId = await pref.getEmployeeHrmsid();
    String? password = await pref.getPassword();
    Map map = {'userId': hrmsEmployeeId, 'password': password};

    print('userid and password -->$map');
    print(' password -->$password');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    var status = responseJSON['status'];
    print('status -->$status');
    if (responseJSON['status'] == "1") {
      setState(() {
        isPasswordChanged = false;
      });
    } else if (responseJSON['status'] == "0" ||
        responseJSON['status'] == "2" ||
        responseJSON['status'] == "3") {
      isPasswordChanged = true;
    }
    print('isPasswordChanged $isPasswordChanged');
  }

  void popupFingerPrint() async {
    try {
      bool isAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to login');

      checkPasswordChanged();
      if (isAuthenticate) {
        if (isPasswordChanged) {
          print('Login Page Entered');
          pref.logout();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          print('Home Page Entered');
          getUserdetails();
          userfingerPrint();
        }
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            automaticallyImplyLeading: false,
            title: Text("Finger Print",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
          ),
          body: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: ExactAssetImage('assets/images/rail.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                  child: Image(
                    image: AssetImage("assets/images/user.png"),
                    height: 90.0,
                    width: 90.0,
                  ),
                ),*/
                /*Row(
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
                SizedBox(height: 45.0),*/
                Container(
                  child: Center(
                      child: Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  )),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                ),
                GestureDetector(
                  onTap: () async {
                    popupFingerPrint();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      Icon(
                        Icons.fingerprint,
                        size: 90.0,
                      ),
                      Text(
                        "Touch to Login",
                        style: TextStyle(
                          fontFamily: 'Roboto', // or remove this line to use default
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        width: 100.0,
                        margin: EdgeInsets.symmetric(
                            horizontal: 90.0, vertical: 10.0),
                        child: FilledButton(
                            child: Text(
                              "Go To Login Page",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFF0C3A57)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
