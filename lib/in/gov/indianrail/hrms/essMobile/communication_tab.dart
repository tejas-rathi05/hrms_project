import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

//import 'package:url_launcher/url_launcher.dart';

import 'editCommunicationTab.dart';

class CommunicationTab extends StatefulWidget {
  @override
  CommunicationTabState createState() => CommunicationTabState();
}

class CommunicationTabState extends State<CommunicationTab> {
  bool editOption = false;
  late bool checkboxVisible;
  bool loader = true;
  bool riseBtn_flag = false;
  var prev_requestId = 0;
  bool prev_request_box = false;
  bool _hasBeenPressed = false;
  var prev_Status = "";

  TextStyle styleHeading = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  TextEditingController reasonController = TextEditingController();

  var hrmsId,
      status,
      personal_mobileno,
      personal_email,
      Official_mobileno,
      Official_email,
      permanent_pincode,
      recieve_otp_on,
      communication_address,
      permanent_address_line1,
      permanent_address_line2,
      permanent_state,
      permanent_district,
      permanent_city,
      present_address_line1,
      present_address_line2,
      present_pincode,
      present_state,
      present_district,
      present_city,
      srPageNumber,
      present_district_code,
      present_state_code;
  String hrmsIdsend = "";
  @override
  void initState() {
    getId();
    getdetails();
    getLastchange_request_status();

    super.initState();
  }

  Future get_AllStateList(String statecode) async {
    // data.clear();

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

      for (int i = 0; i < StateList.length; i++) {
        if (statecode == StateList[i]["code"].toString()) {
          present_state = StateList[i]["description"];

          get_distric(StateList[i]["code"].toString());
        }
      }
    });
  }

  Future get_distric(String code) async {
    loader = true;

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

      for (int i = 0; i < DistrictList.length; i++) {
        if (present_district_code == DistrictList[i]["code"].toString()) {
          present_district = DistrictList[i]["description"];
        }
      }
    });

    loader = false;
  }

  Future getdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("get_communicationInfo");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "employeeId": await pref.getEmployeeUserid(),
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
        personal_mobileno = responseJSON['headerdata']['personalMobileNumber'];
        hrmsId = responseJSON['headerdata']['hrmsEmployeeIdForCom'];
        personal_email = responseJSON['headerdata']['personalEmailId'];
        Official_mobileno = responseJSON['headerdata']['officialMobileNo'];
        Official_email = responseJSON['headerdata']['officialEmailId'];

        communication_address =
            responseJSON['headerdata']['addressForCommunication'];
        permanent_address_line1 =
            responseJSON['headerdata']['permanentAddressLine1'];
        permanent_address_line2 =
            responseJSON['headerdata']['permanentAddressLine2'];
        permanent_pincode =
            responseJSON['headerdata']['permanentPincode'] ?? "";

        permanent_state = responseJSON['headerdata']['permanentState'];
        permanent_district = responseJSON['headerdata']['permanentDistrict'];
        permanent_city = responseJSON['headerdata']['permanentCity'];
        present_address_line1 =
            responseJSON['headerdata']['presentAddressLine1'];
        present_address_line2 =
            responseJSON['headerdata']['presentAddressLine2'];

        present_pincode = responseJSON['headerdata']['presentPincode'];
        present_state_code = responseJSON['headerdata']['presentState'];
        present_district_code = responseJSON['headerdata']['presentDistrict'];
        present_city = responseJSON['headerdata']['presentCity'];
        srPageNumber = responseJSON['headerdata']['srPageNumber'];
        status = responseJSON['headerdata']['status'];
        print(permanent_pincode);
        loader = false;
        get_AllStateList(responseJSON['headerdata']['presentState'].toString());
      });
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
      "tabname": "Communication",
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
          } else if (status_request.trim() == "D") {
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
            // prev_request_box=true;
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
        title: Text("Communication Tab",
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
                      height: 90,
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
                        Align(
                          child: Text("  Status : " + prev_Status),
                          alignment: Alignment.centerLeft,
                        ),
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
                              'HRMS Employee ID:',
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
                            margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                            child: Text(
                              'Personal Mobile Number *:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(personal_mobileno ?? "Not Available",
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
                              'Personal Email:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(personal_email ?? "Not Available",
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
                              'Official Mobile Number :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(Official_mobileno ?? "Not Available",
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
                              'Official Email :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(Official_email ?? "Not Available :",
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
                              'Recieve OTP On? :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(recieve_otp_on ?? "Not Available",
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
                              'Communication Address :',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            )),
                      ),
                      Expanded(
                        child: Text(communication_address ?? "Not Available",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Visibility(
                    visible: true,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Column(children: <Widget>[
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
                                        'Address Line 1:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                        present_address_line1 ??
                                            "Not Available",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12)),
                                  ),
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
                                        'Address Line 2:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                        present_address_line2 ??
                                            "Not Available",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12)),
                                  ),
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
                                        'Pincode :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                        present_pincode.toString() ??
                                            "Not Available",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12)),
                                  ),
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
                                        'State :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                        present_state ?? "Not Available",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12)),
                                  ),
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
                                        'District :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                        present_district ?? "Not Available",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12)),
                                  ),
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
                                        'City :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(present_city ?? "Not Available",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ],
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
                                'Present Address',
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ),
                  ),
                ]),
              ),
              /* Container(
                  padding:EdgeInsets.fromLTRB(16.0,16.0,30.0,16.0),
                  child:GestureDetector(
                    onTap:(){
                      _launchURL();
                    },
                    child:Align(
                      alignment: Alignment.bottomRight,
                      child:Text("Click Here For Help Video",),
                    ),

                  )
              ),*/
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
                            builder: (context) => EditCommunicationTabInfo(
                                hrmsId,
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
                                present_state_code,
                                present_district_code,
                                present_city,
                                srPageNumber,
                                status)),
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
    var urlvideolink="https://youtu.be/V814gLRtS3s ";
    if (await canLaunch(urlvideolink)) {
      await launch(urlvideolink);
    }

  }*/
}
