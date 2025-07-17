import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

//import 'package:url_launcher/url_launcher.dart';

class EditContact extends StatefulWidget {
  @override
  EditContactState createState() => EditContactState();
}

class EditContactState extends State<EditContact> {
  sharedpreferencemanager pref = sharedpreferencemanager();
  List<String> type_no = ['Personal', "Official"];
  bool flag_offemail = false;
  // bool flag_offmobile=true;

  // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  var _selectedtype, userType, sendtype;
  TextEditingController personal_mobile = new TextEditingController();
  TextEditingController official_mobile = new TextEditingController();
  TextEditingController personal_email = new TextEditingController();
  TextEditingController official_email = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCommunicationDetails();
  }

  bool checkValidation(email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  Future getCommunicationDetails() async {
    String url =
        new UtilsFromHelper().getValueFromKey("get_communication_details");
    String? hrmsId = await pref.getEmployeeHrmsid();
    String? Status = await pref.getEmployeeUsertype();
    if (Status == "RT") {
      setState(() {
        flag_offemail = false;
      });
    } else {
      setState(() {
        flag_offemail = true;
      });
    }
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Map map = {'hrmsId': hrmsId};

    String basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    String? PhoneNo = await pref.getEmployeeMobileno();
    String? Email = await pref.getEmployeeEmail();
    setState(() {
      if (responseJSON['result'] != "data not found") {
        // personal_mobile.text=responseJSON['result']['personal_mobile_number'].toString();
        if (responseJSON['result']['personal_mobile_number'] != null &&
            responseJSON['result']['personal_mobile_number'] != "") {
          personal_mobile.text =
              responseJSON['result']['personal_mobile_number'].toString();
        }
        if (responseJSON['result']['official_mobile_no'] != null &&
            responseJSON['result']['official_mobile_no'] != "") {
          official_mobile.text =
              responseJSON['result']['official_mobile_no'].toString();
        }
        if (responseJSON['result']['personal_email_id'] != null &&
            responseJSON['result']['personal_email_id'] != "") {
          personal_email.text =
              responseJSON['result']['personal_email_id'].toString();
        }

        // personal_email.text=responseJSON['result']['personal_email_id'].toString();
        if (responseJSON['result']['official_email_id'] != null &&
            responseJSON['result']['official_email_id'] != "") {
          official_email.text =
              responseJSON['result']['official_email_id'].toString();
        }
      } else {
        personal_mobile.text = PhoneNo!;
        official_mobile.text = "0";
        personal_email.text = Email!;
      }
    });
  }

  Future updateCommunicationDetails() async {
    String url =
        new UtilsFromHelper().getValueFromKey("update_communication_details");
    String? hrmsId = await pref.getEmployeeHrmsid();
    String? userstatus = await pref.getServiceStatus();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Map map = {
      "up_personal_mobile": personal_mobile.text,
      "up_official_mobile": official_mobile.text,
      "up_personal_email": personal_email.text,
      "up_official_email": official_email.text,
      "otpMobile": sendtype,
      "userType": userstatus,
      "userId": hrmsId
    };
    //print(map.toString());

    String basicAuth = await Hrmstokenplugin.hrmsToken;
    //print("Basic Auth"+basicAuth);

    //  YWRtaW4xMjM2OTpwcnk1M0BwdCE1Ng==
    // Basic YWRtaW4xMjM2OTpwcnk1M0BwdCE1Ng==

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print(responseJSON);
    if (responseJSON['result'] == true) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditContact()),
      );
      await pref.editCommunication(personal_email.text, personal_mobile.text);
      Fluttertoast.showToast(
          msg: "Update Communication Details Sucessfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      Fluttertoast.showToast(
          msg: "Please Try Later.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          fontSize: 14.0);
    }
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
        title: Text("Update Communication Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Visibility(
            visible: true,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(211, 211, 211, 211), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    color: Colors.white10,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: new Text("Personal Mobile Number")),

                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: TextField(
                            controller: personal_mobile,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: new InputDecoration(
                              filled: true,
                              hintText: 'Personal Mobile Number',
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
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: new Text("Personal Email Id")),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 25),
                          child: TextField(
                            controller: personal_email,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                              filled: true,
                              hintText: 'Personal Email Id',
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
                          ),
                        ),
                        Visibility(
                          visible: flag_offemail,
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: new Text("Official Mobile Number")),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: TextField(
                                  controller: official_mobile,
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 13.0),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: new InputDecoration(
                                    filled: true,
                                    hintText: 'Official Mobile Number',
                                    fillColor: Color(0xFFF2F2F2),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: new Text("Official Email Id")),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 30),
                                child: TextField(
                                  controller: official_email,
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 13.0),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: new InputDecoration(
                                    filled: true,
                                    hintText: 'Official Email Id',
                                    fillColor: Color(0xFFF2F2F2),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: new Text("Received OTP on?")),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    ' Received OTP on?',
                                    style: TextStyle(fontSize: 14),
                                  ), // Not necessary for Option 1
                                  value: _selectedtype,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedtype = newValue;
                                      if (newValue == "Personal") {
                                        sendtype = "P";
                                      } else {
                                        sendtype = "O";
                                      }
                                    });
                                  },
                                  items: type_no.map((value) {
                                    return DropdownMenuItem(
                                      child: new Text(value,
                                          style: TextStyle(fontSize: 13)),
                                      value: value,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Visibility(visible:flag_offemail,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: <Widget>[
                        //       Expanded(
                        //
                        //         child: Container(
                        //             margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                        //             child:Text('Receive OTP On?', textAlign: TextAlign.left,style: TextStyle(fontSize:13,fontWeight:
                        //             FontWeight.bold,color: Colors.black),)
                        //         ),
                        //       ),
                        //       Expanded(child:
                        //       Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 10.0),
                        //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        //           border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 0.80),),
                        //         child: DropdownButton(
                        //           isExpanded: true,
                        //           dropdownColor: Color(0xFFF2F2F2),
                        //           hint: Text(' Received OTP on?',style:TextStyle(fontSize: 14),), // Not necessary for Option 1
                        //           value: _selectedtype,
                        //           onChanged: (newValue) {
                        //             setState(() {
                        //               _selectedtype = newValue;
                        //               if(newValue=="Personal")
                        //               {
                        //                 sendtype="P";
                        //               }
                        //               else{
                        //                 sendtype="O";
                        //               }
                        //
                        //             });
                        //           },
                        //           items: type_no.map((value) {
                        //             return DropdownMenuItem(
                        //               child: new Text(value,style:TextStyle(fontSize: 13)),
                        //               value: value,
                        //             );
                        //           }).toList(),
                        //         ),
                        //       ),
                        //
                        //
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),
                        //
                        //
                        SizedBox(
                          height: 35,
                        ),
                        FilledButton(
                            // width: 130,
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFF40C4FF)),
                            onPressed: () {
                              if (personal_mobile.text.trim().length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Personal Mobile No",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.pinkAccent,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (official_mobile.text.trim().length ==
                                  0) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Official Mobile No",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.pinkAccent,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (personal_email.text.trim().length ==
                                      0 ||
                                  (!checkValidation(personal_email.text))) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please Enter Correct Personal EmailId",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.pinkAccent,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (official_email.text.trim().length >
                                  0) {
                                if (!checkValidation(official_email.text)) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please Enter Correct Official EmailId",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.pinkAccent,
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                } else {
                                  updateCommunicationDetails();
                                }
                              } else {
                                updateCommunicationDetails();
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 12,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      color: Colors.white,
                      child: Text(
                        "",
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
      ),
    );
  }
}
