import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'editBasicInfoTab.dart';

class BasicTab extends StatefulWidget {
  @override
  BasicTabState createState() => BasicTabState();
}

class BasicTabState extends State<BasicTab> {
  bool editOption = false;
  late bool checkboxVisible;
  bool _hasBeenPressed = false;
  bool loader = true;
  bool riseBtn_flag = false;
  var prev_requestId = 0;
  bool prev_request_box = false;
  var prev_Status = "";

  TextStyle styleHeading = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  TextEditingController reasonController = TextEditingController();
  var ipassId,
      hrmsId,
      emp_name_sr,
      emp_name_aadhaar,
      aadhaarnumber,
      emp_first_name,
      emp_last_name,
      emp_mid_name,
      emp_hindi_name,
      emp_regional_name = null,
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
      superannuation_date;
  String hrmsIdsend = "";
  @override
  void initState() {
    getId();
    getdetails();
    getLastchange_request_status();
    super.initState();
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
      "railwayUnit": await pref.getEmployeeUnitcode()
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON['jsonResult']['statusresult'] == true) {
      setState(() {
        ipassId = responseJSON['jsonResult']['headerdata']['ipasEmployeeId'];
        hrmsId = responseJSON['jsonResult']['headerdata']['hrmsEmployeeId'];
        emp_name_sr =
            responseJSON['jsonResult']['headerdata']['employeeNameSR'];
        emp_name_aadhaar =
            responseJSON['jsonResult']['headerdata']['employeeNameAadhaar'];
        aadhaarnumber =
            responseJSON['jsonResult']['headerdata']['aadhaarNumber'];
        emp_first_name =
            responseJSON['jsonResult']['headerdata']['employeeFirstName'];
        emp_last_name =
            responseJSON['jsonResult']['headerdata']['employeeLastName'];
        emp_mid_name =
            responseJSON['jsonResult']['headerdata']['employeeMiddleName'];
        emp_hindi_name =
            responseJSON['jsonResult']['headerdata']['nameHindiLang'];
        emp_regional_name =
            responseJSON['jsonResult']['headerdata']['nameRegionalLang'];
        birth_place = responseJSON['jsonResult']['headerdata']['birthPlace'];
        date_of_birth = responseJSON['jsonResult']['headerdata']['dateOfBirth'];
        father_name = responseJSON['jsonResult']['headerdata']['fatherName'];
        mother_name = responseJSON['jsonResult']['headerdata']['motherName'];
        guardian = responseJSON['jsonResult']['headerdata']['guardianName'];
        spouse_name = responseJSON['jsonResult']['headerdata']['spouseName'];
        spouse_emp_type =
            responseJSON['jsonResult']['headerdata']['spouseEmploymentType'];
        ipasid_spouse =
            responseJSON['jsonResult']['headerdata']['spouseIpasID'];
        pan_number = responseJSON['jsonResult']['headerdata']['panNumber'];
        blood_group = responseJSON['jsonResult']['headerdata']['bloodGroup'];
        superannuation_date =
            responseJSON['jsonResult']['headerdata']['superannuationDate'];
        loader = false;
        if (responseJSON['jsonResult']['headerdata']['gender'] == "M") {
          gender = "Male";
        } else if (responseJSON['jsonResult']['headerdata']['gender'] == "F") {
          gender = "Female";
        } else if (responseJSON['jsonResult']['headerdata']['gender'] == "O") {
          gender = "Other";
        }

        if (responseJSON['jsonResult']['headerdata']['birthCountry'] == "CPV") {
          country_birth = "CAPE VERDE";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "CYM") {
          country_birth = "CAYMAN ISLANDS";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "CAF") {
          country_birth = "CENTRAL AFRICAN REPUBLIC";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "TCD") {
          country_birth = " CENTRAL AFRICAN REPUBLIC";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "CHL") {
          country_birth = "CHILE";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "PYF") {
          country_birth = "FRENCH POLYNESIA";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "FRA") {
          country_birth = "FRANCE";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "GAB") {
          country_birth = "GABON";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "GRC") {
          country_birth = "GREECE";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "IND") {
          country_birth = "INDIA";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "IDN") {
          country_birth = "INDONESIA";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "IRN") {
          country_birth = "ISLAMIC REPUBLIC OF IRAN";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "IRQ") {
          country_birth = "IRAQ";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "IRL") {
          country_birth = "IRELAND";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "ISR") {
          country_birth = "ISRAEL";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "ITA") {
          country_birth = "ITALY";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "JPN") {
          country_birth = "JAPAN";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "JEY") {
          country_birth = "JERSEY";
        } else if (responseJSON['jsonResult']['headerdata']['birthCountry'] ==
            "JOR") {
          country_birth = "JORDAN";
        }
      });
    } else {
      loader = false;
    }
  }

  Future getLastchange_request_status() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("get_change_request_status");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    String? userId = await pref.getUsername();
    Map map = {
      "tabname": "Basic",
      "userId": userId,
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
        if (responseJSON['data']['result']) {
          String status_request = responseJSON['data']['status'];
          prev_requestId = responseJSON['data']['change_req_id'];
          if (status_request == "C") {
            prev_Status = "Change Requested";
          } else if (status_request == "D") {
            prev_Status = "Draft";
          } else if (status_request == "E") {
            prev_Status = "Submitted By DC(Sent to Verification Authority)";
          } else if (status_request == "V") {
            prev_Status = "Data verified by Verification Authority";
          } else if (status_request == "VR") {
            prev_Status = "Rejected by Verification Authority";
          } else if (status_request == "DR") {
            prev_Status = "Rejected by Dealing Clerk";
          } else if (status_request == "A") {
            prev_Status = "Data accepted by Accepting Authority";
          } else if (status_request == "AR") {
            prev_Status = "Rejected by Accepting Authority";
          }

          if (status_request == "C" ||
              status_request == "E" ||
              status_request == "V") {
            riseBtn_flag = false;
          } else {
            riseBtn_flag = true;
          }
          prev_request_box = true;
        } else {
          riseBtn_flag = true;
          prev_request_box = false;
        }
      });
    }
  }

  void getId() async {
    sharedpreferencemanager pref = sharedpreferencemanager();

    hrmsIdsend = (await pref.getEmployeeHrmsid())!;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Basic Tab",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              /*Center(
                child: Visibility(
                  visible: loader,
                  child: Loading(
                      indicator: BallPulseIndicator(),
                      size: 100.0,
                      color: Colors.lightBlueAccent),
                ),
              ),*/
              Visibility(
                visible: prev_request_box,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 85,
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Text("  Change Request ID : " +
                              prev_requestId.toString()),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: Align(
                            child: Text("  Status : " + prev_Status),
                            alignment: Alignment.centerLeft,
                          ),
                        )
                      ]),
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 51, 204, 255), width: 1),
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Positioned(
                        left: 50,
                        top: 12,
                        child: Container(
                          padding:
                              EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          color: Colors.white,
                          child: Text(
                            'Previous Change Request Details',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white54,
                    border: Border.all(width: 1, color: Colors.white)),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'IPAS Employee Id:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(ipassId ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'HRMS Employee ID :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(hrmsId ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: Text(
                              'Employee Name As in SR :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_name_sr ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Employee Name As in Aadhaar :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_name_aadhaar ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Aadhaar Number :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(aadhaarnumber ?? "Not Available :",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Employee First Name :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_first_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Employee Middle Name :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_mid_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Employee Last Name:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_last_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Employee Name Hindi:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_hindi_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Employee Name Regional:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(emp_regional_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Country of Birth:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(country_birth ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Birth Place:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(birth_place ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Date Of Birth  :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(date_of_birth ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Gender :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(gender ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Father Name:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(father_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Mother Name:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(mother_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Guardian:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(guardian ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Spouse Name:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(spouse_name ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Spouse Employment Type:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(spouse_emp_type ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'IPAS ID of Spouse:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(ipasid_spouse ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'PAN Number :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(pan_number ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Blood Group :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(blood_group ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            height: 14,
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Superannuation Date:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(superannuation_date ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                ]),
              ),
              /*Container(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 30.0, 16.0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURL();
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Click Here For Help Video",
                      ),
                    ),
                  )),*/
              Visibility(
                visible: riseBtn_flag,
                child: FilledButton(
                    //width: 200,
                    child: Text(
                      'Raise Change Request',
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
                      setState(() {
                        _hasBeenPressed = true;
                      });

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditbasicTabInfo(
                                emp_hindi_name,
                                emp_regional_name,
                                country_birth,
                                birth_place,
                                spouse_name,
                                spouse_emp_type,
                                ipasid_spouse,
                                blood_group)),
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*_launchURL() async {
    var urlvideolink = "https://youtu.be/FW_awd2NuHs";
    if (await canLaunch(urlvideolink)) {
      await launch(urlvideolink);
    }
  }*/
}
