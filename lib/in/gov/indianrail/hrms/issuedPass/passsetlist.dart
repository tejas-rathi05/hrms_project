import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


import 'my_pass.dart';

class PassSetList extends StatefulWidget {
  @override
  PasslistState createState() => PasslistState();
}

class PasslistState extends State<PassSetList> {
  List data_passset=[];

  List<Map<String, dynamic>> setlist = [];

  bool flag_Pass = false;
  bool flag_Pass_Go = false;
  bool _hasBeenPressed = false;
  bool _firstClick_go = true;

  String? selectedCategory;
  String? errorMessage;
  String? familyDeclErrorMessage;
  bool familyDeclarationFlag = false;
  late String Year, fullset, halfset;
  var Result;
  bool disableapplypass = true;
  bool disablefullpass = true;
   List<Map<String, dynamic>>? newResult;
  late Map<String, dynamic> myObject;
  String passFamilyDeclaration = "";
  String passFDBefore13thMonth = "";
  String passFDBefore13thMonthPendingWithPassClerk = "";
  String passFDPendingWithPassClerk = "";
  String oneMonthAdavanceRemainingDays = "";

  onGoBack(dynamic value) {
    flag_Pass_Go = false;

    setState(() {});
  }

  Future pass_set_list() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("pass_set_list");
    print('url $url');
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    String? serviceStatus = await pref.getServiceStatus();
    String? prcpWindowFlag = await pref.getPrcpWindowFlag();
    String? prcpWidowFlag = await pref.getPrcpWindowFlag();
    Map map = {
      "serviceStatus": await pref.getServiceStatus(),
      "userId": await pref.getEmployeeUserid(),
      "railwayunit": await pref.getEmployeeUnitcode()
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
    print('responseJSON1213--> $responseJSON');
    oneMonthAdavanceRemainingDays =
        responseJSON["oneMonthAdavanceRemainingDays"]??'';
    passFamilyDeclaration = responseJSON["passFamilyDeclaration"]??'';

    passFDBefore13thMonth =
        responseJSON["passFamilyDeclarationBefore13thMonth"]??'';
    passFDBefore13thMonthPendingWithPassClerk = responseJSON[
        "passFamilyDeclarationBefore13thMonthPendingWithPassClerk"]??'';
    passFDPendingWithPassClerk =
        responseJSON["passFamilyDeclarationPendingWithPassClerk"]??'';

    setState(() {
      EasyLoading.dismiss();
      print(responseJSON["manualPassDeclaration"]);
      List manualPasslist = responseJSON["manualPassDeclaration"]??[];
      if (responseJSON["notAccepted"] != "" &&
          responseJSON["notAccepted"] != null) {
        errorMessage =
            "Please ensure your Data is in Accepted state before proceeding further.";

        flag_Pass = false;
      } else if (responseJSON["passTypeForDeclaration"] != "" &&
          responseJSON["passTypeForDeclaration"] != null) {
        errorMessage =
            "Your manual Pass declaration is pending with Pass Clerk. Kindly contact your Pass Clerk to get it completed.";

        flag_Pass = false;
      } else if (manualPasslist.length>0) {
        errorMessage =
            "Kindly review your Manual Passes entered by Pass Clerk.";
        Fluttertoast.showToast(
            msg: "Kindly review your Manual Passes entered by Pass Clerk.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
        flag_Pass = false;
      } else if (responseJSON["passFamily"] != null &&
          responseJSON["passFamily"] != "") {
        print('hgv ${responseJSON["passFamily"]["passfamilyinfo"]}');
        List<dynamic> PassFamilyInfo = responseJSON["passFamily"]["passfamilyinfo"]??[];

        if(PassFamilyInfo != "") {
          errorMessage =
              "Kindly complete your family declaration for Pass. Go to 'Pass' > 'Family Declaration'";

          flag_Pass = false;
        } else {
          flag_Pass = true;
        }
        //flag_Pass=true;
        if(responseJSON['passFamily']["msg"] != null &&
            responseJSON['passFamily']["msg"] != "" &&
            serviceStatus == "RT") {
          errorMessage = responseJSON['passFamily']["msg"];

          flag_Pass = false;
        } else {
          flag_Pass = true;
        }
      } else if ((prcpWindowFlag == "" || prcpWindowFlag == null) &&
          serviceStatus == "RT") {
        errorMessage =
            "Your family and pass related data is pending with  Pass clerk. Please contact your pass clerk for submitting/verifying the same before you can apply for Pass";

        flag_Pass = false;
      } else {
        flag_Pass = true;
      }
      print('Hello initially');
      if ((passFamilyDeclaration == "M1" || passFamilyDeclaration == "M2") &&
          serviceStatus != "RT") {
        familyDeclErrorMessage =
            "Your Family Declaration is more than one year old."
            "Please submit family declaration to apply for e-Pass/Pto.";
        familyDeclarationFlag = false;
      }
      if (oneMonthAdavanceRemainingDays != "" &&
          passFDBefore13thMonthPendingWithPassClerk == "M3" &&
          serviceStatus != "RT") {
        familyDeclErrorMessage =
            "Your latest Family Declaration is pending with Pass Clerk/PIA. you can still apply for pass upto ${oneMonthAdavanceRemainingDays}, after which you will not be able to apply unless new pass family declaration is approved";
        familyDeclarationFlag = false;
      }
      if (passFDPendingWithPassClerk == "M2" &&
          serviceStatus != "RT") {
        familyDeclErrorMessage =
            "Your Family Declaration is Pending with Pass clerk. e-Pass/e-Pto can be applied only when Family Declaration is approved.";
        familyDeclarationFlag = false;
      }
      if (serviceStatus != "RT" &&
          (passFDPendingWithPassClerk == "M2" ||
              passFamilyDeclaration == "M2")) {
        print('Hello');
        //Remove Apply Pass Option
        disableapplypass = false;
        // $('.apply-pass-btn').remove();
      }
      if (passFDBefore13thMonthPendingWithPassClerk == "M3" &&
          oneMonthAdavanceRemainingDays != "" &&
          serviceStatus != "RT") {
        String message =
            "Your latest Family Declaration is pending with Pass Clerk/PIA. you can still apply for pass upto ${oneMonthAdavanceRemainingDays}, after which you will not be able to apply unless new pass family declaration is approved";
        showFamilyDeclAlertDialog(context, message);
      }

      if (passFDPendingWithPassClerk == "M2" && serviceStatus != "RT") {
        String message =
            "Your Family Declaration is Pending with Pass clerk. e-Pass/e-Pto can be applied only when Family Declaration is approved.";
        showFamilyDeclAlertDialog(context, message);
      }
      var PassSetdetails = responseJSON["passTypeList"] as List;

      if (prcpWidowFlag == "PRCP") {
        myObject = {
          "description": "POST RETIREMENT COMPLEMENTORY PASS",
          "code": "PRCP"
        };
        data_passset.add(myObject);
      } else if (prcpWidowFlag == "WP") {
        myObject = {"description": "WIDOW PASS", "code": "WP"};
        data_passset.add(myObject);
      } else {
        data_passset = PassSetdetails;
      }
    });
  }

  Future get_pass_set_list() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("get_pass_set_list");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "hrmsId": await pref.getEmployeeHrmsid(),
      "type": selectedCategory
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    List<Map<String, dynamic>> myList = [];

    if (responseJSON["result"]["v_previous_year_data"] != null) {
      print('previousYear');
      Map<String, dynamic> data = responseJSON["result"]["v_previous_year_data"];
      myList.add(data);
      newResult = myList;
      //newResult?.add(responseJSON["result"]["v_previous_year_data"]);
    }
    if (responseJSON["result"]["v_current_year_data"] != null) {
      print('currentYear');
      Map<String, dynamic> data = responseJSON["result"]["v_current_year_data"];
      myList.add(data);
      newResult = myList;
    }
    if (responseJSON["result"]["v_next_year_data"] != null) {
      print('NextYear');
      //newResult?.add(responseJSON["result"]["v_next_year_data"]);
      Map<String, dynamic> data = responseJSON["result"]["v_next_year_data"];
      myList.add(data);
      newResult = myList;
    }
    print('add $newResult');
    setState(() {
      _hasBeenPressed = false;
      _firstClick_go = true;
    });
  }

