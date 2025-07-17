import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';

import '../util/session_check.dart';

class ViewLeaveApplication extends StatefulWidget {
  var _leaveId;

  ViewLeaveApplication(this._leaveId);

  @override
  ViewLeaveApplicationState createState() => ViewLeaveApplicationState();
}

class ViewLeaveApplicationState extends State<ViewLeaveApplication> {
  String empType = "";
  String _hrmsEmployeeId = "";
  String _employeeName = "";
  String _employeeDepartment = "";
  String _employeeDesignation = "";
  String _employeeRailwayUnit = "";
  String _employeeZone = "";
  String _lienUnit = "";
  String _dateOfJoining = "";
  String _retirementDate = "";
  String _sanctionOn = "";
  String _leaveType1 = "";
  String _leaveType1Name = "";
  String _leaveFrom1 = "";
  String _leaveTo1 = "";
  String _noOfDays1 = "";
  String _leaveMode = "";
  String _leaveType2 = "";
  String _leaveType2Name = "";
  String _leaveFrom2 = "";
  String _leaveFrom2FNAN = "FN";
  String _leaveTo2 = "";
  String _leaveTo2FNAN = "AN";
  String _noOfDays2 = "";
  String _leaveType3 = "";
  String _leaveType3Name = "";
  String _leaveFrom3 = "";
  String _leaveFrom3FNAN = "FN";
  String _leaveTo3 = "";
  String _leaveTo3FNAN = "AN";
  String _noOfDays3 = "";
  String _hqLeave = "";
  String _hqLeaveFrom = "";
  String _hqLeaveTo = "";
  String _hqLeaveFromFNAN = "";
  String _hqLeaveToFNAN = "";
  String _exLeave = "";
  String _exLeaveFrom = "";
  String _exLeaveTo = "";
  String _exLeaveFromFNAN = "";
  String _exLeaveToFNAN = "";

  String _leavePeriodAddress = "";
  String _reasonForLeave = "";
  String _appliedOn = "";
  String _supportingDoc = "";
  String _leaveStatus = "";
  Color _leaveStatusColor = Colors.black;
  String _weeklyOffDaysLabel = "";
  String _holidaysLabel = "";
  String path = "";
  String _sanctionedAuthorityName = "";
  String _sanctionedAuthorityDesignation = "";
  String _sanctionedAuthorityDepartment = "";
  String _sanctionedAuthorityHrmsId = "";
  String _pendingWith = "";
  String _sanctionedBy = "";
  String _leaveBalCal = "";
  String _leaveBalCal2 = "";
  String _leaveBalCal3 = "";
  String _leaveFromFNAN = "";
  String _leaveToFNAN = "";
  bool _isLeaveModeVisibility = false;
  bool _isLeave2Visibility = false;
  bool _isLeave3Visibility = false;
  bool _isLoading = true;
  bool _isLeave2DescVisibility = false;
  bool _isLeave3DescVisibility = false;
  bool _interveningUpdateDetailsView = false;
  bool _hqLeaveFromUptoVisibility = false;
  bool _exLeaveFromUptoVisibility = false;
  bool _leavePeriodAddressVisibility = false;
  bool _supportingDocVisibility = false;
  bool _sanctionedFinalizedByVisibility = false;
  bool _exIndiaLeaveVisibility= false;
  late Directory directory;
  SessionCheck sessionCheck=  SessionCheck();

  @override
  void initState() {
    _getLeaveDetailsList(widget._leaveId.toString());
    _getPath();
    _fetchNpsDetails().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    sessionCheck.startTimer(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _fetchNpsDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    empType = (await pref.get_nps_flag())!;
    if (empType == 'Y') {
      empType = "Regular in NPS Schema";
    } else {
      empType = "Regular in PF Schema";
    }
    setState(() {
      empType = empType;
    });
  }

  Future _getLeaveDetailsList(String leaveId) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("fetch_leave_details_to_view");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "leaveId": await leaveId.toString(),
    };
    print('Map Leave $map');
    print('url Leave $url');
    _hrmsEmployeeId = (await pref.getUsername())!;
    _employeeName = (await pref.getEmployeeName())!;
    _employeeDepartment = (await pref.getEmployeeDept())!;
    _employeeDesignation = (await pref.getEmployeeDesig())!;
    _employeeRailwayUnit = (await pref.getEmployeeUnitcode())!;
    _employeeZone = (await pref.getEmployeeRailwayzone())!;

