import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';

import 'package:intl/intl.dart';
//import 'package:wifi/wifi.dart';
import '../util/apiurl.dart';
import '../local_shared_pref/sharedpreferencemanager.dart';

import 'dart:async';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

var designation = "",
    railwayunit = "",
    dob = "",
    department = "",
    mobileno = "",
    billunit = "",
    ipasempid = "",
    hrmsid = "",
    railwayzone = "",
    profilename = "";

class AparProfile extends StatefulWidget {
  var hrmsEmployeeId,
      employeeName,
      Designation,
      vafCode,
      aparFinYr,
      profiletype;

  AparProfile(this.hrmsEmployeeId, this.employeeName, this.Designation,
      this.vafCode, this.aparFinYr, this.profiletype);

  @override
  AparProfileState createState() => AparProfileState();
}

class AparProfileState extends State<AparProfile> {
  bool visibleRemarks = false;
  String _Send_selectedleadership = "",
      _Send_selecteddecision_making = "",
      _Send_selectedhigher_responsibility = "",
      _Send_selectedinspire_confidence = "",
      _Send_selectedenforce_discipline = "";
  late File _image;
  late String _ip;
  TextEditingController empId = TextEditingController();
  TextEditingController remarks = TextEditingController();

  TextEditingController hrmsidController = TextEditingController();

  sharedpreferencemanager pref = sharedpreferencemanager();

  List<String> leadership = [
    "Outstanding",
    "Very Good",
    "Good",
    "Average",
    "Below Average"
  ];
  List<String> decision_making = [
    "Outstanding",
    "Very Good",
    "Good",
    "Average",
    "Below Average"
  ];
  List<String> higher_responsibility = [
    "Outstanding",
    "Very Good",
    "Good",
    "Average",
    "Below Average"
  ];
  List<String> inspire_confidence = [
    "Outstanding",
    "Very Good",
    "Good",
    "Average",
    "Below Average"
  ];
  List<String> enforce_discipline = [
    "Outstanding",
    "Very Good",
    "Good",
    "Average",
    "Below Average"
  ]; // Option 2
  late String _selectedleadership;
  late String _selecteddecision_making;
  late String _selectedhigher_responsibility;
  late String _selectedinspire_confidence;
  late String _selectedenforce_discipline;
  late Size screenSize;
  String text_leadership = "Select";
  String text_decision_making = "Select";
  String text_higher_responsibility = "Select";
  String text_inspire_confidence = "Select";
  String text_enforce_discipline = "Select";

  /*Future<Null> _getIP() async {
    String ip = await Wifi.ip;
    setState(() {
      _ip = ip;
    });
  }*/

