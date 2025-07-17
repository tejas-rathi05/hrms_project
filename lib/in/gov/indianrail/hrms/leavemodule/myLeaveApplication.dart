import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/leavemodule/LeaveUtil/PastSanctionedLeaveDetailsModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/leavemodule/viewLeaveAppliedDetails.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../util/session_check.dart';
import 'cancelLeaveApplication.dart';

class MyLeaveApplication extends StatefulWidget {
  var leaveType, leaveStatus, year;

  MyLeaveApplication(this.leaveType, this.leaveStatus, this.year);

  @override
  MyLeaveApplicationState createState() => MyLeaveApplicationState();
}

class MyLeaveApplicationState extends State<MyLeaveApplication> {
  late List<PastSanctionLeaveDetailsModel> _pastSanctionedInfo;
  int listsize = 0;
  var leaveTypes, noDays, leaveTo, leaveToFnAn;
  bool showCancelVisibility = false;
  bool showWithdrawVisibility = false;
  SessionCheck sessionCheck=  SessionCheck();

  @override
  void initState() {
    getMyLeaveDetails();
    sessionCheck.startTimer(context);
    super.initState();
  }

  Future getMyLeaveDetails() async {

    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("fetch_my_leave_details");
    print("url $url");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    String _leaveType = "";
    String _leaveStatus = "";
    if (widget.leaveType == '' || widget.leaveType == null) {
      _leaveType = 'ALL';
    } else {
      _leaveType = widget.leaveType;
    }
    if (widget.leaveStatus == '' || widget.leaveStatus == null) {
      _leaveStatus = 'ALL';
    } else {
      _leaveStatus = widget.leaveStatus;
    }
    Map map = {
      "hrmsId": await pref.getUsername(),
      "leaveType": _leaveType,
      "year": widget.year,
      "leaveStatus": _leaveStatus
    };
    print('map $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON $responseJSON');

    setState(() {
      var pastLeaveDetails = responseJSON["myLeaveDetails"] as List;
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
            title: Text("My Leave Applications",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                SizedBox(
                  height: 10,
                ),
                Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Year : ' + widget.year,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xF5043F8A),
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                //Divider(color: Colors.grey),
                SizedBox(
                  height: 5,
                ),
                Container(
                    height: MediaQuery.of(context).size.height*.8,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5,0,5,0),
                      child: ListView.builder(
                        // current the spelling of length here
                        shrinkWrap: true,
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
                          String pendingWith="";
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

                          List<String> mdy1 = _pastSanctionedInfo[index]
                              .leave_from
                              .toString()
                              .split('-');

                          DateTime fromDate = DateTime(int.parse(mdy1[0]),
                              int.parse(mdy1[1]), int.parse(mdy1[2]));

                          DateTime currentDate = DateTime.now();

                          currentDate = DateTime(currentDate.year,
                              currentDate.month, currentDate.day);
                          var canWithdraw=false;

                          if(currentDate.isBefore(fromDate))
                          {
                            print('current Date Check $currentDate');
                            canWithdraw = true;
                          }
                          var _daysDiff =
                          (currentDate.difference(fromDate).inMilliseconds / (1000 * 60 * 60 * 24))
                              .round();
                          print('daysDiff New $_daysDiff');
                          if(_daysDiff>30){
                            showCancelVisibility=false;
                          }


                          if ((_pastSanctionedInfo[index].leave_status == "A" ||
                                  _pastSanctionedInfo[index].leave_status == "F") &&
                              _pastSanctionedInfo[index].leave_mode == 'O') {
                            if(canWithdraw){
                              showWithdrawVisibility = true;
                            }else{
                              showWithdrawVisibility = false;
                            }
                          }else
                            {
                              showWithdrawVisibility = false;
                            }
                          if (_pastSanctionedInfo[index].leave_status == "S" &&
                              _pastSanctionedInfo[index].leave_mode == 'O' &&
                              _pastSanctionedInfo[index].leave_type != 'JTLAP' &&
                              _pastSanctionedInfo[index].leave_type != 'COL' &&
                              _pastSanctionedInfo[index].leave_type2 != 'COL' &&
                              _pastSanctionedInfo[index].leave_type3 != 'COL' &&
                              _pastSanctionedInfo[index].encashment_applied_flag!='Y') {
                            //show Cancel Option if LeaveDate is after submission Date and Leave is sanctioned
                            showCancelVisibility = true;
                            /*if (fromDate.isAfter(currentDate)) {
                              showCancelVisibility = true;
                            } else {
                              showCancelVisibility = false;
                            }*/
                          }else
                            {
                              showCancelVisibility = false;
                            }
                          if (_pastSanctionedInfo[index].leave_status == "A") {
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#FF8C00".replaceAll("#", "0xFF")));
                          } else if (_pastSanctionedInfo[index].leave_status =="S") {
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#089673".replaceAll("#", "0xFF")));
                          }else if (_pastSanctionedInfo[index].leave_status =="CP") {
                            showCancelVisibility = false;
                            showWithdrawVisibility = false;
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#089673".replaceAll("#", "0xFF")));
                          } else if (_pastSanctionedInfo[index].leave_status =="R"||
                              _pastSanctionedInfo[index].leave_status =="FCR"||
                              _pastSanctionedInfo[index].leave_status =="PCR"||
                              _pastSanctionedInfo[index].leave_status =="C") {
                            showCancelVisibility = false;
                            showWithdrawVisibility = false;
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#FA1E25".replaceAll("#", "0xFF")));
                          } else if (_pastSanctionedInfo[index].leave_status ==
                              "W") {
                            showCancelVisibility = false;
                            showWithdrawVisibility = false;
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#68478D".replaceAll("#", "0xFF")));
                          } else if (_pastSanctionedInfo[index].leave_status =="PCS"||
                              _pastSanctionedInfo[index].leave_status=="FCS" ||
                              _pastSanctionedInfo[index].leave_status=="PS" ) {
                            showCancelVisibility = false;
                            showWithdrawVisibility = false;
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#415A9E".replaceAll("#", "0xFF")));
                          }
                          else if (_pastSanctionedInfo[index].leave_status =="FCF"||
                              _pastSanctionedInfo[index].leave_status=="PCF") {
                            showCancelVisibility = false;
                            showWithdrawVisibility = false;
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#000000".replaceAll("#", "0xFF")));
                          }
                          else if (_pastSanctionedInfo[index].leave_status =="FCA"||
                              _pastSanctionedInfo[index].leave_status=="PCA") {
                            showCancelVisibility = false;
                            showWithdrawVisibility = false;
                            leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                            color =
                                Color(int.parse("#000000".replaceAll("#", "0xFF")));
                          }else
                            {
                              leaveStatus = leaveStatusDescription(_pastSanctionedInfo[index].leave_status);
                              color =
                                  Color(int.parse("#000000".replaceAll("#", "0xFF")));
                            }
                          if (_pastSanctionedInfo[index]
                              .pending_with!=null) {
                            pendingWith = _pastSanctionedInfo[index]
                                    .pendingWithName
                                    .toString() +
                                ' (' +
                                _pastSanctionedInfo[index].pending_with.toString() +
                                ') ' +
                                _pastSanctionedInfo[index]
                                    .pendingWithDesignation
                                    .toString();
                          } else {
                            pendingWith = 'NA';
                          }


                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 4.0,
                            margin: EdgeInsets.all(8),
                            child: ClipPath(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: Colors.lightBlueAccent, width: 5))),
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          /*decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(
                                                0), // Half of the width/height
                                          ),*/
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            leaveStatus,
                                            style: TextStyle(
                                                color: color,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        ExpansionTile(
                                          tilePadding:
                                              EdgeInsets.fromLTRB(10, 0, 15, 0),
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
                                                fontSize: 12,
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
                                            buildContainer(index, 'HQ Leave From:',
                                                formattedHqLeaveFrom),
                                            buildContainer(index, 'HQ Leave Upto:',
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
                                            buildContainer(
                                                  index, 'Pending With:', pendingWith),

                                          ],
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(
                                                  3), // Half of the width/height
                                                ),
                                              padding: EdgeInsets.all(8),
                                              child: GestureDetector(
                                                onTap: () {
                                                /*_viewLeaveApplication(
                                                    context,
                                                    _pastSanctionedInfo[
                                                    index]);*/
                                                  Route route = MaterialPageRoute(
                                                      builder: (context) => ViewLeaveApplication(
                                                          _pastSanctionedInfo[
                                                          index].leave_id));
                                                  Navigator.push(context, route);
                                                },
                                                child: Text(
                                                  ' View ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Visibility(
                                              visible: showWithdrawVisibility,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepOrange,
                                                  borderRadius: BorderRadius.circular(
                                                      3), // Half of the width/height
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType.confirm,
                                                        text:
                                                            'Do you want to withdraw Leave application',
                                                        confirmBtnText: 'Yes',
                                                        cancelBtnText: 'No',
                                                        confirmBtnColor: Colors.green,
                                                        onConfirmBtnTap: () {
                                                          _withdrawLeaveApplication(
                                                              context,
                                                              _pastSanctionedInfo[
                                                                  index]);
                                                        } // Call the API when user confirms
                                                        );
                                                  },
                                                  child: Text(
                                                    'Withdraw',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: showCancelVisibility,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(
                                                      3), // Half of the width/height
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    Route route = MaterialPageRoute(
                                                        builder: (context) => MyCancelLeaveApplication(
                                                            _pastSanctionedInfo[
                                                            index].leave_id));
                                                    Navigator.push(context, route);

                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
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
                              ),
                              clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _withdrawLeaveApplication(BuildContext context,
      PastSanctionLeaveDetailsModel pastSanctionedInfo) async {
    // Perform your API call for logging out here
    final String url =
        new UtilsFromHelper().getValueFromKey("withdraw_leave_application");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "leaveId": await pastSanctionedInfo.leave_id.toString(),
    };
    print('map withdraw leave application--> $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON --> $responseJSON');

    setState(() {
      if (responseJSON['result'] == true) {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0);
        setState(() {
          getMyLeaveDetails();
        });
      } else {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    });
    Navigator.of(context).pop();
  }

  String leaveStatusDescription(status){
    var desc='';
    switch(status){
      case  'A'  :  desc='LEAVE APPLIED';   break;
      case  'F' :   desc='LEAVE FORWARDED';   break;
      case  'R' :   desc='LEAVE REJECTED';   break;
      case  'S' :   desc='LEAVE SANCTIONED';   break;
      case  'FCA' :  desc='CANCELLATION APPLIED';   break;
      case  'PCA' :  desc='CANCELLATION APPLIED';   break;
      case  'FCF' :  desc='CANCELLATION FORWARDED';   break;
      case  'PCF' :  desc='CANCELLATION FORWARDED';   break;
      case  'FCS' :  desc='CANCELLATION APPROVED';   break;
      case  'PCS' :  desc='CANCELLATION APPROVED';   break;
      case  'FCR' :  desc='CANCELLATION REJECTED';   break;
      case  'PCR' :  desc='CANCELLATION REJECTED';   break;
      case  'PS' :  desc='PARTIALLY SANCTIONED';   break;
      case  'CP':    desc='LEAVE SANCTIONED';   break;
      case  'C':    desc='LEAVE CANCELLED';   break;
      case  'W':    desc='WITHDRAWN';   break;
      default    :  desc= "New";
    }
    return desc;
  }

  Container buildContainer(int index, String titleText, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
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
