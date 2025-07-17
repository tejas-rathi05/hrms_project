import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';

import '../util/session_check.dart';
import '../util/validation_check.dart';


String clbal = "", rhbal = "", lapbal = "", lhapbal = "", cclbal = "";
var empname = "", hrmsEmployeeId = "";
String currentdatetimestamp = "";

class LeaveBalance extends StatefulWidget {
  @override
  LeaveBalanceState createState() => LeaveBalanceState();
}

class LeaveBalanceState extends State<LeaveBalance> {
  SessionCheck sessionCheck=  SessionCheck();
  @override
  void initState() {
    getLeaveBalanceDetails();
    sessionCheck.startTimer(context);
    super.initState();
  }

  Future getLeaveBalanceDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("getLeaveBalanceDetails");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await pref.getUsername(),
    };
    hrmsEmployeeId = (await pref.getUsername())!;
    empname = (await pref.getEmployeeName())!;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    setState(() {
      clbal = leave_balance_status_check(responseJSON['cl_balance'].toString());
      rhbal = leave_balance_status_check(responseJSON['rh_balance'].toString());
      lapbal =
          leave_balance_status_check(responseJSON['lap_balance'].toString());
      DateTime now =
          DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
      currentdatetimestamp = DateFormat('yyyy-MM-dd hh:mm:ss a').format(now);

      print('currnet $currentdatetimestamp');
      lhapbal =
          leave_balance_status_check(responseJSON['lhap_balance'].toString());
      cclbal =
          leave_balance_status_check(responseJSON['ccl_balance'].toString());
    });
  }

  Widget LeaveBalanceContainer() {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (event) {
        sessionCheck.startTimer(context);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.blue)),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Text(
            empname,
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xF5043F8A),
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  'HRMS ID : ' + hrmsEmployeeId ?? "Not Available",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xF5043F8A),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          //Divider(color: Colors.grey),
          SizedBox(
            height: 15,
          ),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  'As On : ' + currentdatetimestamp,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xF5043F8A),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                row("CL", clbal),
                Divider(color: Colors.grey,),
                row("LAP", lapbal),
                Divider(color: Colors.grey,),
                row("LHAP", lhapbal),
                Divider(color: Colors.grey,),
                row("CCL", cclbal),
                Divider(color: Colors.grey,),
                row("RH", rhbal),
                Divider(color: Colors.grey,),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Row row(String typeOfLeave, String leaveBal) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              height: 14,
              margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: Text(
                typeOfLeave,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              )),
        ),
        Expanded(
          child: Text(leaveBal.toString(),
              textAlign: TextAlign.right, style: TextStyle(fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800])),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("My Leave Balances",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                LeaveBalanceContainer(),
          ],
        )),
      ),
    );
  }
}