  showFamilyDeclAlertDialog(BuildContext context, String message) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    pass_set_list();
    super.initState();
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
        title: Text("Pass Set List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          children: [
            Visibility(
                visible: !flag_Pass,
                child: Text(
                  errorMessage ?? " ",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                )),
            Visibility(
                visible: !familyDeclarationFlag,
                child: Text(
                  familyDeclErrorMessage ?? " ",
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 20,
            ),
            Visibility(
                visible: flag_Pass,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "On clicking Generate button, Pass/PTO application will not be sent to Pass clerk and Pass issuing Authority and Pass/PTO will be generated automatically and immediately. Please fill in the details carefully before applying.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "जनरेट बटन क्लिक करने पर, पास/पीटीओ आवेदन पास क्लर्क और पास जारी करने वाले प्राधिकारी को नहीं भेजा जाएगा और पास/पीटीओ स्वचालित रूप से और तुरंत उत्पन्न हो जाएगा। कृपया आवेदन करने से पहले विवरण सावधानीपूर्वक भरें।",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Type Of Pass",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCategory,
                            items: data_passset.map((item) {
                              var code;
                              var des;
                              return DropdownMenuItem<String>(
                                value: item["code"].toString(),
                                child: Text(item["description"].toString()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                            hint: Container(
                              //and here
                              child: Text(
                                "-- Please Select --",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            style: TextStyle(
                                color: Colors.black,
                                decorationColor: Colors.red),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FilledButton(
                          onPressed: () {
                            if (selectedCategory == null) {
                              Fluttertoast.showToast(
                                  msg: "Please select type of pass",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            } else {
                              flag_Pass_Go = true;
                              newResult?.clear();
                              Result = "";
                              setState(() {
                                setState(() {
                                  _hasBeenPressed = true;
                                });
                                if (selectedCategory == "PTO") {
                                  disablefullpass = false;
                                } else {
                                  disablefullpass = true;
                                }
                              });
                              if (_firstClick_go == true) {
                                setState(() {
                                  _firstClick_go = false;
                                });
                                get_pass_set_list();
                              }
                            }
                          },
                          //width: 70,
                          child: Text(
                            'Go',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                              backgroundColor: _hasBeenPressed
                                  ? Colors.black38
                                  : Colors.lightBlueAccent),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 30.0,
              color: Colors.lightBlueAccent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      padding: EdgeInsets.all(4.0),
                      width: 120.0,
                      child: Text(
                        "Pass Year",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      padding: EdgeInsets.all(4.0),
                      width: 110.0,
                      child: Text(
                        "Full Set",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      padding: EdgeInsets.all(4.0),
                      width: 90.0,
                      child: Text(
                        "Half Set",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: flag_Pass_Go,
              child: Expanded(
                child: newResult?.length != null
                    ? ListView.separated(
                        itemCount: newResult!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  padding: EdgeInsets.all(4.0),
                                  width: 70.0,
                                  child: Text(
                                    newResult![index]["year"].toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                width: 145.0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        newResult![index]
                                                    ["available_full_set"] !=
                                                null
                                            ? newResult![index]
                                                    ["available_full_set"]
                                                .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Visibility(
                                        visible: disableapplypass,
                                        child: Visibility(
                                          visible: disablefullpass,
                                          child: Container(
                                            child: FilledButton(
                                                //width: 80,
                                                // height: 22,
                                                child: Text(
                                                  'Apply',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFF40C4FF)),
                                                onPressed: () {
                                                  Route route = MaterialPageRoute(
                                                      builder: (context) => MyPassList(
                                                          selectedCategory,
                                                          newResult![index]
                                                                  ["year"]
                                                              .toString(),
                                                          "F",
                                                          newResult![index][
                                                                      "available_full_set"] !=
                                                                  null
                                                              ? newResult![index]
                                                                      [
                                                                      "available_full_set"]
                                                                  .toString()
                                                              : "0"));
                                                  Navigator.push(context, route)
                                                      .then(onGoBack);
                                                }),
                                          ),
                                        ),
                                      ) // Text("click here to apply",style: TextStyle(fontSize: 12 ,color: Colors.lightBlueAccent,fontWeight: FontWeight.bold),),
                                    ]),
                              ),
                              Container(
                                width: 120.0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // cart_prod_qty!=null?cart_prod_qty:'Default Value'
                                      Text(
                                        newResult![index]
                                                    ["available_half_set"] !=
                                                null
                                            ? newResult![index]
                                                    ["available_half_set"]
                                                .toString()
                                            : "0",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Visibility(
                                        visible: disableapplypass,
                                        child: Container(
                                          child: FilledButton(
                                              //width: 80,
                                              //height: 25,
                                              child: Text(
                                                'Apply',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              style: FilledButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF40C4FF)),
                                              onPressed: () {
                                                Route route = MaterialPageRoute(
                                                    builder: (context) => MyPassList(
                                                        selectedCategory,
                                                        newResult![index]["year"]
                                                            .toString(),
                                                        "H",
                                                        newResult![index][
                                                                    "available_half_set"] !=
                                                                null
                                                            ? newResult![index][
                                                                    "available_half_set"]
                                                                .toString()
                                                            : "0"));
                                                Navigator.push(context, route)
                                                    .then(onGoBack);
                                              }),
                                        ),
                                      ),
                                    ]),
                              ),
                            ],
                            // title: Text('Item ${index + 1}'),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 2,
                            color: Colors.grey,
                          );
                        },
                      )
                    : Center(child: const Text('')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