    _lienUnit = (await pref.getEmployeeLienUnit())!;
    _dateOfJoining = (await pref.getEmployeeAppointmentDate())!;
    _dateOfJoining =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(_dateOfJoining));
    _retirementDate = (await pref.getRetirementDate())!;
    _retirementDate =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(_retirementDate));

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON $responseJSON');
    if (responseJSON['viewFetchLeaveList'].containsKey('pending_with')) {
      _sanctionedFinalizedByVisibility = false;
      await _getEmployeeNameByHrmsId(
          responseJSON['viewFetchLeaveList']['pending_with'].toString());
      print('_sanctionedBy $_sanctionedBy');
      print('_pending $_pendingWith');
      setState(() {
        _sanctionedBy = '--';
      });
    }
    if (responseJSON['viewFetchLeaveList'].containsKey('sanctioned_by')) {
      _sanctionedFinalizedByVisibility = true;

      await _getEmployeeNameByHrmsId(
          responseJSON['viewFetchLeaveList']['sanctioned_by'].toString());
      print('as ${responseJSON['viewFetchLeaveList']['sanctioned_date']}');
      setState(() {
        _sanctionOn = responseJSON['viewFetchLeaveList']['sanctioned_date']
            .toString();
        print('sansna');
        _pendingWith = '--';
      });
    }
    setState(() {
      _leaveType1 = responseJSON['viewFetchLeaveList']['leave_type'];
      print('_leaveType1 $_leaveType1');
      _leaveType1Name = responseJSON['viewFetchLeaveList']['leave_type_name'];
      _leaveBalCal =
          responseJSON['viewFetchLeaveList']['current_leave_bal'].toString()!='null'?responseJSON['viewFetchLeaveList']['current_leave_bal'].toString():'--';
      //_leavePeriodAddress = responseJSON['viewFetchLeaveList']['leave_period_address'];
      _leaveFrom1 = (DateFormat('dd/MM/yyyy').format(
              DateTime.parse(responseJSON['viewFetchLeaveList']['leave_from'])))
          .toString();
      _leaveFromFNAN = responseJSON['viewFetchLeaveList']['leave_from_fn_an'];
      _leaveTo1 = (DateFormat('dd/MM/yyyy').format(
              DateTime.parse(responseJSON['viewFetchLeaveList']['leave_to'])))
          .toString();
      _leaveToFNAN = responseJSON['viewFetchLeaveList']['leave_to_fn_an'];
      _noOfDays1 =
          responseJSON['viewFetchLeaveList']['number_of_days'].toString();
      _leaveMode = responseJSON['viewFetchLeaveList']['leave_mode'].toString();
      if (_leaveMode == 'O') {
        _isLeaveModeVisibility = true;
        _leaveMode = 'ONLINE';
      } else if (_leaveMode == 'M') {
        _isLeaveModeVisibility = true;
        _leaveMode = 'MANUAL';
      } else {
        _isLeaveModeVisibility = false;
      }
      if (responseJSON['viewFetchLeaveList'].containsKey('weekly_off_days')) {
        if (responseJSON['viewFetchLeaveList']['weekly_off_days'] != null ||
            responseJSON['viewFetchLeaveList']['break_holidays'] != null) {
          _interveningUpdateDetailsView = true;
          _weeklyOffDaysLabel =
              responseJSON['viewFetchLeaveList']['weekly_off_days'];
          _holidaysLabel = responseJSON['viewFetchLeaveList']['break_holidays'];
        } else {
          _interveningUpdateDetailsView = false;
        }
      }
      if (responseJSON['viewFetchLeaveList'].containsKey('hq_leave')) {
        _hqLeave = responseJSON['viewFetchLeaveList']['hq_leave'];
        if (_hqLeave == 'Y') {
          _hqLeave = 'YES';
          _hqLeaveFromUptoVisibility = true;
          _exIndiaLeaveVisibility=true;
          _hqLeaveFrom = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                  responseJSON['viewFetchLeaveList']['hq_leave_from'])))
              .toString();
          _hqLeaveFromFNAN =
              responseJSON['viewFetchLeaveList']['hq_leave_from_time'];
          _hqLeaveTo = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                  responseJSON['viewFetchLeaveList']['hq_leave_to'])))
              .toString();
          _hqLeaveToFNAN =
              responseJSON['viewFetchLeaveList']['hq_leave_to_time'];
        } else {
          _hqLeave = 'NO';
          _hqLeaveFromUptoVisibility = false;
          _exIndiaLeaveVisibility= false;
        }
      }else
        {
          _hqLeave = 'NO';
          _exIndiaLeaveVisibility=false;
        }
      if (responseJSON['viewFetchLeaveList'].containsKey('ex_india_leave')) {

        _exLeave = responseJSON['viewFetchLeaveList']['ex_india_leave'];
        if (_exLeave == 'Y') {
          _exLeave = 'YES';
          _exLeaveFromUptoVisibility = true;
          _exLeaveFrom = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                  responseJSON['viewFetchLeaveList']['ex_india_leave_from'])))
              .toString();
          _exLeaveFromFNAN =
              responseJSON['viewFetchLeaveList']['ex_india_leave_from_fn_an'];
          _exLeaveTo = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                  responseJSON['viewFetchLeaveList']['ex_india_leave_to'])))
              .toString();
          _exLeaveToFNAN =
              responseJSON['viewFetchLeaveList']['ex_india_leave_to_fn_an'];
        } else {
          _exLeave = 'NO';
          _exLeaveFromUptoVisibility = false;
        }
      }
      _reasonForLeave = responseJSON['viewFetchLeaveList']['reason_for_leave'];
      _appliedOn =
              responseJSON['viewFetchLeaveList']['txn_timestamp']
          .toString();

      if (responseJSON['viewFetchLeaveList']
          .containsKey('leave_period_address')) {
        _leavePeriodAddressVisibility = true;
        _leavePeriodAddress =
            responseJSON['viewFetchLeaveList']['leave_period_address'];
      }
      if (responseJSON['viewFetchLeaveList'].containsKey('supporting_doc')) {
        _supportingDocVisibility = true;
        _supportingDoc = responseJSON['viewFetchLeaveList']['supporting_doc'];
      }
      if (responseJSON['viewFetchLeaveList'].containsKey('sanctioned_date')) {
        _sanctionOn =  responseJSON['viewFetchLeaveList']['sanctioned_date']
            .toString();
      }
      if (responseJSON['viewFetchLeaveList'].containsKey('leave_status')) {
        if (responseJSON['viewFetchLeaveList']['leave_status'] == 'S' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'CP' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'FCS' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'PCS' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'PS') {
          _leaveStatusColor = Colors.green;
          //Green
        } else if (responseJSON['viewFetchLeaveList']['leave_status'] == 'R' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'FCR' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'PCR' ||
            responseJSON['viewFetchLeaveList']['leave_status'] == 'C') {
          //red
          _leaveStatusColor = Colors.red;
        }
        _leaveStatus = leaveStatusDescription(
            responseJSON['viewFetchLeaveList']['leave_status']);
      }

      if (responseJSON['viewFetchLeaveList']['leave_from2'] != null) {
        _isLeave2DescVisibility = true;
        _isLeave2Visibility = true;
        _leaveType2 = responseJSON['viewFetchLeaveList']['leave_type2'];
        _leaveType2Name =
            responseJSON['viewFetchLeaveList']['leave_type_name2'];
        _leaveBalCal2 =
            responseJSON['viewFetchLeaveList']['current_leave_bal2'].toString();

        _leaveFrom2 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                responseJSON['viewFetchLeaveList']['leave_from2'])))
            .toString();
        _leaveFrom2FNAN =
            responseJSON['viewFetchLeaveList']['leave_from_fn_an2'];
        _leaveTo2 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                responseJSON['viewFetchLeaveList']['leave_to2'])))
            .toString();
        _leaveTo2FNAN = responseJSON['viewFetchLeaveList']['leave_to_fn_an2'];
        _noOfDays2 =
            responseJSON['viewFetchLeaveList']['number_of_days2'].toString();
      }
      if (responseJSON['viewFetchLeaveList']['leave_from3'] != null) {
        _isLeave3DescVisibility = true;
        _isLeave3Visibility = true;
        _leaveType3 = responseJSON['viewFetchLeaveList']['leave_type3'];
        _leaveType3Name =
            responseJSON['viewFetchLeaveList']['leave_type_name3'];
        _leaveBalCal3 =
            responseJSON['viewFetchLeaveList']['current_leave_bal3'].toString();

        _leaveFrom3 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                responseJSON['viewFetchLeaveList']['leave_from3'])))
            .toString();
        _leaveFrom3FNAN =
            responseJSON['viewFetchLeaveList']['leave_from_fn_an3'];
        _leaveTo3 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                responseJSON['viewFetchLeaveList']['leave_to3'])))
            .toString();
        _leaveTo3FNAN = responseJSON['viewFetchLeaveList']['leave_to_fn_an3'];
        _noOfDays3 =
            responseJSON['viewFetchLeaveList']['number_of_days3'].toString();
      }
    });
  }

  Future _getEmployeeNameByHrmsId(String SanctionedHrmsId) async {
    print('okay Button Pressed');
    final String url =
        new UtilsFromHelper().getValueFromKey("get_employee_name_by_hrms_id");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await SanctionedHrmsId,
    };
    print('url $url');
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
      _sanctionedAuthorityName = responseJSON['profile']['employeeName'];
      _sanctionedAuthorityDesignation =
          responseJSON['profile']['designationDescription'];
      _sanctionedAuthorityDepartment =
          responseJSON['profile']['departmentDescription'];
      _sanctionedAuthorityHrmsId = responseJSON['profile']['hrmsEmployeeId'];
      _pendingWith = _sanctionedAuthorityName +
          '( ' +
          _sanctionedAuthorityHrmsId +
          ' ),' +
          _sanctionedAuthorityDesignation +
          ',' +
          _sanctionedAuthorityDepartment;
      _sanctionedBy = _sanctionedAuthorityName +
          '( ' +
          _sanctionedAuthorityHrmsId +
          ' ),' +
          _sanctionedAuthorityDesignation +
          ',' +
          _sanctionedAuthorityDepartment;
      print('_sanctionedBy $_sanctionedBy');
    });
  }

  Future<void> _getPath() async {
    //path = await ExtStorage.getExternalStoragePublicDirectory(
    //  ExtStorage.DIRECTORY_DOWNLOADS);
    if(Platform.isAndroid) {
      Directory? externalStorageDirectory = await getExternalStorageDirectory();
      List<Directory>? externalStorageDirectories =
      await getExternalStorageDirectories();

      if (externalStorageDirectory != null) {
        print('External Storage Directory: ${externalStorageDirectory.path}');
      }

      if (externalStorageDirectories != null) {
        print('External Storage Directories:');
        for (Directory directory in externalStorageDirectories) {
          print(directory.path);
          path = directory.path;
        }
      }
    }
    else
    {// for ios
      await getApplicationDocumentsDirectory();
    }
    //print(check_offier);
  }

  Future downloadPdf(String _supportingDocPath) async {
    Fluttertoast.showToast(
        msg: "Processing, please wait…!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);
    final String url =
        new UtilsFromHelper().getValueFromKey("leave_file_download");

    Map map = {'file': _supportingDocPath};
    print('map $map');
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if(responseJSON['status']=='true') {
      String filepdf = responseJSON['fileString'];
      Fluttertoast.showToast(
          msg: responseJSON['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0);

      if (Platform.isAndroid) {
        try {
          _supportingDocPath=_supportingDocPath.substring(_supportingDocPath.lastIndexOf('/') + 1);
          print('_supportingDocPath $_supportingDocPath');
          await _write(filepdf, _supportingDocPath);
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Some error ocurred:" +
                  e.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0);
        }

        Fluttertoast.showToast(
            msg: "Downloaded Successfully:" +
                directory.path +
                '/${_supportingDocPath}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        _supportingDocPath=_supportingDocPath.substring(_supportingDocPath.lastIndexOf('/') + 1);
        _ioswrite(filepdf, _supportingDocPath);
        Fluttertoast.showToast(
            msg: "Downloaded Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }else{
      Fluttertoast.showToast(
          msg: 'Upload Document is not available',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  Future _write(String textmy, String _supportingDocPath) async {
    directory = await Directory('$path/HRMS').create(recursive: true);
    final File file = File('${directory.path}/${_supportingDocPath}');
    var base64str = base64.decode(textmy);
    print('_supportingDocPath $_supportingDocPath');

    await file.writeAsBytes(base64str);
    await OpenFilex.open('$path/HRMS/${_supportingDocPath}');
    Fluttertoast.showToast(
        msg: "Downloaded Successfully:" +
            directory.path +
            '/${_supportingDocPath}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  Future _ioswrite(String textmy, String _supportingDocPath) async {
    Directory directory = await getTemporaryDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final File file = File(directory.path + "/${_supportingDocPath}");
    print("Directory Path : $directory");
    print("Directory file : $file");
    var base64str = base64.decode(textmy);
    print(" $textmy");
    await file.writeAsBytes(base64str);
    var existsSync = file.existsSync();
    print("$existsSync");

    await OpenFilex.open(directory.path + "/${_supportingDocPath}");
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
            title: Text("View Leave Application",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        body: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator(), // Replace with your custom loading widget
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            //--- leave 1 Starts ---//
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  color: Colors.blue,
                                  child: Text(
                                    'Personal Details',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC8E6D6),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      buildLeaveRow('Leave ID',
                                          ': ' + widget._leaveId.toString()),
                                      SizedBox(height: 10),
                                      buildLeaveRow(
                                          'HRMS ID', ': ' + _hrmsEmployeeId),
                                      SizedBox(height: 10),
                                      buildLeaveRow(
                                          'Employee Name', ': ' + _employeeName),
                                      SizedBox(height: 10),
                                      buildLeaveRow('Designation ',
                                          ': ' + _employeeDesignation ?? '--'),
                                      SizedBox(height: 10),
                                      buildLeaveRow('Department',
                                          ': ' + _employeeDepartment),
                                      SizedBox(height: 10),
                                      buildLeaveRow(
                                          'Current Zone', ': ' + _employeeZone),
                                      SizedBox(height: 10),
                                      buildLeaveRow('Railway Unit',
                                          ': ' + _employeeRailwayUnit),
                                      SizedBox(height: 10),
                                      buildLeaveRow(
                                          'Employee Type ', ': ' + empType),
                                      SizedBox(height: 10),
                                      buildLeaveRow('Lien ', ': ' + _lienUnit),
                                      SizedBox(height: 10),
                                      buildLeaveRow('Date of Joining ',
                                          ': ' + _dateOfJoining),
                                      SizedBox(height: 10),
                                      buildLeaveRow('Date of Retirement ',
                                          ': ' + _retirementDate),
                                      SizedBox(height: 10),
                                      Visibility(
                                          visible: _isLeaveModeVisibility,
                                          child: buildLeaveRow(
                                              'Leave Mode ', ': ' + _leaveMode)),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  color: Colors.blue,
                                  child: Text(
                                    'Application Details',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFFEDCBA),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 5, left: 5, top: 5, right: 5),
                                        color: Colors.blue,
                                        child: Text(
                                          'Leave 1',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                            textAlign:TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Color(0XFFFFF8C2),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            buildLeaveRow(
                                                'Nature of Leave',
                                                ': ' +
                                                    _leaveType1Name +
                                                    ' (' +
                                                    _leaveType1 +
                                                    ')'),
                                            SizedBox(height: 10),
                                            buildLeaveRow(
                                                'Leave Balance (when applied)',
                                                ': ' + _leaveBalCal),
                                            SizedBox(height: 10),
                                            buildLeaveRow(
                                                'Leave From ',
                                                ': ' +
                                                    _leaveFrom1 +
                                                    ' (' +
                                                    _leaveFromFNAN +
                                                    ')'),
                                            SizedBox(height: 10),
                                            buildLeaveRow(
                                                'Leave UpTo ',
                                                ': ' +
                                                    _leaveTo1 +
                                                    ' (' +
                                                    _leaveToFNAN +
                                                    ')'),
                                            SizedBox(height: 10),
                                            buildLeaveRow('No. of Days Applied',
                                                ': ' + _noOfDays1),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                      //--- leave 1 Ends ---//
                                      SizedBox(height: 10),
                                      Visibility(
                                        visible: _isLeave2DescVisibility,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: 5,
                                              left: 5,
                                              top: 5,
                                              right: 5),
                                          color: Colors.blue,
                                          child: Text(
                                            'Leave 2',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _isLeave2Visibility,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFFFF8C2),
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Nature of Leave',
                                                  ': ' +
                                                      _leaveType2Name +
                                                      ' (' +
                                                      _leaveType2 +
                                                      ')'),
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Leave Balance (when applied)',
                                                  ': ' + _leaveBalCal2),
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Leave From ',
                                                  ': ' +
                                                      _leaveFrom2 +
                                                      ' (' +
                                                      _leaveFrom2FNAN +
                                                      ')'),
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Leave UpTo ',
                                                  ': ' +
                                                      _leaveTo2 +
                                                      ' (' +
                                                      _leaveTo2FNAN +
                                                      ')'),
                                              SizedBox(height: 10),
                                              buildLeaveRow('No. of Days Applied',
                                                  ': ' + _noOfDays2),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //--- leave 2 Ends ---//
                                      SizedBox(height: 10),
                                      Visibility(
                                        visible: _isLeave3DescVisibility,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: 5,
                                              left: 5,
                                              top: 5,
                                              right: 5),
                                          color: Colors.blue,
                                          child: Text(
                                            'Leave 3',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _isLeave3Visibility,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFFFF8C2),
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Nature of Leave',
                                                  ': ' +
                                                      _leaveType3Name +
                                                      ' (' +
                                                      _leaveType3 +
                                                      ')'),
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Leave Balance (when applied)',
                                                  ': ' + _leaveBalCal3),
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Leave From ',
                                                  ': ' +
                                                      _leaveFrom3 +
                                                      ' (' +
                                                      _leaveFrom3FNAN +
                                                      ')'),
                                              SizedBox(height: 10),
                                              buildLeaveRow(
                                                  'Leave UpTo ',
                                                  ': ' +
                                                      _leaveTo3 +
                                                      ' (' +
                                                      _leaveTo3FNAN +
                                                      ')'),
                                              SizedBox(height: 10),
                                              buildLeaveRow('No. of Days Applied',
                                                  ': ' + _noOfDays3),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildLeaveRow('HQ Leave Applied',
                                                ': ' + _hqLeave),
                                            SizedBox(height: 10),
                                            Visibility(
                                              visible: _exIndiaLeaveVisibility,
                                              child: buildLeaveRow(
                                                  'Ex India Leave Applied',
                                                  ': ' + _exLeave),
                                            ),
                                            SizedBox(height: 10),
                                            Visibility(
                                              visible: _hqLeaveFromUptoVisibility,
                                              child: Column(
                                                children: [
                                                  buildLeaveRow(
                                                      'HQ Leave From ',
                                                      ': ' +
                                                          _hqLeaveFrom +
                                                          ' (' +
                                                          _hqLeaveFromFNAN +
                                                          ')'),
                                                  SizedBox(height: 10),
                                                  buildLeaveRow(
                                                      'HQ Leave UpTo ',
                                                      ': ' +
                                                          _hqLeaveTo +
                                                          ' (' +
                                                          _hqLeaveToFNAN +
                                                          ')'),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: _exLeaveFromUptoVisibility,
                                              child: Column(
                                                children: [
                                                  buildLeaveRow(
                                                      'Ex India Leave From ',
                                                      ': ' +
                                                          _exLeaveFrom +
                                                          ' (' +
                                                          _exLeaveFromFNAN +
                                                          ')'),
                                                  SizedBox(height: 10),
                                                  buildLeaveRow(
                                                      'Ex India Leave UpTo ',
                                                      ': ' +
                                                          _exLeaveTo +
                                                          ' (' +
                                                          _exLeaveToFNAN +
                                                          ')'),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                            buildLeaveRow('Reason For Leave',
                                                ': ' + _reasonForLeave),
                                            SizedBox(height: 10),
                                            buildLeaveRow(
                                                'Applied On', ': ' + _appliedOn),
                                            SizedBox(height: 10),
                                            Visibility(
                                                visible:
                                                    _leavePeriodAddressVisibility,
                                                child: buildLeaveRow('Address ',
                                                    ': ' + _leavePeriodAddress)),
                                            Visibility(
                                                visible: _supportingDocVisibility,
                                                child: buildLeaveViewDocumentRow(
                                                    'Supporting Document ', _supportingDoc)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //--- leave 3 Ends ---//
                              ],
                            ),
                            SizedBox(height: 8),
                            Visibility(
                              visible: _interveningUpdateDetailsView,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    color: Colors.blue,
                                    child: Text(
                                      'Intervening Period Details',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFF8F0DC),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Table(
                                                border: TableBorder.all(),
                                                columnWidths: const <int,
                                                    TableColumnWidth>{
                                                  0: FlexColumnWidth(1),
                                                  1: FlexColumnWidth(1),
                                                },
                                                children: [
                                                  TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              'Weekly Off Days',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text('Holidays',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            _weeklyOffDaysLabel,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors.red,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            _holidaysLabel,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors.red,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.blue,
                              child: Text(
                                'Leave Status',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0XFFF7E3EE),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  buildLeaveRow(
                                      'Pending With', ': ' + _pendingWith),
                                  SizedBox(height: 10),
                                  buildLeaveRow1('Leave Status',
                                      ': ' + _leaveStatus, _leaveStatusColor),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: _sanctionedFinalizedByVisibility,
                                    child: Column(
                                      children: [
                                        buildLeaveRow('Sanctioned/Finalized By',
                                            ': ' + _sanctionedBy),
                                        SizedBox(height: 10),
                                        buildLeaveRow(
                                            'Finalized On Date and Time ',
                                            ': ' + _sanctionOn),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String leaveStatusDescription(status) {
    var desc = '';
    switch (status) {
      case 'A':
        desc = 'LEAVE APPLIED';
        break;
      case 'F':
        desc = 'LEAVE FORWARDED';
        break;
      case 'R':
        desc = 'LEAVE REJECTED';
        break;
      case 'S':
        desc = 'LEAVE SANCTIONED';
        break;
      case 'FCA':
        desc = 'CANCELLATION APPLIED';
        break;
      case 'PCA':
        desc = 'CANCELLATION APPLIED';
        break;
      case 'FCF':
        desc = 'CANCELLATION FORWARDED';
        break;
      case 'PCF':
        desc = 'CANCELLATION FORWARDED';
        break;
      case 'FCS':
        desc = 'CANCELLATION APPROVED';
        break;
      case 'PCS':
        desc = 'CANCELLATION APPROVED';
        break;
      case 'FCR':
        desc = 'CANCELLATION REJECTED';
        break;
      case 'PCR':
        desc = 'CANCELLATION REJECTED';
        break;
      case 'PS':
        desc = 'PARTIALLY SANCTIONED';
        break;
      case 'CP':
        desc = 'LEAVE SANCTIONED';
        break;
      case 'C':
        desc = 'LEAVE CANCELLED';
        break;
      case 'W':
        desc = 'WITHDRAWN';
        break;
      default:
        desc = "New";
    }
    return desc;
  }

  Row buildLeaveRow(String _textDescription, String _textValue) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              _textDescription,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12),
            ),
          ),
        ),
        Expanded(
          child: Text(
            _textValue,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Row buildLeaveViewDocumentRow(String _textDescription, String _textValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            child: Text(
              _textDescription,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              children: [
                new IconButton(
                  icon: new Icon(Icons.picture_as_pdf, color: Colors.red),
                  onPressed: () {
                    bool fileexist =
                        File('$path/HRMS/${_supportingDoc}').existsSync();
                    if (fileexist) {
                      OpenFilex.open('$path/HRMS/${_supportingDoc}');
                    } else {
                      downloadPdf(_textValue);
                    }
                  },
                ),
                Container(
                  child: new TextButton(
                    onPressed: () {
                      bool fileexist =
                          File('$path/HRMS/${_supportingDoc}').existsSync();
                      if (fileexist) {
                        OpenFilex.open('$path/HRMS/${_supportingDoc}');
                      } else {
                        downloadPdf(_textValue);
                      }
                    },
                    child: Text(
                      'view document',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildLeaveRow1(
      String _textDescription, String _textValue, Color _textColor) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              _textDescription,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12),
            ),
          ),
        ),
        Expanded(
          child: Text(
            _textValue,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: _textColor, fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
