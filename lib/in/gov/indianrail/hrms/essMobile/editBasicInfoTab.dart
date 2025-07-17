import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as fileUtil;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/pdftabview.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
//import 'package:wifi/wifi.dart';

import '../selectdoc.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

String _selectedblood = "A POSITIVE";
var testText = "A+";
String _selectedspouse_type = "Please Select";
String _selected_country_type = "Please Select";

class EditbasicTabInfo extends StatefulWidget {
  var emp_hindi_name,
      emp_regional_name,
      country_birth,
      birth_place,
      spouse_name,
      spouse_emp_type,
      ipasid_spouse,
      blood_group;

  EditbasicTabInfo(
    this.emp_hindi_name,
    this.emp_regional_name,
    this.country_birth,
    this.birth_place,
    this.spouse_name,
    this.spouse_emp_type,
    this.ipasid_spouse,
    this.blood_group,
  );

  @override
  EditbasicTabInfo_State createState() => EditbasicTabInfo_State();
}

class EditbasicTabInfo_State extends State<EditbasicTabInfo> {
  var fileUploaded = "";
  late String result;
  double percent = 0.0;

  var fileuploader_flag = false;
  late List<String> edit_col;
  late String _ip;
  bool editOption_reason = false;
  bool editOption_namehindi = false;
  bool editOption_namereginal = false;
  bool editOption_country = true;
  bool editOption_birtyplace = false;
  bool editOption_spousename = false;
  bool editOption_spouseemp_type = true;
  bool editOption_spouseipassId = false;
  bool editOption_bloodgroup = true;
  bool _hasBeenPressed = false;
  bool _isLoading = false;
  late bool checkboxVisible;

  TextStyle styleHeading = TextStyle(color: Colors.black, fontSize: 16);

  var ipassId,
      hrmsId,
      emp_name_sr,
      emp_name_aadhaar,
      aadhaarnumber,
      emp_first_name,
      emp_last_name,
      emp_mid_name,
      emp_hindi_name,
      emp_regional_name,
      country_birth,
      birth_place,
      date_of_birth,
      gender,
      father_name,
      mother_name,
      guardian,
      spouse_name,
      spouse_emp_type,
      ipasid_spouse,
      pan_number,
      blood_group,
      superannuation_date,
      userId,
      pan_upload,
      medical_facility,
      name_parent_other,
      aadhaar_upload,
      db_certificate;
  String sr_number = "";
  TextEditingController reasonController = TextEditingController();
  TextEditingController emp_name_hindiController = TextEditingController();
  TextEditingController emp_name_regionalController = TextEditingController();
  TextEditingController country_birthController = TextEditingController();
  TextEditingController birth_placeController = TextEditingController();
  TextEditingController spouse_nameController = TextEditingController();
  TextEditingController emp_spouse_typeController = TextEditingController();
  TextEditingController ipas_id_spouseController = TextEditingController();
  TextEditingController blood_groupController = TextEditingController();

  TextEditingController ipassController = TextEditingController();
  TextEditingController hrmsController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController emp_name_srController = TextEditingController();
  TextEditingController emp_name_aadharController = TextEditingController();
  TextEditingController employee_first_nameController = TextEditingController();
  TextEditingController employee_middle_nameController =
      TextEditingController();
  TextEditingController employee_last_nameController = TextEditingController();

  TextEditingController genderController = TextEditingController();
  TextEditingController father_nameController = TextEditingController();
  TextEditingController mother_nameController = TextEditingController();
  TextEditingController date_of_birthController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController superannuation_dateController = TextEditingController();
  late String fileName;
  late String path;
  late Map<String, String> paths;
  late List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;

  // FileType fileType=null;

  var files;
  var file_path;

  late String uploadedfile;
  late String img64;

  Future<void> getImages() async {
    final picker = ImagePicker();
    final File image =
        (await picker.pickImage(source: ImageSource.gallery, imageQuality: 50))
            as File;
  }

