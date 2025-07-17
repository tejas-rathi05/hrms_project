import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';

import 'package:intl/intl.dart';
//import 'package:wifi/wifi.dart';
import '../util/apiurl.dart';
import '../local_shared_pref/sharedpreferencemanager.dart';
import 'dart:async';
import 'dart:convert';

var designation = "",
    railwayunit = "",
    dob = "",
    department = "",
    mobileno = "",
    billunit = "",
    ipasempid = "",
    hrmsid = "",
    railwayzone = "",
    profilename = "",
    pay_level = "",
    apar_format_desc = "",
    apar_format_desc_hindi = "";

class SelfApprasial extends StatefulWidget {
  var finyear;
  SelfApprasial(this.finyear);
  @override
  SelfApprasialState createState() => SelfApprasialState();
}

class SelfApprasialState extends State<SelfApprasial> {
  bool _isButtonDisabled = false;
  late String _ip;
  TextEditingController work_done_text_f = TextEditingController();
  TextEditingController dc_duties_text_f = TextEditingController();
  TextEditingController property_text_f = TextEditingController();
  var aparyear, aparformate, pay_level, operatingunit;
  var visiblity_con = true;
  late File _image;
  sharedpreferencemanager pref = sharedpreferencemanager();
  final String url = new UtilsFromHelper().getValueFromKey("file_download");

