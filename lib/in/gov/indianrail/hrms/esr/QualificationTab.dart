import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'model/EmployeeSRFamilyDetailsModel.dart';
import 'model/EmployeeSRQualificationDetailsModel.dart';

class QualificationTab extends StatefulWidget {
  @override
  State<QualificationTab> createState() => _QualificationTabState();
}

class _QualificationTabState extends State<QualificationTab> {
  late List<EmployeeSRQualificationDetailsModel> _qualificationInfo;
  int listsize = 0;
  var serviceStatus = "";

  @override
  void initState() {
    getQualificationDetails();
    super.initState();
  }

  Future getQualificationDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("show_e_sr_qualification");
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
    //try {
      if (responseJSON != null) {
        setState(() {
          var qualificationdetails =
              responseJSON["qualificationDetails"]["headerdata"] as List;
          print('data: $qualificationdetails');
          _qualificationInfo = qualificationdetails
              .map<EmployeeSRQualificationDetailsModel>(
                  (json) => EmployeeSRQualificationDetailsModel.fromJson(json))
              .toList();
          listsize = _qualificationInfo.length;
          serviceStatus = _qualificationInfo[0].st;
          print('_qualificationInfo: $_qualificationInfo');
          print('listsize: $listsize');
          if (_qualificationInfo.length == 0) {
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
    /*} catch (e) {
      Fluttertoast.showToast(
          msg: 'No data found',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }*/
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
                                  subtitle: Text(
                                    _qualificationInfo[index].passingYear,
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  title: Text(
                                    _qualificationInfo[index]
                                        .qualificationLevel,
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
                                                  'Course :',
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
                                                _qualificationInfo[index]
                                                    .courseDescription,
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
                                                  'SUBJECTS /SPECIALIZATION :',
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
                                                _qualificationInfo[index]
                                                    .subjects,
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
                                                  'Board/University :',
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
                                                _qualificationInfo[index]
                                                    .boardName,
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
                                                  'PERCENTAGE(%) :',
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
                                                _qualificationInfo[index]
                                                    .marksPercentage,
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
