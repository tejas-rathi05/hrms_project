import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/apply_pass.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

class MyPassList extends StatefulWidget {
  var passType, year, setType, total;
  MyPassList(this.passType, this.year, this.setType, this.total);

  @override
  MyPassListState createState() => MyPassListState();
}

class MyPassListState extends State<MyPassList> {
  late String Pass_Type;
  late String UserId;
  late String Year;
  bool flag_newApplication = true;
  bool _hasBeenPressed = false;

  String upgradedPass="";

  List? data_passset;
  int passListLength=0;

  Future pass_list() async {
    if (widget.setType == "H") {
      Pass_Type = "Half Set";
    } else {
      Pass_Type = "Full Set";
    }
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("pass-application_list");
    print('url $url');
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    String? serviceStatus = await pref.getServiceStatus();
    String? prcpWindowFlag = await pref.getPrcpWindowFlag();
    if (prcpWindowFlag == null) {
      prcpWindowFlag = "";
    }

    Map map = {
      "passyear": widget.year,
      "passtype": widget.passType,
      "setflag": widget.setType,
      "hrmsId": await pref.getEmployeeHrmsid(),
      "serviceStatus": serviceStatus,
      "prcpWidowFlag": prcpWindowFlag
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
    print('pass-application_list response $responseJSON');
    UserId = (await pref.getEmployeeHrmsid())!;
    setState(() {
      var PassSetdetails = responseJSON["passApplicationList"] as List;
      if(PassSetdetails.length>0){
        data_passset= PassSetdetails;
        passListLength=PassSetdetails.length;
      }else
        {
          passListLength=0;
        }
      upgradedPass = responseJSON["upgradedPass"];
      print('upgradedPass $upgradedPass');
      //data_passset = PassSetdetails;
    });
  }

  Future delete_pass(String pan, String userId) async {
    final String url = new UtilsFromHelper().getValueFromKey("delete_pass");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {"application_no": pan, "userId": userId};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    setState(() {
      if (responseJSON['result']) {
        Navigator.of(context).pop();

        Fluttertoast.showToast(
            msg: "Your pass  delete sucessfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
            msg: "Please try later!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //  timeInSecForIos: 5,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    });
  }

  @override
  void initState() {
    Year = widget.year;

    if (int.parse(widget.total) <= 0) {
      flag_newApplication = false;
    } else {
      flag_newApplication = true;
    }
    pass_list();

    super.initState();
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
        title: Text("Pass List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "List of $Pass_Type Pass Applications for the year : $Year",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 14,
            ),
            Visibility(
              child: FilledButton(
                  //width: 150,
                  //height: 40,
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
                        MaterialPageRoute(
                            builder: (context) => NewPass(
                                widget.passType,
                                widget.year,
                                widget.setType,
                                upgradedPass,
                                "NewPass",
                                null)));
                  }),
              visible: flag_newApplication,
            ),

            SizedBox(
              height: 20,
            ),

            Expanded(
              child: ListView.builder(
                // current the spelling of length here
                itemCount: passListLength,
                itemBuilder: (context, index) {
                  bool flag_pass_status = false;
                  bool flag_withdraw_status = false;

                  if (data_passset![index]["status_flag"] == "I") {
                    flag_pass_status = false;
                    flag_withdraw_status = false;
                  }
                  if (data_passset![index]["status_flag"] == "D") {
                    flag_pass_status = true;
                    flag_withdraw_status = false;
                  }
                  if (data_passset![index]["status_flag"] == "S") {
                    flag_pass_status = false;
                    flag_withdraw_status = true;
                  }

                  //  IssuedPassModel project = snapshot.data;
                  return Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      child: Card(
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(5, 15, 0, 5),
                          child: new Column(
                            children: <Widget>[
                              Container(
                                height: 52,
                                margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Appl. No.",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data_passset![index]['pan']
                                                    .toString() ??
                                                "NA",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Pass Type",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data_passset![index]
                                                        ['pass_type_code']
                                                    .toString() ??
                                                "NA",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Submited Date",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data_passset![index]
                                                        ['submitted_date']
                                                    .toString() ??
                                                "NA",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Visibility(
                                child: Divider(
                                  height: 2,
                                  color: Colors.grey,
                                ),
                                visible:
                                    flag_pass_status || flag_withdraw_status,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: flag_withdraw_status,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          // Icon(Icons.subdirectory_arrow_left,color: Colors.lightBlueAccent,),
                                          SizedBox(
                                            width: 3,
                                          ),

                                          TextButton.icon(
                                              icon: Icon(
                                                Icons.subdirectory_arrow_left,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            dialogContext) =>
                                                        CustomDialog(
                                                            passId: data_passset![
                                                                        index]
                                                                    ['pan']
                                                                .toString(),
                                                            hrmsId: UserId));
                                              },
                                              label: Text("Withdraw",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0))),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: flag_pass_status,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          TextButton.icon(
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.blueAccent,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewPass(
                                                                widget.passType,
                                                                widget.year,
                                                                widget.setType,
                                                                upgradedPass,
                                                                "Draft",
                                                                data_passset![
                                                                        index]
                                                                    ['pan'])));
                                              },
                                              label: Text("Edit",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 16.0))),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          TextButton.icon(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                delete_pass(
                                                    data_passset![index]['pan']
                                                        .toString(),
                                                    UserId);
                                              },
                                              label: Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0))),
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                      visible: flag_pass_status,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),

            // Container(
            //   padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            //   height: 40,
            //   color: Colors.lightBlueAccent,
            //   child:
            //   new Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       new Container(
            //         child: Text(
            //           "Unique Pass No",
            //           textAlign: TextAlign.left,
            //           style: TextStyle(
            //               fontSize: 13,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white
            //           ),
            //           maxLines: 1,
            //         ),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //         ),
            //       ),
            //       new Container(
            //         child: Text(
            //           "Pass Type",
            //           textAlign: TextAlign.left,
            //           style: TextStyle(
            //               fontSize: 13,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white
            //           ),
            //           maxLines: 1,
            //         ),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //         ),
            //       ),
            //       new Container(
            //         child: Text(
            //           "Submitted Date",
            //           textAlign: TextAlign.left,
            //           style: TextStyle(
            //               fontSize: 13,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white
            //           ),
            //           maxLines: 1,
            //         ),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //         ),
            //       ),
            //       new Container(
            //         child: Text(
            //           "Edit | Delete",
            //           textAlign: TextAlign.left,
            //           style: TextStyle(
            //               fontSize: 13,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white
            //           ),
            //           maxLines: 1,
            //         ),
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 20,),
            // Expanded(
            //   child:ListView.builder(
            //     itemCount: data_passset.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       bool flag_pass_status=false;
            //
            //       if(data_passset[index]["status_flag"]!="D")
            //       {
            //
            //         flag_pass_status=false;
            //       }else{
            //         flag_pass_status=true;
            //       }
            //       return new GestureDetector(
            //
            //         child: Container(
            //
            //             decoration: BoxDecoration(
            //             ),
            //             child: new Column(
            //               children: <Widget>[
            //                 Container(
            //                   padding: EdgeInsets.fromLTRB(2.0, 15, 2.0,15),
            //                   child: new Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       new Container(
            //                         child: Text(
            //                           data_passset[index]['pan'].toString(),
            //                           textAlign: TextAlign.right,
            //                           style: TextStyle(
            //                               fontSize: 15,
            //                               fontWeight: FontWeight.bold
            //                           ),
            //                           maxLines: 1,
            //                         ),
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //                         ),
            //                       ),
            //                       new Container(
            //
            //                         child: Text(
            //                           data_passset[index]['pass_type_code'].toString(),
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                             fontSize: 13,
            //
            //                           ),
            //                           maxLines: 1,
            //                         ),
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //                         ),
            //                       ),
            //                       new Container(
            //                         child: Text(
            //                           data_passset[index]['submitted_date'].toString(),
            //                           textAlign: TextAlign.right,
            //                           style: TextStyle(
            //                             fontSize: 13,
            //
            //                           ),
            //                           maxLines: 1,
            //                         ),
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
            //                         ),
            //                       ),
            //                       Visibility(
            //                         child: new Container(
            //
            //                             margin: const EdgeInsets.all(0.0),
            //                             child:Row(
            //                               children: [
            //                                 Container(
            //                                   padding: EdgeInsets.fromLTRB(2.0, 0, 2.0,0),
            //                                   child: GestureDetector(
            //                                     onTap: () {
            //                                       setState(() {
            //                                         if(flag_pass_status==true){
            //                                           Navigator.of(context).pop();
            //                                           Navigator.push(
            //                                               context,
            //                                               MaterialPageRoute(builder: (context) =>NewPass(widget.passType,widget.year,widget.setType,upgradedPass,"Draft",data_passset[index]['pan']))
            //                                           );
            //                                         }
            //                                       });
            //                                     },
            //
            //                                     child:  new Icon(
            //                                       Icons.edit_outlined,
            //                                       color:flag_pass_status?Colors.black45:Colors.white,
            //                                       size: 20.0,
            //                                     ) ,
            //                                   ),),
            //
            //
            //                                 Visibility(
            //                                   visible: flag_pass_status,
            //                                   child: Text("|",style: TextStyle(color: Colors.black45),),
            //                                 ),
            //
            //                                 Container(
            //                                   padding: EdgeInsets.fromLTRB(2.0, 0, 2.0,0),
            //                                   child:  GestureDetector(
            //                                     onTap: () {
            //                                       setState(() {
            //
            //                                         if(flag_pass_status==true){
            //                                           delete_pass(data_passset[index]['pan'].toString(),UserId);
            //                                         }
            //
            //                                       });
            //                                     },
            //                                     child: new Icon(
            //
            //
            //                                       Icons.delete,
            //                                       color:flag_pass_status?Colors.redAccent:Colors.white,
            //                                       size: 20.0,
            //                                     ),),
            //                                 ),
            //
            //
            //                               ],
            //                             )
            //
            //                         ),
            //                       ),
            //
            //
            //                     ],
            //                   ),
            //                 ),
            //                 Divider(height: 1,color: Colors.grey,),
            //                 Container(
            //                   padding: EdgeInsets.only(
            //                       left: 15.0, right: 15.0, top: 0.0),
            //                   child: Container(
            //
            //                     height: 1.0,
            //                   ),
            //                 ),
            //               ],
            //             )
            //         ),
            //       );
            //     },
            //   ),
            // ),
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
  final String hrmsId;

