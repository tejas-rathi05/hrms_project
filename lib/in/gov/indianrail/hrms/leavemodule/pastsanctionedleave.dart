import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/leavemodule/LeaveUtil/PastSanctionedLeaveDetailsModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/session_check.dart';
import 'package:intl/intl.dart';

class PastSanctionedLeaveDetails extends StatefulWidget {
  @override
  PastSanctionedLeaveDetailsState createState() =>
      PastSanctionedLeaveDetailsState();
}

class PastSanctionedLeaveDetailsState
    extends State<PastSanctionedLeaveDetails> {
  late List<PastSanctionLeaveDetailsModel> _pastSanctionedInfo;
  int listsize = 0;
  var leaveTypes, noDays, leaveTo, leaveToFnAn;
  SessionCheck sessionCheck=  SessionCheck();

  @override
  void initState() {
    getPastSanctionedLeaveDetails();
    sessionCheck.startTimer(context);
    super.initState();
  }

  Future getPastSanctionedLeaveDetails() async {
    print("Hihgh");
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper()
        .getValueFromKey("show_past_sanction_leave_details");
    print("url $url");
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
    //try {
    print('response $response');
    setState(() {
      var pastLeaveDetails = responseJSON["leaveHistoryDetailsList"] as List;
      print('data: $pastLeaveDetails');
      _pastSanctionedInfo = pastLeaveDetails
          .map<PastSanctionLeaveDetailsModel>(
              (json) => PastSanctionLeaveDetailsModel.fromJson(json))
          .toList();
      listsize = _pastSanctionedInfo.length;
      print('_pastSanctionedInfo: $_pastSanctionedInfo');
      print('listsize: $listsize');

      if (_pastSanctionedInfo.length == 0) {
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

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (event) {
        sessionCheck.startTimer(context);
      },
      child: Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.lightBlueAccent,
            title: Text("View Past Sanctioned Leave Details",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(16.0,16.0,16.0, 0),
                  child: Text(
                    "Leave History of the Employee for last 1 year",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xF5043F8A),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,10,0),
                  child: Container(
                      height: MediaQuery.of(context).size.height*.8,
                      child: ListView.builder(
                        // current the spelling of length here
                        itemCount: listsize,
                        itemBuilder: (context, index) {
                          var leaveTypes = _pastSanctionedInfo[index].leave_type;
                          var noDays = double.parse(
                              _pastSanctionedInfo[index].number_of_days.toString());
                          var leaveTo = _pastSanctionedInfo[index].leave_to;
                          var leaveToFnAn =
                              _pastSanctionedInfo[index].leave_to_fn_an;
                          String leaveStatus = "";
                          Color color =
                              Color(int.parse("#FFFF00".replaceAll("#", "0x")));
                          if (_pastSanctionedInfo[index].number_of_days2 != null) {
                            leaveTypes = leaveTypes! +
                                ", " +
                                _pastSanctionedInfo[index].leave_type2.toString();
                            noDays = noDays +
                                double.parse(_pastSanctionedInfo[index]
                                    .number_of_days2
                                    .toString());
                            leaveTo = _pastSanctionedInfo[index].leave_to2;
                            leaveToFnAn =
                                _pastSanctionedInfo[index].leave_to_fn_an2;
                          }

                          if (_pastSanctionedInfo[index].number_of_days3 != null) {
                            leaveTypes = leaveTypes! +
                                ", " +
                                _pastSanctionedInfo[index].leave_type3.toString();
                            noDays = noDays +
                                double.parse(_pastSanctionedInfo[index]
                                    .number_of_days3
                                    .toString());
                            leaveTo = _pastSanctionedInfo[index].leave_to3;
                            leaveToFnAn =
                                _pastSanctionedInfo[index].leave_to_fn_an3;
                          }
                          String formattedHqLeaveFrom = "";
                          String formattedHqLeaveUpto = "";
                          String formattedExLeaveFrom = "";
                          String formattedExLeaveUpto = "";
                          String formattedLeaveFrom =
                              (_pastSanctionedInfo[index].leave_from != null
                                      ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(_pastSanctionedInfo[index]
                                              .leave_from
                                              .toString()))
                                      : '') +
                                  ' ' +
                                  _pastSanctionedInfo[index]
                                      .leave_from_fn_an
                                      .toString();
                          String formattedLeaveUpto = (leaveTo != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(DateTime.parse(leaveTo))
                                  : '') +
                              ' ' +
                              leaveToFnAn!;
                          if (_pastSanctionedInfo[index].hq_leave.toString() == 'Y')
                            formattedHqLeaveFrom =
                                (_pastSanctionedInfo[index].hq_leave_from != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(
                                                DateTime.parse(
                                                    _pastSanctionedInfo[index]
                                                        .hq_leave_from
                                                        .toString()))
                                        : '') +
                                    ' ' +
                                    _pastSanctionedInfo[index]
                                        .hq_leave_from_time
                                        .toString();
                          else
                            formattedHqLeaveFrom = "NA";
                          if (_pastSanctionedInfo[index].hq_leave.toString() == 'Y')
                            formattedHqLeaveUpto =
                                (_pastSanctionedInfo[index].hq_leave_to != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                _pastSanctionedInfo[index]
                                                    .hq_leave_to
                                                    .toString()))
                                        : '') +
                                    ' ' +
                                    _pastSanctionedInfo[index]
                                        .hq_leave_to_time
                                        .toString();
                          else
                            formattedHqLeaveUpto = "NA";
                          if (_pastSanctionedInfo[index].ex_india_leave == 'Y')
                            formattedExLeaveFrom = (_pastSanctionedInfo[index]
                                            .ex_india_leave_from !=
                                        null
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(_pastSanctionedInfo[index]
                                            .ex_india_leave_from
                                            .toString()))
                                    : '') +
                                ' ' +
                                _pastSanctionedInfo[index]
                                    .ex_india_leave_from_fn_an
                                    .toString();
                          else
                            formattedExLeaveFrom = "NA";
                          if (_pastSanctionedInfo[index]
                                  .ex_india_leave
                                  .toString() ==
                              'Y')
                            formattedExLeaveUpto = (_pastSanctionedInfo[index]
                                            .ex_india_leave_to !=
                                        null
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(_pastSanctionedInfo[index]
                                            .ex_india_leave_to
                                            .toString()))
                                    : '') +
                                ' ' +
                                _pastSanctionedInfo[index]
                                    .ex_india_leave_to_fn_an
                                    .toString();
                          else
                            formattedExLeaveUpto = "NA";

                          print(_pastSanctionedInfo[index].leave_status);
                          if (_pastSanctionedInfo[index].leave_status == "A") {
                            leaveStatus = "LEAVE APPLIED";
                            color =
                                Color(int.parse("#FF8C00".replaceAll("#", "0xFF")));
                          } else if (_pastSanctionedInfo[index].leave_status ==
                                  "S" ||
                              _pastSanctionedInfo[index].leave_status == 'PS' ||
                              _pastSanctionedInfo[index].leave_status == 'CP') {
                            leaveStatus = "SANCTIONED";
                            color =
                                Color(int.parse("#089673".replaceAll("#", "0xFF")));
                            print('hi $color');
                          } else if (_pastSanctionedInfo[index].leave_status ==
                              "R") {
                            leaveStatus = "LEAVE REJECTED";
                            color =
                                Color(int.parse("#FA1E25".replaceAll("#", "0xFF")));
                          } else if (_pastSanctionedInfo[index].leave_status ==
                              "W") {
                            leaveStatus = "WITHDRAWN";
                            color =
                                Color(int.parse("#68478D".replaceAll("#", "0xFF")));
                          }
                          print('leaveStatus $leaveStatus');
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                            elevation: 3,
                            child: ClipPath(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: Colors.lightBlueAccent,
                                            width: 5))),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            /*decoration: BoxDecoration(
                                              color: color,
                                              borderRadius: BorderRadius.circular(
                                                  0), // Half of the width/height
                                            ),*/
                                            padding: EdgeInsets.fromLTRB(16,12,0,0),
                                            child: Text(
                                              leaveStatus,
                                              style: TextStyle(
                                                  color: Color(0xFF006400),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: ExpansionTile(
                                              backgroundColor: Color(0xFFFFFFE0),
                                              subtitle: Text(
                                                "No of Days: " + noDays.toString(),
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                              title: Text(
                                                leaveTypes.toString() + ' ( From:-' + formattedLeaveFrom + ' To:- ' + formattedLeaveUpto+ ' )',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                              children: [
                                                buildContainer(
                                                    index,
                                                    'Leave ID:',
                                                    _pastSanctionedInfo[index]
                                                        .leave_id
                                                        .toString()),
                                                buildContainer(
                                                    index,
                                                    'Employee Name (Hrms Id):',
                                                    _pastSanctionedInfo[index]
                                                            .employee_name +
                                                        ' ( ' +
                                                        _pastSanctionedInfo[index]
                                                            .hrms_employee_id +
                                                        ' )'),
                                                buildContainer(index, 'Leave From:',
                                                    formattedLeaveFrom),
                                                buildContainer(index, 'Leave Upto:',
                                                    formattedLeaveUpto),
                                                buildContainer(
                                                    index,
                                                    'HQ Leave Applied:',
                                                    _pastSanctionedInfo[index]
                                                                .hq_leave
                                                                .toString() ==
                                                            'Y'
                                                        ? "Yes"
                                                        : "No"),
                                                buildContainer(
                                                    index,
                                                    'HQ Leave From:',
                                                    formattedHqLeaveFrom),
                                                buildContainer(
                                                    index,
                                                    'HQ Leave Upto:',
                                                    formattedHqLeaveUpto),
                                                buildContainer(
                                                    index,
                                                    'Ex India Leave Applied:',
                                                    _pastSanctionedInfo[index]
                                                                .ex_india_leave
                                                                .toString() ==
                                                            'Y'
                                                        ? "Yes"
                                                        : "No"),
                                                buildContainer(
                                                    index,
                                                    'Ex India Leave From:',
                                                    formattedExLeaveFrom),
                                                buildContainer(
                                                    index,
                                                    'Ex India Leave Upto:',
                                                    formattedExLeaveUpto),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainer(int index, String titleText, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Text(
                  titleText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
