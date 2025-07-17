import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'model/EmployeeSRDeputationDetailsModel.dart';
import 'model/EmployeeSRPublicationDetailsModel.dart';

class DeputationTab extends StatefulWidget {
  @override
  State<DeputationTab> createState() => _DeputationTabState();
}

class _DeputationTabState extends State<DeputationTab> {
  late List<EmployeeSRDeputationDetailsModel> _deputationInfo;
  int listsize = 0;
  var serviceStatus = "";

  @override
  void initState() {
    getDeputationDetails();
    super.initState();
  }

  Future getDeputationDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("show_e_sr_deputations");
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
          var deputationdetails =
              responseJSON["deputationList"]["headerdata"] as List;
          print('data: $deputationdetails');
          _deputationInfo = deputationdetails
              .map<EmployeeSRDeputationDetailsModel>(
                  (json) => EmployeeSRDeputationDetailsModel.fromJson(json))
              .toList();
          listsize = _deputationInfo.length;
          print('_deputationInfo: $_deputationInfo');
          serviceStatus = _deputationInfo[0].status;
/*
          if (serviceStatus == 'A') {
            serviceStatus = 'Verified';
          } else {
            serviceStatus = 'Not Verified';
          }*/

          print('listsize: $listsize');
          if (_deputationInfo.length == 0) {
            Fluttertoast.showToast(
                msg: 'No data found',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'No data found',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
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
          top: 10,
          child: Container(
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
                                    _deputationInfo[index].station,
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  title: Text(
                                    _deputationInfo[index].ministry_name,
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
                                                  'Deputation Type :',
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
                                                _deputationInfo[index]
                                                    .deputation_type,
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
                                                  'Country :',
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
                                                _deputationInfo[index]
                                                    .country_code,
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
                                                  'Department/ Organisation :',
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
                                                _deputationInfo[index]
                                                    .department_organisation,
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
                                                  'Designation :',
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
                                                _deputationInfo[index]
                                                    .designation,
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
                                                  'Pay Level :',
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
                                                _deputationInfo[index]
                                                    .pay_level,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                          left: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                1, 1, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Deputation Out Details [START]:',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Date of Release from Railway :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .date_from,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Office Order Number :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .dep_out_oo_no,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Office Order Date :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .dep_out_oo_date,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Date of Joining at Dep. :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .date_joining_at_dept,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Unit/Station :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .dep_out_from_station,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
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
                                                  'Repatriated To Railway?  :',
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
                                                _deputationInfo[index]
                                                    .repatriated_to_railway,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                          left: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Color(0xFF000000)),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                1, 1, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Repatriation to Railway:',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Date of Release from deputation :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .date_release_from_deputation,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Office Order Number :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .dep_in_oo_no,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Office Order Date :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .dep_out_oo_date,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Date of Joining to Railway :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .date_to,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 15),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Unit/Station :',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[600]),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      _deputationInfo[index]
                                                          .dep_in_to_station,
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
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