  Future get_no_gazettedofficer(int destination) async {
    final String url =
        new UtilsFromHelper().getValueFromKey("select_no_gazetted_officer");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {"designation_code": destination};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null || responseJSON != "") {
      setState(() {
        var aparyear = responseJSON['apar_fin_yr'];
        aparformate = responseJSON['apar_format_code'];
        pay_level = responseJSON['pay_level'];
        apar_format_desc = responseJSON['apar_format_desc'];
        apar_format_desc_hindi = responseJSON['apar_format_desc_hindi'];
      });

      if (aparformate == "A1" ||
          aparformate == "A2" ||
          aparformate == "A3" ||
          aparformate == "A4" ||
          aparformate == "A5" ||
          aparformate == "H1" ||
          aparformate == "RBD1" ||
          aparformate == "RBD2" ||
          aparformate == "RBD3" ||
          aparformate == "RBD4") {
        select_apprasial_emp(widget.finyear);
      }
    }
  }

  Future getDetails() async {
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

    if (responseJSON['status'] == "1") {
      setState(() {
        profilename = responseJSON['userProfile']['profile']['employeeName'];
        designation =
            responseJSON['userProfile']['profile']['designationDescription'];

        dob = responseJSON['userProfile']['profile']['dateOfBirth'];
        railwayunit = responseJSON['userProfile']['profile']['railwayUnitCode'];

        department =
            responseJSON['userProfile']['profile']['departmentDescription'];
        mobileno = responseJSON['userProfile']['profile']['mobileNo'];
        billunit = responseJSON['userProfile']['profile']['billUnit'];
        ipasempid = responseJSON['userProfile']['profile']['ipasEmployeeId'];
        hrmsid = responseJSON['userProfile']['profile']['hrmsEmployeeId'];
        int desig_code =
            responseJSON['userProfile']['profile']['designationcode'];
        print('desig_code $desig_code');
        if (desig_code != 0) {
          get_no_gazettedofficer(desig_code);
        }
      });
    }
  }

  Future getselfappraisaldetails() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("details_self_appraisal");
    HttpClient client = new HttpClient();
    sharedpreferencemanager pref = sharedpreferencemanager();
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

    if (responseJSON['status'] == "1") {
      setState(() {
        profilename = responseJSON['userProfile']['profile']['employeeName'];
        designation =
            responseJSON['userProfile']['profile']['designationDescription'];

        dob = responseJSON['userProfile']['profile']['dateOfBirth'];
        railwayunit = responseJSON['userProfile']['profile']['railwayUnitCode'];

        department =
            responseJSON['userProfile']['profile']['departmentDescription'];
        mobileno = responseJSON['userProfile']['profile']['mobileNo'];
        billunit = responseJSON['userProfile']['profile']['billUnit'];
        ipasempid = responseJSON['userProfile']['profile']['ipasEmployeeId'];
        hrmsid = responseJSON['userProfile']['profile']['hrmsEmployeeId'];
        int desig_code =
            responseJSON['userProfile']['profile']['designationCode'];
      });
    }
  }

  /*Future<Null> _getIP() async {
    String ip = await Wifi.ip;
    setState(() {
      _ip = ip;

    });
  }*/
  Future add_self_apprasial_emp() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("add_self_appraisal_emp");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    DateTime now = DateTime.now();

    Map map = {
      "hrms_employee_id": hrmsid,
      "apar_fin_yr": widget.finyear,
      "apar_format_code": aparformate,
      "desc_of_duties": dc_duties_text_f.text,
      "property_returns": property_text_f.text,
      "date_created": now.toString(),
      "ip_address": _ip,
      "work_done": work_done_text_f.text,
      "operating_unit": railwayunit
    };
    print(map.toString());

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    print(responseJSON);

    if (responseJSON != null || responseJSON != "") {
      setState(() {
        if (responseJSON['result'] == 1) {
          Navigator.of(context).pop();
        } else {}
      });
    }
  }

  Future select_apprasial_emp(String year) async {
    final String url =
        new UtilsFromHelper().getValueFromKey("select_self_apprasial");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {"hrms_employee_id": hrmsid, "apar_fin_yr": year};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON != null || responseJSON != "") {
      var aparformate;
      setState(() {
        if (responseJSON['result'] == 1) {
          visiblity_con = true;
          _isButtonDisabled = true;
          getselfappraisaldetails();
          Fluttertoast.showToast(
              msg: "self-appraisal already submitted",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              //  timeInSecForIos: 5,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);
        } else {
          _isButtonDisabled = false;
          visiblity_con = true;
        }
      });
    }
  }

  @override
  void initState() {
    //_getIP();
    getDetails();
    super.initState();
  }

  Widget _buildStatContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white54,
          border: Border.all(width: 1, color: Colors.white)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      child: Column(children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 14,
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'HRMS ID :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(hrmsid ?? "Not Available",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 14,
                  margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text(
                    'DESIGNATION :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(designation ?? "Not Available",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 14,
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'DEPARTMENT :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(department ?? "Not Available",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 14,
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'PAYLEVEL :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(pay_level ?? "Not Available",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 14,
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'OPERATING UNIT :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(billunit ?? "Not Available",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 14,
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'APAR FORMAT CODE :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Container(
              width: 18,
              child: Row(
                children: <Widget>[
                  Text(aparformate ?? "NA",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 150,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 180,
                    child: Text(apar_format_desc_hindi ?? "Not Available",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12)),
                  ),
                  Container(
                    width: 180,
                    child: Text(apar_format_desc ?? "Not Available",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Visibility(
          visible: visiblity_con,
          child: Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Brief description of duties",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.5, horizontal: 0.0),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter brief description of duties",
                ),
                controller: dc_duties_text_f,
                maxLines: 1,
                style: TextStyle(fontSize: 15),
                enableInteractiveSelection: true,
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Work done in the current year",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.5, horizontal: 0.0),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter work done in the current year",
                ),
                controller: work_done_text_f,
                maxLines: 1,
                style: TextStyle(fontSize: 15),
                enableInteractiveSelection: true,
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Property returns (Y / N)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.5, horizontal: 0.0),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter property returns (Y / N)",
                ),
                maxLength: 1,
                textCapitalization: TextCapitalization.characters,
                controller: property_text_f,
                maxLines: 1,
                style: TextStyle(fontSize: 15),
                enableInteractiveSelection: true,
              ),
            ),
            Container(
              height: 45.0,
              margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.lightBlueAccent,
                child: Container(
                  decoration: BoxDecoration(),
                  child: MaterialButton(
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                            if (dc_duties_text_f.text.length == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Enter brief description of duties',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  //  timeInSecForIos: 5,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            } else if (work_done_text_f.text.length == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Enter work done in the current year',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  //  timeInSecForIos: 5,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            } else if (property_text_f.text.length == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Enter property returns(Y/N)',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  //  timeInSecForIos: 5,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            } else {
                              add_self_apprasial_emp();
                            }
                          },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
    );
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Self Apprasial",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: Stack(
        children: <Widget>[
          // _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    profilename,
                    style: _nameTextStyle,
                  ),
                  SizedBox(height: 5.0),
                  _buildStatContainer(),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
