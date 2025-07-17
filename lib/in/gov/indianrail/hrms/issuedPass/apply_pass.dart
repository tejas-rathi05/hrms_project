import 'dart:convert';
import 'dart:io';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/pass/passApplication_newUI.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:network_info_plus/network_info_plus.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//import 'package:wifi/wifi.dart';

import 'Station_List.dart';
import 'cancelPass.dart';
import 'familyedit_col.dart';
import 'memberEdit_col.dart';

bool _hasBeenPressed = false;

class NewPass extends StatefulWidget {
  var passType, year, setType, upgradedPass, newordraft, application_no;

  NewPass(this.passType, this.year, this.setType, this.upgradedPass,
      this.newordraft, this.application_no);

  @override
  NewPassState createState() => NewPassState();
}

class NewPassState extends State<NewPass> {
  int totalFamily = 0;

  getCheckboxItems() {
    for (int i = 0; i < family_list.length; i++) {
      late String date_string;
      if (family_list[i].member_date_of_birth.toString() != "") {
        DateTime todayDate_exp =
            DateTime.parse(family_list[i].member_date_of_birth.toString());
        date_string = DateFormat('dd/MM/yyyy').format(todayDate_exp);
      }
      if (family_list[i].isChecked == true) {
        setState(() {
          totalFamily = 1;
        });

        myObject = {
          "familyMemberSrNo": family_list[i].family_member_sr_no.toString(),
          "memberAge": family_list[i].age.toString(),
          "memberName": family_list[i].member_name.toString(),
          "includeMember": "Y",
          "relativeFlag": family_list[i].relation_flag_description.toString(),
          "relation_description":
              family_list[i].relation_description.toString(),
          "memberDateOfBirth": date_string.toString(), //dd-mm-yyyy
          "gender": family_list[i].gender.toString()
        };

        setState(() {
          send.removeAt(i);
          send.insert(i, myObject);
        });
      } else {
        if (send.length > 0) {
          print(send.toString());
          myObject = {
            "familyMemberSrNo": family_list[i].family_member_sr_no.toString(),
            "memberAge": family_list[i].age.toString(),
            "memberName": family_list[i].member_name.toString(),
            "includeMember": "N",
            "relativeFlag": family_list[i].relation_flag_description.toString(),
            "relation_description":
                family_list[i].relation_description.toString(),
            "memberDateOfBirth": date_string.toString(), //dd-mm-yyyy
            "gender": family_list[i].gender.toString()
          };

          setState(() {
            myObject["includeMember"] = "N";
            send.removeAt(i);

            send.insert(i, myObject);
          });
        } else {
          setState(() {
            totalFamily = 0;
          });
        }
      }
    }
  }

  GroupController multipleCheckController = GroupController(
    isMultipleSelection: true,
    initSelectedItem: List.generate(10, (index) => index),
  );
  bool _hasBeenPressed_draft = false;
  bool _hasBeenPressed_Alternate = false;
  late List<Map<String, dynamic>> api_family_list;
  var draft_passId;
  String text_attendent_upgrade = "";
  String currentText = "";
  String attendantTravelling = "N";
  String _upgradedpass = "N";
  String companionTravelling = "N";
  String ipAddress="127.0.0.1";
  bool flag_attendentTrav_view = false;
  bool _upgradedPassView=false;
  bool flag_famlimember = false;
  bool flag_attendentTrav = false;
  bool flag_upgradedPass = false;
  bool upgradedPassContainsA = false;
  bool carryCycleVisible = true;
  bool carryCycleFlag = false;
  bool RouteStationOption = false;
  String carryCycle = "N";
  String routeFlag = "";
  bool flag_viajourneyCheckBok = false;
  bool flag_viajourneyView = false;
  bool via_journey_view = false;
  bool flag_companionTrav = false;
  bool flag_return_journey = false;
  bool submit_flag = false;
  bool loading = true;
  sharedpreferencemanager pref = sharedpreferencemanager();

  // stationviaOutBreak,stationviaInBreak,
  // final String stationviaBreak;
  late List<StationCode> station_code;
  final _focusNode = FocusNode();
  bool break_journy_view = false;

  List<String> stationdes = [];
  List<FamilyEditCol> family_list = [];
  List<MemberEditCol> memberEdit1 = [];
  late List<Map<String, dynamic>> memberEdit;
  late Map<String, dynamic> myObject;
  late Map<String, dynamic> employee_details;
  List<Map<String, dynamic>> send = [];

  var application_no = "";
  final station_out_from = TextEditingController();
  final staion_out_des = TextEditingController();
  final station_out_to = TextEditingController();
  final staion_out_to_des = TextEditingController();
  final station_in_from = TextEditingController();
  final staion_in_from_des = TextEditingController();
  final station_in_to = TextEditingController();
  final staion_in_to_des = TextEditingController();
  final break_station = TextEditingController();
  final break_station_des = TextEditingController();
  final break_station_list = TextEditingController();
  final break_station_return = TextEditingController();

  final via_station = TextEditingController();
  final via_station_des = TextEditingController();
  final via_station_list = TextEditingController();
  final via_station_return = TextEditingController();

  // === ADD THESE TWO NEW CONTROLLERS ===
  late TextEditingController _stationOutDescController;
  late TextEditingController _stationOutFromController;
  late TextEditingController _breakStationDescController;
  late TextEditingController _viaStationDescController;


  late List<StationList> station_suggestion;
  late List<bool> _isChecked;
  bool checked = false;
  String optedDistance = "";
  List<String> _arraybreak_journey = [];
  List<String> _arrayvia_journey = [];
  String prcpWindowFlag = "";
  String pass_class = "";
  bool servingCarryCycleFlag = true;

