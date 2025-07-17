import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/fingerprint.dart';
import '../login/loginscreen.dart';
import '../util/pinvery.dart';
import '../util/session_check.dart';
import '../util/validation_check.dart';

String clbal = "", rhbal = "", lapbal = "", lhapbal = "", cclbal = "";
var empname = "";
String? hrmsEmployeeId;

class LiteApplyLeave extends StatefulWidget {
  @override
  LiteApplyLeaveState createState() => LiteApplyLeaveState();
}

class LiteApplyLeaveState extends State<LiteApplyLeave> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List zonesList = [];
  String? _selectZone;
  List DivisionList = [];
  String? _selectDepartment;
  List departmentList = [];
  String? _selectSubDepartment;
  String? _selectPrimaryUnit;
  List subDepartmentList = [];
  String? _leaveType1;
  String _leaveBal = "";
  String _leaveBal1 = "";
  String _leaveBalCal = "";
  var _daysDiff;
  var _hqDaysDiff;
  String _numberOfDays = "";
  bool _isLeaveFromFNANEnabled = true;
  String? _leaveFromFNAN = "FN";
  bool _isLeaveToFNANEnabled = true;
  String? _leaveToFNAN = "AN";
  String? _leaveHqFromFNAN = "FN";
  String? _leaveHqToFNAN = "AN";
  String _leaveHqFromTimeVal="09:30";
  String _leaveHqToTimeVal="18:00";
  String _initialBalMessage = "";
  bool _initialBalMessageVisible = false;
  String _provisionalMyBalMsg = "";
  String _provMsg = "";
  String selectedAuthority = "";
  String zoneUnitDepartment = "";
  String? _ipAddress;
  List<Map<String,dynamic>> _tempListOfForwardingAuthorities=[];
  List<Map<String,dynamic>> _listOfForwardingAuthorities = [];
  String empHrmsId="";
  String _hqLeavingPermission = 'N';
  bool _diffDaysVisible = false;
  bool _hqDiffDaysVisible = false;
  bool _hqLeaveFromToView = false;
  bool _exIndiaLeaveView = false;
  String _goingExIndiaLeave='N';
  String _retirementDate = "";
  String _dateOfJoining = "";
  String? empType = "";
  String result = "";
  String? hrmsid;
  String? frwdAuthoritiesHrmsId;
  String _rhApplied = "";
  String _clApplied = "";
  String _balanceStatus = "";
  String? selectedValues;
  bool _isLoading = true;
  bool _hasBeenPressedSubmit = false;
  String _errorMessage="";

  List<dynamic>? _files;
  String _filePath = "";
  String? _fileString;

  bool isEnabled = true;
  bool isCLInitialBalanceVisibility = false;
  bool isRHInitialBalanceVisibility = false;
  bool isCurrentLeaveBalanceVisibility = true;
  String _lienUnit='';

  TextEditingController frwdAuthorityController = new TextEditingController();
  TextEditingController _leave1FromDate = TextEditingController();
  TextEditingController _leave1ToDate = TextEditingController();
  TextEditingController _leaveHqFromDate = TextEditingController();
  TextEditingController _leaveHqToDate = TextEditingController();
  TextEditingController _initialCLBalanceController= TextEditingController();
  TextEditingController _initialRHBalanceController= TextEditingController();

  TextEditingController _reasonForLeave = TextEditingController();
  TextEditingController _leavePeriodAddress = TextEditingController();
  TextEditingController selectedItem = TextEditingController();
  TextEditingController _hqLeaveFromTime = new TextEditingController();
  TextEditingController _hqLeaveToTime = new TextEditingController();


  List<DropdownMenuItem<String>> dropdownItems = [];
  SessionCheck sessionCheck=  SessionCheck();
  List<FileSystemEntity> files = [];

  // Timer? _timer;
  @override
  void initState() {
    _getLeaveBalanceDetails();
    _fetchLeaveOptions();
    _fetchNpsDetails();
    _getAllZones();
    _getIP();
    _getFiles();
    _getFrwAuthorities().then((_) {
      //_fetchLeavesLeft();
      setState(() {
        _isLoading = false;
        isEnabled=false;
      });
    });
    //_startTimer();
    sessionCheck.startTimer(context);

    super.initState();
  }

  @override
  void dispose() {
    frwdAuthorityController.dispose();
    _leave1FromDate.dispose();
    _leave1ToDate.dispose();
    _leaveHqFromDate.dispose();
    _leaveHqToDate.dispose();
    _initialCLBalanceController.dispose();
    _initialRHBalanceController.dispose();
    _reasonForLeave.dispose();
    _leavePeriodAddress.dispose();

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

  Future _isClRhApplied(String _leaveType) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("isLeaveAvailed");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"hrmsId": await pref.getUsername(), "leaveType": _leaveType};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    setState(() {
      if (_leaveType == 'RH') {
        _rhApplied = value;
      } else if (_leaveType == 'CL') {
        _clApplied = value;
      }
    });
  }

  Future<bool> isOverlapping(String _leaveFromDate,String _leaveToDate,String _leaveFromFnAn,String _leaveToFnAn) async{
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("is_overlapping_leave");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await pref.getUsername(),
      "fromDate": _leaveFromDate,
      "toDate":_leaveToDate,
      "fromFnAn":_leaveFromFnAn,
      "toFnAn":_leaveToFnAn
    };
    print('map $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    try {
      String result = await response.transform(utf8.decoder).join();
      print('result $result');
      setState(() {
        if (result == 'Y') {
          _leave1FromDate.text = "";
          _leave1ToDate.text = "";
          _numberOfDays = '';
          _daysDiff='';
          alertify(context, "A leave already applied in the selected period");
          isEnabled=true;
        }

      });
      if(result == 'Y'){
        return false;
      }

    }catch(e){
      isEnabled=true;
      alertify(context, "Some error occured please try again");
    }
    return true;
  }

  Future<bool> checkInitialBalance(String initialBalance, String leaveType) async {
    if (initialBalance.isNotEmpty) {
      if (leaveType == "CL") {
        double inputValue = double.parse(initialBalance);
        bool result = (inputValue - inputValue.floor()) != 0 ||
            (inputValue - inputValue.ceil()) != 0;
        if (result) {
          String decimalPart = inputValue.toString().split(".")[1];

          if (decimalPart.length > 1) {
            decimalPart = decimalPart.substring(0, 1);
          }
          if (decimalPart != "0" && decimalPart != "5") {
            print("Please enter valid CL initial balance in Leave 1 section");
            alertify(context,
                "Please enter valid CL initial balance in Leave 1 section");
            isEnabled=true;
            return false;
          }
        }
        if (inputValue > 15 || inputValue < 0) {
          print("Please enter valid CL initial balance in Leave 1 section");
          alertify(context,
              "Please enter valid CL initial balance in Leave 1 section");
          isEnabled=true;
          return false;
        }
      } else {
        double inputValue = double.parse(initialBalance);
        if (inputValue > 2 || inputValue < 0) {
          print("Please enter valid RH initial balance in Leave 1 section");
          alertify(context,
              "Please enter valid RH initial balance in Leave 1 section");
          isEnabled=true;
          return false;
        }
      }
    } else {
      print("Please enter initial leave balance in Leave section");
      alertify(
          context, "Please enter initial leave balance in Leave section");
      setState(() {
        _initialCLBalanceController.text='';
        _initialRHBalanceController.text='';
      });
      return false;
    }
    return true;
  }

  Future _getAllZones() async {
    print('Zones List');
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

    await _getAllPrimaryUnit("");
  }

  Future _getAllPrimaryUnit(String SelectedZone) async {
    print('PrimaryUnit List');
    sharedpreferencemanager pref = sharedpreferencemanager();
    if (SelectedZone == "")
      _selectZone = (await pref.getEmployeeRailwayzone())!;
    else
      _selectZone = SelectedZone;
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
    print('Department List');
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
    Map<String, dynamic> allSubDepart = {'description': 'All', 'code': ''};

    setState(() {
      if (responseJSON['sub_department'] != null) {
        subDepartmentList = responseJSON['sub_department'];
        subDepartmentList.add(allSubDepart);
        //_selectSubDepartment = subDepartmentList.first['code'].toString();
        _selectSubDepartment = '';
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
          empHrmsId = responseJSON['authoritiesList'][index]['emp_hrms_id'];

          String authorityText=responseJSON['authoritiesList']
          [index]['employee_name'] +
              ' (' +
              responseJSON['authoritiesList'][index]['emp_hrms_id'] +
              ') ' +
              responseJSON['authoritiesList'][index]['designation'];
          _listOfForwardingAuthorities.add({
            'text':authorityText,
            'emp_hrms_id':empHrmsId
          });
        }
      }
    });
  }

  Future _getFrwAuthoritiesBySearchRange() async {
    _listOfForwardingAuthorities.clear();
    empHrmsId="";
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
    print('_selectSubDepartment123 $_selectSubDepartment');
    if (subDepartmentList.length == 0)
      _selectSubDepartment = "";
    else if (_selectSubDepartment == "") {
      print('hi');
      _subDepartmentDesc = "- All Sub Department";
    } else
      _subDepartmentDesc = " - " + _subDepartmentDesc;
    print('_subDepartmentDesc $_subDepartmentDesc');
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
          empHrmsId = responseJSON['authoritiesList'][index]['emp_hrms_id'];

          String authorityText=responseJSON['authoritiesList']
          [index]['employee_name'] +
              ' (' +
              responseJSON['authoritiesList'][index]['emp_hrms_id'] +
              ') ' +
              responseJSON['authoritiesList'][index]['designation'];
          _listOfForwardingAuthorities.add({
            'text':authorityText,
            'emp_hrms_id':empHrmsId
          });
        }
      }
    });
  }

  Future _getLeaveBalanceDetails() async {
    print('okay Button Pressed');
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
    _lienUnit = (await pref.getEmployeeLienUnit())!;
    _retirementDate = (await pref.getRetirementDate())!;
    _dateOfJoining= (await pref.getEmployeeAppointmentDate())!;
    print('_dateOfJoining $_dateOfJoining');
    _retirementDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(_retirementDate));
    _dateOfJoining = DateFormat('dd/MM/yyyy').format(DateTime.parse(_dateOfJoining));

    print('_ret $_retirementDate');
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

      if (responseJSON['updation_status'].toString() == 'P')
        _provisionalMyBalMsg =
        "Wherever the leave balance is provisional, the same may change subject to verification and updation by the competent authority.";
      _balanceStatus = responseJSON['updation_status'].toString();

    });
  }

  Future<bool> _checkLeaveBalanceDetails(String _leaveType, String _leaveBalCal) async {
    //URL Request for Get Leave Balance Details
    sharedpreferencemanager pref = sharedpreferencemanager();
    String url =
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
    _lienUnit = (await pref.getEmployeeLienUnit())!;
    _retirementDate = (await pref.getRetirementDate())!;
    _retirementDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(_retirementDate));
    _dateOfJoining = (await pref.getEmployeeAppointmentDate())!;
    _dateOfJoining = DateFormat('dd/MM/yyyy').format(DateTime.parse(_dateOfJoining));

    print('_ret $_retirementDate');
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
    //url request for CL and RH Current Balance
    url = new UtilsFromHelper().getValueFromKey("isLeaveAvailed");
    client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    basicAuth = await Hrmstokenplugin.hrmsToken;
    map = {"hrmsId": await pref.getUsername(), "leaveType": _leaveType};
    request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    response = await request.close();
    value = await response.transform(utf8.decoder).join();

    setState(() {
      if (_leaveType == 'RH') {
        _rhApplied = value;
      } else if (_leaveType == 'CL') {
        _clApplied = value;
      }
    });
    if(_leaveType =='CL' && clbal=='' ){
      if(_clApplied!='0'){alertify(context,
          "Leave Balance is Incorrect. Please Refresh Leave Application");
      _hasBeenPressedSubmit=false;
      isEnabled=true;
      return false;
      }else
      {
        return true;
      }
    }
    if(_leaveType =='RH' && rhbal=='' ){
      if(_rhApplied!='0'){
        alertify(context,
            "Leave Balance is Incorrect. Please Refresh Leave Application");
        _hasBeenPressedSubmit=false;
        isEnabled=true;
        return false;
      }else
      {
        return true;
      }
    }

    if (_leaveType =='CL' && clbal==_leaveBalCal) {
      return true;
    }else if (_leaveType =='RH' && rhbal==_leaveBalCal){
      return true;
    }else if (_leaveType =='LAP' && lapbal==_leaveBalCal){
      return true;
    }else if (_leaveType =='LHAP' && lhapbal==_leaveBalCal){
      return true;
    }else
    {
      alertify(context,
          "Leave Balance is Incorrect. Please Refresh Leave Application");
      _hasBeenPressedSubmit=false;
      isEnabled=true;
      return false;
    }
  }

  Future _fetchLeaveOptions() async {
    setState(() {
      dropdownItems.add(
        DropdownMenuItem(
          value: "",
          child: Text("Please Select",
              style: TextStyle(
                fontFamily: 'Roboto', // or remove this line to use default
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "CL",
          child: Text("CASUAL LEAVE (CL)",
              style: TextStyle(
                fontFamily: 'Roboto', // or remove this line to use default
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "RH",
          child: Text("RESTRICTED HOLIDAY (RH)",
              style: TextStyle(
                fontFamily: 'Roboto', // or remove this line to use default
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "LAP",
          child: Text("LEAVE ON AVERAGE PAY (LAP)",
              style: TextStyle(
                fontFamily: 'Roboto', // or remove this line to use default
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "LHAP",
          child: Text("LEAVE ON AVERAGE HALF PAY (LHAP)",
              style: TextStyle(
                fontFamily: 'Roboto', // or remove this line to use default
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      );
    });
  }

  Future _getLeavesBalance(String _leaveType) async {
    isRHInitialBalanceVisibility=false;
    isCLInitialBalanceVisibility=false;
    isCurrentLeaveBalanceVisibility=true;
    await _isClRhApplied(
        _leaveType1!);
    setState(() {
      _leaveBal1 = _getLeavesBalanceLeftType(_leaveBal, _leaveType);

      if (_leaveBal1 == '') {
        _leaveBalCal = ''; //Actually sent in json of leave application
        _leaveBal1 = 'No Record Found';
        if (_leaveType == 'LAP' || _leaveType == 'LHAP') {
          isEnabled = false;
          alertifyBarrierDissimable(context,
              "Your Balance is not updated Please contact your dealing clerk to update the same");
          _leave1FromDate.text = "";
          _leave1ToDate.text = "";
          _daysDiff = '';
          _numberOfDays = '';

          return;
        } /*else if (_leaveType == 'CL' && _clApplied != "0" ||
            _leaveType == 'RH' && _rhApplied != "0") {
          print('Balance $_clApplied');
          print('Balance $_rhApplied');
          _initialBalMessageVisible = false;
          isEnabled = false;
          alertify(context,
              "You can not apply $_leaveType as you have already applied the leave with some initial balance which has not been approved till now.");
          _leave1FromDate.text = "";
          _leave1ToDate.text = "";
          _daysDiff = '';
          _numberOfDays = '';
          return;
        } else if (_leaveType == 'CL' && _clApplied == "0") {

         /* isEnabled=true;
          print('hi $_clApplied');
          isCLInitialBalanceVisibility=true;
          isRHInitialBalanceVisibility=false;
          isCurrentLeaveBalanceVisibility=false;
          _initialBalMessage =
          'Your Leave balance for CL is not yet updated. Please enter the current leave balance as on date. Please note that entering incorrect balance may lead to rejection of leave application, and may invite appropriate action by the competent authority.';
          _initialBalMessageVisible = true;*/
          //2 Jan 2024
          isEnabled=false;

        } else if (_leaveType == 'RH' && _rhApplied == "0") {
         /* isEnabled=true;
          print('hello $_rhApplied');
          isCLInitialBalanceVisibility=false;
          isRHInitialBalanceVisibility=true;
          isCurrentLeaveBalanceVisibility=false;
          _initialBalMessage =
          'Your Leave balance for RH is not yet updated. Please enter the current leave balance as on date. Please note that entering incorrect balance may lead to rejection of leave application, and may invite appropriate action by the competent authority.';
          _initialBalMessageVisible = true;*/
          //2 Jan 2024
          isEnabled=false;
        }*/
        isEnabled = false;
        alertifyBarrierDissimable(context,
            "You cannot apply leave of type $_leaveType as your leave balance is not updated.");
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        return;
      }else if (_leaveType1 == "CL" && _leaveBal1 != "") {
        isEnabled = true;
        if (double.parse(_leaveBal1) > 1) {
          _leaveBal1 = _leaveBal1 + ' days';
        } else {
          _leaveBal1 = _leaveBal1 + ' day';
        }
        _leaveBalCal = _getLeavesBalanceLeftType(_leaveBal1, "CL");
        _initialBalMessageVisible = false;
      } else if (_leaveType1 == "RH" && _leaveBal1 != "") {
        isEnabled = true;
        if (double.parse(_leaveBal1) > 1) {
          _leaveBal1 = _leaveBal1 + ' days';
        } else {
          _leaveBal1 = _leaveBal1 + ' day';
        }
        _leaveBalCal = _getLeavesBalanceLeftType(_leaveBal1, "RH");
        _initialBalMessageVisible = false;
      } else if (_leaveType1 == "LAP" && _leaveBal1 != "") {
        isEnabled = true;
        if (_balanceStatus == 'P') {
          _initialBalMessageVisible = true;
          _initialBalMessage = _provisionalMyBalMsg;
          _provMsg = " (Provisional)";
        }
        if (double.parse(_leaveBal1) > 1) {
          if (double.parse(_leaveBal1) > 300) {
            _leaveBal1 = "300+" +
                (double.parse(_leaveBal1) - 300).toString() +
                " days" +
                _provMsg;
          } else {
            _leaveBal1 = _leaveBal1 + " days" + _provMsg;
          }
        } else {
          _leaveBal1 = _leaveBal1 + " day" + _provMsg;
        }
        _leaveBalCal = _getLeavesBalanceLeftType(_leaveBal1, "LAP");
      } else if (_leaveType1 == "LHAP" && _leaveBal1 != "") {
        isEnabled = true;
        if (_balanceStatus == 'P') {
          _initialBalMessageVisible = true;
          _initialBalMessage = _provisionalMyBalMsg;
          _provMsg = " (Provisional)";
        }
        if (double.parse(_leaveBal1) > 1) {
          _leaveBal1 = _leaveBal1 + " days" + _provMsg;
        } else {
          _leaveBal1 = _leaveBal1 + " day" + _provMsg;
        }
        _leaveBalCal = _getLeavesBalanceLeftType(_leaveBal1, "LHAP");
      } else if(_leaveType1=="" && _leaveBal1==''){
        _initialBalMessageVisible=false;
        isEnabled=false;
      }
    });
    print('_currnetBal $_leaveBal1');
    print('_leaveBalCal $_leaveBalCal');
  }

  String _getLeavesBalanceLeftType(_leaveBal, _leaveType) {
    if (_leaveType == 'CL') {
      print('clbal $clbal');
      _leaveBal = clbal;
    } else if (_leaveType == 'RH') {
      _leaveBal = rhbal;
    } else if (_leaveType == 'LAP') {
      _leaveBal = lapbal;
    } else if (_leaveType == 'LHAP') {
      _leaveBal = lhapbal;
    } else {
      _leaveBal = 'NA';
    }
    return _leaveBal;
  }

  void _getFiles() async {
    Directory? externalStorageDir = await getApplicationDocumentsDirectory();
    Directory directory = Directory(externalStorageDir!.path);
    print('dir1213 $directory');
    if (await directory.exists()) {
      print('direxits12 yes');
      var path = directory.path;
      print('path $path');
      final pdfFiles = await directory.listSync();
      print('filesDir $pdfFiles');
      // Iterate through the files and print their names
      for (var file in pdfFiles) {
        if (file is File) {
          print(file.path);
        }
      }
    }
    List<FileSystemEntity> ListFiles = directory.listSync();
    print('ListFiles -- >$ListFiles');
    for (FileSystemEntity file in ListFiles) {
      if (file is File) {
        //fileList.add(file);
        _files?.add(file);
      }
    }
  }

  Future submitLeaveApplication() async {
    bool status=true;
    /*String _initialBalance="";
    if(_leaveType1=='CL'){
      _initialBalance=_initialCLBalanceController.text;
      print('initialBalance $_initialBalance');
      if(!isCurrentLeaveBalanceVisibility) {
        status = await checkInitialBalance(_initialBalance, _leaveType1!);
      }
    }else if(_leaveType1=='RH')
    {
      _initialBalance=_initialRHBalanceController.text;
      if(!isCurrentLeaveBalanceVisibility) {
        status = await checkInitialBalance(_initialBalance, _leaveType1!);
      }
    }*/
    status =await _checkLeaveBalanceDetails(_leaveType1!, _leaveBalCal);
    print('status $status');
    if(status) {
      if (_filePath.isNotEmpty) {
        final bytes = Io.File(_filePath).readAsBytesSync();
        _fileString = base64Encode(bytes);
      }
      sharedpreferencemanager pref = sharedpreferencemanager();
      final String url =
      new UtilsFromHelper().getValueFromKey("submit_leave_application");

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      String basicAuth = await Hrmstokenplugin.hrmsToken;

      if(_leaveBalCal.isEmpty){
        if(_leaveType1=='CL')
          _leaveBalCal=_initialCLBalanceController.text;
        else if(_leaveType1=='RH')
          _leaveBalCal=_initialRHBalanceController.text;
      }

      Map map = {
        "employeeHrmsId": await pref.getEmployeeHrmsid(),
        "employeeName": await pref.getEmployeeName(),
        "designationCode": await pref.getDesignationCode(),
        "departmentCode": await pref.getDepartmentCode(),
        "empType": empType,
        "zoneId": await pref.getEmployeeRailwayzone(),
        "unitCode": await pref.getEmployeeUnitcode(),
        "leaveType": _leaveType1,
        "currentLeaveBal": _leaveBalCal,
        "leaveFrom": _leave1FromDate.text,
        "leaveFromFnAn": _leaveFromFNAN,
        "leaveTo": _leave1ToDate.text,
        "leaveToFnAn": _leaveToFNAN,
        "numberOfDays": _daysDiff,
        "hqLeaving": _hqLeavingPermission,
        "hqLeaveFrom": _leaveHqFromDate.text ?? '',
        "hqLeaveFromTime": _leaveHqFromTimeVal,
        "hqLeaveTo": _leaveHqToDate.text ?? '',
        "hqLeaveToTime": _leaveHqToTimeVal,
        "exIndiaLeave": _goingExIndiaLeave,
        "reasonForLeave": _reasonForLeave.text,
        "leavePeriodAddress": _leavePeriodAddress.text ?? '',
        "supportingDoc": _filePath ?? '',
        "leaveApplicationFileUpload": _fileString,
        "leaveMode": "O",
        "leaveStatus": "A",
        "lienHeld":_lienUnit,
        "frwAuthority": frwdAuthoritiesHrmsId,
        "userId": await pref.getEmployeeHrmsid(),
        "ipAddress": _ipAddress,
        "gender": await pref.getEmployeeGender(),
        "frwAuthorityDetails": selectedAuthority,
        "clInitialBalance": _initialCLBalanceController.text ?? '',
        "rhInitialBalance": _initialRHBalanceController.text ?? '',
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

      setState(()  {
        if (responseJSON['status'] == true) {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: responseJSON['message'],
              onConfirmBtnTap: ()  {
                Navigator.of(context).pop();
              }
          );
          setState(() {
            _formKey.currentState?.reset();
            _leave1FromDate.clear();
            _leave1ToDate.clear();
            _leaveHqFromDate.clear();
            _leaveHqToDate.clear();
            _reasonForLeave.clear();
            _leavePeriodAddress.clear();
            _leaveType1='';
            _leaveBal1='';
            _numberOfDays='';
            selectedAuthority='';
            _initialBalMessage='';
            _filePath='';
            _initialCLBalanceController.clear();
            _initialRHBalanceController.clear();
            _getLeaveBalanceDetails();
            _errorMessage="";
          });
        } else {
          setState(() {
            _errorMessage=responseJSON['message'];
          });

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
      setState(() {
        _hasBeenPressedSubmit = false;
      });
    }
    else{

    }
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
            title: Text("New Leave Application",
                style: TextStyle(
                  fontFamily: 'Roboto', // or remove this line to use default
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ))),
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
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 10, top: 10, right: 10),
                              color: Colors.orange,
                              child: Text(
                                'Leave Application',
                                style: TextStyle(
                                  fontFamily: 'Roboto', // or remove this line to use default
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                              fontFamily: 'Roboto', // or remove this line to use default
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                          child: DropdownButtonFormField(
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
                                            value: _leaveType1,
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Leave Type is required';
                                              }
                                              return null;
                                            },
                                            onChanged: (newValue)  {
                                              setState(()    {
                                                print('_leaveType1 $_leaveType1');
                                                _leaveType1 =
                                                newValue! as String?;
                                                print(
                                                    '_leaveType1 $_leaveType1');

                                                _getLeavesBalance(
                                                    _leaveType1!);

                                                if (_leaveType1 == 'RH' ||
                                                    _leaveType1 ==
                                                        'LHAP') {
                                                  _isLeaveFromFNANEnabled =
                                                  false;
                                                  _isLeaveToFNANEnabled =
                                                  false;
                                                  _leaveToFNAN = 'AN';
                                                } else {
                                                  _isLeaveFromFNANEnabled =
                                                  true;
                                                  _isLeaveToFNANEnabled =
                                                  true;
                                                }
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
                                        child: Visibility(
                                          visible:
                                          _initialBalMessageVisible,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child: Text(
                                              _initialBalMessage,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
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

                                      Visibility(
                                        visible:isCurrentLeaveBalanceVisibility,
                                        child: Expanded(
                                          child: Text(
                                            _leaveBal1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 12),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible:isCLInitialBalanceVisibility,
                                        child: Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15.0, 0, 15, 0),
                                            padding: EdgeInsets.fromLTRB(
                                                25.0, 0.0, 25.0, 0.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFE0),
                                              borderRadius:
                                              BorderRadius.circular(0.0),
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  width: 0.30),
                                            ),
                                            child: TextFormField(
                                              controller: _initialCLBalanceController,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Enter CL Current Balance',
                                                hintStyle:  TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'CL Current Balance is required';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _initialCLBalanceController.text = value!;
                                              },
                                              onChanged: (value) {
                                                checkInitialBalance(value,_leaveType1!);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible:isRHInitialBalanceVisibility,
                                        child: Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15.0, 0, 15, 0),
                                            padding: EdgeInsets.fromLTRB(
                                                25.0, 0.0, 25.0, 0.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFE0),
                                              borderRadius:
                                              BorderRadius.circular(0.0),
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  width: 0.30),
                                            ),
                                            child: TextFormField(
                                              controller: _initialRHBalanceController,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Enter RH Current Balance',
                                                hintStyle:  TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'RH Current Balance is required';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _initialRHBalanceController.text = value!;
                                              },
                                              onChanged: (value) {
                                                checkInitialBalance(value,_leaveType1!);
                                              },
                                            ),
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
                                            enabled: isEnabled,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: 'DD/MM/YYYY',
                                              hintStyle:  TextStyle(
                                                  fontSize: 11,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            // keyboardType: TextInputType.datetime,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Leave From date is required';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _leave1FromDate.text = value!;
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
                                            enabled: isEnabled,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: 'DD/MM/YYYY',
                                              hintStyle:  TextStyle(
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
                                            onChanged: _isLeaveToFNANEnabled
                                                ? (String? newValue) {
                                              print('To newValue $newValue');
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
                                        child: Container(
                                          height: 14,
                                          margin: EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _diffDaysVisible,
                                        child: Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 15, 0),
                                            child: Text(
                                              textAlign: TextAlign.right,
                                              _numberOfDays,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
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
                          ],
                        ),
                        //--- leave 1 Ends ---//
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
                                            dropdownColor:
                                            Color(0xFFF2F2F2),
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
                                                  //_goingExIndiaLeave = 'N';
                                                } else {
                                                  _hqLeaveFromToView =
                                                  false;
                                                  _exIndiaLeaveView = false;
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
                                  SizedBox(height: 15),
                                  Visibility(
                                    visible: _exIndiaLeaveView,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child: Text(
                                              'If you are applying for Ex India Leave, please apply from web browser. ',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        /*Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFFE0),
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
                                                    value: 'N',
                                                    onChanged: (newValue) {
                                                      setState(() {});
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
                                                    ],
                                                  ),
                                                ),
                                              ),*/
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
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    25.0,
                                                    0.0,
                                                    25.0,
                                                    0.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      0.0),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    style:
                                                    BorderStyle.solid,
                                                    width: 0.30,
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                  _leaveHqFromDate,
                                                  readOnly: true,
                                                  decoration:
                                                  InputDecoration(
                                                    hintText: 'DD/MM/YYYY',
                                                    hintStyle:  TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Leave HQ From date is required';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _leaveHqFromDate.text =
                                                    value!;
                                                  },
                                                  onTap: () {
                                                    _selectHqLeaveFromDate(
                                                        context);
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Expanded(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _hqLeaveFromTime,
                                                  decoration: InputDecoration(
                                                    hintText: 'HH : MM',
                                                    hintStyle:  TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                    contentPadding: EdgeInsets.all(8),
                                                    border: new OutlineInputBorder(
                                                      borderRadius:
                                                      new BorderRadius.circular(15.0),
                                                      borderSide: new BorderSide(),
                                                    ),
                                                    prefixIcon: Icon(Icons.alarm),
                                                  ),
                                                  /*validator: (value) {
                                                            if (value!.isEmpty) {
                                                              return 'Leave HQ From Time is required';
                                                            }
                                                            return null;
                                                          },*/
                                                  onSaved: (value) {
                                                    _hqLeaveFromTime.text =
                                                    value!;
                                                  },
                                                  onTap: () {
                                                    _selectHqLeaveFromTime();
                                                  },
                                                )
                                            ),
                                            SizedBox(height: 8),
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
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    25.0,
                                                    0.0,
                                                    25.0,
                                                    0.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF2F2F2),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      0.0),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    style:
                                                    BorderStyle.solid,
                                                    width: 0.30,
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  controller:
                                                  _leaveHqToDate,
                                                  readOnly: true,
                                                  decoration:
                                                  InputDecoration(
                                                    hintText: 'DD/MM/YYYY',
                                                    hintStyle:  TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Leave HQ Upto is required';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _leaveHqToDate.text =
                                                    value!;
                                                  },
                                                  onTap: () {
                                                    _selectHqLeaveToDate(
                                                        context);
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            /*Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.fromLTRB(
                                                          15.0, 0, 15, 0),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              0.0,
                                                              25.0,
                                                              0.0),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFFFFFE0),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          style:
                                                              BorderStyle.solid,
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
                                                            checkLeaveHqFnAn(
                                                                context,
                                                                _leaveHqToFNAN!);
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
                                                                  "1st Half",
                                                                  style:
                                                                      TextStyle(
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
                                                                  "2nd Half",
                                                                  style:
                                                                      TextStyle(
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
                                                  ),*/
                                            Expanded(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _hqLeaveToTime,
                                                  decoration: InputDecoration(
                                                    hintText: 'HH : MM',
                                                    hintStyle:  TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                    contentPadding: EdgeInsets.all(8),
                                                    border: new OutlineInputBorder(
                                                      borderRadius:
                                                      new BorderRadius.circular(15.0),
                                                      borderSide: new BorderSide(),
                                                    ),
                                                    prefixIcon: Icon(Icons.alarm),
                                                  ),
                                                  /*validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Leave HQ To Time is required';
                                                          }
                                                          return null;
                                                        },*/
                                                  onSaved: (value) {
                                                    _hqLeaveToTime.text =
                                                    value!;
                                                  },
                                                  onTap: () {
                                                    _selectHqLeaveToTime();
                                                  },
                                                )
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
                                                  '',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            /*Visibility(
                                                    visible: _hqDiffDaysVisible,
                                                    child: Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 15, 0),
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.right,
                                                          _numberOfHqDays,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.red,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),*/
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                  //  Ex India  Leave From To Date   //

                                  //Address Starts
                                  Visibility(
                                    visible: _hqLeaveFromToView,
                                    // Set the visibility based on a boolean value
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 14,
                                          margin: EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
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
                                                BorderRadius.circular(
                                                    0),
                                              ),
                                            ),
                                            onSaved: (value) {
                                              _leavePeriodAddress.text =
                                              value!;
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
                                          print('remarks is empty');
                                          return 'Enter Reason For Leave Upto 300 characters';
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
                                  Container(
                                    width: double.infinity,
                                    child: RichText(
                                      text: TextSpan(
                                        text:'Upload Approval Document *',
                                        style: TextStyle(fontSize: 11.0,fontWeight: FontWeight.bold, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' (only pdf less than 2MB) ',
                                            style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold, color: Colors.red),
                                          ),
                                        ],
                                      ),
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
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    5, 7, 5, 7),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .lightBlueAccent)),
                                                //             <--- BoxDecoration here
                                                child: GestureDetector(
                                                    onTap: () async {
                                                      Fluttertoast
                                                          .showToast(
                                                          msg:
                                                          'Please Wait...',
                                                          toastLength: Toast
                                                              .LENGTH_LONG,
                                                          gravity:
                                                          ToastGravity
                                                              .BOTTOM,
                                                          // timeInSecForIos: 5,
                                                          backgroundColor:
                                                          Colors
                                                              .pink,
                                                          textColor:
                                                          Colors
                                                              .white,
                                                          fontSize:
                                                          14.0);

                                                      /*result =
                                                                await Navigator
                                                                    .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FileList()),
                                                            );*/
                                                      setState(() {
                                                        //_filePath = result;
                                                        getExternalStorageFiles();
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
                                                  _filePath=="" ?
                                                  "No file chosen":_filePath,
                                                  style: TextStyle(
                                                      fontSize: 10.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                          child: Text(_errorMessage,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 12),
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
                                      print(
                                          "Submit Application button pressed!");
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
                                            submitLeaveApplication();
                                            setState(() {
                                              _hasBeenPressedSubmit = true;
                                            });
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
                        SizedBox(
                          height: 20,
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
                                      print('on callback $_selectZone');
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
                                      })
                              ),
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
                                            ((_tempListOfForwardingAuthorities !=
                                                null &&
                                                _tempListOfForwardingAuthorities!
                                                    .length >
                                                    0)
                                                ? _tempListOfForwardingAuthorities![
                                            index]['text']
                                                : _listOfForwardingAuthorities[
                                            index]['text']) ,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )));
                                      setState(() {
                                        this.selectedAuthority =
                                        ((_tempListOfForwardingAuthorities !=
                                            null &&
                                            _tempListOfForwardingAuthorities!
                                                .length >
                                                0)
                                            ? _tempListOfForwardingAuthorities![
                                        index]['text']
                                            : _listOfForwardingAuthorities[
                                        index]['text']) ;
                                        //get Authorities HRMS ID

                                       /* RegExp regExp = RegExp(r"\((.*?)\)");
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
                                        }*/
                                        var selectedItem =_listOfForwardingAuthorities.firstWhere(
                                              (item) => item['text'] == selectedAuthority,
                                          orElse: () => {},  // Return an empty map if no match is found
                                        );
                                        print('selectedItem23 $selectedItem');
                                        //String? selectedEmpHrmsId = selectedItem != null ? selectedItem['emp_hrms_id'] : null;

                                        if (selectedItem != null) {
                                          print(
                                              "frwdAuthoritiesHrmsEmployeeId12: $selectedItem['emp_hrms_id']");
                                          frwdAuthoritiesHrmsId =
                                          selectedItem['emp_hrms_id'];
                                          print('frwdAuthoritiesHrmsId $frwdAuthoritiesHrmsId');
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
  Widget _showBottomSheetWithSearch(int index, List<Map<String, dynamic>> listOfFrwdAuthorities) {
    String frwdAuthority=listOfFrwdAuthorities[index]['text'];
    print('frwdAuthority $frwdAuthority');
    return Text(frwdAuthority,
        style: TextStyle(color: Colors.black, fontSize: 16),
        textAlign: TextAlign.center);
  }

  //9
  List<Map<String, dynamic>> _buildSearchList(String userSearchTerm) {
    List<Map<String,dynamic>> _searchList = [];

    for (int i = 0; i < _listOfForwardingAuthorities.length; i++) {
      Map<String, dynamic> item = _listOfForwardingAuthorities[i];
      // Check if any relevant field contains the search term
      String employeeName = item['employee_name']?.toLowerCase() ?? '';
      String empHrmsId = item['emp_hrms_id']?.toLowerCase() ?? '';
      String designation = item['designation']?.toLowerCase() ?? '';

      if (employeeName.contains(userSearchTerm.toLowerCase()) ||
          empHrmsId.contains(userSearchTerm.toLowerCase())||
          designation.contains(userSearchTerm.toLowerCase())) {
        _searchList.add(item);
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
    if (_leave1FromDate.text != "") {
      print('_leave1 ${_leave1FromDate.text}');
      List<String> mdy1 = _leave1FromDate.text.split('/');
      print('mdy1 $mdy1');
      DateTime fromDate =
      DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      print('fromDate $fromDate');
      List<String> mdy2 = _retirementDate.split('/');

      DateTime retirementDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));
      print('retirement $retirementDate');
      if (fromDate.isAfter(retirementDate)) {
        String message = "Leave From Date cannot be after retirement date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      mdy2 = _dateOfJoining.split('/');

      DateTime joiningDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      if(fromDate.isBefore(joiningDate)){
        String message = "Leave From Date cannot be before appointment date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      var currDate=DateFormat('dd/MM/yyyy').format(DateTime.now());
      var cd =currDate.split('/');
      var today =
      DateTime(int.parse(cd[2]), int.parse(cd[1]), int.parse(cd[0]));
      _daysDiff =
          (fromDate.difference(today).inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      print('daysDiff $_daysDiff');
      if((_leaveType1=='CL'||_leaveType1=='RH') && _daysDiff>31){
        String message = "You can not apply $_leaveType1 leave of after one month.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if(_daysDiff>120){
        String message = "Leave from date can not be after 120 days from current date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if((_leaveType1=='CL'||_leaveType1=='RH') && fromDate.year>today.year){
        String message = "You can not apply next year $_leaveType1 through Mobile App. Please apply it through Web Application.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if((_leaveType1=='CL'||_leaveType1=='RH') && fromDate.year<today.year){
        String message = "You can not apply previous year $_leaveType1 through Mobile App. Please apply it through Web Application";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if(_daysDiff<-60){
        String message = "Leave end date can not be before 60 days from current date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
    }

    if (_leave1ToDate.text != "") {
      print('_leave1 ${_leave1ToDate.text}');
      List<String> mdy2 = _leave1ToDate.text.split('/');
      DateTime toDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      List<String> rd = _retirementDate.split('/');
      DateTime retirementDate =
      DateTime(int.parse(rd[2]), int.parse(rd[1]), int.parse(rd[0]));
      if (toDate.isAfter(retirementDate)) {
        String message = "Leave Upto date can not be after retirement date";
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        alertify(context, message);
        return;
      }
    }
    if (_leave1FromDate.text != "" && _leave1ToDate.text != "") {
      List<String> mdy1 = _leave1FromDate.text.split('/');
      DateTime fromDate =
      DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      List<String> mdy2 = _leave1ToDate.text.split('/');
      DateTime toDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      _daysDiff =
          (toDate
              .difference(fromDate)
              .inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      if (toDate.isBefore(fromDate)) {
        String message =
            "'Leave Upto' date can not be before 'Leave From' date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      bool result = await validateLeaveFnAn(
          _leaveType1!, _leave1FromDate.text, _leave1ToDate.text,
          _leaveFromFNAN!, _leaveToFNAN!);
      if (result) {
        if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'AN') {
          _daysDiff = _daysDiff + 1;
        } else if (_leaveFromFNAN == 'AN' && _leaveToFNAN == 'AN') {
          _daysDiff = _daysDiff + 0.5;
        } else if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'FN') {
          _daysDiff = _daysDiff + 0.5;
        }
        if (_daysDiff > 0) {
          if (_leaveBalCal != '' && _daysDiff > double.parse(_leaveBalCal)) {
            String message =
                "Days for which leave applied cannot be greater than the current available balance.";
            alertify(context, message);
            _leave1FromDate.text = "";
            _leave1ToDate.text = "";
            _daysDiff = '';
            _numberOfDays = '';
            isEnabled=true;
            return;
          }
          String dayName = "";
          if (_daysDiff > 1) {
            _numberOfDays = _daysDiff.toString();
            dayName = " days";
          } else {
            _numberOfDays = _daysDiff.toString();
            dayName = " day";
          }
          setState(() {
            _diffDaysVisible = true;
            _daysDiff = _daysDiff;
            _numberOfDays = _numberOfDays + dayName;

            print('1_numberOfDays $_numberOfDays');
          });
        } else {
          String message = "Please select valid leave period.";
          alertify(context, message);
          _leave1FromDate.text = "";
          _leave1ToDate.text = "";
          _daysDiff = '';
          _numberOfDays = '';
          isEnabled=true;
          return;
        }
      }
    }
  }

  Future<void> _selectLeave1ToDate(BuildContext context) async {
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
    if (_leave1ToDate.text != "") {
      print('_leave1 ${_leave1ToDate.text}');
      List<String> mdy2 = _leave1ToDate.text.split('/');
      DateTime toDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));
      print('_retirementDate $_retirementDate');
      List<String> rd = _retirementDate.split('/');
      DateTime retirementDate =
      DateTime(int.parse(rd[2]), int.parse(rd[1]), int.parse(rd[0]));
      if (toDate.isAfter(retirementDate)) {
        String message = "You cannot apply leave after the retirement date.";
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        alertify(context, message);
        return;
      }
      mdy2 = _dateOfJoining.split('/');

      DateTime joiningDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));
      print('to Date Joining Date $joiningDate');
      if(toDate.isBefore(joiningDate)){
        String message = "Leave To Date cannot be before appointment date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      var currDate=DateFormat('dd/MM/yyyy').format(DateTime.now());
      var cd =currDate.split('/');
      var today =
      DateTime(int.parse(cd[2]), int.parse(cd[1]), int.parse(cd[0]));
      _daysDiff =
          (toDate.difference(today).inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      print('daysDiff $_daysDiff');
      if((_leaveType1=='CL'||_leaveType1=='RH') && _daysDiff>31){
        String message = "You can not apply $_leaveType1 leave of after one month.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if(_daysDiff>120){
        String message = "Leave from date can not be after 120 days from current date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if((_leaveType1=='CL'||_leaveType1=='RH') && toDate.year>today.year){
        String message = "You can not apply next year $_leaveType1 through Mobile App. Please apply it through Web Application.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if((_leaveType1=='CL'||_leaveType1=='RH') && toDate.year<today.year){
        String message = "You can not apply previous year $_leaveType1 through Mobile App. Please apply it through Web Application";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      if(_daysDiff<-60){
        String message = "Leave end date can not be before 60 days from current date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
    }

    if (_leave1FromDate.text != "" && _leave1ToDate.text != "") {
      List<String> mdy1 = _leave1FromDate.text.split('/');
      DateTime fromDate =
      DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      List<String> mdy2 = _leave1ToDate.text.split('/');
      DateTime toDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      _daysDiff =
          (toDate
              .difference(fromDate)
              .inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      if (toDate.isBefore(fromDate)) {
        String message =
            "'Leave Upto' date can not be before 'Leave From' date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        _daysDiff = '';
        _numberOfDays = '';
        isEnabled=true;
        return;
      }
      bool result = await validateLeaveFnAn(
          _leaveType1!, _leave1FromDate.text, _leave1ToDate.text,
          _leaveFromFNAN!, _leaveToFNAN!);
      if (result) {
        if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'AN') {
          _daysDiff = _daysDiff + 1;
        } else if (_leaveFromFNAN == 'AN' && _leaveToFNAN == 'AN') {
          _daysDiff = _daysDiff + 0.5;
        } else if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'FN') {
          _daysDiff = _daysDiff + 0.5;
        }
        if (_daysDiff > 0) {
          if (_leaveBalCal != '' && _daysDiff > double.parse(_leaveBalCal)) {
            String message =
                "Days for which leave applied cannot be greater than the current available balance.";
            alertify(context, message);
            _leave1FromDate.text = "";
            _leave1ToDate.text = "";
            _daysDiff = '';
            _numberOfDays = '';
            isEnabled=true;
            return;
          }
          String dayName = "";
          if (_daysDiff > 1) {
            _numberOfDays = _daysDiff.toString();
            dayName = " days";
          } else {
            _numberOfDays = _daysDiff.toString();
            dayName = " day";
          }
          setState(() {
            _diffDaysVisible = true;
            _numberOfDays = _numberOfDays + dayName;
            _daysDiff = _daysDiff;
          });
        } else {
          String message = "Please select valid leave period.";
          alertify(context, message);
          _leave1FromDate.text = "";
          _leave1ToDate.text = "";
          _daysDiff = '';
          _numberOfDays = '';
          isEnabled=true;
          return;
        }
      }
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
    if (_leaveHqFromDate.text != "" && _leaveHqToDate.text != "") {
      List<String> mdy1 = _leaveHqFromDate.text.split('/');
      DateTime hqFromDate =
      DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      List<String> mdy2 = _leaveHqToDate.text.split('/');
      DateTime hqToDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      /*_hqDaysDiff = (hqToDate.difference(hqFromDate).inMilliseconds /
              (1000 * 60 * 60 * 24))
          .round();*/
      if (hqToDate.isBefore(hqFromDate)) {
        String message =
            "'HQ Leave Upto' date can not be before 'HQ Leave From' date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        isEnabled=true;
        return;
      }
      /*if (_leaveHqFromFNAN == 'FN' && _leaveHqToFNAN == 'AN') {
        _hqDaysDiff = _hqDaysDiff + 1;
      } else if (_leaveHqFromFNAN == 'AN' && _leaveHqToFNAN == 'AN') {
        _hqDaysDiff = _hqDaysDiff + 0.5;
      } else if (_leaveHqFromFNAN == 'FN' && _leaveHqToFNAN == 'FN') {
        _hqDaysDiff = _hqDaysDiff + 0.5;
      }
      String dayName = "";
      if (_hqDaysDiff > 0) {
        if (_hqDaysDiff > 1) {
          _hqDaysDiff = _hqDaysDiff;
          dayName = ' days';
        } else {
          _hqDaysDiff = _hqDaysDiff;
          dayName = ' day';
        }
        setState(() {
          _hqDiffDaysVisible = true;
          _numberOfHqDays = _hqDaysDiff.toString() + dayName;
        });
      } else {
        String message = "Please select valid HQ leave period.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        return;
      }*/
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
    if (_leaveHqFromDate.text != "" && _leaveHqToDate.text != "") {
      List<String> mdy1 = _leaveHqFromDate.text.split('/');
      DateTime hqFromDate =
      DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      List<String> mdy2 = _leaveHqToDate.text.split('/');
      DateTime hqToDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      /*_hqDaysDiff = (hqToDate.difference(hqFromDate).inMilliseconds /
              (1000 * 60 * 60 * 24))
          .round();*/
      print('No of days $_hqDaysDiff');
      if (hqToDate.isBefore(hqFromDate)) {
        String message =
            "'HQ Leave Upto' date can not be before 'HQ Leave From' date.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        isEnabled=true;
        return;
      }
      /*if (_leaveHqFromFNAN == 'FN' && _leaveHqToFNAN == 'AN') {
        _hqDaysDiff = _hqDaysDiff + 1;
      } else if (_leaveHqFromFNAN == 'AN' && _leaveHqToFNAN == 'AN') {
        _hqDaysDiff = _hqDaysDiff + 0.5;
      } else if (_leaveHqFromFNAN == 'FN' && _leaveHqToFNAN == 'FN') {
        _hqDaysDiff = _hqDaysDiff + 0.5;
      }

      String dayName = "";
      if (_hqDaysDiff > 0) {
        if (_hqDaysDiff > 1) {
          _hqDaysDiff = _hqDaysDiff;
          dayName = " days";
        } else {
          _hqDaysDiff = _hqDaysDiff;
          dayName = " day";
        }
        setState(() {
          _hqDiffDaysVisible = true;
          _numberOfHqDays = _hqDaysDiff.toString() + dayName;
        });
      } else {
        String message = "Please select valid HQ leave period.";
        alertify(context, message);
        _leave1FromDate.text = "";
        _leave1ToDate.text = "";
        return;
      }*/
    }
  }

  void alertify(BuildContext context, String message) {
    isEnabled = false;
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

  void alertifyBarrierDissimable(BuildContext context, String message) {
    isEnabled = false;
    showDialog(
      context: context,
      barrierDismissible: false,
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
          (toDate
              .difference(fromDate)
              .inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      if (toDate.isBefore(fromDate)) {} else
      if (toDate.isAfter(fromDate)) {} else {
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
      bool result = await validateLeaveFnAn(
          _leaveType1!, _leave1FromDate.text, _leave1ToDate.text,
          _leaveFromFNAN!, _leaveToFNAN!);
      if (result) {
        if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'AN') {
          _daysDiff = _daysDiff + 1;
        } else if (_leaveFromFNAN == 'AN' && _leaveToFNAN == 'AN') {
          _daysDiff = _daysDiff + 0.5;
        } else if (_leaveFromFNAN == 'FN' && _leaveToFNAN == 'FN') {
          _daysDiff = _daysDiff + 0.5;
        }
        String dayName = "";
        if (_daysDiff > 1) {
          _numberOfDays = _daysDiff.toString();
          dayName = " days";
        } else {
          _numberOfDays = _daysDiff.toString();
          dayName = " day";
        }
        setState(() {
          _diffDaysVisible = true;
          _numberOfDays = _daysDiff.toString() + dayName;
        });
      }
    }
  }

  Future<bool> validateLeaveFnAn(String _leaveType,String _leaveFromDate,String _leaveToDate,String _leaveFromFnAn,String _leaveToFnAn) async {
    print('validateLeaveFnAn');
    sharedpreferencemanager pref = sharedpreferencemanager();
    var f =true;
    bool res=true;
    if(_leaveType!='CL'){
      String? rlyUnit = await pref.getEmployeeUnitcode();
      String? rlyGroup = await pref.getEmployeeRailwayGroup();
      bool isWorkshop = rlyUnit?.substring(rlyUnit.length-1)=='W'?true:false;
      print('isWorkshop $isWorkshop');
      print('railway Group $rlyGroup');
      if(_leaveType=='LAP' && (_leaveFromFnAn!='FN'||_leaveToFnAn!='AN')){
        if(!isWorkshop || (rlyGroup!='C' && rlyGroup!='D')){
          alertify(context, "Half day LAP can not be applied");
          isEnabled=true;
          f = false;
        }
      }else if(_leaveType!='LAP' && (_leaveFromFnAn!='FN'||_leaveToFnAn!='AN')){
        alertify(context, "Half day $_leaveType can not be applied");
        isEnabled=true;
        f = false;
      }
    }
    if(!f){
      setState(() {
        print('Before _leaveFromFnAn $_leaveFromFnAn');
        _leaveToFNAN= _leaveToFnAn == 'FN'?'AN':'FN';
        print('After _leaveToFNAN $_leaveToFNAN');
      });
    }else
    {
      res= await isOverlapping( _leaveFromDate, _leaveToDate, _leaveFromFnAn, _leaveToFnAn);
    }
    return res;
  }

  Future<void> checkLeaveHqFnAn(
      BuildContext context, String _SelectedLeaveHqFnAn) async {
    if (_leaveHqFromDate.text != "" && _leaveHqToDate.text != "") {
      List<String> mdy1 = _leaveHqFromDate.text.split('/');
      DateTime fromDate =
      DateTime(int.parse(mdy1[2]), int.parse(mdy1[1]), int.parse(mdy1[0]));
      List<String> mdy2 = _leaveHqToDate.text.split('/');
      DateTime toDate =
      DateTime(int.parse(mdy2[2]), int.parse(mdy2[1]), int.parse(mdy2[0]));

      _hqDaysDiff =
          (toDate.difference(fromDate).inMilliseconds / (1000 * 60 * 60 * 24))
              .round();
      if (toDate.isBefore(fromDate)) {
      } else if (toDate.isAfter(fromDate)) {
      } else {
        if (_leaveHqFromFNAN == 'AN' && _leaveHqToFNAN == 'FN') {
          String message =
              "'Hq Leave From' and 'Hq Leave Upto' date is same. So it can not be from Afternoon to Forenoon.";
          setState(() {
            _leaveHqFromFNAN = _SelectedLeaveHqFnAn == 'FN' ? 'AN' : 'FN';
            _leaveHqToFNAN = _SelectedLeaveHqFnAn == 'FN' ? 'AN' : 'FN';
          });
          alertify(context, message);
          return;
        }
      }
      if (_leaveHqFromFNAN == 'FN' && _leaveHqToFNAN == 'AN') {
        _hqDaysDiff = _hqDaysDiff + 1;
      } else if (_leaveHqFromFNAN == 'AN' && _leaveHqToFNAN == 'AN') {
        _hqDaysDiff = _hqDaysDiff + 0.5;
      } else if (_leaveHqFromFNAN == 'FN' && _leaveHqToFNAN == 'FN') {
        _hqDaysDiff = _hqDaysDiff + 0.5;
      }
      print('_hqDaysDiff from $_hqDaysDiff');
      String dayName = "";
      if (_hqDaysDiff > 1) {
        _hqDaysDiff = _hqDaysDiff;
        dayName = " days";
      } else {
        _hqDaysDiff = _hqDaysDiff;
        dayName = " day";
      }
      setState(() {
        _hqDiffDaysVisible = true;
        //_numberOfHqDays = _hqDaysDiff.toString() + dayName;
      });
    }
  }
  TimeOfDay _hqLeaveFromTimeConst = TimeOfDay.now();
  void _selectHqLeaveFromTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _hqLeaveFromTimeConst,

    );
    if (newTime != null) {
      setState(() {
        _hqLeaveFromTimeConst = newTime;
        _hqLeaveFromTime.text=_hqLeaveFromTimeConst.format(context);
        print('_hqLeaveFromTime ${_hqLeaveFromTime.text}');

        final parsedTime = DateFormat('hh:mm a').parse(_hqLeaveFromTime.text);
        final formattedHqLeaveFromTime = DateFormat('HH:mm').format(parsedTime);
        print('Converted Time HQ Leave From (24-hour format): $formattedHqLeaveFromTime');
        _leaveHqFromTimeVal=formattedHqLeaveFromTime;
      });
    }
  }
  TimeOfDay _hqLeaveToTimeConst = TimeOfDay.now();
  void _selectHqLeaveToTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _hqLeaveToTimeConst,

    );
    if (newTime != null) {
      setState(() {
        _hqLeaveToTimeConst = newTime;
        _hqLeaveToTime.text=_hqLeaveToTimeConst.format(context);
        print('_hqLeaveToTime ${_hqLeaveToTime.text}');
        final parsedTime = DateFormat('hh:mm a').parse(_hqLeaveToTime.text);
        final formattedHqLeaveToTime = DateFormat('HH:mm').format(parsedTime);
        print('Converted Time HQ Leave To (24-hour format): $formattedHqLeaveToTime');
        _leaveHqToTimeVal=formattedHqLeaveToTime;
      });
    }
  }

  void getExternalStorageFiles() async {
    if(Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        Directory externalStorageDir = Directory(
            '/storage/emulated/0/Download/');
        List<FileSystemEntity>? _files;

        String directory  = await externalStorageDir.path;

        _files = Directory('/storage/emulated/0/Download/')?.listSync(
            recursive: true, followLinks: false);
        print('path1234 ${_files!.length}');
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: true,
          dialogTitle: 'Select PDF Files',
          withData: true,
          withReadStream: true,
          initialDirectory: directory,
        );
        /*for (FileSystemEntity file in _files) {
          if (file is File) {
            print('File: ${file.path}');
            _filePath=file.path;
          } else if (file is Directory) {
            print('Directory: ${file.path}');
            _filePath=file.path;
          }

        }*/



        print('_filePath $_filePath');

        setState(() {
          //files = _files!;
          if (result != null) {
            setState(() {
              // Convert List<PlatformFile> to List<FileSystemEntity>
              files = result.files.map((file) => File(file.path??''))
                  .where((file) => file.lengthSync() < 2 * 1024 * 1024).toList();
              File file = File(result.files.single.path!);
              _filePath= file.path;
              Fluttertoast.showToast(
                  msg: _filePath,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  // timeInSecForIos: 5,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 14.0);
            });
          }
        });
        print("files:-> $files");

      }
      else {
        print('Permission denied');
      }
    }
    else {
      // List<FileSystemEntity> FileList;
      final directory = await getTemporaryDirectory();
      final dir = directory.path;
      String pdfDirectory = '$dir/';
      print("pdfDirectory:-> $pdfDirectory");
      final myDir = Directory(pdfDirectory);
      String dire = await myDir.path;

      bool hasExisted = await myDir.existsSync();
      print("hasExisted $hasExisted");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
        dialogTitle: 'Select PDF Files',
        withData: true,
        withReadStream: true,
        initialDirectory: dire,
      );
      if (hasExisted) {
        //files = myDir.listSync(recursive: true, followLinks: false);
        //files = myDir.listSync();
        if (result != null) {
          setState(() {
            // files = files;
            files = result.files.map((file) => File(file.path ?? ''))
                .where((file) => file.lengthSync() < 2 * 1024 * 1024).toList();
            File file = File(result.files.single.path!);
            _filePath = file.path;
            Fluttertoast.showToast(
                msg: _filePath,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                // timeInSecForIos: 5,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 14.0);
          });
        }
      }
      print("files:-> $files");
    }

  }

/*void _startTimer() {
    print('_startTimer');
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 5), () {
      _timer?.cancel();
      _timer = null;
      sessionAlertify(context, "Your Session is expired. Please login again");

    });
  }
  void _handleInteraction([_]) {
    _startTimer();
  }
  Future<void> sessionAlertify(BuildContext context, String message) async {

    sharedpreferencemanager pref = sharedpreferencemanager();
    String? pin =await pref.getuserpin()??"";
    var keyPrint = await pref.isfingerPrint();
    var username = await pref.getEmployeeName();
    print('get User Pin $pin');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (keyPrint == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fingerprintmain(username!)), (_) => false
                  );

                }else if(pin.isNotEmpty) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Pinverify()), (_) => false
                  );
                }else
                {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()), (_) => false
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
*/
}



