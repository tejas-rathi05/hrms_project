import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'model/EmployeeSRPayChangeDetailsModel.dart';

class PayChangeTab extends StatefulWidget {
  @override
  State<PayChangeTab> createState() => _PayChangeTabState();
}

class _PayChangeTabState extends State<PayChangeTab> {
  late List<EmployeeSRPayChangeDetailsModel> _payInfo;
  int listsize = 0;
  var serviceStatus = "";

  @override
  void initState() {
    getPayChangeDetails();
    super.initState();
  }

  Future getPayChangeDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("show_e_sr_paychange_history");
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
          var paydetails = responseJSON["payChangeList"]["headerdata"] as List;

          print('data: $paydetails');
          _payInfo = paydetails
              .map<EmployeeSRPayChangeDetailsModel>(
                  (json) => EmployeeSRPayChangeDetailsModel.fromJson(json))
              .toList();
          print('data: break');
          listsize = _payInfo.length;

          print('_payInfo: $_payInfo');
          serviceStatus = _payInfo[0].st;
          print('listsize: $listsize');
          if (_payInfo.length == 0) {
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
      print(e);
      Fluttertoast.showToast(
          msg: 'No data found',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
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
                                    (_payInfo[index].payChangeDescription) +
                                        " - " +
                                        (_payInfo[index].dateOfPayChange),
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  title: Text(
                                    _payInfo[index].scaleCode +
                                        " (" +
                                        _payInfo[index].scaleDesc +
                                        ")",
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
                                                  'Station Code :',
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
                                                _payInfo[index].stationCode,
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
                                                  'Pay Commission :',
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
                                                _payInfo[index].payCommission,
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
                                                  'Scale Code/Pay Band/Pay Level :',
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
                                                _payInfo[index].scaleCode +
                                                    " (" +
                                                    _payInfo[index].scaleDesc +
                                                    ")",
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
                                                  'Basic Pay :',
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
                                                _payInfo[index].basicPay,
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
                                                  'Personal Pay :',
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
                                                _payInfo[index].personalPay,
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
                                                  'Pay Change Date :',
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
                                                _payInfo[index].dateOfPayChange,
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
                                                  'Remarks :',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[600]),
                                                )),
                                          ),
                                          Expanded(
                                            child: Text(_payInfo[index].remarks,
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