  Future get_station_des(String Stationcode, String flag) async {
    final String url = new UtilsFromHelper().getValueFromKey("get_station_des");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "stationCode": Stationcode,
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
      if (responseJSON["result"]["station_list"] != null) {
        if (flag == "out_from") {
          staion_out_des.text =
              responseJSON["result"]["station_list"]["description"];
          staion_in_to_des.text = staion_out_des.text;
          station_in_to.text = Stationcode;
          setState(() {
            AutoStationListViewModel autoStationListViewModel =
                AutoStationListViewModel();
            autoStationListViewModel.get_station(
                staion_out_des.text.trim(), "");
          });
        }
        if (flag == "out_to") {
          staion_out_to_des.text =
              responseJSON["result"]["station_list"]["description"];
          staion_in_from_des.text = staion_out_to_des.text;
          station_in_from.text = Stationcode;
        }

        if (flag == "break_journey") {
          break_station_des.text =
              responseJSON["result"]["station_list"]["description"];
        }
        if (flag == "via_journey") {
          via_station_des.text =
              responseJSON["result"]["station_list"]["description"];
        }
      } else {}
    });
  }

  Future get_station(String Stationcode, String flag) async {
    final String url = new UtilsFromHelper().getValueFromKey("get_station");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {"station": Stationcode};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    var station_suggestion_list =
        responseJSON["result"]["station_list"] as List;
    setState(() {
      for (int i = 0; i < station_suggestion.length; i++) {
        station_code.add(new StationCode.fromJson(station_suggestion_list[i]));
      }
    });
    if (station_out_from.text.trim().length == 0 &&
        staion_out_des.text.trim().length != 0) {}

    setState(() {
      loading = false;
    });
  }

  Future _getIP() async {
    sharedpreferencemanager pref = sharedpreferencemanager();

    String? prcpWindow = await pref.getPrcpWindowFlag();

    String? serviceStatus = await pref.getServiceStatus();

    NetworkInfo info = NetworkInfo();
    String? ipAddress = await info.getWifiIP() ;
    print('ip $ipAddress');
    setState(() {
      ipAddress =  ipAddress; //info.getWifiIP() as String?;
      print('ip $ipAddress');
      prcpWindowFlag = prcpWindow!;
      if (serviceStatus == 'RT') {
        servingCarryCycleFlag = false;
      }
    });
  }

  Future get_familydetails_list() async {
    send.clear();
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("get_family_list");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await pref.getEmployeeHrmsid(),
      "serviceStatus": await pref.getServiceStatus()
    };
    print('url get family list $url');
    print('map $map');

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;
    print(' family responseJSON $responseJSON');
    print('get_familydetails_list ${responseJSON}');
    print('no of attendants ${responseJSON['no_of_attendants']}');
    text_attendent_upgrade="Attendent Traveling";
    if (responseJSON['no_of_attendants']==null) {
      setState(() {
        flag_attendentTrav_view = false;
      });
    } else {
      setState(() {
        flag_attendentTrav_view = true;
      });
    }
    if(widget.passType=='PP'){
      print('passType ${widget.passType}');
      if(widget.upgradedPass!=null && widget.upgradedPass.toString().isNotEmpty && widget.upgradedPass.toString().contains('A')){
        //upgraded Pass Disabled for Upgraded pass A
        text_attendent_upgrade = "Upgraded Pass";
        flag_upgradedPass=true;
        upgradedPassContainsA=true;
        _upgradedpass='Y';
        print('text_attendent_upgrade $text_attendent_upgrade');
        _upgradedPassView=true;
      }
      if(widget.upgradedPass!=null && widget.upgradedPass.toString().isNotEmpty && widget.upgradedPass.toString().contains('B')){
       print('_upgradedPass ${widget.upgradedPass}');
       text_attendent_upgrade = "Upgraded Pass";
       flag_upgradedPass =false;
       print('text_attendent_upgrade1 $text_attendent_upgrade');
        _upgradedPassView=true;
      }
    }
    var newItem;
    var streetsFromJson = responseJSON['familyinfo'];

    late String selfddate_string;

    if (responseJSON["date_of_birth"].toString() != "") {
      DateTime todayDate_exp =
          DateTime.parse(responseJSON["date_of_birth"].toString());
      selfddate_string = DateFormat('dd/MM/yyyy').format(todayDate_exp);
    }
    if (prcpWindowFlag != "WP") {
      employee_details = {
        "family_member_sr_no": 0.toString(),
        "age": responseJSON['member_age'].toString(),
        "member_name": responseJSON['employee_name_sr'].toString(),
        "relation_description": "SELF",
        "relation_flag_description": "FAMILY",
        "relation_flag": "F",
        "member_date_of_birth": responseJSON['date_of_birth'].toString(),
        //dd-mm-yyyy
        "gender": responseJSON['gender'].toString()
      };
      family_list.add(FamilyEditCol(
        family_member_sr_no: 0,
        age: responseJSON['member_age'].toString(),
        member_name: responseJSON['employee_name_sr'].toString(),
        relation_description: "SELF",
        relation_flag_description: "F",

        member_date_of_birth: responseJSON['date_of_birth'].toString(),
        //dd-mm-yyyy
        gender: responseJSON['gender'].toString(),
        isChecked: false,
      ));
      myObject = {
        "familyMemberSrNo": 0.toString(),
        "memberAge": responseJSON["member_age"].toString(),
        "memberName": responseJSON["employee_name_sr"].toString(),
        "includeMember": "N",
        "relativeFlag": "F",
        "relation_description": "SELF",
        "memberDateOfBirth": selfddate_string, //dd-mm-yyyy
        "gender": responseJSON["gender"].toString()
      };

      send.insert(0, myObject);
    }

    if (streetsFromJson != null) {
      for (int k = 0; k < streetsFromJson.length; k++) {
        newItem = FamilyEditCol(
          family_member_sr_no: streetsFromJson[k]["family_member_sr_no"],
          member_name: streetsFromJson[k]["member_name"],
          relation_description: streetsFromJson[k]["relation_description"],
          relation_flag_description: streetsFromJson[k]["relation_flag"],
          gender: streetsFromJson[k]["gender"],
          member_date_of_birth: streetsFromJson[k]["member_date_of_birth"],
          age: streetsFromJson[k]["age"],
          isChecked: false,
        );

        setState(() {
          family_list.add(newItem);
          late String otherddate_string;

          if (streetsFromJson[k]["member_date_of_birth"].toString() != "") {
            DateTime todayDate_exp = DateTime.parse(
                streetsFromJson[k]["member_date_of_birth"].toString());
            otherddate_string =
                DateFormat('dd/MM/yyyy').format(todayDate_exp);
          }

          myObject = {
            "familyMemberSrNo":
                streetsFromJson[k]["family_member_sr_no"].toString(),
            "memberAge": streetsFromJson[k]["age"].toString(),
            "memberName": streetsFromJson[k]["member_name"].toString(),
            "includeMember": "N",
            "relativeFlag": streetsFromJson[k]["relation_flag"].toString(),
            "relation_description":
                streetsFromJson[k]["relation_description"].toString(),
            "memberDateOfBirth": otherddate_string,
            //dd-mm-yyyy
            "gender": streetsFromJson[k]["gender"].toString()
          };
          int sendIndex = k;
          if (prcpWindowFlag != "WP") {
            sendIndex = sendIndex + 1;
          } else {}

          send.insert(sendIndex, myObject);
        });
      }
    }

    if (widget.newordraft == "Draft") {
      get_draft_pass_details();
    }
  }

  Future get_draft_pass_details() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("pass-draft_details");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "passAplicationNum": widget.application_no.toString(),
      "passtype": widget.passType,
      "setflag": widget.setType
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
    print('responseJSON getdraft details-->$responseJSON');
    setState(() {
      var streetsFromJson = responseJSON['pass_application_member'];

      var newItemMemberEdit;
      if (streetsFromJson != null) {
        for (int k = 0; k < streetsFromJson.length; k++) {
          newItemMemberEdit = MemberEditCol(
            family_member_sr_no: streetsFromJson[k]["family_member_sr_no"]??'',
            member_name: streetsFromJson[k]["name"]??'',
            relation_description: streetsFromJson[k]["relation_description"]??'',
            relation_flag_description: streetsFromJson[k]["relation_flag"]??'',
            gender: streetsFromJson[k]["gender"]??'',
            member_date_of_birth: streetsFromJson[k]["dob"]??'',
            age: streetsFromJson[k]["age"]??'',
            isChecked: false,
          );

          if (streetsFromJson[k]["dob"].toString() != "") {
            DateTime todayDate_exp =
                DateTime.parse(streetsFromJson[k]["dob"].toString());
          }
//print(streetsFromJson[k]["family_member_sr_no"]);
          int index =
              int.parse(streetsFromJson[k]["family_member_sr_no"].toString());

          setState(() {
            // family_list[index].isChecked = true;
            // send[index]["includeMember"] = "Y";
            memberEdit1.add(newItemMemberEdit);
          });
        }
      }
    });
    station_out_from.text = responseJSON['from_station'] ?? "";
    station_out_to.text = responseJSON['to_station'] ?? "";
    application_no = responseJSON['pan'].toString() ?? "";

    break_station_return.text =
        responseJSON['pass_application_journey_details']['inward'] ?? "";

    if (responseJSON['pass_application_journey_details']['outward'] == null ||
        responseJSON['pass_application_journey_details']['outward'] == "") {
    } else {
      break_station_list.text =
          responseJSON['pass_application_journey_details']['outward'] ?? "";
      _arraybreak_journey.add(break_station_list.text.trim().toUpperCase());
    }

    if (responseJSON['pass_application_journey_details']['outward_via'] ==
            null ||
        responseJSON['pass_application_journey_details']['outward_via'] ==
            "") {
    } else {
      via_station_list.text = responseJSON['pass_application_journey_details']
              ['outward_via'] ??
          "";
      _arrayvia_journey.add(via_station_list.text.trim().toUpperCase());
    }

    via_station_return.text =
        responseJSON['pass_application_journey_details']['inward_via'] ?? "";
    if (responseJSON['pass_application_journey_details']['outward_via'] ==
            null ||
        responseJSON['pass_application_journey_details']['outward_via'] ==
            "") {
      flag_viajourneyCheckBok = false;
      flag_viajourneyView = false;
    } else {
      flag_viajourneyCheckBok = true;
      flag_viajourneyView = true;
    }
    get_station_des(station_out_from.text.trim(), "out_from");
    get_station_des(station_out_to.text.trim(), "out_to");
    print('upgraded Result ${responseJSON['upgraded_pass']}');
    if (responseJSON['upgraded_pass'] == null) {
      _upgradedpass = "N";
    } else {
      _upgradedpass = responseJSON['upgraded_pass'];
    }
    pass_class = responseJSON['pass_class'];

    memberEdit1.forEach((element) {
      var id = family_list.indexWhere((note) =>
          note.family_member_sr_no.toString() ==
          element.family_member_sr_no.toString());

      if (id >= 0) {
        setState(() {
          family_list[id].isChecked = true;
          send[id]["includeMember"] = "Y";
        });
      }
    });
  }

  Future save_as_draft_pass() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("submit_pass");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    var appl_no;
    if (application_no.isEmpty) {
      appl_no = widget.application_no;
    } else {
      appl_no = application_no;
    }

    Map map = {
    //  "applicationNo": widget.application_no,
      "applicationNo": appl_no,
      "serviceStatus": await pref.getServiceStatus(),
      "userId": await pref.getEmployeeHrmsid(),
      "employeeName": await pref.getEmployeeName(),
      "mobileNo": await pref.getEmployeeMobileno(),
      "designationDescription": await pref.getEmployeeDesig(),
      "railwayUnitCode": await pref.getEmployeeUnitcode(),
      "typeOfPass": widget.passType,
      "fullHalfSet": widget.setType,
      "stationOutFrom": station_out_from.text ?? "",
      "stationOutTo": station_out_to.text ?? "",
      "stationOutBreak": break_station_list.text ?? "",
      "stationOutVia": via_station_list.text,
      "ipAddress": ipAddress,
      "stationInFrom": station_in_from.text ?? "",
      "stationInTo": station_in_to.text ?? "",
      "stationInBreak": break_station_list.text ?? "",
      "stationInVia": via_station_list.text,
      "attendantTravelling": attendantTravelling,
      "companionTravelling": companionTravelling,
      "carryCycle": carryCycle,
      "yearOfPass": widget.year,
      "familymember": send,
      "pass_class": pass_class,
      "upgradedPass": _upgradedpass,
      "status": "D",
    };
    print(send.toString());
    print('_upgradedpass--> $_upgradedpass');
    print('map--> $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON Draft $responseJSON');
    if(responseJSON['result'] == true) {
      setState(() {
        optedDistance = responseJSON['optedDistance'].toString();
        application_no = responseJSON['applicationNo'].toString();
        _hasBeenPressed_draft = false;
        _hasBeenPressed_Alternate = false;
        submit_flag = true;
        print('optedDistance Distance--> $optedDistance');
        print('application_no--> $application_no');
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      });
    }else
      {
        Fluttertoast.showToast(
            msg: responseJSON['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);

        setState(() {
          print('Submit flag disabled');
          submit_flag = false;
          _hasBeenPressed_draft = true;
        });
      }
  }

  void _loadData() async {
    AutoStationListViewModel? autoStationListViewModel =
        AutoStationListViewModel();
    await autoStationListViewModel.get_station("", "");
  }

  @override
  void initState() {
    super.initState();
    _stationOutDescController = TextEditingController();
    _stationOutFromController = TextEditingController();
    _breakStationDescController = TextEditingController();
    _viaStationDescController   = TextEditingController();

    // pr.show();
    _getIP();
    setState(() {
      send.clear();
      get_familydetails_list();
    });
    _loadData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    station_out_from.dispose();
    station_out_to.dispose();
    station_in_from.dispose();
    station_in_to.dispose();
    staion_out_des.dispose();
    staion_in_to_des.dispose();
    staion_out_to_des.dispose();
    staion_in_from_des.dispose();
    via_station_des.dispose();
    break_station_des.dispose();
    _stationOutDescController.dispose();
    _stationOutFromController.dispose();
    _breakStationDescController.dispose();
    _viaStationDescController.dispose();
    super.dispose();
    _hasBeenPressed = false;
    _hasBeenPressed_draft = false;
    _hasBeenPressed_Alternate = false;
  }

  Widget rowDescription(item) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            item.description,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ],
    );
  }

  Widget row(StationList stationList) {
    return Row(
      children: <Widget>[
        Text(
          stationList.description.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];
    int index;

    /*if (widget.upgradedPass == "A") {
      _upgradedpass = "Y";
      text_attendent_upgrade = "Upgraded Pass";
    } else if (widget.upgradedPass == "B") {
      print('upgraded B');
      text_attendent_upgrade = "Upgraded Pass";
    } else {
      text_attendent_upgrade = "Attendent Traveling";
    }*/
    //text_attendent_upgrade = "Attendent Traveling";

    rows.add(TableRow(children: [
      Container(
        margin: EdgeInsets.all(10),
        child: Text(
          "Name",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: Text("Relation",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
      Container(
        margin: EdgeInsets.all(10),
        child: Text("Relative Flag",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
      Container(
          margin: EdgeInsets.all(10),
          child: Text("Members to be included in Pass",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
    ]));

    for (int i = 0; i < family_list.length; i++) {
      String date_string;
      if (family_list[i].member_date_of_birth.toString() != "") {
        DateTime todayDate_exp =
            DateTime.parse(family_list[i].member_date_of_birth.toString());
        date_string = DateFormat('dd/MM/yyyy').format(todayDate_exp);
      }

      rows.add(TableRow(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text(family_list[i].member_name.toString()),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Text(family_list[i].relation_description.toString()),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Text(family_list[i].relation_flag_description.toString()),
        ),
        Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.lightBlue,
          value: family_list[i].isChecked,
          onChanged: (value) {
            setState(() {
              family_list[i].isChecked = value!;
            });
          },
        ),
      ]));
    }

    if (widget.setType == "H") {
      flag_return_journey = false;
    } else {
      flag_return_journey = true;
    }

    if (widget.passType == "PTO") {
      break_journy_view = true;
      //hide CarryCycle
      carryCycleVisible = false;
      RouteStationOption = true;
    } else {
      break_journy_view = true;
      via_journey_view = true;
      //carryCycleVisible=true;
    }
    List<AutoStationList>? suggestionsStationList = [];

    AutoStationListViewModel autoStationListViewModel =
        AutoStationListViewModel();

    //suggestionsStationList = autoStationListViewModel.autoStationList;
    suggestionsStationList = [];
    if(suggestionsStationList.length>0){
      suggestionsStationList= autoStationListViewModel.autoStationList;
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Apply Pass",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: new GestureDetector(
        onTap: () {
          if (station_out_from.text.trim().length > 1) {
            get_station_des(station_out_from.text.trim(), "out_from");
          }
          if (station_out_to.text.trim().length > 0) {
            get_station_des(station_out_to.text, "out_to");
          }
          if (break_station.text.trim().length > 1) {
            get_station_des(break_station.text, "break_journey");
          }
          if (via_station.text.trim().length > 1) {
            get_station_des(via_station.text, "via_journey");
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Visibility(
                  visible: true,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 35,
                          ),
                          new Container(
                            margin: const EdgeInsets.all(5.0),
                            child: new Text(
                                "On clicking Generate button, Pass/PTO application will not be sent to Pass clerk and Pass issuing Authority and Pass/PTO will be generated automatically and immediately. Please fill in the details carefully before applying.",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ),
                          new Container(
                            margin: const EdgeInsets.all(5.0),
                            child: new Text(
                                "जनरेट बटन क्लिक करने पर, पास/पीटीओ आवेदन पास क्लर्क और पास जारी करने वाले प्राधिकारी को नहीं भेजा जाएगा और पास/पीटीओ स्वचालित रूप से और तुरंत उत्पन्न हो जाएगा। कृपया आवेदन करने से पहले विवरण सावधानीपूर्वक भरें।",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 14,
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: Text(
                                      'Application no. (Autogenerated)',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(application_no,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 14,
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: Text(
                                      'Station From *',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                      height: 45,
                                      child: Focus(
                                          onFocusChange: (hasFocus) {
                                            if (hasFocus) {
                                              // do stuff
                                            } else {
                                              //  AutoStationListViewModel.get_station(station_out_from.text.trim(), "");

                                              if (station_out_from.text
                                                      .trim()
                                                      .length >
                                                  1) {
                                                get_station_des(
                                                    station_out_from.text
                                                        .trim(),
                                                    "out_from");
                                              }
                                            }
                                          },
                                          child: TextField(
                                            controller: station_out_from,
                                            onChanged: (value) {
                                              station_out_from.value =
                                                  TextEditingValue(
                                                      text: value.toUpperCase(),
                                                      selection:
                                                          station_out_from
                                                              .selection);
                                            },
                                            keyboardType: TextInputType.text,
                                            textCapitalization:
                                                TextCapitalization.characters,

                                            style: TextStyle(fontSize: 13),
                                            //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                            decoration: InputDecoration(
                                              hintText: "Code",
                                              filled: true,
                                              fillColor: Color(0xFFF2F2F2),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                        child: Focus(
                                          onFocusChange: (hasFocus) {
                                            if (hasFocus) {
                                            } else {}
                                          },
                                          child: Autocomplete<AutoStationList>(
                                            optionsBuilder: (TextEditingValue textEditingValue) {
                                              if (textEditingValue.text.isEmpty) {
                                                return const Iterable<AutoStationList>.empty();
                                              }
                                              return suggestionsStationList!.where((AutoStationList item) {
                                                return item.description.toLowerCase().startsWith(
                                                  textEditingValue.text.toLowerCase(),
                                                );
                                              });
                                            },
                                            displayStringForOption: (AutoStationList option) => option.description,
                                            fieldViewBuilder:
                                                (context, textEditingController, focusNode, onFieldSubmitted) {
                                                  TextEditingController _stationOutDescController = TextEditingController();
                                              return TextField(
                                                controller: _stationOutDescController,
                                                focusNode: focusNode,
                                                textCapitalization: TextCapitalization.characters,
                                                style: TextStyle(color: Colors.black, fontSize: 13.0),
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  hintText: "Station description",
                                                  filled: true,
                                                  fillColor: Color(0xFFF2F2F2),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                    borderSide: BorderSide(width: 1, color: Colors.grey),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                    borderSide: BorderSide(width: 1, color: Colors.grey),
                                                  ),
                                                ),
                                              );
                                            },
                                            onSelected: (AutoStationList selectedItem) {
                                              setState(() {
                                                _stationOutDescController.text = selectedItem.description;
                                                _stationOutFromController.text = selectedItem.code;
                                              });
                                            },
                                            optionsViewBuilder: (context, onSelected, options) {
                                              return Align(
                                                alignment: Alignment.topLeft,
                                                child: Material(
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 40,
                                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                                    child: ListView.builder(
                                                      padding: EdgeInsets.all(8.0),
                                                      itemCount: options.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        final AutoStationList option = options.elementAt(index);
                                                        return ListTile(
                                                          title: Text(option.description, style: TextStyle(fontSize: 12)),
                                                          onTap: () => onSelected(option),
                                                        );
                                                      },
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
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 14,
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: Text(
                                      'Station To *',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 45,
                                      margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                      child: Focus(
                                          onFocusChange: (hasFocus) {
                                            if (hasFocus) {
                                              if (station_out_from.text
                                                          .trim()
                                                          .length >
                                                      1 &&
                                                  staion_out_des.text
                                                          .trim()
                                                          .length ==
                                                      0) {
                                                get_station_des(
                                                    station_out_from.text
                                                        .trim(),
                                                    "out_from");
                                              }
                                              if (station_out_to.text
                                                      .trim()
                                                      .length >
                                                  0) {
                                                get_station_des(
                                                    station_out_to.text,
                                                    "out_to");
                                              }
                                              if (break_station.text
                                                      .trim()
                                                      .length >
                                                  1) {
                                                get_station_des(
                                                    break_station.text,
                                                    "break_journey");
                                              }
                                              // do stuff
                                            } else {
                                              if (station_out_to.text
                                                      .trim()
                                                      .length >
                                                  1) {
                                                AutoStationListViewModel
                                                    autoStationListViewModel =
                                                    AutoStationListViewModel();
                                                autoStationListViewModel
                                                    .get_station(
                                                        station_out_to.text
                                                            .trim(),
                                                        "");
                                                get_station_des(
                                                    station_out_to.text.trim(),
                                                    "out_to");
                                              }
                                            }
                                          },
                                          child: TextField(
                                            onTap: () {},
                                            controller: station_out_to,
                                            onChanged: (value) {
                                              station_out_to.value =
                                                  TextEditingValue(
                                                      text: value.toUpperCase(),
                                                      selection: station_out_to
                                                          .selection);
                                            },
                                            keyboardType: TextInputType.text,
                                            textCapitalization:
                                                TextCapitalization.characters,

                                            style: TextStyle(fontSize: 13),
                                            //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                            decoration: InputDecoration(
                                              hintText: "Code",
                                              filled: true,
                                              fillColor: Color(0xFFF2F2F2),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                      child: Autocomplete<AutoStationList>(
                                        // 1. Filter your list
                                        optionsBuilder: (TextEditingValue textEditingValue) {
                                          final list = suggestionsStationList ?? [];
                                          if (textEditingValue.text.isEmpty) {
                                            return const Iterable<AutoStationList>.empty();
                                          }
                                          return list.where((item) =>
                                              item.description
                                                  .toLowerCase()
                                                  .startsWith(textEditingValue.text.toLowerCase())
                                          );
                                        },
                                        // 2. Show the description in the field once selected
                                        displayStringForOption: (AutoStationList option) => option.description,
                                        // 3. Hook our controllers into the field
                                        fieldViewBuilder:
                                            (BuildContext context,
                                            TextEditingController textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          _stationOutDescController = textEditingController;
                                          return TextField(
                                            controller: _stationOutDescController,
                                            focusNode: focusNode,
                                            textCapitalization: TextCapitalization.characters,
                                            style: TextStyle(color: Colors.black, fontSize: 13),
                                            decoration: InputDecoration(
                                              hintText: "Station description",
                                              filled: true,
                                              fillColor: Color(0xFFF2F2F2),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                              ),
                                            ),
                                            onSubmitted: (_) => onFieldSubmitted(),
                                          );
                                        },
                                        // 4. When the user picks one, fill both fields
                                        onSelected: (AutoStationList selection) {
                                          setState(() {
                                            _stationOutDescController.text = selection.description;
                                            station_out_to.text            = selection.code;
                                          });
                                        },
                                        // 5. (Optional) Customize the dropdown
                                        optionsViewBuilder:
                                            (BuildContext context,
                                            AutocompleteOnSelected<AutoStationList> onSelected,
                                            Iterable<AutoStationList> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: 200,
                                                  maxWidth: MediaQuery.of(context).size.width - 40,
                                                ),
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: options.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final item = options.elementAt(index);
                                                    return ListTile(
                                                      title: Text(item.description, style: TextStyle(fontSize: 12)),
                                                      onTap: () => onSelected(item),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: break_journy_view,
                            child: Column(
                              children: [
                                Divider(
                                  height: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                new Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: new Text(
                                      "ब्रेक जर्नी/यात्रा विराम स्टेशन वे स्टेशन होते हैं जहां से आपकी ट्रेन शुरू होती है, समाप्त होती है अथवा जहां आपको ट्रेनों को बदलने की आवश्यकता होती है, अर्थात जहां आपकी यात्रा ब्रेक होती है। / Break journey stations are stations at which your train(s) starts, ends or where you need to change trains, i.e. where you break your journey ",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          height: 30,
                                          margin:
                                              EdgeInsets.fromLTRB(5, 3, 0, 0),
                                          child: RouteStationOption == false
                                              ? Text(
                                                  'Break journey \n  Stations*',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                )
                                              : Text(
                                                  'Route Station*',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                )),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 2, 0),
                                            height: 45,
                                            child: Focus(
                                                onFocusChange: (hasFocus) {
                                                  if (hasFocus) {
                                                  } else {
                                                    //callauto

                                                    if (break_station.text
                                                            .trim()
                                                            .length >
                                                        1) {
                                                      get_station_des(
                                                          break_station.text
                                                              .trim(),
                                                          "break_journey");
                                                    }
                                                  }
                                                },
                                                child: TextField(
                                                  controller: break_station,
                                                  onChanged: (value) {
                                                    break_station.value =
                                                        TextEditingValue(
                                                            text: value
                                                                .toUpperCase(),
                                                            selection:
                                                                break_station
                                                                    .selection);
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                  decoration: InputDecoration(
                                                    hintText: "Code",
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFFF2F2F2),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colors.grey),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 2, 0),
                                            child: Autocomplete<AutoStationList>(
                                              optionsBuilder: (TextEditingValue textEditingValue) {
                                                if (textEditingValue.text.isEmpty) {
                                                  return const Iterable<AutoStationList>.empty();
                                                }
                                                return suggestionsStationList!.where((AutoStationList item) {
                                                  return item.description.toLowerCase().startsWith(
                                                    textEditingValue.text.toLowerCase(),
                                                  );
                                                });
                                              },
                                              displayStringForOption: (AutoStationList option) => option.description,
                                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                                _breakStationDescController = textEditingController;
                                                return TextField(
                                                  controller: _breakStationDescController,
                                                  focusNode: focusNode,
                                                  style: TextStyle(color: Colors.black, fontSize: 13.0),
                                                  keyboardType: TextInputType.text,
                                                  textCapitalization: TextCapitalization.characters,
                                                  decoration: InputDecoration(
                                                    hintText: "Station description",
                                                    filled: true,
                                                    fillColor: Color(0xFFF2F2F2),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onSelected: (AutoStationList selectedItem) {
                                                setState(() {
                                                  _breakStationDescController.text = selectedItem.description;
                                                  break_station.text = selectedItem.code;
                                                });
                                              },
                                              optionsViewBuilder: (context, onSelected, options) {
                                                return Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Material(
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width - 40,
                                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                                      child: ListView.builder(
                                                        padding: EdgeInsets.all(8.0),
                                                        itemCount: options.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          final AutoStationList option = options.elementAt(index);
                                                          return ListTile(
                                                            title: Text(option.description, style: TextStyle(fontSize: 12)),
                                                            onTap: () => onSelected(option),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "Kindly enter the stations in order of travel ",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              if (break_station.text
                                                      .trim()
                                                      .length >
                                                  1) {
                                                if (station_out_from.text
                                                            .trim()
                                                            .length ==
                                                        0 ||
                                                    station_out_to.text
                                                            .trim()
                                                            .length ==
                                                        0) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Please enter From staion and To staion',
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      // timeInSecForIos: 5,
                                                      backgroundColor:
                                                          Colors.pink,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                }
                                                // else if(break_station_des.text.trim().length==0){
                                                //   Fluttertoast.showToast(
                                                //       msg: 'Please enter break journey',
                                                //       toastLength: Toast.LENGTH_LONG,
                                                //       gravity: ToastGravity.BOTTOM,
                                                //       timeInSecForIos: 5,
                                                //       backgroundColor: Colors.pink,
                                                //       textColor: Colors.white,
                                                //       fontSize: 14.0
                                                //   );
                                                // }

                                                else {
                                                  if (break_station.text !=
                                                          station_out_from
                                                              .text &&
                                                      break_station.text !=
                                                          station_out_to.text) {
                                                    if (widget.newordraft ==
                                                        "Draft") {
                                                      if (break_station.text
                                                              .trim()
                                                              .length ==
                                                          0) {
                                                        _arraybreak_journey.add(
                                                            break_station.text
                                                                .toString()
                                                                .toUpperCase());
                                                      } else {
                                                        _arraybreak_journey.add(
                                                            break_station.text
                                                                .toUpperCase());
                                                      }
                                                    } else {
                                                      _arraybreak_journey.add(
                                                          break_station.text
                                                              .toUpperCase());
                                                    }
                                                    // _arraybreak_journey.add(break_station.text.toUpperCase());
                                                    _arraybreak_journey =
                                                        _arraybreak_journey
                                                            .toSet()
                                                            .toList();

                                                    for (int i = 0;
                                                        i <
                                                            _arraybreak_journey
                                                                .length;
                                                        i++) {
                                                      if (i == 0) {
                                                        break_station_list
                                                                .text =
                                                            _arraybreak_journey[
                                                                    i]
                                                                .toUpperCase();
                                                      } else {
                                                        if (RouteStationOption ==
                                                            true) {
                                                          Fluttertoast
                                                              .showToast(
                                                                  msg:
                                                                      'Only 1(one) journey station allowed in PTOs',
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  // timeInSecForIos:
                                                                  //   5,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .pink,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      14.0);
                                                        }
                                                        if (RouteStationOption ==
                                                            false) {
                                                          break_station_list
                                                              .text = break_station_list
                                                                  .text +
                                                              ',' +
                                                              _arraybreak_journey[
                                                                      i]
                                                                  .toUpperCase();
                                                        }
                                                        //   _arraybreak_journey.add(break_station.text);
                                                      }
                                                    }
                                                    break_station_return.text =
                                                        break_station_list.text
                                                            .split(",")
                                                            .reversed
                                                            .join(',');
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Outward Break stations Break Journey station cannot be same as Source/Destination',
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        //timeInSecForIos: 5,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0);
                                                    break_station.text = "";
                                                    break_station_des.text = "";
                                                  }
                                                }

                                                break_station.text = "";
                                                break_station_des.text = "";
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Enter break station code',
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    // timeInSecForIos: 1,
                                                    backgroundColor:
                                                        Colors.pink,
                                                    textColor: Colors.white,
                                                    fontSize: 14.0);
                                              }
                                            },
                                            //height: 30,
                                            //width: 100,
                                            child: Text(
                                              'Add',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF40C4FF)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextField(
                                        controller: break_station_list,
                                        onChanged: (value) {
                                          break_station_list.value =
                                              TextEditingValue(
                                                  text: value.toUpperCase(),
                                                  selection: break_station_list
                                                      .selection);
                                        },
                                        enabled: false,
                                        minLines: 1,
                                        maxLines: 10,
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.characters,

                                        style: TextStyle(fontSize: 13),
                                        //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                        decoration: InputDecoration(
                                          hintText: "",
                                          filled: true,
                                          fillColor: Color(0xFFF2F2F2),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.grey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.grey),
                                          ),
                                        ),
                                      )),
                                      IconButton(
                                        icon: new Icon(Icons.cancel,
                                            color: Colors.red),
                                        onPressed: () {
                                          break_station_list.text = "";
                                          break_station_return.text = "";
                                          _arraybreak_journey.clear();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            child: Column(
                              children: [
                                Divider(
                                  height: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: Colors.lightBlue,
                                      value: flag_viajourneyCheckBok,
                                      onChanged: (value) {
                                        setState(() {
                                          flag_viajourneyCheckBok = value!;
                                          if (flag_viajourneyCheckBok == true) {
                                            setState(() {
                                              flag_viajourneyView = true;
                                            });
                                          } else {
                                            setState(() {
                                              flag_viajourneyView = false;
                                              via_station_list.text = "";
                                              via_station_return.text = "";
                                              _arrayvia_journey.clear();
                                            });
                                          }
                                        });

                                        //   });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                          "Click here, if you want to add via stations in your journey. (यदि आप अपनी यात्रा में वाया स्टेशनों को जोड़ना चाहते हैं तो यहां क्लिक करें।)"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            visible: via_journey_view,
                          ),
                          Visibility(
                            child: Visibility(
                              //set False
                              visible: via_journey_view,
                              child: Column(
                                children: [
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.all(5.0),
                                    child: new Text(
                                        " वाया स्टेशन वे स्टेशन होते हैं जिनसे आपकी ट्रेन गुजरती है, वे ट्रेन के मार्ग को परिभाषित करते हैं। इन स्टेशनों पर टिकट बुक नहीं होंगे / Via stations are stations through which trains pass, they define the route of the train. Tickets will not be booked on these stations ",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      //  Align(
                                      //   alignment: Alignment.center,
                                      //   child:Padding(padding: EdgeInsets.all(5),child:
                                      //   ),
                                      // ),

                                      Expanded(
                                        child: Container(
                                            height: 30,
                                            margin:
                                                EdgeInsets.fromLTRB(5, 3, 0, 0),
                                            child: Text(
                                              'Via Journey Stations',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            )),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 2, 0),
                                              height: 45,
                                              child: Focus(
                                                  onFocusChange: (hasFocus) {
                                                    if (hasFocus) {
                                                    } else {
                                                      //callauto

                                                      if (via_station.text
                                                              .trim()
                                                              .length >
                                                          1) {
                                                        get_station_des(
                                                            via_station.text
                                                                .trim(),
                                                            "via_journey");
                                                      }
                                                    }
                                                  },
                                                  child: TextField(
                                                    controller: via_station,
                                                    onChanged: (value) {
                                                      via_station.value =
                                                          TextEditingValue(
                                                              text: value
                                                                  .toUpperCase(),
                                                              selection:
                                                                  via_station
                                                                      .selection);
                                                    },
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .characters,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                    decoration: InputDecoration(
                                                      hintText: "Code",
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFFF2F2F2),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 2, 0),
                                              child: Autocomplete<AutoStationList>(
                                                // where suggestionsStationList is your List<AutoStationList>
                                                optionsBuilder: (TextEditingValue textEditingValue) {
                                                  if (textEditingValue.text.isEmpty) {
                                                    return const Iterable<AutoStationList>.empty();
                                                  }
                                                  return (suggestionsStationList ?? <AutoStationList>[]).where((option) {
                                                    return option.description
                                                        .toLowerCase()
                                                        .startsWith(textEditingValue.text.toLowerCase());
                                                  });
                                                },

                                                displayStringForOption: (AutoStationList option) => option.description,
                                                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                                  // keep a reference so we can write back the selection
                                                  _viaStationDescController = textEditingController;
                                                  return TextField(
                                                    controller: _viaStationDescController,
                                                    focusNode: focusNode,
                                                    textCapitalization: TextCapitalization.characters,
                                                    style: TextStyle(fontSize: 13),
                                                    decoration: InputDecoration(
                                                      hintText: "Station description",
                                                      filled: true,
                                                      fillColor: Color(0xFFF2F2F2),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                        borderSide: BorderSide(color: Colors.grey, width: 1),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                        borderSide: BorderSide(color: Colors.grey, width: 1),
                                                      ),
                                                    ),
                                                    onSubmitted: (value) => onFieldSubmitted(),
                                                  );
                                                },
                                                onSelected: (AutoStationList selected) {
                                                  setState(() {
                                                    // fill both the description and the code
                                                    _viaStationDescController.text = selected.description;
                                                    via_station.text = selected.code;
                                                  });
                                                },
                                                optionsViewBuilder: (context, onSelected, options) {
                                                  return Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Material(
                                                      elevation: 4,
                                                      child: Container(
                                                        constraints: BoxConstraints(
                                                          maxHeight: 200,
                                                          maxWidth: MediaQuery.of(context).size.width - 40,
                                                        ),
                                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                                        child: ListView.builder(
                                                          padding: EdgeInsets.zero,
                                                          itemCount: options.length,
                                                          itemBuilder: (context, index) {
                                                            final AutoStationList option = options.elementAt(index);
                                                            return ListTile(
                                                              title: Text(option.description, style: TextStyle(fontSize: 12)),
                                                              onTap: () => onSelected(option),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                "Kindly enter the stations in order of travel ",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                if (via_station.text
                                                        .trim()
                                                        .length >
                                                    1) {
                                                  //  get_station_des(via_station.text.trim(), "via_journey");
                                                  if (station_out_from.text
                                                              .trim()
                                                              .length ==
                                                          0 ||
                                                      station_out_to.text
                                                              .trim()
                                                              .length ==
                                                          0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please enter From staion and To staion',
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        // timeInSecForIos: 5,
                                                        backgroundColor:
                                                            Colors.pink,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0);
                                                  }
                                                  // else if(via_station_des.text.trim().length==0){
                                                  //   Fluttertoast.showToast(
                                                  //       msg: 'Please enter via break journey',
                                                  //       toastLength: Toast.LENGTH_LONG,
                                                  //       gravity: ToastGravity.BOTTOM,
                                                  //       timeInSecForIos: 5,
                                                  //       backgroundColor: Colors.pink,
                                                  //       textColor: Colors.white,
                                                  //       fontSize: 14.0
                                                  //   );
                                                  // }

                                                  else {
                                                    if (via_station.text !=
                                                            station_out_from
                                                                .text &&
                                                        via_station.text !=
                                                            station_out_to
                                                                .text) {
                                                      if (widget.newordraft ==
                                                          "Draft") {
                                                        if (via_station.text
                                                                    .trim()
                                                                    .length ==
                                                                0 &&
                                                            via_station_list
                                                                    .text
                                                                    .length !=
                                                                0) {
                                                          _arrayvia_journey.add(
                                                              via_station_list
                                                                  .text
                                                                  .toString()
                                                                  .trim()
                                                                  .toUpperCase());
                                                        } else {
                                                          _arrayvia_journey.add(
                                                              via_station.text
                                                                  .trim()
                                                                  .toUpperCase());
                                                        }
                                                      } else {
                                                        _arrayvia_journey.add(
                                                            via_station.text
                                                                .toUpperCase());
                                                      }
                                                      //_arrayvia_journey.add(via_station.text.toUpperCase());
                                                      _arrayvia_journey =
                                                          _arrayvia_journey
                                                              .toSet()
                                                              .toList();

                                                      for (int i = 0;
                                                          i <
                                                              _arrayvia_journey
                                                                  .length;
                                                          i++) {
                                                        if (i == 0) {
                                                          via_station_list
                                                                  .text =
                                                              _arrayvia_journey[
                                                                      i]
                                                                  .toUpperCase();
                                                        } else {
                                                          via_station_list
                                                              .text = via_station_list
                                                                  .text +
                                                              ',' +
                                                              _arrayvia_journey[
                                                                      i]
                                                                  .toUpperCase();
                                                          //   _arraybreak_journey.add(break_station.text);
                                                        }
                                                      }
                                                      // if(via_station_list.text=="")
                                                      //   {
                                                      //     via_station_return.text=via_station.text;
                                                      //   }else{
                                                      //
                                                      // }
                                                      via_station_return.text =
                                                          via_station_list.text
                                                              .split(",")
                                                              .reversed
                                                              .join(',');
                                                      //via_station_return.text=via_station_list.text;
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Outward Break stations Break Journey station cannot be same as Source/Destination',
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          // timeInSecForIos: 5,
                                                          backgroundColor:
                                                              Colors.pink,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 14.0);
                                                      via_station.text = "";
                                                      via_station_des.text = "";
                                                    }
                                                  }
                                                  via_station.text = "";
                                                  via_station_des.text = "";
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Enter via station code',
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      //  timeInSecForIos: 1,
                                                      backgroundColor:
                                                          Colors.pink,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0);
                                                }
                                              },
                                              //height: 30,
                                              // width: 100,
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              style: FilledButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF40C4FF)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          controller: via_station_list,
                                          onChanged: (value) {
                                            via_station_list.value =
                                                TextEditingValue(
                                                    text: value.toUpperCase(),
                                                    selection: via_station_list
                                                        .selection);
                                          },
                                          enabled: false,
                                          minLines: 1,
                                          maxLines: 10,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: TextStyle(fontSize: 13),
                                          //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                          decoration: InputDecoration(
                                            hintText: "",
                                            filled: true,
                                            fillColor: Color(0xFFF2F2F2),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                          ),
                                        )),
                                        IconButton(
                                          icon: new Icon(Icons.cancel,
                                              color: Colors.red),
                                          onPressed: () {
                                            via_station_list.text = "";
                                            via_station_return.text = "";
                                            _arrayvia_journey.clear();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: break_journy_view,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          " Please enter only those stations as via journey which fall on the route of the train by which you intend to travel, otherwise ticket booking may fail. ",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            visible: flag_viajourneyView,
                          ),

                          /* End via */

                          SizedBox(
                            height: 15,
                          ),
                        ]),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(200, 200, 200, 200),
                              width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      Positioned(
                          left: 50,
                          top: 12,
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: Text(
                              'Outward Journey Details',
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: flag_return_journey,
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 14,
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: Text(
                                      'Station From *',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        height: 35,
                                        child: TextField(
                                          enabled: false,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          controller: station_in_from,
                                          keyboardType: TextInputType.text,

                                          style: TextStyle(fontSize: 13),
                                          //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFFF2F2F2),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: TextField(
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      controller: staion_in_from_des,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: "",
                                        filled: true,
                                        fillColor: Color(0xFFF2F2F2),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 14,
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: Text(
                                      'Station To *',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        height: 35,
                                        child: TextField(
                                          enabled: false,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          controller: station_in_to,
                                          onChanged: (value) {
                                            station_in_to.value =
                                                TextEditingValue(
                                                    text: value.toUpperCase(),
                                                    selection: station_in_to
                                                        .selection);
                                          },
                                          keyboardType: TextInputType.text,

                                          style: TextStyle(fontSize: 13),
                                          //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                          decoration: InputDecoration(
                                            hintText: "",
                                            filled: true,
                                            fillColor: Color(0xFFF2F2F2),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        child: TextField(
                                      enabled: false,
                                      controller: staion_in_to_des,
                                      onChanged: (value) {
                                        staion_in_to_des.value =
                                            TextEditingValue(
                                                text: value.toUpperCase(),
                                                selection:
                                                    staion_in_to_des.selection);
                                      },
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      maxLines: 2,

                                      style: TextStyle(fontSize: 13),
                                      //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                      decoration: InputDecoration(
                                        hintText: "",
                                        filled: true,
                                        fillColor: Color(0xFFF2F2F2),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 30,
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: Text(
                                      'Break journey \n  Stations*',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                        height: 35,
                                        child: TextField(
                                          controller: break_station_return,
                                          onChanged: (value) {
                                            break_station_return.value =
                                                TextEditingValue(
                                                    text: value.toUpperCase(),
                                                    selection:
                                                        break_station_return
                                                            .selection);
                                          },
                                          enabled: false,

                                          keyboardType: TextInputType.text,

                                          style: TextStyle(fontSize: 13),
                                          //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                          decoration: InputDecoration(
                                            hintText: "",
                                            filled: true,
                                            fillColor: Color(0xFFF2F2F2),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: flag_viajourneyCheckBok,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      height: 30,
                                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                      child: Text(
                                        'Via Journey Stations',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 35,
                                          child: TextField(
                                            controller: via_station_return,
                                            enabled: false,
                                            onChanged: (value) {
                                              via_station_return.value =
                                                  TextEditingValue(
                                                      text: value.toUpperCase(),
                                                      selection:
                                                          via_station_return
                                                              .selection);
                                            },
                                            keyboardType: TextInputType.text,

                                            style: TextStyle(fontSize: 13),
                                            //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],

                                            decoration: InputDecoration(
                                              hintText: "",
                                              filled: true,
                                              fillColor: Color(0xFFF2F2F2),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ]),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(200, 200, 200, 200),
                              width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      Positioned(
                          left: 50,
                          top: 12,
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: Text(
                              'Return Journey Details',
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Visibility(
                  visible: true,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 35,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 3, 5, 0),
                                    child: Text(
                                      'Select the family members to be included in Pass. Please note that maximum two dependents are allowed in a single Pass. Also, if Dependents are included in the Pass then maximum 5 total members are allowed.',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Table(
                                      border: TableBorder.all(),
                                      children: rows),
                                ),
                              ]),
                          SizedBox(
                            height: 15,
                          ),
                        ]),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(211, 211, 211, 211),
                              width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      Positioned(
                          left: 50,
                          top: 12,
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: Text(
                              'Dependents & Family Members',
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: flag_attendentTrav_view,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Check the applicable boxes below:",
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.lightBlue,
                          value: flag_attendentTrav,
                          onChanged: (value) {
                            setState(() {
                              flag_attendentTrav = value!;
                              if (flag_attendentTrav == true) {
                                attendantTravelling = "Y";
                              } else {
                                attendantTravelling = "N";
                              }
                              /*if (widget.upgradedPass == "A") {
                                flag_attendentTrav = !false;
                                flag_upgradedpass = "Y";
                              } else if (widget.upgradedPass == "B") {
                                if (flag_attendentTrav == true) {
                                  flag_upgradedpass = "Y";
                                } else {
                                  flag_upgradedpass = "N";
                                }
                              } else {
                                if (flag_attendentTrav == true) {
                                  attendantTravelling = "Y";
                                } else {
                                  attendantTravelling = "N";
                                }
                              }*/
                            });
                          },
                        ),
                        Text(text_attendent_upgrade),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _upgradedPassView,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Check the applicable boxes below:",
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.lightBlue,
                          value: flag_upgradedPass,
                          onChanged: !upgradedPassContainsA?(value) {
                            print('flag_upgradedPa $flag_upgradedPass');
                            setState(() {
                              flag_upgradedPass = value!;
                              if (flag_upgradedPass == true) {
                                _upgradedpass = "Y";
                              } else {
                                _upgradedpass = "N";
                              }
                            });
                          }:null,
                        ),
                        Text(text_attendent_upgrade),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: servingCarryCycleFlag,
                child: Visibility(
                  visible: carryCycleVisible,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.lightBlue,
                            value: carryCycleFlag,
                            onChanged: (value) {
                              setState(() {
                                carryCycleFlag = value!;
                                if (carryCycleFlag == true) {
                                  carryCycle = "Y";
                                } else {
                                  carryCycle = "N";
                                }
                              });
                              //   });
                            },
                          ),
                          Text("CarryCycle"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.all(5.0),
                child: new Text(
                    "Please save pass application as draft first. Only then option to submit will be available",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Visibility(
                    visible: submit_flag,
                    child: FilledButton(
                        // width: 120,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent),
                        onPressed: () {
                          getCheckboxItems();
                          if (station_out_from.text.trim().length == 0 ||
                              staion_out_des.text.trim().length == 0) {
                            Fluttertoast.showToast(
                                msg: "From station is required",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                // timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            station_out_from.text = "";
                          } else if (station_out_to.text.trim().length == 0 ||
                              staion_out_to_des.text.trim().length == 0) {
                            Fluttertoast.showToast(
                                msg: "To station is required",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //  timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            station_out_to.text = "";
                          }
                          //send.length
                          else if (totalFamily == 0) {
                            Fluttertoast.showToast(
                                msg:
                                    "Please select at least 1 family member to include in Pass.",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //  timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) =>
                                  CustomDialog(
                                application_no: application_no,
                                stationFrom: station_out_from.text,
                                stationTo: station_out_to.text,
                                stationBreak: break_station_list.text,
                                stationVia: via_station_list.text,
                                passType: widget.passType,
                                setType: widget.setType,
                                station_out_from: station_out_from.text,
                                stationOutBreak: break_station_list.text,
                                stationInBreak: break_station_list.text,
                                stationviaOutBreak: via_station_list.text,
                                stationviaInBreak: via_station_list.text,
                                station_out_to: station_out_to.text,
                                ip: ipAddress,
                                station_in_from: station_in_from.text,
                                station_in_to: station_in_to.text,
                                attendantTravelling: attendantTravelling,
                                companionTravelling: companionTravelling,
                                carryCycle: carryCycle,
                                routeFlag: routeFlag,
                                year: widget.year,
                                send: send,
                                upgradedPass: _upgradedpass,
                                optedDistance: optedDistance,
                                pass_class: '',
                              ),
                            );
                          }
                        }),
                  ),
                  FilledButton(
                      //width: 130,
                      child: Text(
                        'Save as Draft',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: _hasBeenPressed_draft
                              ? Colors.black38
                              : Colors.lightBlueAccent),
                      onPressed: () {
                        getCheckboxItems();
                        if (_hasBeenPressed_draft == false) {
                          setState(() {
                            save_as_draft_pass();
                            _hasBeenPressed_draft = true;
                          });
                        }
                      }),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StationCode {
  String code;
  String description;

  StationCode({
    required this.code,
    required this.description,
  });

  factory StationCode.fromJson(Map<String, dynamic> parsedJson) {
    return StationCode(
      code: parsedJson['code'] as String,
      description: parsedJson['description'],
    );
  }
}

class CustomDialog extends StatefulWidget {
  var application_no;
  final String stationFrom;
  final String stationTo;
  final String stationBreak;
  final String stationVia;
  final String optedDistance;
  String passType,
      setType,
      station_out_from,
      stationOutBreak,
      stationInBreak,
      stationviaOutBreak,
      stationviaInBreak,
      station_out_to,
      ip,
      station_in_from,
      station_in_to,
      attendantTravelling,
      companionTravelling,
      year,
      pass_class,
      carryCycle,
      routeFlag,
      upgradedPass;
  List<Map<String, dynamic>> send = [];

  List<Map<String, dynamic>> updatecheck = [];

  bool stationVia_flag = false;
  bool stationBreak_flag = false;

  CustomDialog({
    required this.application_no,
    required this.stationFrom,
    required this.stationTo,
    required this.stationBreak,
    required this.stationVia,
    required this.passType,
    required this.setType,
    required this.station_out_from,
    required this.stationOutBreak,
    required this.stationInBreak,
    required this.stationviaOutBreak,
    required this.stationviaInBreak,
    required this.station_out_to,
    required this.ip,
    required this.station_in_from,
    required this.station_in_to,
    required this.attendantTravelling,
    required this.companionTravelling,
    required this.year,
    required this.pass_class,
    required this.send,
    required this.carryCycle,
    required this.routeFlag,
    required this.upgradedPass,
    required this.optedDistance,
  });

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  late String result;
  sharedpreferencemanager pref = sharedpreferencemanager();
  bool alternateRouteModal = false;
  String message = "";
  String optedDistance = "";

  Future save_pass(BuildContext dialogcontext) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("submit_pass");
    print('url $url');
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    print('application no ${widget.application_no}');
   /* var appl_no;
    print('application No ${widget.application_no}');
    if (widget.application_no!=null) {
      print('hi');
      appl_no = widget.application_no;
    } else {
      print('world');
      appl_no = null;
    }*/

    Map map = {
      "applicationNo": widget.application_no,
      "serviceStatus": await pref.getServiceStatus(),
      "userId": await pref.getEmployeeHrmsid(),
      "employeeName": await pref.getEmployeeName(),
      "mobileNo": await pref.getEmployeeMobileno(),
      "designationDescription": await pref.getEmployeeDesig(),
      "railwayUnitCode": await pref.getEmployeeUnitcode(),
      "typeOfPass": widget.passType,
      "fullHalfSet": widget.setType,
      "stationOutFrom": widget.station_out_from,
      "stationOutTo": widget.station_out_to,
      "stationOutBreak": widget.stationOutBreak,
      "stationOutVia": widget.stationviaOutBreak,
      "ipAddress": widget.ip,
      "stationInFrom": widget.station_in_from,
      "stationInTo": widget.station_in_to,
      "stationInBreak": widget.stationInBreak,
      "stationInVia": widget.stationviaInBreak,
      "attendantTravelling": widget.attendantTravelling,
      "companionTravelling": widget.companionTravelling,
      "yearOfPass": widget.year,
      "familymember": widget.send,
      "upgradedPass": widget.upgradedPass,
      "pass_class": widget.pass_class,
      "carryCycle": widget.carryCycle,
      "status": "S",
    };
    print('url $url');
    print('map apply submit pass--> $map');
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
      if (responseJSON['result']) {
        Navigator.of(dialogcontext, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PassApplicationStatus_New()),
        );
        message = responseJSON['message'];
        optedDistance = responseJSON['optedDistance'].toString();
      } else if (responseJSON['errorCode'] != null &&
          responseJSON['errorCode'] == 'ROUTE') {
        message = responseJSON['message'];
        alternateRouteModal = true;
      } else if (responseJSON['invalidDate'] != null) {
        message = responseJSON['message'] + responseJSON['invalidDate'];
      } else {
        message = "Some error Occured. Please try again";
      }
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    });
    setState(() {
      _hasBeenPressed = false;
    });
  }

  Future alternate_faster_save_pass(BuildContext dialogcontext) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("submit_pass");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "applicationNo": widget.application_no,
      "serviceStatus": await pref.getServiceStatus(),
      "userId": await pref.getEmployeeHrmsid(),
      "employeeName": await pref.getEmployeeName(),
      "mobileNo": await pref.getEmployeeMobileno(),
      "designationDescription": await pref.getEmployeeDesig(),
      "railwayUnitCode": await pref.getEmployeeUnitcode(),
      "typeOfPass": widget.passType,
      "fullHalfSet": widget.setType,
      "stationOutFrom": widget.station_out_from,
      "stationOutTo": widget.station_out_to,
      "stationOutBreak": widget.stationOutBreak,
      "stationOutVia": widget.stationviaOutBreak,
      "ipAddress": widget.ip,
      "stationInFrom": widget.station_in_from,
      "stationInTo": widget.station_in_to,
      "stationInBreak": widget.stationInBreak,
      "stationInVia": widget.stationviaInBreak,
      "attendantTravelling": widget.attendantTravelling,
      "companionTravelling": widget.companionTravelling,
      "yearOfPass": widget.year,
      "familymember": widget.send,
      "upgradedPass": widget.upgradedPass,
      "pass_class": widget.pass_class,
      "carryCycle": widget.carryCycle,
      "routeFlag": widget.routeFlag,
      "status": "S",
    };
    print('map apply submit pass--> $map');
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
      if (responseJSON['result']) {
        Navigator.of(dialogcontext, rootNavigator: true).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PassApplicationStatus_New()),
        );
      }
      Fluttertoast.showToast(
          msg: responseJSON['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    });

    setState(() {
      _hasBeenPressed = false;
    });
  }

  int _groupValue = -1;

  @override
  Widget build(BuildContext dialogcontext) {
    if (widget.stationBreak.toString().length == 0 ||
        widget.stationBreak.toString() == "") {
      setState(() {
        widget.stationBreak_flag = false;
      });
    } else {
      setState(() {
        widget.stationBreak_flag = true;
      });
    }

    if (widget.stationVia.toString().length == 0) {
      setState(() {
        widget.stationVia_flag = false;
      });
    } else {
      setState(() {
        widget.stationVia_flag = true;
      });
    }
    if (alternateRouteModal == true) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: alternateRouteModalDialog(dialogcontext, message),
      );
    } else {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(dialogcontext),
      );
    }
  }

  dialogContent(BuildContext dialogcontext) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15.0,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Are you sure you want to submit the Pass application? You will not able to make changes after submission.",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: HexColor("#757171")),
                ),
                SizedBox(height: 10),
                Text(
                  "Please check your journey details before submission:",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Column(
                  children: [
                    Row(children: [
                      Text("Application No: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        child: Text(
                          widget.application_no.toString() ,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ]),
                    SizedBox(
                      width: 5,
                    ),
                    Row(children: [
                      Text("From Station: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        child: Text(
                          widget.stationFrom ?? "",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ]),
                    SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      child: Row(children: [
                        Text("Via Journey: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.stationVia ?? "",
                              maxLines: 10,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        )
                      ]),
                      visible: widget.stationVia_flag,
                    ),
                    Visibility(
                      child: Row(children: [
                        Text("Break Journey: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.stationBreak ?? "",
                              maxLines: 10,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        )
                      ]),
                      visible: widget.stationBreak_flag,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Row(children: [
                      Text("To Station: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        child: Text(
                          widget.stationTo ?? "",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Text("Route Kms: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        child: Text(
                          widget.optedDistance ?? "",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ]), /*Row(children: [
                      Text("Please Save As Draft first to get Pass Kms: ",
                          style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10.0,color: Colors.red)),


                    ]),*/
                  ],
                ),
                // Unique Pass number
                //     : 11430
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FilledButton(
                        //width: 100,
                        //height: 40,
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF40C4FF)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    FilledButton(
                      //width: 100,
                      // height: 40,
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: _hasBeenPressed
                              ? Colors.black38
                              : Colors.lightBlueAccent),
                      onPressed: () {
                        if (_hasBeenPressed == false) {
                          save_pass(dialogcontext);
                          setState(() {
                            _hasBeenPressed = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  alternateRouteModalDialog(BuildContext dialogcontext, errorMessage) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15.0,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Alternate/Faster Route",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#000000")),
                ),
                SizedBox(height: 20),
                Text(
                  errorMessage,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor("FF0000")),
                ),
                SizedBox(height: 5.0),
                Text(
                  "Please select if you want to opt for Alternate Route or faster Route or click on 'Change Journey Station' & change your journey station?",
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#000000")),
                ),
                SizedBox(height: 5.0),
                _myRadioButton(
                  title: "Alternate Route",
                  value: 0,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = value!;
                      widget.routeFlag = "A";
                    });
                  },
                ),
                Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 20.0,
                ),
                Text(
                  "If you choose Alternate Route option - You will only be able to travel in a single train from starting(From) to destination station(To)",
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#FF0000")),
                ),
                SizedBox(
                  height: 25,
                ),
                _myRadioButton(
                  title: "Faster Route",
                  value: 1,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = value!;
                      widget.routeFlag = "F";
                    });
                  },
                ),
                Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 20.0,
                ),
                Text(
                  "Please select faster route option only if Total time taken in transit "
                  "i.e. Train Journey time + Layover time( intervening time between trains) is lesser than the time taken "
                  "by the fastest direct train between from-to stations. Otherwise ticket booking will fail even if pass is issued.",
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#FF0000")),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width:185,
                          child: FilledButton(
                              //width: 165,
                              //height: 40,
                              child: Text(
                                'Change Journey Stations',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                  backgroundColor: Color(0xFF40C4FF)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width:185,
                      child: FilledButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: _hasBeenPressed
                                ? Colors.black38
                                : Colors.lightBlueAccent),
                        onPressed: () {
                          if (_hasBeenPressed == false) {
                            var len = widget.routeFlag.length;
                            if (len > 0) {
                              setState(() {
                                widget.routeFlag = widget.routeFlag;
                                _hasBeenPressed = true;
                              });
                              alternate_faster_save_pass(dialogcontext);
                            } else {
                              setState(() {
                                widget.routeFlag = "";
                                _hasBeenPressed = true;
                              });
                              Fluttertoast.showToast(
                                  msg:
                                      "Please select either option and then click on Submit",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  //  timeInSecForIos: 5,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                              _hasBeenPressed = false;
                            }
                          }
                        },
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
        ),
      ],
    );
  }

  Widget _myRadioButton(
      {String? title, int? value, Function(int?)? onChanged}) {
    return RadioListTile<int>(
      value: value!,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title ?? ''),
    );
  }
}

class AutoStationList {
  late String code;
  late String description;

  AutoStationList({
    required this.code,
    required this.description,
  });

  factory AutoStationList.fromJson(Map<String, dynamic> parsedJson) {
    return AutoStationList(
      code: parsedJson['code'] as String,
      description: parsedJson['description'],
    );
  }
}

class AutoStationListViewModel {
  List<AutoStationList>? autoStationList;

  Future get_station(String Stationcode, String flag) async {
    final String url = new UtilsFromHelper().getValueFromKey("get_station");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {"station": Stationcode};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    List<dynamic> station_suggestion_list =
        responseJSON["result"]["station_list"]??[];

    if (station_suggestion_list.length>0) {
      for (int i = 0; i < station_suggestion_list.length; i++) {
        if(autoStationList?.length != null) {
          autoStationList!
              .add(new AutoStationList.fromJson(station_suggestion_list[i]));
        }
      }
    } else {

    }
  }
}
