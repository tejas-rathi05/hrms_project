import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/apar/ui/downloadApar.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/BuildConfig.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/new_homepage.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../config/ColorSet.dart';
import '../login/loginscreen.dart';
import '../local_shared_pref/sharedpreferencemanager.dart';
import 'package:flutter/services.dart';
import '../login/pin_code_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Pinverify extends StatefulWidget {
  @override
  PinVerification createState() => PinVerification();
}

class PinVerification extends State<Pinverify> {
  Uint8List? _bytesImage;
  var username = "";
  bool _hasBeenPressed = false;
  bool _hasBeenPressed_forgotpin = false;

  bool isPasswordChanged = false;

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  sharedpreferencemanager pref = sharedpreferencemanager();

  TextEditingController controller = TextEditingController(text: "");

  Future checkPin() async {
    var pin = await pref.getuserpin();

    if (controller.text == pin) {
      Navigator.pop(context);
      if (isPasswordChanged) {
        pref.logout();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          // MaterialPageRoute(builder: (context) => DownloadApar()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeProfile(username)),
          // MaterialPageRoute(builder: (context) => DownloadApar()),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter correct pin no.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
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
    //print(responseJSON);
    if (int.parse(responseJSON['mobileAppData']['utility_value']) >
        BuildConfig.VERSION_CODE) {
      print('show pop up');
      _showDialog(responseJSON['mobileAppData']['remarks']);
    } else {
      print('show pop not');
    }
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
  @override
  void dispose() {
    _pinFocusNode.dispose(); // Dispose the focus node to release resources
    controller.dispose(); // Dispose the text controller
    super.dispose();
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

    //String msgtext = responseJSON['message'];
    var status = responseJSON['status'];
    print('status -->$status');
    if (responseJSON['status'] == "1") {
      if (mounted) {
        setState(() {
          isPasswordChanged = false;
        });
      }
    } else if (responseJSON['status'] == "0" ||
        responseJSON['status'] == "2" ||
        responseJSON['status'] == "3") {
      isPasswordChanged = true;
    }
    print('isPasswordChanged $isPasswordChanged');
  }

  Future getUserdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    String? userId = await pref.getUsername();
    final String url = new UtilsFromHelper().getValueFromKey("user_details");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": userId,
    };
    print('hrmsId -->$map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    String ServiceStatus = "";

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
        // print(responseJSON['userProfile']['profile']['servicestatus']);
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
            responseJSON['userProfile']['profile']['railwayGroup']??'' );
        checkPin();
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Try later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
        throw Exception(e);
      }
    }
  }

  void getdetails() async {
    username = (await pref.getEmployeeName())!;
  }

  Future downloadPhoto() async {

    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("file_download");

    String? hrmsId = await pref.getEmployeeHrmsid();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);

    Map map = {
      'folder': "profilephoto",
      'file': hrmsId,
      'ext': "jpg",
    };

    String basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;
    print('responseJSONImage $responseJSON');
    //String msgtext = responseJSON['message'];
    String image = responseJSON['fileString'];

    if (image == null || image == "" || image == "[]"  ) {
      /*Fluttertoast.showToast(
          msg: "Profile Image Not Found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);*/
    }
    else
    {
      // Decode the Base64 string to a regular string
      setState(() {
        _bytesImage = Base64Decoder().convert(image);
      });
    }
  }

  TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold);
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String errorMessage = "";
  FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    getVersion();
    getdetails();
    downloadPhoto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: materialPin(),
        ));
  }

  Scaffold materialPin() {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text("Pin Verification",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: AssetImage("assets/images/vandebharat.png"),
            //fit: BoxFit.fitHeight,
          ),
        ),
       /* decoration: BoxDecoration(
          *//*image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: AssetImage("assets/images/rail.png"),
            //fit: BoxFit.fitHeight,
          ),*//*
          //color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(0), // Border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 4, // Blur radius
              offset: Offset(2, 2), // Shadow offset
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.white], // Gradient colors
            begin: Alignment.topLeft, // Gradient start point
            end: Alignment.bottomRight, // Gradient end point
          ),
          border: Border.all(
            color: Colors.black, // Border color
            width: 1, // Border width
          ),
        ),*/
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                //child: Text(thisText, style: Theme.of(context).textTheme.title),
                child: Text(thisText),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                width: 140,
                height: 140,
                child: CircleAvatar(
                  child: _bytesImage == null
                      ? new CircleAvatar(
                    backgroundImage:
                    new AssetImage('assets/images/user1.png'),
                    radius: 100.0,
                  )
                      : new CircleAvatar(
                    backgroundImage: MemoryImage(_bytesImage!),
                    radius: 100.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      width: 2, color: HexColor("#1976D2")),
                ),
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  username,
                  style: TextStyle(
                      color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Please Provide Your PIN",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 90.0, vertical: 10.0),
                child: GestureDetector(
                  child: PinCodeTextField(
                    autofocus: true,
                    controller: controller,
                    hideCharacter: true,
                    highlight: true,
                    highlightColor: Colors.orange,
                    defaultBorderColor: Colors.black,
                    hasTextBorderColor: Colors.indigo,
                    maxLength: pinLength,
                    pinBoxColor: Colors.white,
                    hasError: hasError,
                    maskCharacter: "*",
                    onTextChanged: (text) {
                      setState(() {
                        hasError = false;
                      });
                    },
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinBoxDecoration:
                        ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 20.0),
                    pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration:
                        Duration(milliseconds: 300),
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                    keyboardType: TextInputType.phone,
                    highlightAnimationDuration: Duration(milliseconds: 300),
                    onDone: (String text) {},
                    focusNode: _pinFocusNode,
                  ),
                ),
              ),
              Visibility(
                child: Text(
                  "Wrong PIN!",
                  style: TextStyle(color: Colors.red),
                ),
                visible: hasError,
              ),
              Container(
                width: 150,
                child: FilledButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                        backgroundColor: _hasBeenPressed
                            ? Colors.lightBlueAccent
                            : Colors.black),
                    onPressed: () {
                      setState(() {
                        _hasBeenPressed = true;
                      });
                      if (controller.text.length < 4) {
                        setState(() {
                          _hasBeenPressed = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Please enter 4 digits pin no.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else {
                        checkPasswordChanged();
                        if (isPasswordChanged) {
                          print('Login Page Entered');
                          pref.logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        } else {
                          print('Home Page Entered');
                          getUserdetails();
                        }
                      }
                    }),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 150,
                child: FilledButton(
                    child: Text(
                      'Forgot Pin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                        backgroundColor: _hasBeenPressed_forgotpin
                            ? Colors.black38
                            : Colors.lightBlueAccent),
                    onPressed: () {
                      setState(() {
                        _hasBeenPressed_forgotpin = true;
                      });

                      pref.logout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ]),
      ),
    );
  }
}
