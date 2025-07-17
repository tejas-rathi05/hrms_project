import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/pass/Issuedpassmodel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


import '../util/validation_check.dart';

List<dynamic>? files;
String? file_path;


class CancelPass extends StatefulWidget {
  @override
  CancelPassState createState() => CancelPassState();
}

class CancelPassState extends State<CancelPass> {
  var phoneno = "", hrms_Id = "";

  late Icons MyIcon;

  sharedpreferencemanager pref = sharedpreferencemanager();
  late List<IssuedPassModel> _userInfo;

  late List data_passset;
  int listsize = 0;

  void getPassList() async {
    phoneno = (await pref.getEmployeeMobileno())!;
    hrms_Id = (await pref.getEmployeeHrmsid())!;
    String url = new UtilsFromHelper().getValueFromKey("issued_pass_list");
    print('url $url');
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      'userId': hrms_Id,
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON $responseJSON');
    try {
      var passdetails = responseJSON["issuedPassDetails"] as List;

      setState(() {
        _userInfo = passdetails
            .map<IssuedPassModel>((json) => IssuedPassModel.fromJson(json))
            .toList();
        listsize = _userInfo.length;
        if (_userInfo.length == 0) {
          Fluttertoast.showToast(
              msg: 'No data found',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              //timeInSecForIos: 5,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'No data found',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }


  void getFiles() async {
    //List<File> fileList = [];

    //Directory? externalStorageDir = await getExternalStorageDirectory();
    Directory? externalStorageDir =await getApplicationDocumentsDirectory();
   // var path = '/storage/emulated/0/Download/';
    Directory directory = Directory(externalStorageDir!.path);
    //Directory directory = Directory(path);
    print('dir1213 $directory');
    if(await directory.exists()) {
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
        files?.add(file);
      }
    }
    //print('path -- >$path');

    //print('fileList -- >$fileList');
   // return fileList;
  }

  @override
  void initState() {
    getPassList();
    getFiles();
    super.initState();
  }

  var Color_text = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Issued Pass List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 40,
              color: Colors.lightBlueAccent,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: Container(
                      child: Text(
                        "Unique Pass No",
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
                  ),
                  new Expanded(
                    child: Container(
                      child: Text(
                        "Issue Date",
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
                  ),
                  new Expanded(
                    child: Container(
                      child: Text(
                        "Expire Date",
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
                  ),
                  new Expanded(
                    child: Container(
                      child: Text(
                        "Cancel Pass",
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
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listsize,
                itemBuilder: (BuildContext context, int index) {
                  late String date_issuing;
                  late String exp_date;
                  String PasscancelStatus = "";
                  //bool flag_passtype = true;
                  /* if (_userInfo[index].pass_type_code != "PTO") {
                    flag_passtype = true;
                  } else {
                    flag_passtype = false;
                  }*/
                  var upn = _userInfo[index].unique_pass_number;
                  //print('upnn $upn');

                  if (_userInfo[index].cancelstatus.length>0) {
                    if (_userInfo[index].cancelstatus == "S" ||
                        _userInfo[index].cancelstatus == "A") {
                      print('upn--->$upn');
                      PasscancelStatus = "Applied";
                     // print('PasscancelStatus--->$PasscancelStatus');
                      Color_text = Colors.yellow;
                    } else if (_userInfo[index].cancelstatus == "C") {
                      PasscancelStatus = "Cancelled";
                      Color_text = Colors.green;
                    } else if (_userInfo[index].cancelstatus == "R") {
                      Color_text = Colors.blue;
                      PasscancelStatus = "Rejected";
                    }
                  } else if (_userInfo[index].expired == "N" &&
                      _userInfo[index].cancel_flag != "Y" &&
                      _userInfo[index].cancel_allowed == "Y" &&
                      _userInfo[index].split_pass_flag != "Y" &&
                      (_userInfo[index].splitstatus.isEmpty || _userInfo[index].splitstatus == "R" ||
                          _userInfo[index].splitstatus == "I")) {
                    PasscancelStatus = "Cancel";
                   // print('upn expired--->$upn');
                   // print('PasscancelStatus expired--->$PasscancelStatus');
                    Color_text = Colors.red;
                  } else if (_userInfo[index].cancel_flag == "Y") {
                    Color_text = Colors.red;
                    PasscancelStatus = "Cancelled";
                    Color_text = Colors.green;
                  }

                  if (_userInfo[index].issuing_date.toString() != "") {
                    DateTime todayDate_exp = DateTime.parse(
                        _userInfo[index].issuing_date.toString());
                    date_issuing =
                        DateFormat('dd-MM-yyyy').format(todayDate_exp);

                  }
                  if (_userInfo[index].expiry_date.toString() != "") {
                    DateTime todayDate_exp =
                        DateTime.parse(_userInfo[index].expiry_date.toString());
                    exp_date =
                        DateFormat('dd-MM-yyyy').format(todayDate_exp);
                  }

                  return new GestureDetector(
                    child: Container(
                        decoration: BoxDecoration(),
                        child: new Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 12.0, bottom: 12),
                              child: new Row(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _userInfo[index]
                                                  .pass_type_code
                                                  .toString() ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _userInfo[index]
                                                  .unique_pass_number
                                                  .toString() ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        date_issuing,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        exp_date,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(0.0),
                                      child: new GestureDetector(

                                        child: TextButton(
                                            onPressed: () {
                                             /* showDialog(context: context,
                                                  builder: (BuildContext dialogContext) =>
                                                  CustomDialog(),
                                              );*/
                                              print('cancel Button Tapped');

                                              if (_userInfo[index].expired ==
                                                  "N" &&
                                                  _userInfo[index]
                                                      .cancel_flag !=
                                                      "Y" &&
                                                  _userInfo[index]
                                                      .cancel_allowed ==
                                                      "Y" &&
                                                  _userInfo[index]
                                                      .split_pass_flag !=
                                                      "Y" &&
                                                  (_userInfo[index].splitstatus.isEmpty
                                                      || _userInfo[index]
                                                      .splitstatus ==
                                                      "R" ||
                                                      _userInfo[index]
                                                          .splitstatus ==
                                                          "I")) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                  context) =>
                                                      CustomDialog(
                                                          passId: _userInfo[index]
                                                              .unique_pass_number
                                                              .toString(),
                                                          mainwindow: context),

                                                );

                                              }
                                            },
                                            child: Text(
                                              pass_cancel_status_check(
                                                  PasscancelStatus),
                                              style: TextStyle(
                                                  color: Color_text,
                                                  fontSize: 13),
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 2,
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
                        )),
                  );
                },
              ),
            ),
          ])),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CustomDialog extends StatefulWidget {
  final String passId;
  BuildContext mainwindow;

  CustomDialog({required this.passId, required this.mainwindow});

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  TextEditingController remarks_controller = TextEditingController();
   String? result;

  var phoneno = "", hrms_Id = "";

  sharedpreferencemanager pref = sharedpreferencemanager();

  void cancelPass(String UPN, String remarks, BuildContext context) async {
    final bytes = Io.File(file_path!).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print('cancelPass Method Entered ');
    hrms_Id = (await pref.getEmployeeHrmsid())!;
    String url = new UtilsFromHelper().getValueFromKey("cancel-pass");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "uniquePassNumber": UPN,
      "remarks": remarks,
      "file": img64,
      "hrmsId": hrms_Id
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (value.contains("error")) {
      Fluttertoast.showToast(
          msg: responseJSON['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      Fluttertoast.showToast(
          msg: responseJSON['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }

    //Navigator.of(context).pop();
    Navigator.of(context).pop();
    //file_path;
    remarks_controller.text = "";

    EasyLoading.dismiss();
    setState(() {
      _first_click = true;
    });
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

  bool _hasBeenPressed = false;
  bool _first_click = true;

  dialogContent(BuildContext context) {
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
                  "APPLICATION FOR CANCELLATION OF PASS",
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      color: HexColor("#757171")),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  "Please fill the following details to apply for cancellation of pass",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                      child: Text(
                        "Unique Pass number :",
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.passId,
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Upload Approval Document *",
                    style: TextStyle(
                      fontSize: 13.0,
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
                                        // timeInSecForIos: 5,
                                        backgroundColor: Colors.pink,
                                        textColor: Colors.white,
                                        fontSize: 14.0);

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
                                    setState(() {
                                      file_path = result;
                                    });
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "In case of multiple documents, please merge all documents and then upload single pdf file. ",
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Reason for cancellation of Pass *",
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 10,
                  controller: remarks_controller,
                  enabled: true,
                  style: TextStyle(fontSize: 13),
                  maxLength: 400,
                  decoration: InputDecoration(
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
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FilledButton(
                        //width: 120,
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
                          if (remarks_controller.text.length == 0) {
                            Fluttertoast.showToast(
                                msg: 'Please enter reason',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //  timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else if (file_path == "") {
                            Fluttertoast.showToast(
                                msg: 'Please select a file',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //   timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else {
                            setState(() {
                              _hasBeenPressed = true;
                            });
                            if (_first_click == true) {
                              setState(() {
                                _first_click = false;
                              });
                              cancelPass(widget.passId, remarks_controller.text,
                                 widget.mainwindow);
                            }
                          }
                        }),
                    FilledButton(
                      //width: 100,
                      child: Text(
                        'Cancel',
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
                        file_path;
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
