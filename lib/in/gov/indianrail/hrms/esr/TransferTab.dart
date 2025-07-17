import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'model/TransferDetailsModel.dart';

class TransferTab extends StatefulWidget {
  @override
  State<TransferTab> createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
  late List<TransferDetailsModel> _transferInfo;
  int listsize = 0;
  var serviceStatus = "";

  @override
  void initState() {
    getTransferDetails();
    super.initState();
  }

  Future getTransferDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("show_e_sr_transfer");
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
          var transferdetails =
              responseJSON["transfersList"]["headerdata"] as List;

          print('data: $transferdetails');
          _transferInfo = transferdetails
              .map<TransferDetailsModel>(
                  (json) => TransferDetailsModel.fromJson(json))
              .toList();
          print('data: break');
          listsize = _transferInfo.length;

          print('_transferInfo: $_transferInfo');
          serviceStatus = _transferInfo[0].st;
          print('listsize: $listsize');
          if (_transferInfo.length == 0) {
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
      print(e);
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
                            child: Column(
                              children: <Widget>[
                                ExpansionTile(
                                  backgroundColor: Colors.blue[50],
                                  subtitle: Text(
                                    _transferInfo[index].transferOrderDate,
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  title: Text(
                                    _transferInfo[index].transferToPlaceDesc,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'Reason of Transfer	 :',
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
                                                _transferInfo[index]
                                                    .transferReasonDesc,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'Transfer Type :',
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
                                                _transferInfo[index]
                                                    .transferFlagDesc,
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
                                                        'Transfer From',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Unit :',
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
                                                      _transferInfo[index]
                                                          .transferFromPlaceDesc,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Station :',
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
                                                      _transferInfo[index]
                                                          .transferFromStation,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Office	:',
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
                                                      _transferInfo[index]
                                                          .transferFromOffice,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Department :',
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
                                                      _transferInfo[index]
                                                          .transferFromDepartment,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Sub-Department :',
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
                                                      _transferInfo[index]
                                                          .transferFromSubDepartment,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Designation :',
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
                                                      _transferInfo[index]
                                                          .transferFromDesignation,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Charge Taken Date on Post :',
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
                                                      _transferInfo[index]
                                                          .dateChargeTakeFromPost,
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
                                                        'Release Date from Post :',
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
                                                      _transferInfo[index]
                                                          .dateReleaseFromPost,
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
                                                        'Transfer To',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Unit :',
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
                                                      _transferInfo[index]
                                                          .transferToPlaceDesc,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Station :',
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
                                                      _transferInfo[index]
                                                          .transferToOffice,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Office	 :',
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
                                                      _transferInfo[index]
                                                          .transferToOffice,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Department :',
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
                                                      _transferInfo[index]
                                                          .transferDepartment,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Sub-Department :',
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
                                                      _transferInfo[index]
                                                          .transferToSubDepartment,
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
                                                10, 15, 10, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text(
                                                        'Designation :',
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
                                                      _transferInfo[index]
                                                          .transferDesignation,
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
                                                        'Charge Taken on :',
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
                                                      (_transferInfo[index]
                                                                      .chargeTakenFrom !=
                                                                  null &&
                                                              _transferInfo[
                                                                          index]
                                                                      .chargeTakenFrom !=
                                                                  'null'
                                                          ? _transferInfo[index]
                                                              .chargeTakenFrom
                                                          : "NA"),
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
                                          EdgeInsets.fromLTRB(10, 15, 10, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                child: Text(
                                                  'Experience :',
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
                                                _transferInfo[index].experience,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 15, 10, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 15),
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
                                            child: Text(
                                                _transferInfo[index].remarks,
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
