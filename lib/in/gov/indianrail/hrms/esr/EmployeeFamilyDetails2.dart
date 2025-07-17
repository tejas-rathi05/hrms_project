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

class EmployeeFamilyDetails2 extends StatefulWidget {
  @override
  State<EmployeeFamilyDetails2> createState() => _EmployeeFamilyDetailsState();
}

class _EmployeeFamilyDetailsState extends State<EmployeeFamilyDetails2> {
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
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                  child: Text(serviceStatus ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red))),
            ],
          ),
        ),
        Container(
            child: ListView.builder(
          // current the spelling of length here
          itemCount: listsize,
          itemBuilder: (context, index) {
            var member_dob = _familyInfo[index].memberDateOfBirth;

            try {
              final DateTime parsed = DateTime.parse(member_dob);
              member_dob = DateFormat('dd/MM/yyyy').format(parsed);
            } catch (exception) {}

            return Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          color: Colors.blue[900],
                          child: Row(
                            children: [
                              Container(
                                  height: 25,
                                  margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                                  child: Text(
                                      'Family Member : ' +
                                          _familyInfo[index].familyMemberSrNo,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Text(
                                      'MEMBER NAME :',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    _familyInfo[index]
                                            .familyMemberName
                                            .toString() ??
                                        "Not Available",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Text(
                                      'RELATION :',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    _familyInfo[index]
                                            .relationCode
                                            .toString() ??
                                        "Not Available",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Text(
                                      'MEMBER DATE OF BIRTH  :',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    member_dob.toString() ?? "Not Available",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Text(
                                      'MEMBER DEPENDENT(?)   :',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    _familyInfo[index].dependent.toString() ??
                                        "Not Available",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12)),
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
      ],
    );
  }
}