  Future ReportingOffierdetails() async {
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
        railwayunit = responseJSON['userProfile']['profile']['railwayUnitName'];
        dob = responseJSON['userProfile']['profile']['dateOfBirth'];

        department =
            responseJSON['userProfile']['profile']['departmentDescription'];
        mobileno = responseJSON['userProfile']['profile']['mobileNo'];
        billunit = responseJSON['userProfile']['profile']['billUnit'];
        ipasempid = responseJSON['userProfile']['profile']['ipasEmployeeId'];
        hrmsid = responseJSON['userProfile']['profile']['hrmsEmployeeId'];
        railwayunit = responseJSON['userProfile']['profile']['railwayUnitCode'];

        try {
          final DateTime todayDate = DateTime.now();
          final String dob = DateFormat('dd/MM/yyyy').format(todayDate);
        } catch (exception) {}
      });
    }
  }

  Future get_reporting_section() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("get_reporting_section");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "hrms_employee_id": widget.hrmsEmployeeId,
    };

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
        if (responseJSON['leadership'] != null) {
          if (responseJSON['leadership'] == "A") {
            text_leadership = "Average";
            _selectedleadership = "Average";
          } else if (responseJSON['leadership'] == "O") {
            text_leadership = "Outstanding";
            _selectedleadership = "Outstanding";
          } else if (responseJSON['leadership'] == "VG") {
            text_leadership = "Very Good";
            _selectedleadership = "Very Good";
          } else if (responseJSON['leadership'] == "BA") {
            text_leadership = "Below Average";
            _selectedleadership = "Below Average";
          }
        } else {
          text_leadership = "Select";
        }

        if (responseJSON['decision_making'] != null) {
          if (responseJSON['decision_making'] == "A") {
            text_decision_making = "Average";
            _selecteddecision_making = "Average";
          } else if (responseJSON['decision_making'] == "O") {
            text_decision_making = "Outstanding";
            _selecteddecision_making = "Outstanding";
          } else if (responseJSON['decision_making'] == "VG") {
            text_decision_making = "Very Good";
            _selecteddecision_making = "Very Good";
          } else if (responseJSON['decision_making'] == "BA") {
            text_decision_making = "Below Average";
            _selecteddecision_making = "Below Average";
          }
        } else {
          text_decision_making = "Select";
        }

        if (responseJSON['higher_responsibility'] != null) {
          if (responseJSON['higher_responsibility'] == "A") {
            text_higher_responsibility = "Average";
            _selectedhigher_responsibility = "Average";
          } else if (responseJSON['higher_responsibility'] == "O") {
            text_higher_responsibility = "Outstanding";
            _selectedhigher_responsibility = "Outstanding";
          } else if (responseJSON['higher_responsibility'] == "VG") {
            text_higher_responsibility = "Very Good";
            _selectedhigher_responsibility = "Very Good";
          } else if (responseJSON['higher_responsibility'] == "BA") {
            text_higher_responsibility = "Below Average";
            _selectedhigher_responsibility = "Below Average";
          }
        } else {
          text_higher_responsibility = "Select";
        }

        if (responseJSON['inspire_confidence'] != null) {
          if (responseJSON['inspire_confidence'] == "A") {
            text_inspire_confidence = "Average";
            _selectedinspire_confidence = "Average";
          } else if (responseJSON['inspire_confidence'] == "O") {
            text_inspire_confidence = "Outstanding";
            _selectedinspire_confidence = "Outstanding";
          } else if (responseJSON['inspire_confidence'] == "VG") {
            text_inspire_confidence = "Very Good";
            _selectedinspire_confidence = "Very Good";
          } else if (responseJSON['inspire_confidence'] == "BA") {
            text_inspire_confidence = "Below Average";
            _selectedinspire_confidence = "Below Average";
          }
        } else {
          text_inspire_confidence = "Select";
        }

        if (responseJSON['enforce_discipline'] != null) {
          if (responseJSON['enforce_discipline'] == "A") {
            text_enforce_discipline = "Average";
            _selectedenforce_discipline = "Average";
          } else if (responseJSON['enforce_discipline'] == "O") {
            text_enforce_discipline = "Outstanding";
            _selectedenforce_discipline = "Outstanding";
          } else if (responseJSON['enforce_discipline'] == "VG") {
            text_enforce_discipline = "Very Good";
            _selectedenforce_discipline = "Very Good";
          } else if (responseJSON['enforce_discipline'] == "BA") {
            text_enforce_discipline = "Below Average";
            _selectedenforce_discipline = "Below Average";
          }
        } else {
          text_enforce_discipline = "Select";
        }
      });
    }
  }

  Future add_reportingSction() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("Add_reporting_officer");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    DateTime now = DateTime.now();

    Map map = {
      "hrms_employee_id": widget.hrmsEmployeeId,
      "apar_fin_yr": widget.aparFinYr,
      "leadership": _Send_selectedleadership,
      "decision_making": _Send_selecteddecision_making,
      "higher_responsibility": _Send_selectedhigher_responsibility,
      "inspire_confidence": _Send_selectedinspire_confidence,
      "enforce_discipline": _Send_selectedenforce_discipline,
      "rep_officer_hrmsid": hrmsid,
      "rep_designation": designation,
      "rep_date": now.toString(),
      "rep_ip_address": _ip,
      "operating_unit": railwayunit,
      "status": "S2",
      "apar_format_code": widget.vafCode,
    };

    //var aparyear = widget.aparFinYr;
    // var code = widget.vafCode;

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON['message'] == "1") {
      setState(() {
        Fluttertoast.showToast(
            msg: 'Data inserted successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      });
    } else {
      Fluttertoast.showToast(
          msg: responseJSON['result']['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  Future update_reviewing_section() async {
    DateTime now = DateTime.now();
    final String url =
        new UtilsFromHelper().getValueFromKey("update_re_officer");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "hrmsId": widget.hrmsEmployeeId,
      "apar_fin_yr": widget.aparFinYr,
      "rev_officer_hrmsid": hrmsid,
      "rev_officer_name": profilename,
      "rev_designation": designation,
      "rev_station_code": railwayunit,
      "rev_date": now.toString(),
      "rev_ip_address": _ip,
      "rev_remarks": remarks.text
    };

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
        if (responseJSON['result']) {
          Fluttertoast.showToast(
              msg: 'Update successfully',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              //timeInSecForIos: 5,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);
          remarks.text = "";
        }
      });
    }
  }

  Future update_accepting_section() async {
    DateTime now = DateTime.now();
    final String url =
        new UtilsFromHelper().getValueFromKey("update_accepting_officer");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "hrmsId": widget.hrmsEmployeeId,
      "apar_fin_yr": widget.aparFinYr,
      "acc_officer_hrms_id": hrmsid,
      "acc_officer_name": profilename,
      "acc_designation": designation,
      "acc_station": railwayunit,
      "acc_date": now.toString(),
      "acc_ip_address": _ip,
      "acc_remarks": remarks.text
    };

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
        if (responseJSON['result']) {
          Fluttertoast.showToast(
              msg: 'Update successfully',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              //timeInSecForIos: 5,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);
          remarks.text = "";
        }
      });
    }
  }

  @override
  void initState() {
    // _getIP();
    get_reporting_section();
    ReportingOffierdetails();

    super.initState();
  }

  Widget _buildStatContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white54,
          border: Border.all(width: 1, color: Colors.white)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
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
              child: Text(
                widget.hrmsEmployeeId ?? "Not Available",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
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
                    'EMPLOYEE NAME :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                widget.employeeName ?? "Not Available",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
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
              child: Text(
                widget.Designation ?? "Not Available",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
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
                    'FINANCIAL YEAR :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                widget.aparFinYr,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
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
                    'VERIFIED CODE :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                widget.vafCode ?? "Not Available",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey),
      ]),
    );
  }

  Widget _buildStatContainer1() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white54,
          border: Border.all(width: 1, color: Colors.white)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
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
                    'Pay Level:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                "6000",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
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
                    'Basic Pay :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                "6000",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildStatContainer2() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white54,
          border: Border.all(width: 1, color: Colors.white)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
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
                    'Pay Level:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                "6000",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
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
                    'Basic Pay :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(
                "6000",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profiletype == "reviewing" ||
        widget.profiletype == "accepting") {
      visibleRemarks = true;
    } else {
      visibleRemarks = false;
    }
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
    );
    Size screenSize = MediaQuery.of(context).size;
    final loginButon = Material(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        onPressed: () {},
        child: Text("GO",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Personal Details",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.5, horizontal: 0.0),
                          padding: EdgeInsets.only(left: 25),
                          decoration: BoxDecoration(),
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: TextField(
                                  controller: empId,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 12),
                                  enableInteractiveSelection: true,
                                  decoration: new InputDecoration(
                                      hintText: 'Enter HRMS Id'),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.5, horizontal: 55.0),
                            child: loginButon,
                          ),
                        ),
                      ]),
                  SizedBox(height: 30.0),
                  Text(
                    "Personal Information",
                    style: _nameTextStyle,
                  ),
                  SizedBox(height: 5.0),
                  _buildStatContainer(),
                  SizedBox(height: 15),
                  Column(children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Section || of the APAR From for Railway Employees in Scale",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('$text_leadership'),
                        value: _selectedleadership,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedleadership = newValue!;
                          });
                        },
                        items: leadership.map((leadership) {
                          return DropdownMenuItem(
                            child: new Text(leadership),
                            value: leadership,
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  Column(children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Capacity to take decision on matters within his/her competence",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('$text_decision_making'),
                        value: _selecteddecision_making,
                        onChanged: (newValue) {
                          setState(() {
                            _selecteddecision_making = newValue!;
                          });
                        },
                        items: decision_making.map((decision_making) {
                          return DropdownMenuItem(
                            child: new Text(decision_making),
                            value: decision_making,
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  Column(children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Willingness to shoulder higher responsibility",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('$text_higher_responsibility'),
                        value: _selectedhigher_responsibility,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedhigher_responsibility = newValue!;
                          });
                        },
                        items: higher_responsibility.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  Column(children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Ability to inspire confidence,guide,motivate and obtainthe best out of the staff",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('$text_inspire_confidence'),
                        value: _selectedinspire_confidence,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedinspire_confidence = newValue!;
                          });
                        },
                        items: inspire_confidence.map((inspire_confidence) {
                          return DropdownMenuItem(
                            child: new Text(inspire_confidence),
                            value: inspire_confidence,
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  Column(children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Ability to enforce discipline",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('$text_enforce_discipline'),
                        value: _selectedenforce_discipline,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedenforce_discipline = newValue!;
                          });
                        },
                        items: enforce_discipline.map((enforce_discipline) {
                          return DropdownMenuItem(
                            child: new Text(enforce_discipline),
                            value: enforce_discipline,
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  Visibility(
                    visible: visibleRemarks,
                    child: Column(children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                              "Enter Remarks",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.5, horizontal: 0.0),
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        decoration: BoxDecoration(),

                        child: TextField(
                          controller: remarks,
                          maxLines: 1,
                          style: TextStyle(fontSize: 15),
                          enableInteractiveSelection: true,
                          decoration:
                              new InputDecoration(hintText: 'Enter Remarks'),
                        ),
                        // child: new Row(
                        //   children: <Widget>[
                        //     new Expanded(
                        //       child: TextField(
                        //
                        //         controller: remarks,
                        //         maxLines: 1,
                        //         style: TextStyle(
                        //             fontSize: 12),
                        //         enableInteractiveSelection: true,
                        //         decoration: new InputDecoration(
                        //             hintText: 'Enter Remarks'
                        //
                        //         ),
                        //
                        //       ),
                        //     ),
                        //
                        //   ],
                        // ),
                      ),
                    ]),
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
                          onPressed: () {
                            if (widget.profiletype == "reporting") {
                              if (_selectedleadership == "Outstanding") {
                                _Send_selectedleadership = "O";
                              } else if (_selectedleadership == "Very Good") {
                                _Send_selectedleadership = "VG";
                              } else if (_selectedleadership == "Good") {
                                _Send_selectedleadership = "G";
                              } else if (_selectedleadership == "Average") {
                                _Send_selectedleadership = "A";
                              } else if (_selectedleadership ==
                                  "Below Average") {
                                _Send_selectedleadership = "BA";
                              }

                              if (_selecteddecision_making == "Outstanding") {
                                _Send_selecteddecision_making = "O";
                              } else if (_selecteddecision_making ==
                                  "Very Good") {
                                _Send_selecteddecision_making = "VG";
                              } else if (_selecteddecision_making == "Good") {
                                _Send_selecteddecision_making = "G";
                              } else if (_selecteddecision_making ==
                                  "Average") {
                                _Send_selecteddecision_making = "A";
                              } else if (_selecteddecision_making ==
                                  "Below Average") {
                                _Send_selecteddecision_making = "BA";
                              }

                              if (_selectedhigher_responsibility ==
                                  "Outstanding") {
                                _Send_selectedhigher_responsibility = "O";
                              } else if (_selectedhigher_responsibility ==
                                  "Very Good") {
                                _Send_selectedhigher_responsibility = "VG";
                              } else if (_selectedhigher_responsibility ==
                                  "Good") {
                                _Send_selectedhigher_responsibility = "G";
                              } else if (_selectedhigher_responsibility ==
                                  "Average") {
                                _Send_selectedhigher_responsibility = "A";
                              } else if (_selectedhigher_responsibility ==
                                  "Below Average") {
                                _Send_selectedhigher_responsibility = "BA";
                              }

                              if (_selectedinspire_confidence ==
                                  "Outstanding") {
                                _Send_selectedinspire_confidence = "O";
                              } else if (_selectedinspire_confidence ==
                                  "Very Good") {
                                _Send_selectedinspire_confidence = "VG";
                              } else if (_selectedinspire_confidence ==
                                  "Good") {
                                _Send_selectedinspire_confidence = "G";
                              } else if (_selectedinspire_confidence ==
                                  "Average") {
                                _Send_selectedinspire_confidence = "A";
                              } else if (_selectedinspire_confidence ==
                                  "Below Average") {
                                _Send_selectedinspire_confidence = "BA";
                              }

                              if (_selectedenforce_discipline ==
                                  "Outstanding") {
                                _Send_selectedenforce_discipline = "O";
                              } else if (_selectedenforce_discipline ==
                                  "Very Good") {
                                _Send_selectedenforce_discipline = "VG";
                              } else if (_selectedenforce_discipline ==
                                  "Good") {
                                _Send_selectedenforce_discipline = "G";
                              } else if (_selectedenforce_discipline ==
                                  "Average") {
                                _Send_selectedenforce_discipline = "A";
                              } else if (_selectedenforce_discipline ==
                                  "Below Average") {
                                _Send_selectedenforce_discipline = "BA";
                              }

                              if (_Send_selectedleadership == "" ||
                                  _Send_selecteddecision_making == "" ||
                                  _Send_selectedhigher_responsibility == "" ||
                                  _Send_selectedinspire_confidence == "" ||
                                  _Send_selectedenforce_discipline == "") {
                                Fluttertoast.showToast(
                                    msg: 'Select Option',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else {
                                add_reportingSction();
                              }
                            } else if (widget.profiletype == "reviewing") {
                              if (remarks.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Remarks',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else {
                                update_reviewing_section();
                              }
                            } else if (widget.profiletype == "accepting") {
                              if (remarks.text.length == "0") {
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Remarks',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else {
                                //ERDOOB
                                update_accepting_section();
                              }
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeptItem {
  final String name;

  const DeptItem(this.name);
}
