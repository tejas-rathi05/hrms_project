import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';

import '../util/session_check.dart';
import 'myLeaveApplicationFilter.dart';

class MyCancelLeaveApplication extends StatefulWidget {
  var _leaveCancelId;

  MyCancelLeaveApplication(this._leaveCancelId);

  @override
  MyCancelLeaveApplicationState createState() =>
      MyCancelLeaveApplicationState();
}

class MyCancelLeaveApplicationState extends State<MyCancelLeaveApplication> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List zonesList = [];
  String? _selectZone;
  List DivisionList = [];
  String? _selectDepartment;
  List departmentList = [];
  String? _selectSubDepartment;
  String? _selectPrimaryUnit;
  List subDepartmentList = [];
  String? _cancellationType = 'F';
  String _leaveBalCal = "";
  String _leaveBalCal2 = "";
  String _leaveBalCal3 = "";
  var _daysDiff;
  var _daysDiff2;
  var _daysDiff3;
  String _numberOfDays1 = "";
  String _numberOfDays2 = "";
  String _numberOfDays3 = "";
  bool _isLeaveFromFNANEnabled = false;
  bool _isLeaveFrom2FNANEnabled = false;
  bool _isLeave2DescVisibility = false;
  bool _isLeave2Visibility = false;
  bool _isLeaveFrom3FNANEnabled = false;
  bool _isLeave3DescVisibility = false;
  bool _isLeave3Visibility = false;
  String _leaveFromFNAN = "FN";
  bool _isLeaveToFNANEnabled = false;
  bool _isLeaveTo2FNANEnabled = false;
  bool _isLeaveTo3FNANEnabled = false;
  String _leaveToFNAN = "AN";
  String selectedAuthority = "";
  String zoneUnitDepartment = "";
  String? _ipAddress;
  List? _tempListOfForwardingAuthorities;
  List _listOfForwardingAuthorities = [];

  String _retirementDate = "";
  String? empType = "";
  String result = "";
  String _employeeName = "";
  String _hrmsEmployeeId = "";
  String _employeeDepartment = "";
  String _employeeRailwayUnit = "";
  String _employeeZone = "";
  String _previousLeaveId = "";
  String? frwdAuthoritiesHrmsId;
  String? selectedValues;
  bool _isLoading = true;
  bool _hasBeenPressedSubmit = false;
  String _sanctionOn = "";
  String _leaveType1 = "";
  String _leaveType1Name = "";
  String _leaveFrom1 = "";
  String _leaveTo1 = "";
  String _noOfDays1 = "";
  String _leaveType2 = "";
  String _leaveType2Name = "";
  String _leaveFrom2 = "";
  String _leaveFrom2FNAN = "FN";
  String _leaveFrom2FNANdesc = '';
  String _leaveTo2 = "";
  String _leaveTo2FNAN = "AN";
  String _leaveTo2FNANdesc = '';
  String _noOfDays2 = "";
  String _leaveType3 = "";
  String _leaveType3Name = "";
  String _leaveFrom3 = "";
  String _leaveFrom3FNAN = "FN";
  String _leaveFrom3FNANdesc = '';
  String _leaveTo3 = "";
  String _leaveTo3FNAN = "AN";
  String _leaveTo3FNANdesc = '';
  String _noOfDays3 = "";
  String _sanctionedAuthorityName = "";
  String _sanctionedAuthorityDesignation = "";
  String _sanctionedAuthorityDepartment = "";
  String _sanctionedAuthorityHrmsId = "";
  bool isCancellationTypeEnabled = false;
  bool isEnabled = false;
  String _lienUnit = '';
  String? _leavePeriodAddress;

  TextEditingController frwdAuthorityController = new TextEditingController();
  TextEditingController _leave1FromDate = TextEditingController();
  TextEditingController _leave1ToDate = TextEditingController();
  TextEditingController _leave2FromDate = TextEditingController();
  TextEditingController _leave2ToDate = TextEditingController();
  TextEditingController _leave3FromDate = TextEditingController();
  TextEditingController _leave3ToDate = TextEditingController();
  TextEditingController _reasonForLeave = TextEditingController();
  TextEditingController selectedItem = TextEditingController();

  SessionCheck sessionCheck=  SessionCheck();

  @override
  void initState() {
    _getLeaveDetailsList(widget._leaveCancelId.toString());
    _getAllZones();
    _getIP();
    _fetchNpsDetails();
    _getFrwAuthorities().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    sessionCheck.startTimer(context);
    super.initState();
  }

  @override
  void dispose() {
    _leave1FromDate.dispose();
    _leave1ToDate.dispose();
    selectedItem.dispose();
    super.dispose();
  }

  Future _getIP() async {
    NetworkInfo info = NetworkInfo();
    String? ipAddress = await info.getWifiIP();

    setState(() {
      _ipAddress = ipAddress; //info.getWifiIP() as String?;
    });
  }

  Future _getAllZones() async {
    await _getAllDepartments();
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("getAllZones");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value);
    String? zone = await pref.getEmployeeRailwayzone();
    String? primaryUnit = await pref.getEmployeeUnitcode();
    setState(() {
      _selectZone = zone!;
      _selectPrimaryUnit = primaryUnit!;
      if (responseJSON['code_unit'] != null) {
        zonesList = responseJSON['code_unit'];
      }
    });
    await _getAllPrimaryUnit("");
  }

  Future _getAllPrimaryUnit(String SelectedZone) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    if (SelectedZone == "")
      _selectZone = (await pref.getEmployeeRailwayzone())!;
    else
      _selectZone = SelectedZone;
    final String url =
        new UtilsFromHelper().getValueFromKey("getDivisionsByZones");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"railway_code": _selectZone};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value);

    setState(() {
      DivisionList = responseJSON['division'];
      _selectPrimaryUnit = DivisionList.first['code'];
    });
  }

  Future _getAllDepartments() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("getAllDepartments");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value);
    String? deptCode = await pref.getDepartmentCode();
    setState(() {
      _selectDepartment = deptCode!;
      departmentList = responseJSON['department'];
    });
  }

  Future _getAllSubDepartments(
      String _selectDepartment, String _selectPrimaryUnit) async {
    subDepartmentList.clear();
    final String url =
        new UtilsFromHelper().getValueFromKey("getSubDepartments");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "deptCode": _selectDepartment,
      "railwayUnit": _selectPrimaryUnit
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value);
    Map<String, dynamic> allSubDepart = {'description': 'All', 'code': ''};

    setState(() {
      if (responseJSON['sub_department'] != null) {
        subDepartmentList = responseJSON['sub_department'];
        subDepartmentList.add(allSubDepart);
        _selectSubDepartment = '';
      }
    });
  }

  Future _getFrwAuthorities() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    String? hrmsEmployeeId = await pref.getUsername();
    String? zone = await pref.getEmployeeRailwayzone();
    String? unitCode = await pref.getEmployeeUnitname();
    String? departmentDescription = await pref.getEmployeeDept();

    final String url = new UtilsFromHelper()
        .getValueFromKey("get_frwd_leave_authorities_list");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "unit": await pref.getEmployeeUnitcode(),
      "dept": await pref.getDepartmentCode(),
      "subDept": ""
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    setState(() {
      zoneUnitDepartment = zone.toString() +
          "- " +
          unitCode.toString() +
          "- " +
          departmentDescription.toString();
      for (int index = 0;
          index < responseJSON['authoritiesList'].length;
          index++) {
        if (responseJSON['authoritiesList'][index]['emp_hrms_id'] !=
            hrmsEmployeeId) {
          _listOfForwardingAuthorities.add(responseJSON['authoritiesList']
                  [index]['employee_name'] +
              ' (' +
              responseJSON['authoritiesList'][index]['emp_hrms_id'] +
              ') ' +
              responseJSON['authoritiesList'][index]['designation']);
        }
      }
    });
  }

  Future _fetchNpsDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    empType = await pref.get_nps_flag();
    if (empType == 'Y') {
      empType = "NP";
    } else {
      empType = "PF";
    }
    setState(() {
      empType = empType;
    });
  }

  Future _getFrwAuthoritiesBySearchRange() async {
    _listOfForwardingAuthorities.clear();
    sharedpreferencemanager pref = sharedpreferencemanager();
    String? hrmsEmployeeId = await pref.getUsername();

    final String url = new UtilsFromHelper()
        .getValueFromKey("get_frwd_leave_authorities_list");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "unit": _selectPrimaryUnit,
      "dept": _selectDepartment,
      "subDept": _selectSubDepartment
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    String _railwayUnitDesc = "";
    String _departmentDesc = "";
    String _subDepartmentDesc = "";
    for (var division in DivisionList) {
      if (division['code'] == _selectPrimaryUnit) {
        _railwayUnitDesc = division['description'];
      }
    }

    for (var depart in departmentList) {
      if (depart['code'].toString() == _selectDepartment) {
        _departmentDesc = depart['description'];
      }
    }
    for (var subdepart in subDepartmentList) {
      if (subdepart['code'].toString() == _selectSubDepartment) {
        _subDepartmentDesc = subdepart['description'];
      }
    }
    if (subDepartmentList.length == 0)
      _selectSubDepartment = "";
    else if (_selectSubDepartment == "") {
      _subDepartmentDesc = "- All Sub Department";
    } else
      _subDepartmentDesc = " - " + _subDepartmentDesc;
    setState(() {
      zoneUnitDepartment = _selectZone.toString() +
          " - " +
          _railwayUnitDesc +
          " - " +
          _departmentDesc +
          "" +
          _subDepartmentDesc;

      if (responseJSON['authoritiesList'] != null) {
        for (int index = 0;
            index < responseJSON['authoritiesList'].length;
            index++) {
          if (responseJSON['authoritiesList'][index]['emp_hrms_id'] !=
              hrmsEmployeeId) {
            _listOfForwardingAuthorities.add(responseJSON['authoritiesList']
                    [index]['employee_name'] +
                ' (' +
                responseJSON['authoritiesList'][index]['emp_hrms_id'] +
                ') ' +
                responseJSON['authoritiesList'][index]['designation']);
          }
        }
      }
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
    _hrmsEmployeeId = (await pref.getUsername())!;
    _employeeName = (await pref.getEmployeeName())!;
    _employeeDepartment = (await pref.getEmployeeDept())!;
    _employeeRailwayUnit = (await pref.getEmployeeUnitcode())!;
    _employeeZone = (await pref.getEmployeeRailwayzone())!;

    _lienUnit = (await pref.getEmployeeLienUnit())!;
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
    print('responseJSON12 $responseJSON');
    print('date ${responseJSON['viewFetchLeaveList']['sanctioned_date']}');
    await _getEmployeeNameByHrmsId(
        responseJSON['viewFetchLeaveList']['sanctioned_by'].toString());
    setState(() {
      _previousLeaveId =
          responseJSON['viewFetchLeaveList']['leave_id'].toString();
      _sanctionOn =
          responseJSON['viewFetchLeaveList']['sanctioned_date'].toString();
      _leaveType1 = responseJSON['viewFetchLeaveList']['leave_type'];
      _leaveType1Name = responseJSON['viewFetchLeaveList']['leave_type_name'];
      _leaveBalCal =
          responseJSON['viewFetchLeaveList']['current_leave_bal'].toString();
      _leavePeriodAddress =
          responseJSON['viewFetchLeaveList']['leave_period_address'];
      _leaveFrom1 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(responseJSON['viewFetchLeaveList']['leave_from'])))
          .toString();
      _leave1FromDate.text = _leaveFrom1;
      _leaveFromFNAN = responseJSON['viewFetchLeaveList']['leave_from_fn_an'];
      _leaveTo1 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(responseJSON['viewFetchLeaveList']['leave_to']))).toString();
      _leave1ToDate.text = _leaveTo1;
      _leaveToFNAN = responseJSON['viewFetchLeaveList']['leave_to_fn_an'];
      if (responseJSON['viewFetchLeaveList']['number_of_days'] > 1) {
        _noOfDays1 =
            responseJSON['viewFetchLeaveList']['number_of_days'].toString() +
                ' days';
        _numberOfDays1 = _noOfDays1;
      } else {
        _noOfDays1 =
            responseJSON['viewFetchLeaveList']['number_of_days'].toString() +
                ' day';
        _numberOfDays1 = _noOfDays1;
      }
      _daysDiff = responseJSON['viewFetchLeaveList']['number_of_days'];

      if (responseJSON['viewFetchLeaveList']['leave_from2'] != null) {
        _isLeave2DescVisibility = true;
        _isLeave2Visibility = true;
        _leaveType2 = responseJSON['viewFetchLeaveList']['leave_type2'];
        _leaveType2Name =
            responseJSON['viewFetchLeaveList']['leave_type_name2'];
        _leaveBalCal2 =
            responseJSON['viewFetchLeaveList']['current_leave_bal2'].toString();

        _leaveFrom2 =
            (DateFormat('dd/MM/yyyy').format(DateTime.parse(responseJSON['viewFetchLeaveList']['leave_from2']))).toString();
        _leave2FromDate.text = _leaveFrom2;
        _leaveFrom2FNAN =
            responseJSON['viewFetchLeaveList']['leave_from_fn_an2'];
        _leaveFrom2FNANdesc = _leaveFrom2FNAN;
        _leaveTo2 = (DateFormat('dd/MM/yyyy').format(DateTime.parse(responseJSON['viewFetchLeaveList']['leave_to2']))).toString();
        _leave2ToDate.text = _leaveTo2;
        _leaveTo2FNAN = responseJSON['viewFetchLeaveList']['leave_to_fn_an2'];
        _leaveTo2FNANdesc = _leaveTo2FNAN;
        if (responseJSON['viewFetchLeaveList']['number_of_days2'] > 1) {
          _noOfDays2 =
              responseJSON['viewFetchLeaveList']['number_of_days2'].toString() +
                  ' days';
          _numberOfDays2 = _noOfDays2;
        } else {
          _noOfDays2 =
              responseJSON['viewFetchLeaveList']['number_of_days2'].toString() +
                  ' day';
          _numberOfDays2 = _noOfDays2;
        }
        _daysDiff2 = responseJSON['viewFetchLeaveList']['number_of_days2'];
      }
      if (responseJSON['viewFetchLeaveList']['leave_from3'] != null) {
        _isLeave3DescVisibility = true;
        _isLeave3Visibility = true;
        _leaveType3 = responseJSON['viewFetchLeaveList']['leave_type3'];
        _leaveType3Name =
            responseJSON['viewFetchLeaveList']['leave_type_name3'];
        _leaveBalCal3 =
            responseJSON['viewFetchLeaveList']['current_leave_bal3'].toString();

        _leaveFrom3 =
        (DateFormat('dd/MM/yyyy').format(DateTime.parse(responseJSON['viewFetchLeaveList']['leave_from3']))).toString();
        _leave3FromDate.text =_leaveFrom3;
        _leaveFrom3FNAN =
            responseJSON['viewFetchLeaveList']['leave_from_fn_an3'];
        _leaveFrom3FNANdesc = _leaveFrom3FNAN;
        _leaveTo3 =(DateFormat('dd/MM/yyyy').format(DateTime.parse(responseJSON['viewFetchLeaveList']['leave_to3']))).toString();
        _leave3ToDate.text = _leaveTo3;
        _leaveTo3FNAN = responseJSON['viewFetchLeaveList']['leave_to_fn_an3'];
        _leaveTo3FNANdesc = _leaveTo3FNAN;
        if (responseJSON['viewFetchLeaveList']['number_of_days3'] > 1) {
          _noOfDays3 =
              responseJSON['viewFetchLeaveList']['number_of_days3'].toString() +
                  ' days';
          _numberOfDays3 = _noOfDays3;
        } else {
          _noOfDays3 =
              responseJSON['viewFetchLeaveList']['number_of_days3'].toString() +
                  ' day';
          _numberOfDays3 = _noOfDays3;
        }
        _daysDiff3 = responseJSON['viewFetchLeaveList']['number_of_days3'];
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
    print('map sacntioned HrmsId $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('employeeSanctioned $responseJSON');
    setState(() {
      _sanctionedAuthorityName = responseJSON['profile']['employeeName'];
      _sanctionedAuthorityDesignation =
          responseJSON['profile']['designationDescription'];
      _sanctionedAuthorityDepartment =
          responseJSON['profile']['departmentDescription'];
      _sanctionedAuthorityHrmsId = responseJSON['profile']['hrmsEmployeeId'];
    });
  }

  Future submitCancelLeaveApplication() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("cancel_leave_application");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    if (_leave2FromDate.text.isEmpty || _leave3FromDate.text.isEmpty) {
      _leaveFrom2FNANdesc = '';
      _leaveTo2FNANdesc = '';
      _leaveFrom3FNANdesc = '';
      _leaveTo3FNANdesc = '';
    }

    Map map = {
      "previousLeaveId": _previousLeaveId,
      "employeeHrmsId": await pref.getEmployeeHrmsid(),
      "employeeName": await pref.getEmployeeName(),
      "designationCode": await pref.getDesignationCode(),
      "departmentCode": await pref.getDepartmentCode(),
      "zoneId": await pref.getEmployeeRailwayzone(),
      "unitCode": await pref.getEmployeeUnitcode(),
      "empType": empType,
      "lienHeld": _lienUnit,
      "leaveType": _leaveType1,
      "leaveFrom": _leave1FromDate.text,
      "leaveFromFnAn": _leaveFromFNAN,
      "leaveTo": _leave1ToDate.text,
      "leaveToFnAn": _leaveToFNAN,
      "numberOfDays": _daysDiff,
      "reasonForLeave": _reasonForLeave.text,
      "leavePeriodAddress": _leavePeriodAddress,
      "frwAuthority": frwdAuthoritiesHrmsId,
      "userId": await pref.getEmployeeHrmsid(),
      "ipAddress": _ipAddress,
      "leaveType2": _leaveType2,
      "leaveFrom2": _leave2FromDate.text,
      "leaveFromFnAn2": _leaveFrom2FNANdesc,
      "leaveTo2": _leave2ToDate.text,
      "leaveToFnAn2": _leaveTo2FNANdesc,
      "numberOfDays2": _daysDiff2,
      "leaveType3": _leaveType3,
      "leaveFrom3": _leave3FromDate.text,
      "leaveFromFnAn3": _leaveFrom3FNANdesc,
      "leaveTo3": _leave3ToDate.text,
      "leaveToFnAn3": _leaveTo3FNANdesc,
      "numberOfDays3": _daysDiff3,
      "currentLeaveBal": _leaveBalCal,
      "currentLeaveBal2": _leaveBalCal2,
      "currentLeaveBal3": _leaveBalCal3,
      "cancelType": _cancellationType,
      "leaveMode": "C",
      "appliedByMobile": "Y"
    };
    print('map apply submit  cancel leave application--> $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    setState(() {
      if (responseJSON['status'] == true) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: responseJSON['message'],
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
            });
        setState(() {
          _formKey.currentState?.reset();
        });
      } else {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
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
    return Scaffold(
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),

          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Cancellation of Leave Application",
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
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerMove: (event) {
                  sessionCheck.startTimer(context);
                },
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              //--- leave 1 Starts ---//
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      '$_employeeName ($_hrmsEmployeeId) ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                                    child: Text(
                                      '$_employeeDepartment, '
                                      ' $_employeeRailwayUnit, '
                                      ' $_employeeZone',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Original Leave Sanctioned On $_sanctionOn by $_sanctionedAuthorityName ($_sanctionedAuthorityHrmsId) ,$_sanctionedAuthorityDesignation, $_sanctionedAuthorityDepartment',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 0, 5),
                                          child: Text(
                                            'Cancellation Type : *',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            border: Border.all(
                                                color: Colors.black,
                                                style: BorderStyle.solid,
                                                width: 1.0),
                                          ),
                                          child: DropdownButtonFormField(
                                            isExpanded: true,
                                            dropdownColor: Color(0xFFF2F2F2),
                                            hint: Text(
                                              'Please Select ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // Not necessary for Option 1
                                            value: _cancellationType,
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Cancellation Type is required';
                                              }
                                              return null;
                                            },
                                            onChanged: isCancellationTypeEnabled
                                                ? (newValue) {
                                                    setState(() {
                                                      _cancellationType =
                                                          newValue! as String?;
                                                    });
                                                  }
                                                : null,
                                            items: [
                                              DropdownMenuItem(
                                                value: "",
                                                child: Text("Please Select",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DropdownMenuItem(
                                                value: "F",
                                                child: Text("Full Cancellation",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DropdownMenuItem(
                                                value: "P",
                                                child: Text(
                                                    "Partial Cancellation",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: 10, left: 10, top: 10, right: 10),
                                    color: Colors.brown,
                                    child: Text(
                                      'Leave 1',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  'Nature of Leave : *',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                _leaveType1Name +
                                                    ' (' +
                                                    _leaveType1 +
                                                    ')',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  'From ',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                _leaveFrom1 +
                                                    ' (' +
                                                    _leaveFromFNAN +
                                                    ')',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  'To ',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                _leaveTo1 +
                                                    ' (' +
                                                    _leaveToFNAN +
                                                    ')',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 15, 0),
                                                child: Text(
                                                  _noOfDays1,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 10.0, 0, 10.0),
                                          child: Text(
                                            'Cancel From : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    15.0, 0, 15, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    25.0, 0.0, 25.0, 0.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  borderRadius:
                                                      BorderRadius.circular(0.0),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.30),
                                                ),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  controller: _leave1FromDate,
                                                  enabled: isEnabled,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    hintText: 'DD/MM/YYYY',
                                                    hintStyle: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // keyboardType: TextInputType.datetime,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Cancel From date is required';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _leave1FromDate.text = value!;
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    15.0, 0, 15, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    15.0, 0.0, 25.0, 0.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  borderRadius:
                                                      BorderRadius.circular(0.0),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.80),
                                                ),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  dropdownColor:
                                                      Color(0xFFF2F2F2),
                                                  hint: Text(
                                                    'Please Select ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // Not necessary for Option 1
                                                  value: _leaveFromFNAN,
                                                  onChanged:
                                                      _isLeaveFromFNANEnabled
                                                          ? (String? newValue) {
                                                              setState(() {
                                                                _leaveFromFNAN =
                                                                    newValue!;
                                                                checkLeaveFnAn(
                                                                    context,
                                                                    _leaveFromFNAN!);
                                                              });
                                                            }
                                                          : null,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: "FN",
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("1st Half",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          //Icon(Icons.sunny)
                                                        ],
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "AN",
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("2nd Half",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          //Icon(Icons.nightlight_round)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 10.0, 0, 10.0),
                                          child: Text(
                                            'Cancel Upto :  ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    15.0, 0, 15, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    25.0, 0.0, 25.0, 0.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  borderRadius:
                                                      BorderRadius.circular(0.0),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.30),
                                                ),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  controller: _leave1ToDate,
                                                  enabled: isEnabled,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    hintText: 'DD/MM/YYYY',
                                                    hintStyle: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Leave Upto is required';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _leave1ToDate.text = value!;
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    15.0, 0, 15, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    15.0, 0.0, 25.0, 0.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  borderRadius:
                                                      BorderRadius.circular(0.0),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.80),
                                                ),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  dropdownColor:
                                                      Color(0xFFF2F2F2),
                                                  // Not necessary for Option 1
                                                  value: _leaveToFNAN,
                                                  onChanged: _isLeaveToFNANEnabled
                                                      ? (String? newValue) {
                                                          setState(() {
                                                            _leaveToFNAN =
                                                                newValue!;
                                                            checkLeaveFnAn(
                                                                context,
                                                                _leaveToFNAN!);
                                                          });
                                                        }
                                                      : null,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: "FN",
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("1st Half",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          //Icon(Icons.sunny)
                                                        ],
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "AN",
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("2nd Half",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          //Icon(Icons.nightlight_round)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 15, 0),
                                                child: Text(
                                                  textAlign: TextAlign.right,
                                                  _numberOfDays1,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                          bottom: 10,
                                          left: 10,
                                          top: 10,
                                          right: 10),
                                      color: Colors.purple,
                                      child: Text(
                                        'Leave 2',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isLeave2Visibility,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    'Nature of Leave : *',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _leaveType2Name +
                                                      ' (' +
                                                      _leaveType2 +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    'From ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _leaveFrom2 +
                                                      ' (' +
                                                      _leaveFrom2FNAN +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    'To ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _leaveTo2 +
                                                      ' (' +
                                                      _leaveTo2FNAN +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 15, 0),
                                                  child: Text(
                                                    _noOfDays2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Divider(),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'Cancel From : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      25.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.30),
                                                  ),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    controller: _leave2FromDate,
                                                    enabled: isEnabled,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                      hintStyle: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    // keyboardType: TextInputType.datetime,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Cancel From date is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leave2FromDate.text =
                                                          value!;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    hint: Text(
                                                      'Please Select ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    // Not necessary for Option 1
                                                    value: _leaveFrom2FNAN,
                                                    onChanged:
                                                        _isLeaveFrom2FNANEnabled
                                                            ? (String? newValue) {
                                                                setState(() {
                                                                  _leaveFrom2FNAN =
                                                                      newValue!;
                                                                  checkLeaveFnAn(
                                                                      context,
                                                                      _leaveFrom2FNAN!);
                                                                });
                                                              }
                                                            : null,
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("1st Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.sunny)
                                                          ],
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "AN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("2nd Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.nightlight_round)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'Cancel Upto :  ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      25.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.30),
                                                  ),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    controller: _leave2ToDate,
                                                    enabled: isEnabled,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                      hintStyle: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Leave Upto is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leave2ToDate.text = value!;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    // Not necessary for Option 1
                                                    value: _leaveTo2FNAN,
                                                    onChanged:
                                                        _isLeaveTo2FNANEnabled
                                                            ? (String? newValue) {
                                                                setState(() {
                                                                  _leaveTo2FNAN =
                                                                      newValue!;
                                                                  checkLeaveFnAn(
                                                                      context,
                                                                      _leaveTo2FNAN!);
                                                                });
                                                              }
                                                            : null,
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("1st Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.sunny)
                                                          ],
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "AN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("2nd Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.nightlight_round)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 15, 0),
                                                  child: Text(
                                                    textAlign: TextAlign.right,
                                                    _numberOfDays2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                          bottom: 10,
                                          left: 10,
                                          top: 10,
                                          right: 10),
                                      color: Colors.pinkAccent,
                                      child: Text(
                                        'Leave 3',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isLeave3Visibility,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    'Nature of Leave : *',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _leaveType3Name +
                                                      ' (' +
                                                      _leaveType3 +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    'From ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _leaveFrom3 +
                                                      ' (' +
                                                      _leaveFrom3FNAN +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    'To ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _leaveTo3 +
                                                      ' (' +
                                                      _leaveTo3FNAN +
                                                      ')',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 15, 0),
                                                  child: Text(
                                                    _noOfDays3,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Divider(),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'Cancel From : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      25.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.30),
                                                  ),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    controller: _leave3FromDate,
                                                    enabled: isEnabled,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                      hintStyle: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    // keyboardType: TextInputType.datetime,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Cancel From date is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leave3FromDate.text =
                                                          value!;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    hint: Text(
                                                      'Please Select ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    // Not necessary for Option 1
                                                    value: _leaveFrom3FNAN,
                                                    onChanged:
                                                        _isLeaveFrom3FNANEnabled
                                                            ? (String? newValue) {
                                                                setState(() {
                                                                  _leaveFrom3FNAN =
                                                                      newValue!;
                                                                  checkLeaveFnAn(
                                                                      context,
                                                                      _leaveFrom3FNAN!);
                                                                });
                                                              }
                                                            : null,
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("1st Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.sunny)
                                                          ],
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "AN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("2nd Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.nightlight_round)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'Cancel Upto :  ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      25.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.30),
                                                  ),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    controller: _leave3ToDate,
                                                    enabled: isEnabled,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                      hintStyle: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Leave Upto is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leave3ToDate.text = value!;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF2F2F2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        style: BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    // Not necessary for Option 1
                                                    value: _leaveTo3FNAN,
                                                    onChanged:
                                                        _isLeaveTo3FNANEnabled
                                                            ? (String? newValue) {
                                                                setState(() {
                                                                  _leaveTo3FNAN =
                                                                      newValue!;
                                                                  checkLeaveFnAn(
                                                                      context,
                                                                      _leaveTo3FNAN!);
                                                                });
                                                              }
                                                            : null,
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("1st Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.sunny)
                                                          ],
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "AN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("2nd Half",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            //Icon(Icons.nightlight_round)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 15, 0),
                                                  child: Text(
                                                    textAlign: TextAlign.right,
                                                    _numberOfDays3,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //--- leave 3 Ends ---//
                                ],
                              ),

                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Container(
                                          height: 14,
                                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            'Reason For Cancellation:*',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFFFE0),
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            border: Border.all(
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 0.30),
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                            controller: _reasonForLeave,
                                            maxLength: 150,
                                            maxLines: 3,
                                            // Allows multiline input
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Enter Reason For Cancellation Upto 150 characters',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                              filled: true,
                                              fillColor: Colors.grey[200],
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter Reason For Cancellation Upto 150 characters';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _reasonForLeave.text = value!;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                ],
                              ),
                              //Second HQ Ends
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    bottom: 8, left: 8, top: 8, right: 8),
                                color: Colors.green,
                                child: Text(
                                  'Forward Application',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size).height * 0.9,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward,
                                          // Replace this with the icon you want to display
                                          size: 24, // Adjust the size of the icon
                                          color: Colors
                                              .red, // Adjust the color of the icon
                                        ),
                                        TextButton(
                                          child: Text(
                                              "Click Here To Select Fowarding Authorities"),
                                          onPressed: () {
                                            _showForwardingAuthoritiesModal(
                                                context);
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Forward Application to: *',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              selectedAuthority,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Search Range : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              zoneUnitDepartment,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: TextButton(
                                              child: Text(
                                                "Modify Search Range",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 14),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return buildModifySearchRangeAlertDialog(
                                                        context);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width:
                                      (MediaQuery.of(context).size).height * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Add your logic here
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              // Form is valid, do something with the data
                                              if (selectedAuthority == '') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please select Forwarding Authority',
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.BOTTOM,
                                                    // timeInSecForIos: 5,
                                                    backgroundColor: Colors.pink,
                                                    textColor: Colors.white,
                                                    fontSize: 14.0);
                                              } else {
                                                if (_hasBeenPressedSubmit ==
                                                    false) {
                                                  print('BTN PRESSED');
                                                  QuickAlert.show(
                                                      context: context,
                                                      type:
                                                          QuickAlertType.confirm,
                                                      text:
                                                          'Do you want to Cancel Leave application',
                                                      confirmBtnText: 'Yes',
                                                      cancelBtnText: 'No',
                                                      onCancelBtnTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          _hasBeenPressedSubmit =
                                                              false;
                                                        });
                                                      },
                                                      confirmBtnColor:
                                                          Colors.green,
                                                      onConfirmBtnTap: () {
                                                        setState(() {
                                                          _hasBeenPressedSubmit =
                                                              true;
                                                        });

                                                        submitCancelLeaveApplication();
                                                        Navigator.of(context)
                                                            .pop();
                                                      } // Call the API when user confirms
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: Text("Submit Application"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _hasBeenPressedSubmit
                                                ? Colors.black38
                                                : Colors.lightBlueAccent,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            // Button padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Button border radius
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  StatefulBuilder buildModifySearchRangeAlertDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, _setter) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: (MediaQuery.of(context).size).height * 0.5,
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Modify Search Range',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Zone",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Please Select ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: _selectZone,
                                  onChanged: (newValue) {
                                    _setter(() {
                                      _selectZone = newValue as String?;
                                      _getAllPrimaryUnit(_selectZone!)
                                          .then((value) {
                                        _setter(() {
                                          //_selectSubDepartment=_selectSubDepartment;
                                        });
                                      });
                                    });
                                  },
                                  // items: dropdownAllZones,
                                  items: zonesList.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            item['railway_unit'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          value: item['railway_unit_short_code']
                                              .toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Department",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Please Select ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: _selectDepartment,
                                  onChanged: (newValue) {
                                    _setter(() {
                                      _selectDepartment = newValue! as String?;
                                      _getAllSubDepartments(_selectDepartment!,
                                              _selectPrimaryUnit!)
                                          .then((value) {
                                        _setter(() {});
                                      });
                                    });
                                  },
                                  items: departmentList?.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            item['description'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          value: item['code'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Sub Department",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Not Applicable ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: _selectSubDepartment,
                                  onChanged: (newValue) {
                                    _setter(() {
                                      _selectSubDepartment =
                                          newValue! as String?;
                                    });
                                  },
                                  items: subDepartmentList?.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            item['description'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          value: item['code'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                  // dropdownSubDepartment,
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Primary Unit",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Please Select ',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: _selectPrimaryUnit,
                                  onChanged: (newValue) {
                                    _setter(() {
                                      _selectPrimaryUnit = newValue! as String?;
                                    });
                                  },
                                  items: DivisionList?.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(
                                            item['description'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          value: item['code'].toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to handle the update button press
                              setState(() {
                                _getFrwAuthoritiesBySearchRange();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('Proceed'),
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
      );
    });
  }

  void _showForwardingAuthoritiesModal(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter _setState) {
            return DraggableScrollableSheet(
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Column(children: [
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(children: [
                          Expanded(
                              child: TextField(
                                  controller: frwdAuthorityController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _tempListOfForwardingAuthorities =
                                          _buildSearchList(value);
                                    });
                                  })),
                          IconButton(
                              icon: Icon(Icons.close),
                              color: Color(0xFF1F91E7),
                              onPressed: () {
                                setState(() {
                                  frwdAuthorityController.clear();
                                  if (_tempListOfForwardingAuthorities != null)
                                    _tempListOfForwardingAuthorities!.clear();
                                });
                              }),
                        ])),
                    Expanded(
                      child: ListView.separated(
                          controller: scrollController,
                          itemCount: (_tempListOfForwardingAuthorities !=
                                      null &&
                                  _tempListOfForwardingAuthorities!.length > 0)
                              ? _tempListOfForwardingAuthorities!.length
                              : _listOfForwardingAuthorities.length,
                          separatorBuilder: (context, int) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            return InkWell(
                                child: (_tempListOfForwardingAuthorities !=
                                            null &&
                                        _tempListOfForwardingAuthorities!
                                                .length >
                                            0)
                                    ? _showBottomSheetWithSearch(index,
                                        _tempListOfForwardingAuthorities!)
                                    : _showBottomSheetWithSearch(
                                        index, _listOfForwardingAuthorities),
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                      ?.showSnackBar(SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            (_tempListOfForwardingAuthorities !=
                                                        null &&
                                                    _tempListOfForwardingAuthorities!
                                                            .length >
                                                        0)
                                                ? _tempListOfForwardingAuthorities![
                                                    index]
                                                : _listOfForwardingAuthorities[
                                                    index],
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )));
                                  setState(() {
                                    this.selectedAuthority =
                                        (_tempListOfForwardingAuthorities !=
                                                    null &&
                                                _tempListOfForwardingAuthorities!
                                                        .length >
                                                    0)
                                            ? _tempListOfForwardingAuthorities![
                                                index]
                                            : _listOfForwardingAuthorities[
                                                index];
                                    //get Authorities HRMS ID
                                    print(
                                        'selectedAuthority $selectedAuthority');
                                    RegExp regExp = RegExp(r"\((.*?)\)");
                                    Match? match =
                                        regExp.firstMatch(selectedAuthority);
                                    if (match != null) {
                                      String frwdAuthoritiesHrmsEmployeeId =
                                          match.group(1) ?? '';
                                      print(
                                          "frwdAuthoritiesHrmsEmployeeId: $frwdAuthoritiesHrmsEmployeeId");
                                      frwdAuthoritiesHrmsId =
                                          frwdAuthoritiesHrmsEmployeeId;
                                    } else {
                                      print("No match found.");
                                    }
                                  });
                                  Navigator.of(context).pop();
                                });
                          }),
                    )
                  ]);
                });
          });
        });
  }

  //8
  Widget _showBottomSheetWithSearch(int index, List listOfCities) {
    return Text(listOfCities[index],
        style: TextStyle(color: Colors.black, fontSize: 16),
        textAlign: TextAlign.center);
  }

  //9
  List _buildSearchList(String userSearchTerm) {
    List _searchList = [];

    for (int i = 0; i < _listOfForwardingAuthorities.length; i++) {
      String name = _listOfForwardingAuthorities[i];
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(_listOfForwardingAuthorities[i]);
      }
    }
    return _searchList;
  }

  void alertify(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkLeaveFnAn(
      BuildContext context, String _SelectedLeaveFnAn) async {
    if (_leave1FromDate.text != "" && _leave1ToDate.text != "") {
      List<String> mdy1 = _leave1FromDate.text.split('/');
      DateTime fromDate =
          DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      List<String> mdy2 = _leave1ToDate.text.split('/');
      DateTime toDate =
          DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      _daysDiff =
          (toDate.difference(fromDate).inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      if (toDate.isBefore(fromDate)) {
      } else if (toDate.isAfter(fromDate)) {
      } else {
        if (_leaveFromFNAN == 'AN' && _leaveToFNAN == 'FN') {
          String message =
              "'Leave From' and 'Leave Upto' date is same. So it can not be from Afternoon to Forenoon.";
          setState(() {
            _leaveFromFNAN = _SelectedLeaveFnAn == 'FN' ? 'AN' : 'FN';
            _leaveToFNAN = _SelectedLeaveFnAn == 'FN' ? 'AN' : 'FN';
          });
          alertify(context, message);
          return;
        }
      }

      if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'AN') {
        _daysDiff = _daysDiff + 1;
      } else if (_leaveFromFNAN == 'AN' && _leaveToFNAN == 'AN') {
        _daysDiff = _daysDiff + 0.5;
      } else if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'FN') {
        _daysDiff = _daysDiff + 0.5;
      }
      String dayName = "";
      if (_daysDiff > 1) {
        _numberOfDays1 = _daysDiff.toString();
        dayName = " days";
      } else {
        _numberOfDays1 = _daysDiff.toString();
        dayName = " day";
      }
      setState(() {
        _numberOfDays1 = _daysDiff.toString() + dayName;
      });
    }
  }
}
