import 'dart:convert';
import 'dart:core';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/PFModule/savepf.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

//import 'package:url_launcher/url_launcher.dart';

class MyPfloanList extends StatefulWidget {
  var passType, year, setType, total;
  @override
  MyPfloanListState createState() => MyPfloanListState();
}

class MyPfloanListState extends State<MyPfloanList> {
  late String Pass_Type;
  late String UserId;
  bool loader = true;
  late String Year;
  bool flag_newApplication = false;
  bool flag_lcd = false;
  bool flag_clcikonedit = false;
  bool flag_clcikondelete = false;
  var errormsg = "";
  bool errormsg_flag = false;

  bool _hasBeenPressed = false;
  bool _firstClick_newapp = true;

  late String upgradedPass;

  List? data_pfloan;
  bool data_exist = false;
  Future pfloan_list() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("get_pfloan_applocationlist");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    UserId = (await pref.getEmployeeHrmsid())!;
    Map map = {
      "userId": UserId,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    var pfloandeatils = responseJSON["pflist"]["pfLists"] as List;
    data_pfloan = (pfloandeatils.length!=0?pfloandeatils :0) as List?;
    print('pf loan $data_pfloan' );
    setState(() {
      loader = false;
      //data_pfloan = pfloandeatils;
      data_pfloan=data_pfloan;
      if (responseJSON["pflist"]['error'] == null ||
          responseJSON["pflist"]['error'] == "") {
        flag_newApplication=true;
        errormsg_flag = false;
        if (responseJSON["pflist"]["pfLists"][0]["per50"] == true) {
          data_exist = false;
        } else {
          data_exist = true;
        }
      } else {
        flag_newApplication = false;
        data_exist = false;

        errormsg = responseJSON["pflist"]['error'];
        errormsg_flag = true;
      }
    });
    for (int k = 0; k < data_pfloan!.length; k++) {
      if (data_pfloan![k]['pf_ldc'] == "") {
        setState(() {
          flag_lcd = true;
        });
      }
      if (data_pfloan![k]['fiftyper'] == false ||
          data_pfloan![k]['fiftyper'] == false) {
        setState(() {
          flag_newApplication = false;
        });
      }
      if (data_pfloan![k]['status'] == "FS" ||
          data_pfloan![k]['status'] == "DS" ||
          data_pfloan![k]['status'] == "DA" ||
          data_pfloan![k]['status'] == "DR" ||
          data_pfloan![k]['status'] == "VA" ||
          data_pfloan![k]['status'] == "VR" ||
          data_pfloan![k]['status'] == "AS" ||
          data_pfloan![k]['status'] == "AR" ||
          data_pfloan![k]['status'] == "G" ||
          data_pfloan![k]['status'] == "6") {
        setState(() {
          flag_newApplication = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    pfloan_list();
  }

  Future withdraw_application_details(String applicationNo) async {
    final String url =
        new UtilsFromHelper().getValueFromKey("withdraw_pfloan_applocation");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    sharedpreferencemanager pref = sharedpreferencemanager();

    Map map = {
      "applicationNo": applicationNo,
      "userId": await pref.getEmployeeHrmsid(),
    };
    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    flag_clcikondelete = false;

    Fluttertoast.showToast(
        msg: responseJSON['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 5,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);
    Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyPfloanList()),
    );
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
        title: Text("PF Loan List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Text(
                "Bank Details changed in IPAS will be reflected in HRMS after 24 hrs.",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: errormsg_flag,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  errormsg,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "List of PF Loan Applications",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Visibility(
              visible: flag_newApplication,
              child: FilledButton(
                  // width: 150,
                  // height: 40,
                  child: Text(
                    'New Application',
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
                      MaterialPageRoute(builder: (context) => Save_PF("")),
                    );
                  }),
            ),
            Visibility(
                visible: flag_lcd,
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                      "LDC entry missing, Please ask your Unit Admin to assign PF LDC to you"),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 40,
              color: Colors.lightBlueAccent,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    child: Text(
                      "Application. No",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                  ),
                  new Container(
                    child: Text(
                      "App. Date",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                  ),
                  new Container(
                    child: Text(
                      "Withdrawal Type",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                  ),
                  new Container(
                    child: Text(
                      "Edit | Delete",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                  ),
                ],
              ),
            ),
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
            Expanded(
              child: ListView.builder(
                itemCount: data_pfloan!=null?data_pfloan?.length: 0,
                itemBuilder: (BuildContext context, int index) {
                  bool flag_pf_status = false;
                  bool edit_pf_status = false;
                  bool delete_pf_status = false;

                  if (data_pfloan![index]['status'] == "WD") {
                    delete_pf_status = false;
                    edit_pf_status = false;
                  } else if (data_pfloan![index]['status'] == "FS") {
                    delete_pf_status = true;
                    edit_pf_status = false;
                  } else {
                    flag_pf_status = true;
                    edit_pf_status = true;
                    delete_pf_status = true;
                  }

                  return new GestureDetector(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 10),
                        child: Visibility(
                            visible: data_exist,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(2.0, 15, 2.0, 15),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        width: 60,
                                        child: Text(
                                          data_pfloan![index]
                                                  ['application_number']
                                              .toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                      ),
                                      new Container(
                                        child: Text(
                                          data_pfloan![index]['application_date']
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                      ),
                                      new Container(
                                        child: Text(
                                          data_pfloan![index]['withdrawal_type']
                                              .toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                      ),

                                      //For Edit And Delete
                                      Visibility(
                                        visible: true,
                                        child: new Container(
                                            width: 80,
                                            margin: const EdgeInsets.all(0.0),
                                            child: Row(
                                              children: [
                                                Visibility(
                                                  visible: edit_pf_status,
                                                  child: Container(
                                                    width: 35,
                                                    child:
                                                        new FloatingActionButton(
                                                      heroTag: "btn1",
                                                      onPressed: () {
                                                        Fluttertoast.showToast(
                                                            msg: "Please wait!",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            //timeInSecForIos: 15,
                                                            backgroundColor:
                                                                Colors.pink,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 14.0);
                                                        setState(() {
                                                          flag_clcikonedit =
                                                              true;

                                                          if (flag_pf_status ==
                                                              true) {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        Save_PF(
                                                                            data_pfloan![index]['application_number'].toString())));
                                                            //flag_circle=false;
                                                          }
                                                        });
                                                      },
                                                      backgroundColor:
                                                          flag_clcikonedit
                                                              ? Colors.grey
                                                              : Colors
                                                                  .lightBlueAccent,
                                                      child: Container(
                                                        width: 25,
                                                        child: new Icon(
                                                            Icons.edit),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Visibility(
                                                  visible: delete_pf_status,
                                                  child: Container(
                                                    width: 35,
                                                    child:
                                                        new FloatingActionButton(
                                                      heroTag: "btn2",
                                                      onPressed: () {
                                                        setState(() {
                                                          flag_clcikondelete =
                                                              true;
                                                          if (delete_pf_status ==
                                                              true) {
                                                            withdraw_application_details(
                                                                data_pfloan![index]
                                                                        [
                                                                        'application_number']
                                                                    .toString());
                                                          }
                                                        });
                                                      },
                                                      backgroundColor:
                                                          flag_clcikondelete
                                                              ? Colors.grey
                                                              : Colors
                                                                  .lightBlueAccent,
                                                      child: Container(
                                                        width: 25,
                                                        child: new Icon(
                                                            Icons.reply),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                ///Edit and Delete
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15.0, right: 15.0, top: 0.0),
                                  child: Container(
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ))),
                  );
                },
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 30.0, 16.0),
                child: GestureDetector(
                  onTap: () {
                    //  _launchURL();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Help Video : Apply PF from Mobile App",
                    ),
                  ),
                ))
          ])),
    );
  }

  /*_launchURL() async {
    var urlvideolink = "https://www.youtube.com/watch?v=RAhYTFA-0LE";
    if (await canLaunch(urlvideolink)) {
      await launch(urlvideolink);
    }
  }*/
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CustomDialog extends StatefulWidget {
  final String application_no;

  CustomDialog({
    required this.application_no,
  });
  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  late String result;

  var phoneno = "", hrms_Id = "";
  TextEditingController otpedittext = new TextEditingController();
  sharedpreferencemanager pref = sharedpreferencemanager();
  Future withdraw_application_details(String applicationNo) async {
    final String url =
        new UtilsFromHelper().getValueFromKey("withdraw_pfloan_applocation");

    print('url $url');
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    sharedpreferencemanager pref = sharedpreferencemanager();

    Map map = {
      "applicationNo": applicationNo,
      "userId": await pref.getEmployeeHrmsid(),
    };
    print('map $map');
    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
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
        //timeInSecForIos: 5,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);
    Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyPfloanList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext contextb) {
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
                  "Are you sure you want to withdraw the PF Loan Application ${widget.application_no}? \nThe application will not be sent for further processing.",
                  style: TextStyle(fontSize: 15.0, color: Colors.black87),
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
                        // width: 100,
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
                          Navigator.of(contextb).pop();
                        }),
                    FilledButton(
                      //width: 100,
                      //height: 40,
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {
                        Navigator.pop(context);
                        withdraw_application_details(widget.application_no);
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
}
