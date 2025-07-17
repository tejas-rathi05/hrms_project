import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/textField_UI.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/BuildConfig.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/new_homepage.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import '../config/ColorSet.dart';
import '../util/pinvery.dart';
import 'package:local_auth/local_auth.dart';
import '../local_shared_pref/sharedpreferencemanager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GenerateOtp extends StatefulWidget {
  var userName = "";

  GenerateOtp(this.userName);

  @override
  GenerateOtp1 createState() => GenerateOtp1();
}

class GenerateOtp1 extends State<GenerateOtp> {
  Uint8List? _bytesImage;
  var HrmsEmployeeId;
  bool _hasBeenPressed = false;

  TextEditingController pinNumber = TextEditingController();
  TextEditingController re_pinNumber = TextEditingController();
  sharedpreferencemanager pref = sharedpreferencemanager();
  final LocalAuthentication localAuth = LocalAuthentication();

  Future getId() async {
    HrmsEmployeeId = await pref.getEmployeeHrmsid();
  }

  Future userfingerPrint() async {
    HrmsEmployeeId = await pref.getEmployeeHrmsid();
    pref.userfingerPrint("true");
  }

  Future savePin() async {
    HrmsEmployeeId = await pref.getEmployeeHrmsid();
    pref.userpin(re_pinNumber.text, HrmsEmployeeId);
  }

  Future gettoken() async {
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("api_token");

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
    print(responseJSON['token']);
    await pref.token(responseJSON['token'].toString());
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

    if (image == "" || image == "[]") {
    } else {
      // Decode the Base64 string to a regular string
      setState(() {
        _bytesImage = Base64Decoder().convert(image);
      });
    }
  }

  @override
  void initState() {
    gettoken();
    getId();
    downloadPhoto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final skipbutton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xFF36454F),
        child: MaterialButton(
            minWidth: 120,
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeProfile(widget.userName)),
              );
            },
            child: Text(
              "Skip",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )));

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Row(
            children: [
              Container(
                child: Text("Generate Pin ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: AssetImage("assets/images/rail.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Align(
            child: SingleChildScrollView(
               child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      child: _bytesImage == null
                          ? new CircleAvatar(
                              backgroundImage:
                                  new AssetImage('assets/images/user1.png'),
                              radius: 100.0,
                            )
                          : new CircleAvatar(
                              backgroundImage: MemoryImage(_bytesImage!),
                              radius: 300.0,
                            ),
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
                        widget.userName,
                        style: TextStyle(
                            color: Color(0xFF003E78), fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),),
                  SizedBox(height: 40,),
                  Container(
                    margin: EdgeInsets.all(15),
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
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          child: Center(
                            child: Text("Please Create 4 digit PIN",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          child: TextFieldUI(
                              "Enter 4 digit PIN",
                              Icon(
                                Icons.input,
                                color: Colors.white,
                              ),
                              pinNumber,
                              200,
                              300,
                              TextInputType.phone,
                              4),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          child: TextFieldUI(
                              "Re-Enter 4 digit PIN",
                              Icon(
                                Icons.keyboard,
                                color: Colors.white,
                              ),
                              re_pinNumber,
                              200,
                              300,
                              TextInputType.phone,
                              4),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB( 45,20,45,20),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xFF01796F),
                                child: MaterialButton(
                                  minWidth: 120,
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (pinNumber.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "Please enter 4 digit pin no.",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    } else if (re_pinNumber.text == "") {
                                      Fluttertoast.showToast(
                                          msg: "Please re-enter 4 digit pin no.",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    } else if (pinNumber.text.length < 4 ||
                                        re_pinNumber.text.length < 4) {
                                      Fluttertoast.showToast(
                                          msg: "Please 4 digit pin no.",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    } else if (pinNumber.text != re_pinNumber.text) {
                                      Fluttertoast.showToast(
                                          msg: "Please enter correct 4 digit pin no.",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    } else {
                                      setState(() {
                                        _hasBeenPressed = true;
                                      });
                                      savePin();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Pinverify()),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Container(child: skipbutton),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
