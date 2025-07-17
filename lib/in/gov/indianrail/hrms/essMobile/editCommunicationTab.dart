import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/pdftabview.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'package:path_provider/path_provider.dart';

// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//import 'package:wifi/wifi.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';


import '../selectdoc.dart';

class EditCommunicationTabInfo extends StatefulWidget {
  var hrmsId,
      status,
      personal_mobileno,
      personal_email,
      Official_mobileno,
      Official_email,
      recieve_otp_on,
      communication_address,
      permanent_address_line1,
      permanent_address_line2,
      permanent_pincode,
      permanent_state,
      permanent_district,
      permanent_city,
      present_address_line1,
      present_address_line2,
      present_pincode,
      present_state,
      present_district,
      present_city,
      sr_pageno;
  EditCommunicationTabInfo(
      this.hrmsId,
      this.personal_mobileno,
      this.personal_email,
      this.Official_mobileno,
      this.Official_email,
      this.recieve_otp_on,
      this.communication_address,
      this.permanent_address_line1,
      this.permanent_address_line2,
      this.permanent_pincode,
      this.permanent_state,
      this.permanent_district,
      this.permanent_city,
      this.present_address_line1,
      this.present_address_line2,
      this.present_pincode,
      this.present_state,
      this.present_district,
      this.present_city,
      this.sr_pageno,
      this.status);
  @override
  EditbasicTabInfo_State createState() => EditbasicTabInfo_State();
}

class EditbasicTabInfo_State extends State<EditCommunicationTabInfo> {
  late List<String> edit_col;
  late String result;
  bool _hasBeenPressed = false;
  double percent = 0.0;
  late List<String> docPaths;
  late String pathvalue;
  late String file_path;
  var fileUploaded = "";
  late List<dynamic> files;
  var fileuploader_flag = false;
  sharedpreferencemanager pref = sharedpreferencemanager();

  /*void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        sortedBy: FileManagerSorting.Alpha,
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
        );
    setState(() {}); //update the UI
  }*/

  Future<List<File>> getFiles() async {
    List<File> fileList = [];

    Directory? externalStorageDir = await getExternalStorageDirectory();
    if (externalStorageDir != null) {
      Directory directory = Directory(externalStorageDir.path);
      List<FileSystemEntity> files = directory.listSync();

      for (FileSystemEntity file in files) {
        if (file is File) {
          fileList.add(file);
        }
      }
    }

    return fileList;
  }

  late String _ip;
  bool editOption_personal_mobieno = false;
  bool focus_personal_mobieno = false;
  bool editOption_personal_email = false;
  bool editOption_official_mobileno = false;
  bool editOption_official_email = false;
  bool editOption_reciveotp = true;
  bool editOption_communication_address = true;
  bool editOption_present_address1 = false;
  bool editOption_present_address2 = false;
  bool editOption_present_pincode = false;
  bool editOption_present_state = true;
  bool editOption_present_district = true;
  bool editOption_present_city = false;

  late bool checkboxVisible;

  TextStyle styleHeading = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  var recieve_otp_on,
      permanent_state_code,
      permanent_district_code,
      communication_address_code,
      recieve_otp_on_code;

  TextEditingController reasonController = TextEditingController();
  TextEditingController hrmsId_Controller = TextEditingController();
  TextEditingController personal_mobileno_Controller = TextEditingController();
  TextEditingController personal_email_Controller = TextEditingController();
  TextEditingController Official_mobileno_Controller = TextEditingController();
  TextEditingController Official_email_Controller = TextEditingController();
  TextEditingController recieve_otp_on_Controller = TextEditingController();
  TextEditingController communication_addressController =
      TextEditingController();

  TextEditingController permanent_address_line1_Controller =
      TextEditingController();

  TextEditingController permanent_address_line2_Controller =
      TextEditingController();
  TextEditingController permanent_pincode_Controller = TextEditingController();
  TextEditingController permanent_state_Controller = TextEditingController();
  TextEditingController permanent_district_Controller = TextEditingController();
  TextEditingController permanent_city_Controller = TextEditingController();

  TextEditingController present_address_line1_Controller =
      TextEditingController();

  TextEditingController present_address_line2_Controller =
      TextEditingController();
  TextEditingController present_pincode_Controller = TextEditingController();
  TextEditingController present_state_Controller = TextEditingController();
  TextEditingController present_district_Controller = TextEditingController();
  TextEditingController present_city_Controller = TextEditingController();

