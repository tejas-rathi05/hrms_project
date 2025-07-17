import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../util/validation_check.dart';

String clbal = "", rhbal = "", lapbal = "", lhapbal = "", cclbal = "";
var empname = "";
String? hrmsEmployeeId;

class ApplyLeave extends StatefulWidget {
  @override
  ApplyLeaveState createState() => ApplyLeaveState();
}

class ApplyLeaveState extends State<ApplyLeave> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List zonesList = [];
  String? _selectZone;
  List DivisionList = [];
  String? _selectDepartment;
  List departmentList = [];
  String? _selectSubDepartment;
  String? _selectPrimaryUnit;
  List subDepartmentList = [];
  List leavetypeList = [];
  String? _leaveType1;
  String? _leaveType2;
  String? _leaveType3;
  String _leaveBal = "";
  String _leaveBal1 = "";
  String _leaveBal2 = "";
  String _leaveBal3 = "";
  String? _leaveFromFNAN = "FN";
  String? _leaveToFNAN = "AN";
  String? _leaveFromFNAN2 = "FN";
  String? _leaveToFNAN2 = "AN";
  String? _leaveFromFNAN3 = "FN";
  String? _leaveToFNAN3 = "AN";
  String? _leaveHqFromFNAN;
  String? _leaveHqToFNAN;
  String? _leaveExFromFNAN;
  String? _leaveExToFNAN;
  String _weeklyOffDaysLabel = "";
  String _holidaysLabel = "";
  String? _paylevel;
  String? _gender;
  bool _secondLeaveView = false;
  bool _thirdLeaveView = false;
  String selectedAuthority = "";
  String zoneUnitDepartment = "";
  String? _ipAddress;
  List? _tempListOfForwardingAuthorities;
  List _listOfForwardingAuthorities = [];
  String _hqLeavingPermission = 'N';
  bool _hqLeaveFromToView = false;
  bool _exIndiaLeaveView = false;
  bool _exIndiaLeaveFromToView = false;
  bool _interveningLeaveDetailsView = false;
  bool _interveningUpdateDetailsView = false;
  String? _goingExIndiaLeave;
  String _retirementDate = "";
  String? empType = "";
  String result = "";
  String file_path = "";
  String? hrmsid;
  List<DateTime> datesIntervening = [];
  List<String> breakReason = ["", "holiday", "weeklyoff"];
  String? selectedValues;
  bool _isLoading = true;

  TextEditingController frwdAuthorityController = new TextEditingController();
  TextEditingController _leave1FromDate = TextEditingController();
  TextEditingController _leave1ToDate = TextEditingController();
  TextEditingController _leave2FromDate = TextEditingController();
  TextEditingController _leave2ToDate = TextEditingController();
  TextEditingController _leave3FromDate = TextEditingController();
  TextEditingController _leave3ToDate = TextEditingController();
  TextEditingController _leaveHqFromDate = TextEditingController();
  TextEditingController _leaveHqToDate = TextEditingController();
  TextEditingController _leaveExFromDate = TextEditingController();
  TextEditingController _leaveExToDate = TextEditingController();

  TextEditingController _reasonForLeave = TextEditingController();
  TextEditingController _leavePeriodAddress = TextEditingController();
  TextEditingController selectedItem = TextEditingController();

  List<DropdownMenuItem<String>> dropdownItems = [];

  @override
  void initState() {
    _getLeaveBalanceDetails();
    _fetchLeaveOptions();
    _fetchNpsDetails();
    _getAllZones();
    _getAllDepartments();
    _getAllPrimaryUnit("");
    _getIP();
    _getFrwAuthorities().then((_) {
      //_fetchLeavesLeft();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _leave1FromDate.dispose();
    _leave1ToDate.dispose();
    _leave2FromDate.dispose();
    _leave2ToDate.dispose();
    _leave3FromDate.dispose();
    _leave3ToDate.dispose();
    selectedItem.dispose();
    super.dispose();
  }

  Future _getIP() async {
    NetworkInfo info = NetworkInfo();
    String? ipAddress = await info.getWifiIP();
    print('ip $ipAddress');
    setState(() {
      _ipAddress = ipAddress; //info.getWifiIP() as String?;
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

  Future _getAllZones() async {
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
    print('responseAllZones $responseJSON');
    String? zone = await pref.getEmployeeRailwayzone();
    print('responseAllPrimaryUnit $responseJSON');
    String? primaryUnit = await pref.getEmployeeUnitcode();
    print('primaryUnit $primaryUnit');
    setState(() {
      _selectZone = zone!;
      _selectPrimaryUnit = primaryUnit!;
      if (responseJSON['code_unit'] != null) {
        zonesList = responseJSON['code_unit'];
      }
    });
  }

  Future _getAllPrimaryUnit(String SelectedZone) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    if(SelectedZone=="")
      _selectZone = (await pref.getEmployeeRailwayzone())!;
    else
      _selectZone=SelectedZone;
    final String url =
        new UtilsFromHelper().getValueFromKey("getDivisionsByZones");
    print('url $url');
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"railway_code": _selectZone};
    print('map primary unit 123 $map');
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
    print('selected $_selectPrimaryUnit');
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

  Future _getAllSubDepartments(String _selectDepartment,String _selectPrimaryUnit) async {
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
    print('map $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value);
    print('responseJSONSubDepartment $responseJSON');
    setState(() {
      if (responseJSON['sub_department'] != null) {
        subDepartmentList = responseJSON['sub_department'];
        _selectSubDepartment = subDepartmentList.first['code'].toString();
      }
    });
    print('_selectSubDepartment $_selectSubDepartment');
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
      "paylevel": await pref.getPayLevel(),
      "unit": await pref.getEmployeeUnitcode(),
      "dept": await pref.getDepartmentCode(),
      "subDept": ""
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
    print('hrmsEmployeeId $hrmsEmployeeId');
    setState(() {
      zoneUnitDepartment = zone.toString() +
          "- " +
          unitCode.toString() +
          "- " +
          departmentDescription.toString();
      print('zone $zoneUnitDepartment');
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

  Future _getFrwAuthoritiesBySearchRange() async {
    _listOfForwardingAuthorities.clear();
    sharedpreferencemanager pref = sharedpreferencemanager();
    String? hrmsEmployeeId = await pref.getUsername();
    String? unitCode = await pref.getEmployeeUnitname();
    String? departmentDescription = await pref.getEmployeeDept();

    final String url = new UtilsFromHelper()
        .getValueFromKey("get_frwd_leave_authorities_list");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "paylevel": await pref.getPayLevel(),
      "unit": _selectPrimaryUnit,
      "dept": _selectDepartment,
      "subDept": _selectSubDepartment
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
    print('hrmsEmployeeId $hrmsEmployeeId');
    setState(() {
      zoneUnitDepartment = _selectZone.toString() +
          "- " +
          unitCode.toString() +
          "- " +
          departmentDescription.toString();
      print('zone $zoneUnitDepartment');
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

  Future _getLeaveBalanceDetails() async {
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
    print('responseJSON $responseJSON');
    setState(() {
      clbal = leave_balance_status_check(responseJSON['cl_balance'].toString());
      rhbal = leave_balance_status_check(responseJSON['rh_balance'].toString());
      lapbal =
          leave_balance_status_check(responseJSON['lap_balance'].toString());

      lhapbal =
          leave_balance_status_check(responseJSON['lhap_balance'].toString());
      cclbal =
          leave_balance_status_check(responseJSON['ccl_balance'].toString());
    });
  }

  Future _fetchLeaveOptions() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("getLeaveOptions");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await pref.getUsername(),
      "gender": await pref.getEmployeeGender()
    };
    hrmsEmployeeId = (await pref.getUsername())!;
    _retirementDate = (await pref.getRetirementDate())!;
    _paylevel = await pref.getPayLevel();
    _gender = await pref.getEmployeeGender();
    print('paylevel $_paylevel');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value);
    print('response $responseJSON');

    setState(() {
      dropdownItems.add(
        DropdownMenuItem(
          value: "",
          child: Text("Please Select",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "CL",
          child: Text("CASUAL LEAVE (CL)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "RH",
          child: Text("RESTRICTED HOLIDAY (RH)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "LAP",
          child: Text("LEAVE ON AVERAGE PAY (LAP)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "LHAP",
          child: Text("LEAVE ON AVERAGE HALF PAY (LHAP)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      if (_gender == 'F')
        dropdownItems.add(
          DropdownMenuItem(
            value: "CCL",
            child: Text("CHILD CARE LEAVE (CCL)",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        );
      if (_gender == 'M')
        dropdownItems.add(
          DropdownMenuItem(
            value: "CCLSF",
            child: Text("CHILD CARE LEAVE FOR SINGLE FATHER (CCLSF)",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        );
      dropdownItems.add(
        DropdownMenuItem(
          value: "",
          child: Text(
            "-------------------------------",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          enabled: false,
        ),
      );
      leavetypeList = responseJSON['myleaveApplication'];
      // Add the dynamic items using forEach loop
      leavetypeList.forEach((item) {
        if (item['leave_type_code'] == 'COCL' &&
            (_paylevel == '1' ||
                _paylevel == '2' ||
                _paylevel == '3' ||
                _paylevel == '4' ||
                _paylevel == '5'))
          dropdownItems.add(
            DropdownMenuItem(
              value: item['leave_type_code'],
              child: Text(
                item['leave_type_name'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        if (item['leave_type_code'] != 'COCL' &&
            item['leave_type_code'] != 'LVHQ' &&
            item['leave_type_code'] != 'CL' &&
            item['leave_type_code'] != 'LAP' &&
            item['leave_type_code'] != 'RH' &&
            item['leave_type_code'] != 'LHAP' &&
            item['leave_type_code'] != 'CCL' &&
            item['leave_type_code'] != 'CCLSF') {
          dropdownItems.add(
            DropdownMenuItem(
              value: item['leave_type_code'],
              child: Text(
                item['leave_type_name'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      });
    });
  }

  Future _getLeavesLeft(String _leaveType, String _leaveBlock) async {
    setState(() {
      if (_leaveBlock == '1') {
        _leaveBal1 = _getLeavesLeftType(_leaveBal, _leaveType);
      } else if (_leaveBlock == '2') {
        _leaveBal2 = _getLeavesLeftType(_leaveBal, _leaveType);
      } else {
        _leaveBal3 = _getLeavesLeftType(_leaveBal, _leaveType);
      }
    });
    print('_currnetBal $_leaveBal1');
  }

  String _getLeavesLeftType(_leaveBal, _leaveType) {
    if (_leaveType == 'CL') {
      print('clbal $clbal');
      _leaveBal = clbal + ' days';
    } else if (_leaveType == 'RH') {
      _leaveBal = rhbal + ' days';
    } else if (_leaveType == 'LAP') {
      _leaveBal = lapbal + ' days';
    } else if (_leaveType == 'LHAP') {
      _leaveBal = lhapbal + ' days';
    } else if (_leaveType == 'CCL') {
      _leaveBal = cclbal + ' days';
    } else {
      _leaveBal = 'NA';
    }
    return _leaveBal;
  }

  Future<bool> updateIntervening(
      String _leave1ToDate,
      String _leave2FromDate,
      String _leave2ToDate,
      String _leave3FromDate,
      String _leaveToFNAN,
      String _leaveFromFNAN2,
      String _leaveToFNAN2,
      String _leaveFromFNAN3) async {
    datesIntervening.clear();
    //breakReason.clear();
    if (_leave1ToDate != null &&
        _leave1ToDate.isNotEmpty &&
        _leave2FromDate != null &&
        _leave2FromDate.isNotEmpty) {
      print('_leave1 $_leave1ToDate');

      List<String> mdy1 = _leave1ToDate.split('/');
      DateTime toDate1 = DateTime(
          int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]) - 1);
      List<String> mdy2 = _leave2FromDate.split('/');
      DateTime fromDate2 = DateTime(
          int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]) - 1);
      DateTime date = DateTime(toDate1.year, toDate1.month, toDate1.day);
      print('date 21 $date');
      if (_leaveToFNAN == "FN")
        date = date.add(Duration(days: 1));
      else
        date = date.add(Duration(days: 2));

      while (date.isBefore(fromDate2) || date == fromDate2) {
        datesIntervening.add(date);
        date = date.add(Duration(days: 1));
      }
      if (_leaveFromFNAN2 == "AN") datesIntervening.add(date);

      print('datesIntervening12121 $datesIntervening');
    }

    if (_leave2ToDate != null &&
        _leave2ToDate.isNotEmpty &&
        _leave3FromDate != null &&
        _leave3FromDate.isNotEmpty) {
      List<String> mdy1 = _leave2ToDate.split('/');
      DateTime toDate2 = DateTime(
          int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]) - 1);
      List<String> mdy2 = _leave3FromDate.split('/');
      DateTime fromDate3 = DateTime(
          int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]) - 1);
      DateTime date = DateTime(toDate2.year, toDate2.month, toDate2.day);
      print('date 21 $date');

      if (_leaveToFNAN2 == "FN")
        date = date.add(Duration(days: 1));
      else
        date = date.add(Duration(days: 2));
      while (date.isBefore(fromDate3) || date == fromDate3) {
        datesIntervening.add(date);
        date = date.add(Duration(days: 1));
      }
      if (_leaveFromFNAN3 == "AN") datesIntervening.add(date);
    }

    print('datesIntervening $datesIntervening');
    print('datesIntervening length ${datesIntervening.length}');
    print('breakReason $breakReason');

    setState(() {
      breakReason = List.filled(datesIntervening.length, '');
    });
    print('breakReason $breakReason');
    if (datesIntervening.length > 6) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Leave is not continuous"),
          content: Text(
              "Please submit separate applications for each continuous spell of leave."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  Future updateInterveningBtn(
      List datesIntervening, List holidayWeeklyBreakReason) async {
    print('holidayWeeklyBreakReason $holidayWeeklyBreakReason');
    print('updateInterveningBtn $datesIntervening');
    String weeklyOffDays = "";
    String holidays = "";
    print('Update Dialog datesIntervening $datesIntervening');
    for (int i = 0; i < datesIntervening.length; i++) {
      String breakReason = holidayWeeklyBreakReason[i];

      if (breakReason == "") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Break Reason Not Selected"),
            content: Text(
                "Please select break reason for the date ${DateFormat('dd/MM/yyyy').format(datesIntervening[i])}"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else if (breakReason == "holiday") {
        if (holidays == "")
          holidays = DateFormat('dd/MM/yyyy').format(datesIntervening[i]);
        else
          holidays +=
              ", ${DateFormat('dd/MM/yyyy').format(datesIntervening[i])}";
      } else if (breakReason == "weeklyoff") {
        if (weeklyOffDays == "")
          weeklyOffDays = DateFormat('dd/MM/yyyy').format(datesIntervening[i]);
        else
          weeklyOffDays +=
              ", ${DateFormat('dd/MM/yyyy').format(datesIntervening[i])}";
      }
    }

    setState(() {
      _weeklyOffDaysLabel = weeklyOffDays;
      _holidaysLabel = holidays;
      _interveningUpdateDetailsView = true;
    });
  }

  Future submitLeaveApplication(BuildContext dialogcontext) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("submit_pass");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "employeeHrmsId": await pref.getEmployeeHrmsid(),
      "employeeName": await pref.getEmployeeName(),
      "designationCode": await pref.getDesignationCode(),
      "departmentCode": await pref.getDepartmentCode(),
      "empType": empType,
      "zoneId": await pref.getEmployeeRailwayzone(),
      "unitCode": await pref.getEmployeeUnitcode(),
      "leaveType": _leaveType1,
      "currentLeaveBal": _leaveBal1,
      "leaveFrom": _leave1FromDate,
      "leaveFromFnAn": _leaveFromFNAN,
      "leaveTo": _leave1ToDate,
      "leaveToFnAn": _leaveToFNAN,
      "numberOfDays": "2",
      "hqLeaving": _hqLeavingPermission,
      "hqLeaveFrom": _leaveHqFromDate,
      "hqLeaveFromFnAn": _leaveHqFromFNAN,
      "hqLeaveTo": _leaveHqToDate,
      "hqLeaveToFnAn": _leaveHqToFNAN,
      "exIndiaLeave": _goingExIndiaLeave,
      "exIndiaLeaveFrom": _leaveExFromDate,
      "exIndiaLeaveFromFnAn": _leaveExFromFNAN,
      "exIndiaLeaveTo": _leaveExToDate,
      "exIndiaLeaveToFnAn": _leaveExToFNAN,
      "reasonForLeave": _reasonForLeave,
      "leavePeriodAddress": _leavePeriodAddress,
      "supportingDoc": "Leave-Management/OUWOIK_1689317912306_029.pdf",
      "leaveStatus": "A",
      "frwAuthority": "IGFZXL",
      "userId": await pref.getEmployeeHrmsid(),
      "ipAddress": _ipAddress,
      "leaveType2": _leaveType2,
      "currentLeaveBal2": _leaveBal2,
      "leaveFrom2": _leave2FromDate,
      "leaveFromFnAn2": _leaveFromFNAN2,
      "leaveTo2": _leave2ToDate,
      "leaveToFnAn2": _leaveToFNAN2,
      "numberOfDays2": "1",
      "leaveType3": _leaveType3,
      "currentLeaveBal3": _leaveBal3,
      "leaveFrom3": _leave3FromDate,
      "leaveFromFnAn3": _leaveFromFNAN3,
      "leaveTo3": _leave3ToDate,
      "leaveToFnAn3": _leaveToFNAN3,
      "numberOfDays3": "1",
      "weeklyOffDays": _weeklyOffDaysLabel,
      "holidays": _holidaysLabel,
      "gender": await pref.getEmployeeGender(),
      "frwAuthorityDetails": "SANDEEP KUMAR JAIN (IGFZXL) / AEN",
      "appliedByMobile": "Y"
    };
    print('map apply submit leave application--> $map');
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
      if (responseJSON['status'] == "1") {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
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
          title: Text("New Leave Application",
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
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          //--- leave 1 Starts ---//
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    bottom: 10, left: 10, top: 10, right: 10),
                                color: Colors.orange,
                                child: Text(
                                  'Leave 1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Form(
                                  key: _formKey,
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
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFFFE0),
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // Not necessary for Option 1
                                                value: _leaveType1,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveType1 =
                                                        newValue! as String?;
                                                    print(
                                                        '_leaveType1 $_leaveType1');
                                                    String _leaveBlock = '1';
                                                    _getLeavesLeft(_leaveType1!,
                                                        _leaveBlock);
                                                  });
                                                },
                                                items: dropdownItems,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 14,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                'Current Leave Balance : *',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _leaveBal1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 12),
                                              textAlign: TextAlign.left,
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
                                          'Leave From : *  ',
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
                                                controller: _leave1FromDate,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: 'DD/MM/YYYY',
                                                ),
                                                // keyboardType: TextInputType.datetime,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Leave From date is required';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _leave1FromDate = value
                                                      as TextEditingController;
                                                },
                                                onTap: () {
                                                  _selectLeave1FromDate(
                                                      context);
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
                                                color: Color(0xFFFFFFE0),
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
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveFromFNAN = newValue!;
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "FN",
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("FN",
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
                                                        Text("AN",
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
                                          'Leave To : *  ',
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
                                                controller: _leave1ToDate,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: 'DD/MM/YYYY',
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Leave Upto is required';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _leave1ToDate = value
                                                      as TextEditingController;
                                                },
                                                onTap: () {
                                                  _selectLeave1ToDate(context);
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
                                                color: Color(0xFFFFFFE0),
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
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveToFNAN = newValue!;
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "FN",
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("FN",
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
                                                        Text("AN",
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
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 1),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _secondLeaveView = true;
                                    _interveningLeaveDetailsView = true;
                                    //_leaveType2 ="";
                                    _leave2FromDate.clear();
                                    _leave2ToDate.clear();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 10, top: 10, right: 10),
                                  child: Text(
                                    '+ Add Another Leave',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //--- leave 1 Ends ---//
                          // --- Leave 2 Starts ----//
                          Visibility(
                            visible: _secondLeaveView,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 10, top: 10, right: 10),
                                  color: Colors.purple,
                                  child: Text(
                                    'Leave 2',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.purple,
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
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFFFE0),
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // Not necessary for Option 1
                                                value: _leaveType2,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveType2 =
                                                        newValue! as String?;
                                                    print(
                                                        '_leaveType2 $_leaveType2');
                                                    String _leaveBlock = '2';
                                                    _getLeavesLeft(_leaveType2!,
                                                        _leaveBlock);
                                                  });
                                                },
                                                items: dropdownItems,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 14,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                'Current Leave Balance : *',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _leaveBal2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 10.0, 0, 10.0),
                                        child: Text(
                                          'Leave From : *  ',
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
                                                controller: _leave2FromDate,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: 'DD/MM/YYYY',
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Leave From date is required';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _leave2FromDate = value
                                                      as TextEditingController;
                                                },
                                                onTap: () {
                                                  _selectLeave2FromDate(
                                                      context);
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
                                                color: Color(0xFFFFFFE0),
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
                                                value: _leaveFromFNAN2,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveFromFNAN2 = newValue!;
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "FN",
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("FN",
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
                                                        Text("AN",
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
                                          'Leave To : *  ',
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
                                                controller: _leave2ToDate,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: 'DD/MM/YYYY',
                                                ),
                                                // keyboardType: TextInputType.datetime,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Leave Upto is required';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _leave2ToDate = value
                                                      as TextEditingController;
                                                },
                                                onTap: () {
                                                  _selectLeave2ToDate(context);
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
                                                color: Color(0xFFFFFFE0),
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
                                                value: _leaveToFNAN2,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveToFNAN2 = newValue!;
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "FN",
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("FN",
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
                                                        Text("AN",
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
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _thirdLeaveView = true;
                                      _leave3FromDate.clear();
                                      _leave3ToDate.clear();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 10,
                                            left: 10,
                                            top: 10,
                                            right: 10),
                                        child: Text(
                                          '+ Add Another Leave',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _secondLeaveView = false;
                                            _interveningLeaveDetailsView =
                                                false;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: 10,
                                              left: 10,
                                              top: 10,
                                              right: 10),
                                          child: Text(
                                            '- Delete this Leave',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // --- Leave 2 End ----//
                          // --- Leave 3 Starts ----//
                          Visibility(
                            visible: _thirdLeaveView,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 10, left: 10, top: 10, right: 10),
                                  color: Colors.black,
                                  child: Text(
                                    'Leave 3',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
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
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFFFE0),
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // Not necessary for Option 1
                                                value: _leaveType3,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveType3 =
                                                        newValue! as String?;
                                                    print(
                                                        '_leaveType3 $_leaveType3');
                                                    String _leaveBlock = '3';
                                                    _getLeavesLeft(_leaveType3!,
                                                        _leaveBlock);
                                                  });
                                                },
                                                items: dropdownItems,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 14,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                'Current Leave Balance : *',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _leaveBal3,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 10.0, 0, 10.0),
                                        child: Text(
                                          'Leave From : *  ',
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
                                                controller: _leave3FromDate,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: 'DD/MM/YYYY',
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Leave From date is required';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _leave3FromDate = value
                                                      as TextEditingController;
                                                },
                                                onTap: () {
                                                  _selectLeave3FromDate(
                                                      context);
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
                                                color: Color(0xFFFFFFE0),
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
                                                value: _leaveFromFNAN3,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveFromFNAN3 = newValue!;
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "FN",
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("FN",
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
                                                        Text("AN",
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
                                          'Leave To : *  ',
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
                                                controller: _leave3ToDate,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: 'DD/MM/YYYY',
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Leave Upto is required';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _leave3ToDate = value
                                                      as TextEditingController;
                                                },
                                                onTap: () {
                                                  _selectLeave3ToDate(context);
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
                                                color: Color(0xFFFFFFE0),
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
                                                value: _leaveToFNAN3,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _leaveToFNAN3 = newValue!;
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "FN",
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("FN",
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
                                                        Text("AN",
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
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _thirdLeaveView = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: 10,
                                        left: 10,
                                        top: 10,
                                        right: 10),
                                    child: Text(
                                      '- Delete this Leave',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // --- Leave 3 End ----//
                          SizedBox(height: 8),
                          //Intervening Period Details Starts
                          Container(
                            child: Visibility(
                              visible: _interveningLeaveDetailsView,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Click here to provide details for intervening period *',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              // Add the logic to show the modal dialog on button press
                                              //showAlertDialog(BuildContext context) {
                                              if (await updateIntervening(
                                                  _leave1ToDate.text as String,
                                                  _leave2FromDate.text
                                                      as String,
                                                  _leave2ToDate.text as String,
                                                  _leave3FromDate.text
                                                      as String,
                                                  _leaveToFNAN!,
                                                  _leaveFromFNAN2!,
                                                  _leaveToFNAN2!,
                                                  _leaveFromFNAN3!)) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return buildInterveningAlertDialog(
                                                        context);
                                                  },
                                                );
                                              }
                                            },
                                            icon: Icon(Icons.edit),
                                            label: Text('Click here'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _interveningUpdateDetailsView,
                                    child: Container(
                                      margin: EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Intervening Period Details',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
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
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        _weeklyOffDaysLabel,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        _holidaysLabel,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Intervening Period Details Ends
                          //Second Container Starts
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              'HQ Leaving Permission Required : *',
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
                                              color: Color(0xFFFFFFE0),
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  style: BorderStyle.solid,
                                                  width: 0.80),
                                            ),
                                            child: DropdownButton(
                                              isExpanded: true,
                                              dropdownColor: Color(0xFFF2F2F2),
                                              value: _hqLeavingPermission,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _hqLeavingPermission =
                                                      newValue!;
                                                  print(
                                                      '_hqLeavingPermission $_hqLeavingPermission');
                                                  if (_hqLeavingPermission ==
                                                      'Y') {
                                                    _exIndiaLeaveView = true;
                                                    _hqLeaveFromToView = true;
                                                    _goingExIndiaLeave = 'N';
                                                  } else {
                                                    _hqLeaveFromToView = false;
                                                    _exIndiaLeaveView = false;
                                                    _exIndiaLeaveFromToView =
                                                        false;
                                                  }
                                                });
                                              },
                                              items: [
                                                DropdownMenuItem(
                                                  value: "N",
                                                  child: Text("NO",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Y",
                                                  child: Text("YES",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Visibility(
                                      visible: _exIndiaLeaveView,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 14,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                'Going for Ex India Leave?:',
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
                                                color: Color(0xFFFFFFE0),
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
                                                value: _goingExIndiaLeave,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _goingExIndiaLeave =
                                                        newValue! as String?;
                                                    print(
                                                        '_goingExIndiaLeave $_goingExIndiaLeave');
                                                    if (_goingExIndiaLeave ==
                                                        'Y') {
                                                      _exIndiaLeaveView = true;
                                                      _exIndiaLeaveFromToView =
                                                          true;
                                                    } else {
                                                      _exIndiaLeaveFromToView =
                                                          false;
                                                    }
                                                  });
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "N",
                                                    child: Text("NO",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "Y",
                                                    child: Text("YES",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Divider(),
                                    //  HQ Leave From To Date Starts  //
                                    Visibility(
                                      visible: _hqLeaveFromToView,
                                      // Set the visibility based on a boolean value
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'HQ Leave From : *  ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
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
                                                      width: 0.30,
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    controller:
                                                        _leaveHqFromDate,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Leave HQ From date is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leaveHqFromDate = value
                                                          as TextEditingController;
                                                    },
                                                    onTap: () {
                                                      _selectHqLeaveFromDate(
                                                          context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFE0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.80,
                                                    ),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    value: _leaveHqFromFNAN,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _leaveHqFromFNAN =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "FN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                                            Text(
                                                              "AN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                          Divider(),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'HQ Leave To : *  ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
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
                                                      width: 0.30,
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    controller: _leaveHqToDate,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Leave HQ Upto is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leaveHqToDate = value
                                                          as TextEditingController;
                                                    },
                                                    onTap: () {
                                                      _selectHqLeaveToDate(
                                                          context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFE0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.80,
                                                    ),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    value: _leaveHqToFNAN,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _leaveHqToFNAN =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "FN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                                            Text(
                                                              "AN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    //  Ex India  Leave From To Date   //
                                    Visibility(
                                      visible: _exIndiaLeaveFromToView,
                                      // Set the visibility based on a boolean value
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'Ex India Leave From : *  ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
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
                                                      width: 0.30,
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    controller:
                                                        _leaveExFromDate,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Leave From date is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leaveExFromDate = value
                                                          as TextEditingController;
                                                    },
                                                    onTap: () {
                                                      _selectExLeaveFromDate(
                                                          context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFE0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.80,
                                                    ),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    value: _leaveExFromFNAN,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _leaveExFromFNAN =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "FN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                                            Text(
                                                              "AN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                          Divider(),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10.0, 0, 10.0),
                                            child: Text(
                                              'Ex India Leave To : *  ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
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
                                                      width: 0.30,
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    controller: _leaveExToDate,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'DD/MM/YYYY',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Leave Upto is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _leaveExToDate = value
                                                          as TextEditingController;
                                                    },
                                                    onTap: () {
                                                      _selectExLeaveToDate(
                                                          context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15.0, 0, 15, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 0.0, 25.0, 0.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFE0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.80,
                                                    ),
                                                  ),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    dropdownColor:
                                                        Color(0xFFF2F2F2),
                                                    value: _leaveExToFNAN,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _leaveExToFNAN =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: "FN",
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "FN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                                            Text(
                                                              "AN",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
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
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    //Address Starts
                                    Visibility(
                                      visible: _hqLeaveFromToView,
                                      // Set the visibility based on a boolean value
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 14,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Text(
                                              'Address:',
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
                                              controller: _leavePeriodAddress,
                                              maxLength: 300,
                                              maxLines: 3,
                                              // Allows multiline input
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Please Enter Address',
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
                                                  print('Address is empty');
                                                  return 'Leave Address is required';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _leavePeriodAddress = value
                                                    as TextEditingController;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Ground on which leave applied
                                    Container(
                                      height: 14,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        'Ground on which leave applied:',
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
                                        maxLength: 300,
                                        maxLines: 3,
                                        // Allows multiline input
                                        decoration: InputDecoration(
                                          hintText: 'Please Enter Remarks',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 16),
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
                                            print('remarks is empty');
                                            return 'Reason is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _reasonForLeave =
                                              value as TextEditingController;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        "Upload Approval Document *",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors
                                                        .lightBlueAccent)),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5, 2, 5, 2),
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 7, 5, 7),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .lightBlueAccent)),
                                                  //             <--- BoxDecoration here
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Please Wait...',
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            // timeInSecForIos: 5,
                                                            backgroundColor:
                                                                Colors.pink,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 14.0);

                                                        result = await Navigator
                                                            .push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      FileList()),
                                                        );
                                                        setState(() {
                                                          file_path = result;
                                                        });
                                                      },
                                                      child: Text(
                                                        "Choose File",
                                                        style: TextStyle(
                                                            fontSize: 10.0),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    file_path ??
                                                        'No file chosen',
                                                    style: TextStyle(
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
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
                              'Forward Leave',
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
                                              builder: (BuildContext context) {
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
                            height: 40,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: (MediaQuery.of(context).size).height * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add your logic here
                                        print(
                                            "Submit Application button pressed!");
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          // Form is valid, do something with the data
                                        }
                                      },
                                      child: Text("Submit Application"),
                                      style: ElevatedButton.styleFrom(
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
                                ],
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
    );
  }

  StatefulBuilder buildInterveningAlertDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, _setter) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: (MediaQuery.of(context).size).height * 0.65,
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Update Intervening Period Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
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
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Reason for Break *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (datesIntervening.isEmpty)
                        Center(
                          child: Text('No Intervening Date to Update',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 12,
                              )),
                        )
                      else
                        Container(
                          height: (MediaQuery.of(context).size).height * 0.35,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFE0),
                            borderRadius: BorderRadius.circular(0.0),
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: ListView.builder(
                            itemCount: datesIntervening.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${DateFormat('dd/MM/yyyy (EEEE)').format(datesIntervening[index])}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: breakReason[index],
                                    onChanged: (value) {
                                      _setter(() {
                                        breakReason[index] = value!;
                                        print('break12 ${breakReason[index]}');
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          value: "",
                                          child: Text(
                                            "Please Select",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                            textAlign: TextAlign.left,
                                          )),
                                      DropdownMenuItem(
                                          value: "holiday",
                                          child: Text(
                                            "Holiday",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                            textAlign: TextAlign.left,
                                          )),
                                      DropdownMenuItem(
                                          value: "weeklyoff",
                                          child: Text(
                                            "Weekly Off",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                            textAlign: TextAlign.left,
                                          )),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to handle the update button press
                              setState(() {
                                updateInterveningBtn(
                                    datesIntervening, breakReason);
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('Update'),
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
                                      print('on callback $_selectZone');
                                      _getAllPrimaryUnit(_selectZone!).then((value) {
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
                                      _getAllSubDepartments(_selectDepartment!,_selectPrimaryUnit!).then((value) {
                                        _setter(() {
                                          //_selectSubDepartment=_selectSubDepartment;
                                        });
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
                                    'Please Select ',
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
                                      print(
                                          '_selectSubDepartment$_selectSubDepartment');
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
                                      [], // dropdownSubDepartment,
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

  Future<void> _selectLeave1FromDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leave1FromDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLeave1ToDate(BuildContext context) async {
    print('Leave 22 -----');
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leave1ToDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLeave2FromDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leave2FromDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLeave2ToDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leave2ToDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLeave3FromDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leave3FromDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLeave3ToDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leave3ToDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectHqLeaveFromDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leaveHqFromDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectHqLeaveToDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leaveHqToDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectExLeaveFromDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leaveExFromDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectExLeaveToDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime nextYear = DateTime(today.year + 1, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: nextYear,
    );
    if (picked != null) {
      setState(() {
        _leaveExToDate.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}