  /*void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
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

  late FocusNode _emp_namehindiFocus;
  late FocusNode _emp_namereginalFocus;
  late FocusNode _emp_spousenameFocus;
  late FocusNode _emp_ipasid_spouseFocus;
  late FocusNode _emp_birth_placeFocus;
  late FocusNode _reasonFocus;

  Future? unfocus() {
    _emp_namehindiFocus.unfocus();
    _emp_namereginalFocus.unfocus();
    _emp_spousenameFocus.unfocus();
    _emp_ipasid_spouseFocus.unfocus();
    _emp_birth_placeFocus.unfocus();
    _reasonFocus.unfocus();
  }

  Future getdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("ess_basic_info");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "employeeId": await pref.getUsername(),
      "userId": "ESS",
      "railwayUnit": await pref.getEmployeeUnitcode(),
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);

    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null) {
      setState(() {
        ipassId = responseJSON['jsonResult']['headerdata']['ipasEmployeeId'];
        hrmsId = responseJSON['jsonResult']['headerdata']['hrmsEmployeeId'];
        emp_name_sr =
            responseJSON['jsonResult']['headerdata']['employeeNameSR'] ?? "";
        emp_name_aadhaar =
            responseJSON['jsonResult']['headerdata']['employeeNameAadhaar'] ??
            "";
        aadhaarnumber =
            responseJSON['jsonResult']['headerdata']['aadhaarNumber'] ?? "";
        emp_first_name =
            responseJSON['jsonResult']['headerdata']['employeeFirstName'] ?? "";
        emp_last_name =
            responseJSON['jsonResult']['headerdata']['employeeLastName'] ?? "";
        emp_mid_name =
            responseJSON['jsonResult']['headerdata']['employeeMiddleName'] ??
            "";
        emp_hindi_name =
            responseJSON['jsonResult']['headerdata']['nameHindiLang'] ?? "";
        emp_regional_name =
            responseJSON['jsonResult']['headerdata']['nameRegionalLang'] ?? "";
        country_birth =
            responseJSON['jsonResult']['headerdata']['birthCountry'] ?? "";
        birth_place =
            responseJSON['jsonResult']['headerdata']['birthPlace'] ?? "";
        date_of_birth =
            responseJSON['jsonResult']['headerdata']['dateOfBirth'] ?? "";
        gender = responseJSON['jsonResult']['headerdata']['gender'] ?? "";
        father_name =
            responseJSON['jsonResult']['headerdata']['fatherName'] ?? "";
        mother_name =
            responseJSON['jsonResult']['headerdata']['motherName'] ?? "";
        guardian =
            responseJSON['jsonResult']['headerdata']['guardianName'] ?? "";
        spouse_name =
            responseJSON['jsonResult']['headerdata']['spouseName'] ?? "";
        spouse_emp_type =
            responseJSON['jsonResult']['headerdata']['spouseEmploymentType'] ??
            "";
        ipasid_spouse =
            responseJSON['jsonResult']['headerdata']['spouseIpasID'] ?? "";
        pan_number =
            responseJSON['jsonResult']['headerdata']['panNumber'] ?? "";
        blood_group =
            responseJSON['jsonResult']['headerdata']['bloodGroup'] ?? "";
        superannuation_date =
            responseJSON['jsonResult']['headerdata']['superannuationDate'] ??
            "";
        if (responseJSON['jsonResult']['headerdata']['panUpload'] == null ||
            responseJSON['jsonResult']['headerdata']['panUpload'] == "") {
          pan_upload = "";
        } else {
          pan_upload = responseJSON['jsonResult']['headerdata']['panUpload'];
        }

        // medical_facility=responseJSON['medical_facility'];
        //name_parent_other=responseJSON['name_parent_other'];
        //aadhaar_upload=responseJSON['aadhaar_upload'];
        if (responseJSON['jsonResult']['headerdata']['medicalFacility'] ==
                null ||
            responseJSON['jsonResult']['headerdata']['medicalFacility'] == "") {
          medical_facility = "";
        } else {
          medical_facility =
              responseJSON['jsonResult']['headerdata']['medicalFacility'];
        }
        if (responseJSON['jsonResult']['headerdata']['guardianName'] == null ||
            responseJSON['jsonResult']['headerdata']['guardianName'] == "") {
          name_parent_other = "";
        } else {
          name_parent_other =
              responseJSON['jsonResult']['headerdata']['guardianName'];
        }
        if (responseJSON['jsonResult']['headerdata']['aadhaarUpload'] == null ||
            responseJSON['jsonResult']['headerdata']['aadhaarUpload'] == "") {
          aadhaar_upload = "";
        } else {
          aadhaar_upload =
              responseJSON['jsonResult']['headerdata']['aadhaarUpload'];
        }

        if (responseJSON['jsonResult']['headerdata']['dobCertificateUpload'] ==
                null ||
            responseJSON['jsonResult']['headerdata']['dobCertificateUpload'] ==
                "") {
          db_certificate = "";
        } else {
          db_certificate =
              responseJSON['jsonResult']['headerdata']['dobCertificateUpload'];
        }

        ipassController.text = ipassId;
        hrmsController.text = hrmsId;
        emp_name_srController.text = emp_name_sr;
        aadharNoController.text = aadhaarnumber;
        emp_name_aadharController.text = emp_name_aadhaar;
        employee_first_nameController.text = emp_first_name;
        employee_last_nameController.text = emp_last_name;
        employee_middle_nameController.text = emp_mid_name;
        mother_nameController.text = mother_name;
        father_nameController.text = father_name;
        date_of_birthController.text = date_of_birth;
        genderController.text = gender;
        emp_name_hindiController.text = emp_hindi_name;
        emp_name_regionalController.text = emp_regional_name;
        country_birthController.text = country_birth;
        birth_placeController.text = birth_place;
        spouse_nameController.text = spouse_name;
        emp_spouse_typeController.text = spouse_emp_type;
        panController.text = pan_number;
        superannuation_dateController.text = superannuation_date;
        if (ipasid_spouse == "" || ipasid_spouse == null) {
          ipas_id_spouseController.text = "";
        } else {
          ipas_id_spouseController.text = ipasid_spouse;
        }

        // dob= responseJSON['userProfile']['profile']['dateOfBirth'];
      });
    }
    if (country_birth == "CPV") {
      _selected_country_type = "CAPE VERDE";
      sendCountry = "CPV";
    } else if (country_birth == "CYM") {
      _selected_country_type = "CAYMAN ISLANDS";
      sendCountry = "CYM";
    } else if (country_birth == "CAF") {
      _selected_country_type = "CENTRAL AFRICAN REPUBLIC";
      sendCountry = "CAF";
    } else if (country_birth == "TCD") {
      _selected_country_type = " CENTRAL AFRICAN REPUBLIC";
      sendCountry = "TCD";
    } else if (country_birth == "CHL") {
      _selected_country_type = "CHILE";
      sendCountry = "CHL";
    } else if (country_birth == "PYF") {
      _selected_country_type = "FRENCH POLYNESIA";
      sendCountry = "PYF";
    } else if (country_birth == "FRA") {
      _selected_country_type = "FRANCE";
      sendCountry = "FRA";
    } else if (country_birth == "GAB") {
      _selected_country_type = "GABON";
      sendCountry = "GAB";
    } else if (country_birth == "GRC") {
      _selected_country_type = "GREECE";
      sendCountry = "GRC";
    } else if (country_birth == "IND") {
      _selected_country_type = "INDIA";
      sendCountry = "IND";
    } else if (country_birth == "IDN") {
      _selected_country_type = "INDONESIA";
      sendCountry = "IDN";
    } else if (country_birth == "IRN") {
      _selected_country_type = "ISLAMIC REPUBLIC OF IRAN";
      sendCountry = "IRN";
    } else if (country_birth == "IRQ") {
      _selected_country_type = "IRAQ";
      sendCountry = "IRQ";
    } else if (country_birth == "IRL") {
      _selected_country_type = "IRELAND";
      sendCountry = "IRL";
    } else if (country_birth == "ISR") {
      _selected_country_type = "ISRAEL";
      sendCountry = "ISR";
    } else if (country_birth == "ITA") {
      _selected_country_type = "ITALY";
      sendCountry = "ITA";
    } else if (country_birth == "JPN") {
      _selected_country_type = "JAPAN";
      sendCountry = "JPN";
    } else if (country_birth == "JEY") {
      _selected_country_type = "JERSEY";
      sendCountry = "JEY";
    } else if (country_birth == "JOR") {
      sendCountry = "JOR";
      _selected_country_type = "JORDAN";
    }

    if (spouse_emp_type == null || spouse_emp_type == "") {
    } else {
      _selectedspouse_type = spouse_emp_type;
    }
    if (blood_group == "A+") {
      sendBlood = "A+";
      _selectedblood = "A POSITIVE";
    } else if (blood_group == "A-") {
      _selectedblood = "A NEGATIVE";
      sendBlood = "A-";
    } else if (blood_group == "B+") {
      sendBlood = "B+";
      _selectedblood = "B POSITIVE";
    } else if (blood_group == "B-") {
      sendBlood = "B-";
      _selectedblood = "B NEGATIVE";
    } else if (blood_group == "AB-") {
      sendBlood = "AB-";
      _selectedblood = "AB NEGATIVE";
    } else if (blood_group == "AB+") {
      _selectedblood = "AB POSITIVE";
      sendBlood = "AB";
    } else if (blood_group == "O-") {
      sendBlood = "O-";
      _selectedblood = "O NEGATIVE";
    } else if (blood_group == "O+") {
      sendBlood = "O+";
      _selectedblood = "O POSITIVE";
    } else if (blood_group == "HH") {
      sendBlood = "HH";
      _selectedblood = "BOMBAY BLOOD GROUP";
    } else if (blood_group == "INRA") {
      sendBlood = "INRA";
      _selectedblood = "INRA";
    }

    blood_groupController.text = _selectedblood;
  }

  Future uploadFile() async {
    //pr.show();
    _changed(true, "start");
    final bytes = Io.File(file_path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("upload_file");
    basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsEmployeeId': hrmsId,
      "module": "ESS",
      "subModule": "Basic",
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
          //  timeInSecForIos: 15,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      });
    }
    setState(() {
      _changed(false, "finish");

      // dialog_flag=false;
    });
  }

  /*Future<Null> _getIP() async {
    //PermissionHandler().requestPermissions([PermissionGroup.storage]);

    //String ip = await Wifi.ip;
    setState(() {
      _ip = ip;
    });
  }*/