  late FocusNode _titleFocus;
  late FocusNode _reasonFocus;
  late FocusNode _personalMobileFocus;
  late FocusNode _personalEmailFocus;
  late FocusNode _officialEmailFocus;
  late FocusNode _persentPinFocus;
  late FocusNode _persentCityFocus;

  late String path;
  late Map<String, String> paths;
  late List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  late List data;
  late List data_district;
  late String selected_state;

  late String selected_distric;
  late String _selectedspouse_type;
  String _selected_communication_addres = "Please Select";
  var hintvalue_district = "Please Select";
  var hintvalue_state = "";

  Future get_AllStateList() async {
    data.clear();

    final String url = new UtilsFromHelper().getValueFromKey("get_all_states");
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"test": "1"};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;

    setState(() {
      var StateList = responseJSON["states"] as List;

      data = StateList;
      for (int i = 0; i < StateList.length; i++) {
        if (widget.present_state == StateList[i]["code"].toString()) {
          hintvalue_state = StateList[i]["description"];
          present_state_Controller.text = hintvalue_state;
        }
      }
    });
  }

  Future get_distric(String code, String selected_option) async {
    data_district.clear();

    final String url =
        new UtilsFromHelper().getValueFromKey("get_get_districts_byState");
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"state": code};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;
    setState(() {
      var DistrictList = responseJSON["result"]["district"] as List;
      data_district = DistrictList;

      hintvalue_district = "Please select district";

      if (selected_option != "NoSelection") {
        for (int i = 0; i < DistrictList.length; i++) {
          if (widget.present_district == DistrictList[i]["code"].toString()) {
            hintvalue_district = DistrictList[i]["description"].toString();
            present_district_Controller.text = hintvalue_district;
          }
        }
      } else {
        //hintvalue_district=DistrictList[i]["description"];
      }
    });
  }

  Future? Unfocus() {
    _titleFocus.unfocus();
    _reasonFocus.unfocus();
    _personalMobileFocus.unfocus();
    _personalEmailFocus.unfocus();
    _officialEmailFocus.unfocus();
    _persentPinFocus.unfocus();
    _persentCityFocus.unfocus();
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "start") {
        fileuploader_flag = visibility;
      }
      if (field == "finish") {
        fileuploader_flag = visibility;
      }
    });
  }

  Future uploadFile() async {
    _changed(true, "start");
    // pr.show();
    final bytes = Io.File(file_path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("upload_file");
    basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsEmployeeId': hrmsId_Controller.text,
      "module": "Communication",
      "subModule": "Communication",
      "documentType": "BPD",
      "documentKey": "Supportion",
      "file": img64,
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.headers.set('authorization', basicAuth);

    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON["status"]) {
      setState(() {
        fileUploaded = responseJSON["file_path"];
        Fluttertoast.showToast(
            msg: "File uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 15,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      });
    }
    setState(() {
      _changed(false, "finish");
      //pr.hide();
      // dialog_flag=false;
    });
  }

  /*Future<Null> _getIP() async {
    //PermissionHandler().requestPermissions([PermissionGroup.storage]);

    String ip = await Wifi.ip;
    setState(() {
      _ip = ip;
    });
  }*/

  Future SaveData() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("save_communicationInfo");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    DateTime now = DateTime.now();

    String sr_page = "";
    if (widget.sr_pageno != null && widget.sr_pageno != "") {
      sr_page = widget.sr_pageno;
    }
    String receive_otp = "";
    if (recieve_otp_on_code != null && recieve_otp_on_code != "") {
      receive_otp = recieve_otp_on_code;
    }

    Map map = {
      "hrmsEmployeeIdForCom": hrmsId_Controller.text,
      "presentAddressLine1": present_address_line1_Controller.text,
      "presentAddressLine2": present_address_line2_Controller.text,
      "srPageNumber": sr_page,
      "permanentDistrict": permanent_district_code.toString(),
      "ipAddress": _ip,
      "presentDistrict": selected_distric,
      "officialEmailId": Official_email_Controller.text,
      "permanentState": permanent_state_code.toString(),
      "userId": hrmsId_Controller.text,
      "txnEntryDate": now.toString(),
      "personalMobileNumber": personal_mobileno_Controller.text,
      "presentCity": present_city_Controller.text,
      "officialMobileNo": Official_mobileno_Controller.text,
      "permanentAddressLine1": permanent_address_line1_Controller.text,
      "presentState": selected_state,
      "personalEmailId": personal_email_Controller.text,
      "permanentCity": permanent_city_Controller.text,
      "permanentAddressLine2": permanent_address_line2_Controller.text,
      "permanentPincode": int.parse(permanent_pincode_Controller.text),
      "proofDocument": fileUploaded,
      "addressForCommunication": communication_address_code,
      "presentPincode": int.parse(present_pincode_Controller.text),
      "status": widget.status,
      "changeRequestId": null,
      "otpMobile": receive_otp,
      "remarks": reasonController.text,
      "module": "Employee Master",
      "table": "Communication",
      "changestatus": "C",
      "editcolumn": edit_col
    };
    //print(map.toString());

    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    Fluttertoast.showToast(
        msg: responseJSON['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 5,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);
    setState(() {
      _hasBeenPressed = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    _titleFocus = FocusNode();
    _reasonFocus = FocusNode();
    _personalMobileFocus = FocusNode();
    _personalEmailFocus = FocusNode();
    _officialEmailFocus = FocusNode();
    _persentPinFocus = FocusNode();
    _persentCityFocus = FocusNode();
    hrmsId_Controller.text = widget.hrmsId ?? "";
    personal_mobileno_Controller.text = widget.personal_mobileno ?? "";
    personal_email_Controller.text = widget.personal_email ?? "";
    Official_mobileno_Controller.text = widget.Official_mobileno ?? "";
    Official_email_Controller.text = widget.Official_email ?? "";
    communication_addressController.text = widget.communication_address ?? "";
    permanent_address_line1_Controller.text =
        widget.permanent_address_line1 ?? "";
    permanent_address_line2_Controller.text =
        widget.permanent_address_line2 ?? "";
    if (widget.permanent_pincode != null && widget.permanent_pincode != "") {
      permanent_pincode_Controller.text =
          widget.permanent_pincode.toString() ?? "";
    } else {
      permanent_pincode_Controller.text = "0";
    }

    permanent_city_Controller.text = widget.permanent_city ?? "";
    recieve_otp_on = widget.recieve_otp_on ?? "";

    present_address_line1_Controller.text = widget.present_address_line1 ?? "";
    present_address_line2_Controller.text = widget.present_address_line2 ?? "";

    if (widget.present_pincode != null && widget.present_pincode != "") {
      present_pincode_Controller.text = widget.present_pincode.toString() ?? "";
    } else {
      present_pincode_Controller.text = "0";
    }

    present_district_Controller.text = widget.present_district.toString();
    present_state_Controller.text = widget.present_state ?? "";
    present_city_Controller.text = widget.present_city ?? "";
    permanent_state_code = widget.permanent_state.toString() ?? "";
    permanent_district_code = widget.permanent_district.toString() ?? "";
    communication_address_code = widget.communication_address ?? "";

    recieve_otp_on_code = widget.recieve_otp_on;
    selected_distric = widget.present_district ?? "";

    selected_state = widget.present_state ?? "";

    getFiles();
    //_getIP();
    get_AllStateList();
    if (widget.present_state != null) {
      get_distric(widget.present_state, "Selection");
    }

    super.initState();
  }

  List<String> communicationAddress_list = [
    "Please Select",
    'Present Address',
    "Permanent Address"
  ];
  List<String> Recieve_list = ["Please Select", "Personal", "Official"];
  String text_gender = "Select";
  late String sendCountry;
  String select_reciveotp_on = "Please Select";

  @override
  Widget build(BuildContext context) {
    EasyLoading.show(status: 'Please Wait...');
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Communication Tab",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ),
        body: new InkWell(
            child: SingleChildScrollView(
                child: Container(
                    child: Column(children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.lightBlue,
                    value: true,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          value = true;
                        }
                      });

                      //   });
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    "Please tick the checkbox for edit the value.",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reason *",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(_reasonFocus);
                            },
                            child: TextField(
                              enabled: true,

                              focusNode: _reasonFocus,
                              // autofocus: focus_personal_mobieno,
                              style: TextStyle(fontSize: 13),

                              controller: reasonController,
                              decoration: InputDecoration(
                                hintText: "Reason for Editing ",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ))),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "HRMS Employee ID",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      enabled: false,
                      style: TextStyle(fontSize: 13),
                      controller: hrmsId_Controller,
                      decoration: InputDecoration(
                        hintText: "HRMS Employee ID",
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
                    )),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Mobile Number *",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_personalMobileFocus);
                            },
                            child: TextField(
                              focusNode: _personalMobileFocus,
                              enabled: editOption_personal_mobieno,
                              maxLength: 10,
                              style: TextStyle(fontSize: 13),
                              controller: personal_mobileno_Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Personal Mobile Number",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ))),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_personal_mobieno,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              edit_col.add("personalMobileNumber");
                              value = true;

                              editOption_personal_mobieno = true;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Email",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_personalEmailFocus);
                            },
                            child: TextField(
                              focusNode: _personalEmailFocus,
                              enabled: editOption_personal_email,
                              style: TextStyle(fontSize: 13),
                              controller: personal_email_Controller,
                              onChanged: (String value) async {},
                              decoration: InputDecoration(
                                hintText: "Personal Email",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ))),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_personal_email,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              edit_col.add("personalEmailId");
                              value = true;
                              editOption_personal_email = true;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Official Mobile Number",
                  style: styleHeading,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(_titleFocus);
                        },
                        child: TextField(
                          focusNode: _titleFocus,
                          maxLength: 10,
                          enabled: editOption_official_mobileno,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 13),
                          controller: Official_mobileno_Controller,
                          decoration: InputDecoration(
                            hintText: "Official Mobile Number",
                            filled: true,
                            fillColor: Color(0xFFF2F2F2),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                          ),
                        )),

                    // TextField(
                    //
                    //
                    //   enabled: editOption_official_mobileno,
                    //   keyboardType: TextInputType.number,
                    //   style:TextStyle(fontSize: 13),
                    //   decoration: InputDecoration(
                    //     hintText: "Official Mobile Number",
                    //     filled: true,
                    //     fillColor: Color(0xFFF2F2F2),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(4)),
                    //       borderSide: BorderSide(width: 1,color: Colors.grey),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(4)),
                    //       borderSide: BorderSide(width: 1,color: Colors.grey),
                    //     ),
                    //   ),
                    //)
                  ),
                  Visibility(
                    visible: true,
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.lightBlue,
                      value: editOption_official_mobileno,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            edit_col.add("officialMobileNo");
                            value = true;
                            editOption_official_mobileno = true;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Official Email",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_officialEmailFocus);
                            },
                            child: TextField(
                              focusNode: _officialEmailFocus,
                              controller: Official_email_Controller,
                              enabled: editOption_official_email,
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: "Official Email",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ))),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_official_email,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              edit_col.add("officialEmailId");
                              value = true;
                              editOption_official_email = true;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recieve OTP On?",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: IgnorePointer(
                          ignoring: editOption_reciveotp,
                          child: DropdownButton<String>(
                            value: select_reciveotp_on,
                            isExpanded: true,
                            onChanged: (reciveotp_on) {
                              setState(() {
                                select_reciveotp_on = reciveotp_on!;
                                if (reciveotp_on == "Personal") {
                                  recieve_otp_on_code = "P";
                                } else if (reciveotp_on == "Official") {
                                  recieve_otp_on_code = "O";
                                }
                              });
                            },
                            items: Recieve_list.map<DropdownMenuItem<String>>(
                                (String value) {
                              Unfocus();
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 14),
                                  ));
                            }).toList(),
                          )),
                    ),
                    Visibility(
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: !editOption_reciveotp,
                        onChanged: (value) {
                          setState(() {
                            Unfocus();
                            if (value == true) {
                              edit_col.add("otpMobile");
                              editOption_reciveotp = !editOption_reciveotp;
                              value = true;
                            }
                            // widget.editbox_enable=true;
                            // this.valuefirst = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Communication Address",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: IgnorePointer(
                          ignoring: editOption_communication_address,
                          child: DropdownButton<String>(
                            value: _selected_communication_addres,
                            isExpanded: true,
                            onChanged: (comm_address) {
                              setState(() {
                                _selected_communication_addres = comm_address!;
                                if (_selected_communication_addres ==
                                    "Present Address") {
                                  communication_address_code = "PRESENT";
                                } else if (_selected_communication_addres ==
                                    "Permanent Address") {
                                  communication_address_code = "PERMANENT";
                                }
                              });
                            },
                            items: communicationAddress_list
                                .map<DropdownMenuItem<String>>((String value) {
                              Unfocus();
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 14),
                                  ));
                            }).toList(),
                          )),
                    ),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: !editOption_communication_address,
                        onChanged: (value) {
                          Unfocus();
                          setState(() {
                            if (value == true) {
                              edit_col.add("addressForCommunication");
                              editOption_communication_address =
                                  !editOption_communication_address;
                              value = true;
                            }
                            // widget.editbox_enable=true;
                            // this.valuefirst = true;
                          });
                        },
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
          Text(
            "Present Address",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Address Line 1*",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      keyboardType: TextInputType.text,
                      enabled: editOption_present_address1,
                      style: TextStyle(fontSize: 13),
                      //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],
                      controller: present_address_line1_Controller,
                      decoration: InputDecoration(
                        hintText: "Address Line 1",
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
                    )),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_present_address1,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              edit_col.add("presentAddressLine1");
                              value = true;
                              editOption_present_address1 = true;
                            }
                          });

                          //   });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Address Line 2*",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      keyboardType: TextInputType.text,
                      enabled: editOption_present_address2,
                      style: TextStyle(fontSize: 13),
                      //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],
                      controller: present_address_line2_Controller,
                      decoration: InputDecoration(
                        hintText: "Address Line 2",
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
                    )),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_present_address2,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              edit_col.add("presentAddressLine2");
                              value = true;
                              editOption_present_address2 = true;
                            }
                          });

                          //   });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pincode",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_persentPinFocus);
                            },
                            child: TextField(
                              focusNode: _persentPinFocus,
                              keyboardType: TextInputType.number,
                              enabled: editOption_present_pincode,
                              style: TextStyle(fontSize: 13),
                              controller: present_pincode_Controller,
                              maxLength: 6,
                              decoration: InputDecoration(
                                hintText: "Pincode",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ))),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_present_pincode,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              edit_col.add("presentPincode");
                              editOption_present_pincode = true;
                              value = true;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Center(
                child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "State",
                      style: styleHeading,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IgnorePointer(
                          ignoring: editOption_present_state,
                          child: DropdownButton<String>(
                            value: selected_state,
                            isExpanded: true,
                            hint: Text(hintvalue_state),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                selected_state = "";
                                selected_distric = "";
                                selected_state = newValue!;
                                hintvalue_district = "Please select district";
                                if (newValue != null && newValue != "") {
                                  get_distric(newValue, "NoSelction");
                                }
                              });
                            },
                            items: data.map((item) {
                                  Unfocus();
                                  return DropdownMenuItem<String>(
                                    value: item["code"].toString(),
                                    child: Text(item["description"]),
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.lightBlue,
                          value: !editOption_present_state,
                          onChanged: (value) {
                            setState(() {
                              Unfocus();
                              if (value == true) {
                                edit_col.add("presentState");
                                //editOption_present_state=true;
                                editOption_present_state =
                                    !editOption_present_state;
                                value = true;
                              }
                              // widget.editbox_enable=true;
                              // this.valuefirst = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
            child: Center(
                child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "District",
                      style: styleHeading,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IgnorePointer(
                          ignoring: editOption_present_district,
                          child: DropdownButton<String>(
                            value: selected_distric,
                            isExpanded: true,
                            hint: Text(hintvalue_district),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                //selected_state="";
                                selected_distric = "";
                                selected_distric = newValue!;
                                if (newValue != "" && newValue != null) {}
                              });
                            },
                            items: data_district.map((item) {
                                  Unfocus();
                                  return DropdownMenuItem<String>(
                                    value: item["code"].toString(),
                                    child: Text(item["description"]),
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.lightBlue,
                          value: !editOption_present_district,
                          onChanged: (value) {
                            if (this.mounted) {
                              // check whether the state object is in tree
                              setState(() {
                                Unfocus();
                                if (value == true) {
                                  edit_col.add("presentDistrict");
                                  editOption_present_district =
                                      !editOption_present_district;
                                  value = true;
                                }
                                // widget.editbox_enable=true;
                                // this.valuefirst = true;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "City",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_persentCityFocus);
                            },
                            child: TextField(
                              focusNode: _persentCityFocus,
                              enabled: editOption_present_city,
                              style: TextStyle(fontSize: 13),
                              controller: present_city_Controller,
                              decoration: InputDecoration(
                                hintText: "City",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ))),
                    Visibility(
                      visible: true,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.lightBlue,
                        value: editOption_present_city,
                        onChanged: (value) {
                          if (this.mounted) {
                            // check whether the state object is in tree
                            setState(() {
                              Unfocus();

                              if (value == true) {
                                edit_col.add("presentCity");
                                value = true;
                                editOption_present_city = true;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Container(
          //   child:Row(children: <Widget>[
          //     Text("Is Present Address same as Permanent Address?",style: TextStyle(fontSize: 12),),
          //     Container(
          //       child:Checkbox(
          //           value:true,
          //       ),
          //     ),
          //     Text("Yes",style: TextStyle(fontSize: 12),),
          //   ]),
          // ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Supporting Proof Document",
                    style: styleHeading,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlueAccent)),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightBlueAccent)),
                              //             <--- BoxDecoration here
                              child: GestureDetector(
                                  onTap: () async {
                                    Fluttertoast.showToast(
                                        msg: 'Please Wait...',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        //  timeInSecForIos: 5,
                                        backgroundColor: Colors.pink,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                    EasyLoading.show(status: 'Please Wait...');
                                    /*result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FileList(files)),
                                    );*/
                                    result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FileList()),
                                    );
                                    if (this.mounted) {
                                      // check whether the state object is in tree
                                      setState(() {
                                        file_path = result;
                                        EasyLoading.dismiss();
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Choose File",
                                    style: TextStyle(fontSize: 10.0),
                                  )),
                            ),
                            Expanded(
                              child: Text(
                                file_path ?? "No file chosen",
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 40,
                                color: Colors.lightBlueAccent,
                                child: TextButton(
                                  onPressed: () {
                                    Timer timer;

                                    timer = Timer.periodic(
                                        Duration(milliseconds: 500), (_) {
                                      if (mounted) {
                                        if (this.mounted) {
                                          // check whether the state object is in tree
                                          setState(() {
                                            percent += 2;
                                            if (percent >= 100) {
                                              percent = 0.0;
                                              //timer .cancel();
                                              //percent=0;
                                            }
                                          });
                                        }
                                      }
                                    });
                                    if (file_path == "" || file_path == null) {
                                    } else {
                                      uploadFile();
                                    }
                                  },
                                  child: Text("Upload",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
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

          Visibility(
            visible: fileuploader_flag,
            maintainState: true,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 10,
              child: LinearProgressIndicator(
                value: percent / 100, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors
                    .lightBlueAccent), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FilledButton(
                  child: Text(
                    'Submit',
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
                    bool emailValid_personal = false;
                    bool emailValid_official = false;
                    //print("email length"+personal_email_Controller.text.length.toString());
                    if (personal_email_Controller.text.trim().length != 0) {
                      setState(() {
                        emailValid_personal = RegExp(
                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(personal_email_Controller.text);
                      });
                    }
                    if (Official_email_Controller.text.trim().length != 0) {
                      setState(() {
                        emailValid_official = RegExp(
                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(Official_email_Controller.text);
                      });
                    }
                    // print(emailValid_official);
                    if (reasonController.text.trim().length == 0) {
                      Fluttertoast.showToast(
                          msg: 'Please Enter Reason For Editing',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 5,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 14.0);
                    } else if (personal_mobileno_Controller.text
                                .trim()
                                .length ==
                            0 ||
                        personal_mobileno_Controller.text.trim().length > 10 ||
                        personal_mobileno_Controller.text.trim().length < 10) {
                      Fluttertoast.showToast(
                          msg:
                              'Please Enter Correct Employee Personal Mobile Number',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 5,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 14.0);
                    } else if (emailValid_personal == false) {
                      Fluttertoast.showToast(
                          msg: 'Please Enter A Valid Personal Email Address',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 5,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 14.0);
                    } else if (emailValid_official == false) {
                      Fluttertoast.showToast(
                          msg: 'Please Enter A Official Valid Email Address',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 5,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 14.0);
                    } else if (fileUploaded == "" || fileUploaded == null) {
                      Fluttertoast.showToast(
                          msg: 'Please Select File',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 5,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 14.0);
                    } else {
                      // getfilepath();
                      if (Official_mobileno_Controller.text.trim().length >
                          10) {
                        Fluttertoast.showToast(
                            msg:
                                'Please Enter Correct Employee Official Mobile Number',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else if (present_pincode_Controller.text.trim().length >
                          6) {
                        Fluttertoast.showToast(
                            msg: 'Please Enter 6 Digit PinCode',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else {
                        setState(() {
                          _hasBeenPressed = true;
                        });
                        SaveData();
                      }
                    }
                  }),
              Container(
                child: GestureDetector(
                  child: Text("create Document"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PdfTabBarDemo()),
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),

          // TwinkleButton(
          //     buttonWidth: 200,
          //     buttonTitle: Text(
          //       'Create Document',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16.0,
          //       ),
          //     ),
          //     buttonColor: Color(0xFF40C4FF),
          //     onclickButtonFunction: () {
          //
          //
          //     }
          // ),
          SizedBox(
            height: 10,
          ),
        ])))));
  }
}