  CustomDialog({
    required this.passId,
    required this.hrmsId,
  });

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

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
                      "1234",
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
                                border:
                                    Border.all(color: Colors.lightBlueAccent)),
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
                                },
                                child: Text(
                                  "Choose File",
                                  style: TextStyle(fontSize: 10.0),
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "No file chosen",
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 40,
                              color: Colors.lightBlueAccent,
                              child: TextButton(
                                onPressed: () {},
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
                          backgroundColor: Color(0xFF40C4FF)),
                      onPressed: () {}),
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
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  CustomDialogState createState() => CustomDialogState();
}

/// This is the stateless widget that the main application instantiates.

class CustomDialogState extends State<CustomDialog> {
  late String result;

  var phoneno = "", hrms_Id = "";

  sharedpreferencemanager pref = sharedpreferencemanager();

  Future pass_withdraw(BuildContext dialogcontext) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("pass-withdraw");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {"panToWithdraw": widget.passId, "hrmsId": widget.hrmsId};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    setState(() {
      if (responseJSON['result'] != null) {
        Navigator.of(dialogcontext, rootNavigator: true).pop();
        Navigator.of(context).pop();

        // Navigator.push(context,
        //   MaterialPageRoute(builder: (context) =>PassApplicationStatus_New()),
        // );
      }
      Fluttertoast.showToast(
          msg: responseJSON['result'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    });

    setState(() {
      //_hasBeenPressed=false;
    });
  }

  @override
  Widget build(BuildContext dialogcontext) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(dialogcontext),
    );
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
                  "Are you sure you want to withdraw the Pass application ${widget.passId}? The application will become available for editing again.",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: HexColor("#757171")),
                ),

                SizedBox(height: 10),

                SizedBox(height: 5.0),

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
                      // width: 100,
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
                          backgroundColor: Color(0xFF40C4FF)),
                      onPressed: () {
                        pass_withdraw(dialogcontext);
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