  Future SaveData() async {
    final String url = new UtilsFromHelper().getValueFromKey(
      "save_ess_employee",
    );
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    DateTime now = DateTime.now();
    Map map = {
      "ipasEmployeeId": ipassId,
      "hrmsEmployeeId": hrmsId,
      "employeeNameSR": emp_name_sr,
      "employeeNameAadhaar": emp_name_aadhaar,
      "employeeFirstName": emp_first_name,
      "employeeMiddleName": emp_mid_name,
      "employeeLastName": emp_last_name,
      "nameHindiLang": emp_name_hindiController.text,
      "nameRegionalLang": emp_name_regionalController.text,
      "birthCountry": sendCountry,
      "birthPlace": birth_placeController.text,
      "dateOfBirth": date_of_birth,
      "dobCertificateUpload": db_certificate,
      "gender": gender,
      "fatherName": father_name,
      "motherName": mother_name,
      "guardianName": name_parent_other,
      "spouseName": spouse_nameController.text,
      "spouseEmploymentType": _selectedspouse_type,
      "spouseIpasID": ipas_id_spouseController.text,
      "panNumber": pan_number,
      "panUpload": pan_upload,
      "aadhaarNumber": aadhaarnumber,
      "aadhaarUpload": aadhaar_upload,
      "bloodGroup": sendBlood,
      "srPageNumber": sr_number,
      "superannuationDate": superannuation_date,
      "userId": hrmsId,
      "ipAddress": _ip,
      "status": "C",
      "txnEntryDate": now.toString(),
      "statusdcassign": "",
      "remarks": reasonController.text,
      "basicProofDocument": fileUploaded,
      "medicalFacility": medical_facility,
      "changeRequestId": null,
      "module": "Employee Master",
      "table": "Basic",
      "status": "C",
      "editcolumn": edit_col,
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON['result']) {
      Fluttertoast.showToast(
        msg: responseJSON['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 5,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: responseJSON['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //  timeInSecForIos: 15,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    setState(() {
      _hasBeenPressed = false;
    });
    Navigator.pop(context);
    // if(responseJSON!=null){
    //   setState(() {
    //
    //     ipassId=responseJSON['ipas_employee_id'];
    //     hrmsId=responseJSON['hrms_employee_id'];
    //     emp_name_sr=responseJSON['employee_name_sr'];
    //     emp_name_aadhaar=responseJSON['employee_name_aadhaar'];
    //     aadhaarnumber=responseJSON['aadhaar_number'];
    //     emp_first_name=responseJSON['employee_first_name'];
    //     emp_last_name=responseJSON['employee_last_name'];
    //     emp_mid_name=responseJSON['employee_middle_name'];
    //     emp_hindi_name=responseJSON['name_hindi_lang'];
    //     emp_regional_name=responseJSON['name_regional_lang'];
    //     country_birth=responseJSON['birth_country'];
    //     birth_place=responseJSON['birth_place'];
    //     date_of_birth=responseJSON['date_of_birth'];
    //     gender=responseJSON['gender'];
    //     father_name=responseJSON['father_name'];
    //     mother_name=responseJSON['mother_name'];
    //     guardian=responseJSON['name_parent_other'];
    //     spouse_name=responseJSON['spouse_name'];
    //     spouse_emp_type=responseJSON['spouse_employment'];
    //     ipasid_spouse=responseJSON['spouse_ipass_no'];
    //     pan_number=responseJSON['pan_number'];
    //     blood_group=responseJSON['blood_group'];
    //     superannuation_date=responseJSON['superannuation_date'];
    //     // dob= responseJSON['userProfile']['profile']['dateOfBirth'];
    //   });
    //
    // }
  }

  @override
  void initState() {
    getFiles();
    //_getIP();
    getdetails();
    _emp_namehindiFocus = FocusNode();
    _emp_namereginalFocus = FocusNode();
    _emp_spousenameFocus = FocusNode();
    _emp_ipasid_spouseFocus = FocusNode();
    _emp_birth_placeFocus = FocusNode();
    _reasonFocus = FocusNode();
    super.initState();
  }

  List<String> g_list = ['Male', "Female", "Other"];
  List<String> blood_list = [
    "A POSITIVE",
    "A NEGATIVE",
    "AB POSITIVE",
    "AB NEGATIVE",
    "B POSITIVE",
    "B NEGATIVE",
    "O POSITIVE",
    "O NEGATIVE",
    "BOMBAY BLOOD GROUP",
    "INRA",
  ];
  List<String> spouse_emp_type_list = [
    "Please Select",
    "NOT EMPLOYED",
    "PRIVATE SECTOR",
    "PUBLIC SECTOR UNIT",
    "STATE GOVERNMENT",
    "CENTRAL GOVERNMENT(OTHER)",
    "CENTRAL GOVERNMENT(RAILWAYS)",
  ];

  // CPV,
  // CYM,

  // CAF
  // TCD
  // CHL
  List<String> country_list = [
    "Please Select",
    "CAPE VERDE",
    "CAYMAN ISLANDS",
    "CENTRAL AFRICAN REPUBLIC",
    "CHAD",
    "CHILE",
    "FRENCH POLYNESIA",
    "FRANCE",
    "GABON",
    "GREECE",
    "INDIA",
    "INDONESIA",
    "ISLAMIC REPUBLIC OF IRAN",
    "IRAQ",
    "IRELAND",
    "ISRAEL",
    "ITALY",
    "JAPAN",
    "JERSEY",
    "JORDAN",
  ];
  late String _selectedgender;
  late String text_gender = "Select";
  late String sendBlood;
  late String sendCountry;

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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: _isLoading,
      backgroundColor: Colors.white,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            "Basic Tab",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
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
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        child: Text("Reason *", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_reasonFocus);
                              },
                              child: TextField(
                                enabled: true,
                                focusNode: _reasonFocus,
                                style: TextStyle(fontSize: 13),
                                controller: reasonController,
                                decoration: InputDecoration(
                                  hintText: "Reason for Editing ",
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
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
                        child: Text("IPAS Employee Id", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: ipassController,
                              decoration: InputDecoration(
                                hintText: "IPAS Employee Id ",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("HRMS Employee ID", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: hrmsController,
                              decoration: InputDecoration(
                                hintText: "HRMS Employee ID",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                          "Employee Name As in SR",
                          style: styleHeading,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: emp_name_srController,
                              decoration: InputDecoration(
                                hintText: "Employee Name As in SR",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                          "Employee Name As in Aadhaar",
                          style: styleHeading,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: emp_name_aadharController,
                              decoration: InputDecoration(
                                hintText: "Employee Name As in Aadhaar",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("Aadhaar Number", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: aadharNoController,
                              decoration: InputDecoration(
                                hintText: "Aadhaar Number",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("Employee First Name", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: employee_first_nameController,
                              decoration: InputDecoration(
                                hintText: "Employee First Name",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                          "Employee Middle Name",
                          style: styleHeading,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: employee_middle_nameController,
                              decoration: InputDecoration(
                                hintText: "Employee Middle Name ",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("Employee Last Name", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: employee_last_nameController,
                              decoration: InputDecoration(
                                hintText: "Employee Last Name",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("Employee Name Hindi", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_emp_namehindiFocus);
                              },
                              child: TextField(
                                focusNode: _emp_namehindiFocus,
                                keyboardType: TextInputType.text,
                                enabled: editOption_namehindi,
                                style: TextStyle(fontSize: 13),
                                //  inputFormatters: [new FilteringTextInputFormatter.deny(RegExp(r'^[0-9_\-=@,\.;]+$')),],
                                controller: emp_name_hindiController,
                                decoration: InputDecoration(
                                  hintText: "Employee Name Hindi",
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.lightBlue,
                              value: editOption_namehindi,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    edit_col.add("nameHindiLang");
                                    value = true;
                                    editOption_namehindi = true;
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
                          "Employee Name Regional",
                          style: styleHeading,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_emp_namereginalFocus);
                              },
                              child: TextField(
                                focusNode: _emp_namereginalFocus,
                                enabled: editOption_namereginal,
                                style: TextStyle(fontSize: 13),
                                controller: emp_name_regionalController,
                                inputFormatters: [
                                  new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z -]"),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Employee Name Regional",
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.lightBlue,
                              value: editOption_namereginal,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    edit_col.add("nameRegionalLang");
                                    editOption_namereginal = true;
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
                              "Country of Birth",
                              style: styleHeading,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: editOption_country,
                                  child: DropdownButton<String>(
                                    value: _selected_country_type,
                                    isExpanded: true,
                                    onChanged: (country) {
                                      setState(() {
                                        unfocus();
                                        _selected_country_type = country!;

                                        if (country == "CAPE VERDE") {
                                          sendCountry = "CPV";
                                        } else if (country ==
                                            "CAYMAN ISLANDS") {
                                          sendCountry = "CYM";
                                        } else if (country ==
                                            "CENTRAL AFRICAN REPUBLIC") {
                                          sendCountry = "CAF";
                                        } else if (country == "TCD") {
                                          sendCountry = "TCD";
                                        } else if (country == "CHILE") {
                                          sendCountry = "CHL";
                                        } else if (country ==
                                            "FRENCH POLYNESIA") {
                                          sendCountry = "PYF";
                                        } else if (country == "FRANCE") {
                                          sendCountry = "FRA";
                                        } else if (country == "GABON") {
                                          sendCountry = "GAB";
                                        } else if (country == "GREECE") {
                                          sendCountry = "GRC";
                                        } else if (country == "INDIA") {
                                          sendCountry = "IND";
                                        } else if (country == "INDONESIA") {
                                          sendCountry = "IDN";
                                        } else if (country ==
                                            "ISLAMIC REPUBLIC OF IRAN") {
                                          sendCountry = "IRN";
                                        } else if (country == "IRAQ") {
                                          sendCountry = "IRQ";
                                        } else if (country == "IRELAND") {
                                          sendCountry = "IRL";
                                        } else if (country == "ISRAEL") {
                                          sendCountry = "ISR";
                                        } else if (country == "ITALY") {
                                          sendCountry = "ITA";
                                        } else if (country == "JAPAN") {
                                          sendCountry = "JPN";
                                        } else if (country == "JERSEY") {
                                          sendCountry = "JEY";
                                        } else if (country == "JORDAN") {
                                          sendCountry = "JOR";
                                        }
                                      });
                                    },
                                    items: country_list
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          unfocus();
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.lightBlue,
                                  value: !editOption_country,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        edit_col.add("birthCountry");
                                        editOption_country =
                                            !editOption_country;
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
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Birth Place", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_emp_birth_placeFocus);
                              },
                              child: TextField(
                                focusNode: _emp_birth_placeFocus,
                                enabled: editOption_birtyplace,
                                style: TextStyle(fontSize: 13),
                                controller: birth_placeController,
                                decoration: InputDecoration(
                                  hintText: "Birth Place",
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.lightBlue,
                              value: editOption_birtyplace,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    edit_col.add("birthPlace");
                                    value = true;
                                    editOption_birtyplace = true;
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
                        child: Text("Date Of Birth", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: date_of_birthController,
                              decoration: InputDecoration(
                                hintText: "Date Of Birth",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                            child: Text("Gender", style: styleHeading),
                          ),
                          SizedBox(height: 5),
                          IgnorePointer(
                            ignoring: true,
                            child: DropdownButton(
                              isExpanded: true,

                              dropdownColor: Color(0xFFF2F2F2),
                              hint: Text('Please Select Gender'),
                              // Not necessary for Option 1
                              value: _selectedgender,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedgender = newValue!;
                                });
                              },
                              items: g_list.map((value) {
                                return DropdownMenuItem(
                                  child: new Text(
                                    value,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Father Name", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: father_nameController,
                              decoration: InputDecoration(
                                hintText: "Father Name ",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("Mother Name", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: mother_nameController,
                              decoration: InputDecoration(
                                hintText: "Mother Name",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("PAN Number", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: panController,
                              decoration: InputDecoration(
                                hintText: "PAN Number",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                        child: Text("Spouse Name", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_emp_spousenameFocus);
                              },
                              child: TextField(
                                focusNode: _emp_spousenameFocus,
                                enabled: editOption_spousename,
                                style: TextStyle(fontSize: 13),
                                controller: spouse_nameController,
                                inputFormatters: [
                                  new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z -]"),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Spouse Name",
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.lightBlue,
                              value: editOption_spousename,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    edit_col.add("spouseName");
                                    editOption_spousename = true;
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
                              "Spouse Employment Type",
                              style: styleHeading,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: editOption_spouseemp_type,
                                  child: DropdownButton<String>(
                                    value: _selectedspouse_type,
                                    isExpanded: true,
                                    onChanged: (spousetype) {
                                      setState(() {
                                        unfocus();
                                        _selectedspouse_type = spousetype!;
                                      });
                                    },
                                    items: spouse_emp_type_list
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.lightBlue,
                                  value: !editOption_spouseemp_type,
                                  onChanged: (value) {
                                    setState(() {
                                      unfocus();
                                      if (value == true) {
                                        edit_col.add("spouseEmploymentType");
                                        editOption_spouseemp_type =
                                            !editOption_spouseemp_type;
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
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("IPAS ID of Spouse", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_emp_ipasid_spouseFocus);
                              },
                              child: TextField(
                                focusNode: _emp_ipasid_spouseFocus,
                                inputFormatters: [
                                  new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z0-9]"),
                                  ),
                                ],
                                enabled: editOption_spouseipassId,
                                style: TextStyle(fontSize: 13),
                                maxLength: 12,
                                controller: ipas_id_spouseController,
                                decoration: InputDecoration(
                                  hintText: "IPAS ID of Spouse",
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.lightBlue,
                              value: editOption_spouseipassId,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    edit_col.add("spouseIpasId");
                                    editOption_spouseipassId = true;
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
                            child: Text("BLOOD GROUP", style: styleHeading),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: editOption_bloodgroup,
                                  child: DropdownButton<String>(
                                    value: _selectedblood,
                                    isExpanded: true,
                                    onChanged: (newval) {
                                      setState(() {
                                        _selectedblood = newval!;

                                        if (newval == "A POSITIVE") {
                                          sendBlood = "A+";
                                          // _selectedblood="A NEGATIVE";
                                        } else if (newval == "A NEGATIVE") {
                                          // _selectedblood="A NEGATIVE";
                                          sendBlood = "A-";
                                        } else if (newval == "B POSITIVE") {
                                          sendBlood = "B+";
                                          // _selectedblood="A NEGATIVE";
                                        } else if (newval == "B NEGATIVE") {
                                          // _selectedblood="A NEGATIVE";
                                          sendBlood = "B-";
                                        } else if (newval == "O POSITIVE") {
                                          sendBlood = "O+";
                                          // _selectedblood="A NEGATIVE";
                                        } else if (newval == "O NEGATIVE") {
                                          // _selectedblood="A NEGATIVE";
                                          sendBlood = "O-";
                                        } else if (newval == "AB POSITIVE") {
                                          sendBlood = "AB+";
                                          // _selectedblood="A NEGATIVE";
                                        } else if (newval == "AB NEGATIVE") {
                                          // _selectedblood="A NEGATIVE";
                                          sendBlood = "AB-";
                                        } else if (newval == "INRA") {
                                          // _selectedblood="A NEGATIVE";
                                          sendBlood = "INRA";
                                        } else if (newval ==
                                            "BOMBAY BLOOD GROUP") {
                                          // _selectedblood="A NEGATIVE";
                                          sendBlood = "HH";
                                        }
                                      });
                                    },
                                    items: blood_list
                                        .map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.lightBlue,
                                  value: !editOption_bloodgroup,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        edit_col.add("bloodGroup");
                                        value = true;
                                        editOption_bloodgroup =
                                            !editOption_bloodgroup;
                                      }
                                      // widget.editbox_enable=true;
                                      //this.valuefirst = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Superannuation Date", style: styleHeading),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(fontSize: 13),
                              controller: superannuation_dateController,
                              decoration: InputDecoration(
                                hintText: "Superannuation Date",
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
                          "Supporting Proof Document",
                          style: styleHeading,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                    //             <--- BoxDecoration here
                                    child: GestureDetector(
                                      onTap: () async {
                                        Fluttertoast.showToast(
                                          msg: "Please Wait...",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          //  timeInSecForIos: 15,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                        /*result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FileList(files)),
                                    );*/
                                        result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FileList(),
                                          ),
                                        );
                                        setState(() {
                                          file_path = result;
                                        });
                                      },
                                      child: Text(
                                        "Choose File",
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ),
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
                                            Duration(milliseconds: 500),
                                            (_) {
                                              if (mounted) {
                                                setState(() {
                                                  percent += 2;
                                                  if (percent >= 100) {
                                                    percent = 0.0;
                                                    //timer .cancel();
                                                    //percent=0;
                                                  }
                                                });
                                              }
                                            },
                                          );
                                          if (file_path == "" ||
                                              file_path == null) {
                                          } else {
                                            uploadFile();
                                          }
                                        },
                                        child: Text(
                                          "Upload",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
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
                    ],
                  ),
                ),
                Visibility(
                  visible: fileuploader_flag,
                  maintainState: true,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 10,
                    width: 140,
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(
                        Colors.lightBlueAccent,
                      ),
                      // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors.white,
                      // Defaults to the current Theme's backgroundColor.
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FilledButton(
                      //width: 200,
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
                            : Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        if (reasonController.text.trim().length == 0) {
                          Fluttertoast.showToast(
                            msg: 'Please Enter Reason for editing',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        } else if (_selectedspouse_type == "Please Select") {
                          Fluttertoast.showToast(
                            msg: 'Please Select Spouse Employment Type ',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        } else if (ipas_id_spouseController.text.length > 12) {
                          Fluttertoast.showToast(
                            msg: 'Please Enter Correct IPAS Id Of Spouse',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        } else if (fileUploaded == "" || fileUploaded == null) {
                          Fluttertoast.showToast(
                            msg: 'Please Select File',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        } else {
                          setState(() {
                            _hasBeenPressed = true;
                          });
                          SaveData();
                        }
                      },
                    ),
                    Container(
                      child: GestureDetector(
                        child: Text("create Document"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfTabBarDemo(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget setupAlertDialoadContainer() {
  //   return Container(
  //     height: 380.0, // Change as per your requirement
  //     width: 430.0, // Change as per your requirement
  //     child: ListView.builder(  //if file/folder list is grabbed, then show here
  //       itemCount: files?.length ?? 0,
  //       itemBuilder: (context, index) {
  //         return Card(
  //             child:ListTile(
  //               title: Text(files[index].path.split('/').last,style: TextStyle(fontSize: 10),),
  //              //, leading: Icon(Icons.picture_as_pdf),
  //              // trailing: Icon(Icons.arrow_forward, color: Colors.redAccent,),
  //               onTap: (){
  //                 setState(() {
  //                   file_path=files[index].path;
  //                   final f=File(file_path);
  //                   int sizeInBytes = f.lengthSync();
  //                   double sizeInMb = sizeInBytes/(1024 * 1024);
  //
  //                   if(sizeInMb>2)
  //                   {
  //                     file_path=null;
  //                     Fluttertoast.showToast(
  //                         msg: "File Size greater than 2MB.Please select another file.",
  //                         toastLength: Toast.LENGTH_LONG,
  //                         gravity: ToastGravity.BOTTOM,
  //                         timeInSecForIos: 5,
  //                         backgroundColor: Colors.pinkAccent,
  //                         textColor: Colors.white,
  //                         fontSize: 14.0
  //                     );
  //                   }else{
  //
  //                   }
  //                  //
  //                  // final imageBytes = Io.File(file_path).readAsBytesSync();
  //                  //
  //                  //
  //                  //
  //                  //  img64 = base64Encode(imageBytes);
  //
  //
  //                   // File tempFile = File(file_path);
  //                   // final filebytes= tempFile.readAsBytes();
  //                   //
  //                   //
  //                   // img64 = base64Encode(filebytes);
  //
  //                     //uploadedfile.writeAsString(img64                       );
  //
  //
  //
  //                 });
  //                 Navigator.pop(context);
  //
  //               },
  //             )
  //         );
  //       },
  //     ),
  //   );
  // }
}
