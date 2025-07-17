import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'model/EmployeeSRFamilyDetailsModel.dart';

class FamilyTab extends StatefulWidget {
  @override
  State<FamilyTab> createState() => _FamilyTabState();
}

class _FamilyTabState extends State<FamilyTab> {
  late List<EmployeeSRFamilyDetailsModel> _familyInfo;
  int listsize = 0;
  var serviceStatus = "";

  @override
  void initState() {
    getFamilyDetails();
    super.initState();
  }

  Future getFamilyDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("show_e_sr_family");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsEmployeeId": await pref.getUsername(),
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    try {
      if (responseJSON != null) {
        setState(() {
          var familydetails =
              responseJSON["familyDetails"]["headerdata"] as List;
          print('data: $familydetails');
          _familyInfo = familydetails
              .map<EmployeeSRFamilyDetailsModel>(
                  (json) => EmployeeSRFamilyDetailsModel.fromJson(json))
              .toList();
          listsize = _familyInfo.length;
          print('_familyInfo: $_familyInfo');
          serviceStatus = _familyInfo[0].st;
          print(' serviceStatus $serviceStatus');
          print('_familyInfo dob: $_familyInfo');
          print('listsize: $listsize');
          if (_familyInfo.length == 0) {
            Fluttertoast.showToast(
                msg: 'No data found',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                //  timeInSecForIos: 5,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'No data found' + e.toString(),
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
    return Stack(
      children: [
        Positioned(
          top: 10.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white54,
                border: Border.all(width: 1, color: Colors.white)),
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: const Text('Status :',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    color: Colors.grey[100],
                    child: Text(serviceStatus,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
          child: Container(
              child: ListView.builder(
            // current the spelling of length here
            itemCount: listsize,
            itemBuilder: (context, index) {
              var member_dob = _familyInfo[index].memberDateOfBirth;

              try {
                final DateTime parsed = DateTime.parse(member_dob);
                member_dob = DateFormat('dd/MM/yyyy').format(parsed);
              } catch (exception) {}
              var gender = _familyInfo[index].gender;
              if (gender == 'M') {
                gender = 'MALE';
              } else if (gender == 'F') {
                gender = 'FEMALE';
              }

              return Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                padding: EdgeInsets.all(8),
                child: Column(children: <Widget>[
                  Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                      elevation: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child: Column(
                              children: <Widget>[
                                ExpansionTile(
                                  backgroundColor: Colors.blue[50],
                                  title: Text(
                                    _familyInfo[index].familyMemberName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 15),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'Relation :',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600]),
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(
                                                _familyInfo[index].relationCode,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 15),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'MEMBER DATE OF BIRTH :',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600]),
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(member_dob.toString(),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 15),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'Gender :',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600]),
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(gender,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 15),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'MEMBER DEPENDENT(?) :',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600]),
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(
                                                _familyInfo[index].dependent,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              );
            },
          )),
        ),
      ],
    );
  }
}
