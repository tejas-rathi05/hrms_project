import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


import 'Issuedpassmodel.dart';

class IssuedPassL extends StatefulWidget {
  @override
  IssuedPassLState createState() => new IssuedPassLState();
}

//State is information of the application that can change over time or when some actions are taken.
class IssuedPassLState extends State<IssuedPassL> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
  var phoneno = "", hrms_Id = "";
  String path = "";
  bool smsandotpflag = false;
  bool pdfFlag = false;
  late Directory directory;
  late List<IssuedPassModel> _userInfo;
  sharedpreferencemanager pref = sharedpreferencemanager();
  int listsize = 0;
  @override
  void initState() {
    super.initState();
    getPassList();
    getpath();
  }

  Future<Type> getPassList() async {
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

    try {
      if (responseJSON != null && responseJSON.containsKey("issuedPassDetails")) {

        setState(() {
          var passdetails = responseJSON["issuedPassDetails"] as List;
          if(passdetails !=null ) {
            _userInfo = passdetails
                .map<IssuedPassModel>((json) => IssuedPassModel.fromJson(json))
                .toList();
          }
          listsize = _userInfo.length;
          if (_userInfo.length == 0) {
            Fluttertoast.showToast(
                msg: 'No data found',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                // timeInSecForIos: 5,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'No data found',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    return IssuedPassModel;
  }

  Future<void> getpath() async {
    if(Platform.isAndroid) {
      Directory? externalStorageDirectory = await getExternalStorageDirectory();
      List<Directory>? externalStorageDirectories =
      await getExternalStorageDirectories();

      if (externalStorageDirectory != null) {
        print('External Storage Directory: ${externalStorageDirectory.path}');
      }

      if (externalStorageDirectories != null) {
        print('External Storage Directories:');
        for (Directory directory in externalStorageDirectories) {
          print(directory.path);
          path = directory.path;
        }
      }
    }
  }

  Future selectedpassdownloadPdf(String hrmsid, int uniqueNo) async {
    Fluttertoast.showToast(
        msg: "Processing, please wait…!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //  timeInSecForIos: 8,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
    final String url = new UtilsFromHelper().getValueFromKey("issued_passpdf");

    Map map = {
      'uniquePassNo': uniqueNo,
      'hrmsId': hrmsid,
    };

    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;

    String msgtext = responseJSON['message'];
    String filepdf = responseJSON['fileString'];

    Fluttertoast.showToast(
        msg: msgtext,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //  timeInSecForIos: 5,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);

    //_write(filepdf, hrmsid, uniqueNo.toString());

    if (Platform.isAndroid) {
      _write(filepdf, hrmsid, uniqueNo.toString());
      Fluttertoast.showToast(
          msg: "Downloaded Successfully:" +
              directory.path +
              '/${hrmsid}_UPN_${uniqueNo}.pdf',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,

          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      _ioswrite(filepdf, hrmsid, uniqueNo.toString());
      Fluttertoast.showToast(
          msg: "Downloaded Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  Future _write(String textmy, String hrmsId, String uniqueNo) async {
    directory = await Directory('$path/HRMS').create(recursive: true);
    final File file = File('${directory.path}/${hrmsId}_UPN_${uniqueNo}.pdf');
    var base64str = base64.decode(textmy);
    await file.writeAsBytes(base64str);
    await OpenFilex.open('$path/HRMS/${hrmsId}_UPN_${uniqueNo}.pdf');
    Fluttertoast.showToast(
        msg: "Downloaded Successfully:" +
            directory.path +
            '/${hrmsId}_UPN_${uniqueNo}.pdf',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 15,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }
  Future _ioswrite(String textmy, String hrmsId, String uniqueNo) async {
    Directory directory = await getTemporaryDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final File file = File(directory.path + "/${hrmsId}_UPN_${uniqueNo}.pdf");
    print("Directory Path : $directory");
    print("Directory file : $file");
    var base64str = base64.decode(textmy);
    print(" $textmy");
    await file.writeAsBytes(base64str);
    var existsSync = file.existsSync();
    print("$existsSync");
    await OpenFilex.open(directory.path + "/${hrmsId}_UPN_${uniqueNo}.pdf");
  }

  //var  Color_text = Colors.lightBlueAccent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Issued e-Passes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Center(
          child: ListView.builder(
        // current the spelling of length here
        itemCount: listsize,
        itemBuilder: (context, index) {
          var exp_date = _userInfo[index].expiry_date;
          var issue_date = _userInfo[index].issuing_date;
          var attendant_upn;
          if (_userInfo[index].attendant_upn != null) {
            attendant_upn = _userInfo[index].attendant_upn.toString();
          }

          if (_userInfo[index].expired == "N" &&
              _userInfo[index].cancel_flag != 'Y' &&
              _userInfo[index].cancel_transaction_time == null &&
              (_userInfo[index].cancelstatus == null ||
                  _userInfo[index].cancelstatus == 'R')) {
            smsandotpflag = true;
          } else {
            smsandotpflag = false;
          }

          if (_userInfo[index].cancel_flag != 'Y') {
            pdfFlag = true;

            // true
          } else {
            pdfFlag = false;
          }

//                   if(_userInfo[index].cancelstatus!=null) {
//                     print('smsandotpflag true not null');
//
//                     if (_userInfo[index].cancelstatus=="S" || _userInfo[index].cancelstatus=="A")
//                     {
//                       smsandotpflag=false;
//                       pdfFlag=true;
//
//                     }
//                     else if (_userInfo[index].cancelstatus=="C"){
//                       smsandotpflag=false;
//                     }
//                     else if (_userInfo[index].cancelstatus=="R"){
//
//                       smsandotpflag=false;
//                      // Color_text=Colors.grey[300];
//                     }
//                   }
//                   else if(_userInfo[index].expired=="N"&&_userInfo[index].cancel_flag!="Y"
//                       &&_userInfo[index].split_pass_flag!="Y"
//                       &&(_userInfo[index].splitstatus==null||_userInfo[index].splitstatus=="R"||_userInfo[index].splitstatus=="I") )
//                   {
// print('smsandotpflag true');                    smsandotpflag=true;
//                    // Color_text=Colors.lightBlueAccent;
//                     pdfFlag=true;
//
//                   }else if(_userInfo[index].cancel_flag=="Y"){
//
//                     smsandotpflag=false;
//                     print('smsandotpflag true cancel_flag');
//
//                     //Color_text=Colors.grey[300];
//                   }

          try {
            DateTime todayDate_exp = DateTime.parse(exp_date);
            exp_date = DateFormat('dd/MM/yyyy').format(todayDate_exp);
            DateTime todayDate_issue = DateTime.parse(issue_date);
            issue_date = DateFormat('dd/MM/yyyy').format(todayDate_issue);
          } catch (exception) {}

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
                                    "Unique Pass No.",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _userInfo[index]
                                            .unique_pass_number
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
                                    "Pass Year",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _userInfo[index].pass_year.toString() ??
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
                                    _userInfo[index].pass_type_code ?? "NA",
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
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                        height: 52,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Text(
                                    "From Station",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _userInfo[index].from_station ?? "NA",
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
                                    "To Station",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _userInfo[index].to_station ?? "NA",
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
                                    "Attendant-UPN",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    attendant_upn ?? "NA",
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
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                        height: 52,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Text(
                                    "Pass Set",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _userInfo[index].set_flag,
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
                                  Text("Issue Date",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    issue_date ?? "NA",
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
                                    "Expire Date",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    exp_date ?? "NA",
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
                      Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible: smsandotpflag,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sms,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  GestureDetector(
                                      child: Text('Resend SMS/Send OTP SMS'),
                                      onTap: () {
                                        if (_userInfo[index].cancelstatus !=
                                            null) {
                                          if (_userInfo[index].cancelstatus ==
                                                  "S" ||
                                              _userInfo[index].cancelstatus ==
                                                  "A") {
                                          } else if (_userInfo[index]
                                                  .cancelstatus ==
                                              "C") {
                                          } else if (_userInfo[index]
                                                  .cancelstatus ==
                                              "R") {}
                                        } else if (_userInfo[index].expired == "N" &&
                                            _userInfo[index].cancel_flag !=
                                                "Y" &&
                                            _userInfo[index].cancel_allowed ==
                                                "Y" &&
                                            _userInfo[index].split_pass_flag !=
                                                "Y" &&
                                            (_userInfo[index].splitstatus ==
                                                    null ||
                                                _userInfo[index].splitstatus ==
                                                    "R" ||
                                                _userInfo[index].splitstatus ==
                                                    "I")) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                              hrmsId: hrms_Id,
                                              uniquepassno: int.parse(_userInfo[index]
                                                  .unique_pass_number),
                                              phoneNo: phoneno,
                                              buttonText_sms: "Resend SMS",
                                              buttonText_otp: "Send OTP SMS",
                                            ),
                                          );
                                        } else if (_userInfo[index]
                                                .cancel_flag ==
                                            "Y") {}
                                      }),
                                ],
                              ),
                            ),
                            Visibility(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      bool fileexist = File(
                                              '$path/HRMS/${_userInfo[index].hrms_id}_UPN_${_userInfo[index].unique_pass_number}.pdf')
                                          .existsSync();

                                      if (fileexist) {
                                        OpenFilex.open(
                                            '$path/HRMS/${_userInfo[index].hrms_id}_UPN_${_userInfo[index].unique_pass_number}.pdf');
                                      } else {
                                        selectedpassdownloadPdf(
                                            _userInfo[index].hrms_id,
                                            int.parse(_userInfo[index]
                                                .unique_pass_number));
                                      }
                                    },
                                    child: Text('Download'),
                                  ),
                                ],
                              ),
                              visible: pdfFlag,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: !pdfFlag,
                          child: Wrap(
                            children: [
                              Text(
                                " Cancelled",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                height: 15,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ));
        },
      )),
    );

    // return Scaffold(
    //     appBar: AppBar(title: const Text('Scrapy on flutter')),
    //     body: Center(
    //         child: FutureBuilder<String>(
    //           future: getPassList(), // a previously-obtained Future<String> or null
    //           builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //             List<Widget> children;
    //             if (snapshot.hasData) {
    //               children = <Widget>[
    //                 Center(
    //                   child: new Column(
    //                     children: <Widget>[
    //                       Container(
    //                         color: Colors.grey[300],
    //                         width: double.infinity,
    //                         child: Card(
    //                           child: new Container(
    //
    //                             margin: EdgeInsets.fromLTRB(5, 15, 0, 5),
    //                             child: new Column(
    //                               children: <Widget>[
    //                                 Container(
    //                                   height: 52,
    //                                   margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //
    //                                   child: Row(children: [
    //                                     Expanded(
    //                                         child: Container(
    //
    //                                           alignment: Alignment.centerLeft,
    //                                           child:  Column(children: [
    //                                             Text("Unique Pass No.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                             SizedBox(height: 5,),
    //                                             Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                           ],),)),
    //
    //                                     Expanded(child: Container(
    //                                       alignment: Alignment.center,
    //                                       child:  Column(children: [
    //                                         Text("Pass Year",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                         SizedBox(height: 5,),
    //                                         Text("2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                       ],),)),
    //                                     Expanded(child: Container(
    //                                       alignment: Alignment.center,
    //                                       child:  Column(children: [
    //                                         Text("Pass Type",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                         SizedBox(height: 5,),
    //                                         Text("PPT",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                       ],),)),
    //                                   ],),),
    //
    //                                 SizedBox(height: 5,),
    //                                 Divider(height: 2,color: Colors.grey,),
    //                                 SizedBox(height: 5,),
    //                                 Container(
    //                                   margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                                   height: 52,child:  Row(children: [
    //                                   Expanded(
    //                                       child: Container(
    //
    //                                         alignment: Alignment.centerLeft,
    //                                         child:  Column(children: [
    //                                           Text("From Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                           SizedBox(height: 5,),
    //                                           Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                         ],),)),
    //
    //                                   // _getTitleItemWidget('Issue Date', 100),
    //                                   // _getTitleItemWidget('Expire Date', 100),
    //                                   // _getTitleItemWidget('From Station', 100),
    //                                   // _getTitleItemWidget('To Station', 100),
    //                                   // _getTitleItemWidget('Attendant-UPN', 120),
    //                                   // _getTitleItemWidget('Download PDF', 100),
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.center,
    //                                     child:  Column(children: [
    //                                       Text("To Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                       SizedBox(height: 5,),
    //                                       Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.center,
    //                                     child:  Column(children: [
    //                                       Text("Attendant-UPN",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                       SizedBox(height: 5,),
    //                                       Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                 ],),),
    //
    //                                 SizedBox(height: 5,),
    //                                 Divider(height: 2,color: Colors.grey,),
    //                                 SizedBox(height: 5,),
    //                                 Container(
    //                                   margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                                   height: 52,child: Row(children: [
    //
    //                                   Expanded(
    //                                       child: Container(
    //                                         alignment: Alignment.centerLeft,
    //                                         child:  Column(children: [
    //                                           Text("Pass Set",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                           SizedBox(height: 5,),
    //                                           Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                         ],),)),
    //
    //
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.center,
    //                                     child:  Column(children: [
    //                                       Text("Issue Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
    //                                       SizedBox(height: 5,),
    //                                       Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.center,
    //                                     child:  Column(children: [
    //                                       Text("Expire Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                       SizedBox(height: 5,),
    //                                       Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                 ],),),
    //                                 Divider(height: 2,color: Colors.grey,),
    //                                 SizedBox(height: 5,),
    //                                 Container(
    //                                   height: 50,
    //                                   child: Row(
    //                                     mainAxisAlignment:MainAxisAlignment.spaceBetween,
    //                                     children: [
    //
    //                                       Wrap(
    //                                         crossAxisAlignment: WrapCrossAlignment.center,
    //                                         children: [
    //                                           Icon(Icons.sms,color: Colors.lightBlueAccent,),
    //                                           SizedBox(width: 3,),
    //                                           Text('Send SMS/Generate OTP'),
    //
    //
    //                                         ],
    //                                       ),
    //                                       Wrap(
    //                                         crossAxisAlignment: WrapCrossAlignment.center,
    //                                         children: [
    //                                           Icon(Icons.arrow_downward,color: Colors.lightBlueAccent,),
    //                                           SizedBox(width: 3,),
    //                                           Text('Download'),
    //
    //
    //                                         ],
    //                                       )
    //                                     ],),),
    //
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         color: Colors.grey[300],
    //                         width: double.infinity,
    //                         child: Card(
    //                           child: new Container(
    //
    //                             margin: EdgeInsets.fromLTRB(5, 15, 0, 5),
    //                             child: new Column(
    //                               children: <Widget>[
    //                                 Container(
    //                                   height: 52,
    //                                   margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //
    //                                   child: Row(children: [
    //                                     Expanded(
    //                                         child: Container(
    //
    //                                           alignment: Alignment.centerLeft,
    //                                           child:  Column(children: [
    //                                             Text("Unique Pass No.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                             SizedBox(height: 5,),
    //                                             Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                           ],),)),
    //
    //                                     Expanded(child: Container(
    //                                       alignment: Alignment.centerLeft,
    //                                       child:  Column(children: [
    //                                         Text("Pass Year",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                         SizedBox(height: 5,),
    //                                         Text("2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                       ],),)),
    //                                     Expanded(child: Container(
    //                                       alignment: Alignment.centerLeft,
    //                                       child:  Column(children: [
    //                                         Text("Pass Type",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                         SizedBox(height: 5,),
    //                                         Text("PPT",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                       ],),)),
    //                                   ],),),
    //
    //                                 SizedBox(height: 5,),
    //                                 Divider(height: 2,color: Colors.grey,),
    //                                 SizedBox(height: 5,),
    //                                 Container(
    //                                   margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                                   height: 52,child:  Row(children: [
    //                                   Expanded(
    //                                       child: Container(
    //
    //                                         alignment: Alignment.centerLeft,
    //                                         child:  Column(children: [
    //                                           Text("From Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                           SizedBox(height: 5,),
    //                                           Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                         ],),)),
    //
    //                                   // _getTitleItemWidget('Issue Date', 100),
    //                                   // _getTitleItemWidget('Expire Date', 100),
    //                                   // _getTitleItemWidget('From Station', 100),
    //                                   // _getTitleItemWidget('To Station', 100),
    //                                   // _getTitleItemWidget('Attendant-UPN', 120),
    //                                   // _getTitleItemWidget('Download PDF', 100),
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.centerLeft,
    //                                     child:  Column(children: [
    //                                       Text("To Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                       SizedBox(height: 5,),
    //                                       Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.centerLeft,
    //                                     child:  Column(children: [
    //                                       Text("Attendant-UPN",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                       SizedBox(height: 5,),
    //                                       Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                 ],),),
    //
    //                                 SizedBox(height: 5,),
    //                                 Divider(height: 2,color: Colors.grey,),
    //                                 SizedBox(height: 5,),
    //                                 Container(
    //                                   margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                                   height: 52,child: Row(children: [
    //
    //                                   Expanded(
    //                                       child: Container(
    //                                         alignment: Alignment.centerLeft,
    //                                         child:  Column(children: [
    //                                           Text("Pass Set",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                           SizedBox(height: 5,),
    //                                           Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                         ],),)),
    //
    //
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.centerLeft,
    //                                     child:  Column(children: [
    //                                       Text("Issue Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
    //                                       SizedBox(height: 5,),
    //                                       Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                   Expanded(child: Container(
    //                                     alignment: Alignment.centerLeft,
    //                                     child:  Column(children: [
    //                                       Text("Expire Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                       SizedBox(height: 5,),
    //                                       Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                                     ],),)),
    //                                 ],),),
    //                                 Divider(height: 2,color: Colors.grey,),
    //                                 SizedBox(height: 5,),
    //                                 Container(
    //                                   height: 50,
    //                                   child: Row(
    //                                     mainAxisAlignment:MainAxisAlignment.spaceBetween,
    //                                     children: [
    //
    //                                       Wrap(
    //                                         crossAxisAlignment: WrapCrossAlignment.center,
    //                                         children: [
    //                                           Icon(Icons.sms),
    //                                           SizedBox(width: 3,),
    //                                           Text('Send SMS/Generate OTP'),
    //
    //
    //                                         ],
    //                                       ),
    //                                       Wrap(
    //                                         crossAxisAlignment: WrapCrossAlignment.center,
    //                                         children: [
    //                                           Icon(Icons.download_outlined),
    //                                           SizedBox(width: 3,),
    //                                           Text('Download'),
    //
    //
    //                                         ],
    //                                       )
    //                                     ],),),
    //
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //
    //                     ],
    //                   ),
    //                 ),
    //               ];
    //             } else if (snapshot.hasError) {
    //               children = <Widget>[
    //                 const Icon(
    //                   Icons.error_outline,
    //                   color: Colors.red,
    //                   size: 60,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 16),
    //                   child: Text('Error: ${snapshot.error}'),
    //                 )
    //               ];
    //             }
    //             else {
    //               children = const <Widget>[
    //                 SizedBox(
    //                   child: CircularProgressIndicator(),
    //                   width: 60,
    //                   height: 60,
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 16),
    //                   child: Text('Awaiting result...'),
    //                 )
    //               ];
    //             }
    //             return Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: children,
    //               ),
    //             );
    //
    //           },
    //         )
    //     ),
    // );

    // return new Scaffold(
    //   appBar: AppBar(
    //     leading: new IconButton(
    //       icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
    //       onPressed: () { Navigator.of(context).pop();
    //
    //       },
    //     ),
    //     backgroundColor: Colors.lightBlueAccent,
    //     title: Text("Issued e-Passes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
    //
    //   ),
    //   //hit Ctrl+space in intellij to know what are the options you can use in flutter widgets
    //   body: new Container(
    //     width: double.infinity,
    //
    //     child: new Center(
    //       child: new Column(
    //         children: <Widget>[
    //           Container(
    //             color: Colors.grey[300],
    //             width: double.infinity,
    //           child: Card(
    //             child: new Container(
    //
    //               margin: EdgeInsets.fromLTRB(5, 15, 0, 5),
    //               child: new Column(
    //                 children: <Widget>[
    //                   Container(
    //                     height: 52,
    //                     margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //
    //                     child: Row(children: [
    //                     Expanded(
    //                         child: Container(
    //
    //                           alignment: Alignment.centerLeft,
    //                           child:  Column(children: [
    //                             Text("Unique Pass No.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                             SizedBox(height: 5,),
    //                             Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                           ],),)),
    //
    //                     Expanded(child: Container(
    //                       alignment: Alignment.center,
    //                       child:  Column(children: [
    //                         Text("Pass Year",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                         SizedBox(height: 5,),
    //                         Text("2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                       ],),)),
    //                     Expanded(child: Container(
    //                       alignment: Alignment.center,
    //                       child:  Column(children: [
    //                         Text("Pass Type",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                         SizedBox(height: 5,),
    //                         Text("PPT",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                       ],),)),
    //                   ],),),
    //
    //                   SizedBox(height: 5,),
    //                   Divider(height: 2,color: Colors.grey,),
    //                   SizedBox(height: 5,),
    //                 Container(
    //                 margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                 height: 52,child:  Row(children: [
    //                 Expanded(
    //                     child: Container(
    //
    //                       alignment: Alignment.centerLeft,
    //                       child:  Column(children: [
    //                         Text("From Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                         SizedBox(height: 5,),
    //                         Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                       ],),)),
    //
    //                 // _getTitleItemWidget('Issue Date', 100),
    //                 // _getTitleItemWidget('Expire Date', 100),
    //                 // _getTitleItemWidget('From Station', 100),
    //                 // _getTitleItemWidget('To Station', 100),
    //                 // _getTitleItemWidget('Attendant-UPN', 120),
    //                 // _getTitleItemWidget('Download PDF', 100),
    //                 Expanded(child: Container(
    //                   alignment: Alignment.center,
    //                   child:  Column(children: [
    //                     Text("To Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                     SizedBox(height: 5,),
    //                     Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                   ],),)),
    //                 Expanded(child: Container(
    //                   alignment: Alignment.center,
    //                   child:  Column(children: [
    //                     Text("Attendant-UPN",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                     SizedBox(height: 5,),
    //                     Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                   ],),)),
    //               ],),),
    //
    //                   SizedBox(height: 5,),
    //                   Divider(height: 2,color: Colors.grey,),
    //                   SizedBox(height: 5,),
    //                  Container(
    //                 margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                 height: 52,child: Row(children: [
    //
    //                 Expanded(
    //                     child: Container(
    //                       alignment: Alignment.centerLeft,
    //                       child:  Column(children: [
    //                         Text("Pass Set",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                         SizedBox(height: 5,),
    //                         Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                       ],),)),
    //
    //
    //                 Expanded(child: Container(
    //                   alignment: Alignment.center,
    //                   child:  Column(children: [
    //                     Text("Issue Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
    //                     SizedBox(height: 5,),
    //                     Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                   ],),)),
    //                 Expanded(child: Container(
    //                   alignment: Alignment.center,
    //                   child:  Column(children: [
    //                     Text("Expire Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                     SizedBox(height: 5,),
    //                     Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                   ],),)),
    //               ],),),
    //                   Divider(height: 2,color: Colors.grey,),
    //                   SizedBox(height: 5,),
    //                   Container(
    //                     height: 50,
    //                     child: Row(
    //                     mainAxisAlignment:MainAxisAlignment.spaceBetween,
    //                     children: [
    //
    //                       Wrap(
    //                         crossAxisAlignment: WrapCrossAlignment.center,
    //                         children: [
    //                           Icon(Icons.sms,color: Colors.lightBlueAccent,),
    //                           SizedBox(width: 3,),
    //                           Text('Send SMS/Generate OTP'),
    //
    //
    //                         ],
    //                       ),
    //                       Wrap(
    //                         crossAxisAlignment: WrapCrossAlignment.center,
    //                         children: [
    //                           Icon(Icons.arrow_downward,color: Colors.lightBlueAccent,),
    //                           SizedBox(width: 3,),
    //                           Text('Download'),
    //
    //
    //                         ],
    //                       )
    //                     ],),),
    //
    //                 ],
    //               ),
    //             ),
    //           ),
    // ),
    //           Container(
    //             color: Colors.grey[300],
    //             width: double.infinity,
    //             child: Card(
    //               child: new Container(
    //
    //                 margin: EdgeInsets.fromLTRB(5, 15, 0, 5),
    //                 child: new Column(
    //                   children: <Widget>[
    //                     Container(
    //                       height: 52,
    //                       margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //
    //                       child: Row(children: [
    //                         Expanded(
    //                             child: Container(
    //
    //                               alignment: Alignment.centerLeft,
    //                               child:  Column(children: [
    //                                 Text("Unique Pass No.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                                 SizedBox(height: 5,),
    //                                 Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                               ],),)),
    //
    //                         Expanded(child: Container(
    //                           alignment: Alignment.centerLeft,
    //                           child:  Column(children: [
    //                             Text("Pass Year",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                             SizedBox(height: 5,),
    //                             Text("2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                           ],),)),
    //                         Expanded(child: Container(
    //                           alignment: Alignment.centerLeft,
    //                           child:  Column(children: [
    //                             Text("Pass Type",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                             SizedBox(height: 5,),
    //                             Text("PPT",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                           ],),)),
    //                       ],),),
    //
    //                     SizedBox(height: 5,),
    //                     Divider(height: 2,color: Colors.grey,),
    //                     SizedBox(height: 5,),
    //                     Container(
    //                       margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                       height: 52,child:  Row(children: [
    //                       Expanded(
    //                           child: Container(
    //
    //                             alignment: Alignment.centerLeft,
    //                             child:  Column(children: [
    //                               Text("From Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                               SizedBox(height: 5,),
    //                               Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                             ],),)),
    //
    //                       // _getTitleItemWidget('Issue Date', 100),
    //                       // _getTitleItemWidget('Expire Date', 100),
    //                       // _getTitleItemWidget('From Station', 100),
    //                       // _getTitleItemWidget('To Station', 100),
    //                       // _getTitleItemWidget('Attendant-UPN', 120),
    //                       // _getTitleItemWidget('Download PDF', 100),
    //                       Expanded(child: Container(
    //                         alignment: Alignment.centerLeft,
    //                         child:  Column(children: [
    //                           Text("To Station",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                           SizedBox(height: 5,),
    //                           Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                         ],),)),
    //                       Expanded(child: Container(
    //                         alignment: Alignment.centerLeft,
    //                         child:  Column(children: [
    //                           Text("Attendant-UPN",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                           SizedBox(height: 5,),
    //                           Text("1234",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                         ],),)),
    //                     ],),),
    //
    //                     SizedBox(height: 5,),
    //                     Divider(height: 2,color: Colors.grey,),
    //                     SizedBox(height: 5,),
    //                     Container(
    //                       margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
    //                       height: 52,child: Row(children: [
    //
    //                       Expanded(
    //                           child: Container(
    //                             alignment: Alignment.centerLeft,
    //                             child:  Column(children: [
    //                               Text("Pass Set",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                               SizedBox(height: 5,),
    //                               Text("FULL SET",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                             ],),)),
    //
    //
    //                       Expanded(child: Container(
    //                         alignment: Alignment.centerLeft,
    //                         child:  Column(children: [
    //                           Text("Issue Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
    //                           SizedBox(height: 5,),
    //                           Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                         ],),)),
    //                       Expanded(child: Container(
    //                         alignment: Alignment.centerLeft,
    //                         child:  Column(children: [
    //                           Text("Expire Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //                           SizedBox(height: 5,),
    //                           Text("16/03/2021",style: TextStyle(fontSize: 14,),textAlign: TextAlign.left,),
    //
    //                         ],),)),
    //                     ],),),
    //                     Divider(height: 2,color: Colors.grey,),
    //                     SizedBox(height: 5,),
    //                     Container(
    //                       height: 50,
    //                       child: Row(
    //                         mainAxisAlignment:MainAxisAlignment.spaceBetween,
    //                         children: [
    //
    //                           Wrap(
    //                             crossAxisAlignment: WrapCrossAlignment.center,
    //                             children: [
    //                               Icon(Icons.sms),
    //                               SizedBox(width: 3,),
    //                               Text('Send SMS/Generate OTP'),
    //
    //
    //                             ],
    //                           ),
    //                           Wrap(
    //                             crossAxisAlignment: WrapCrossAlignment.center,
    //                             children: [
    //                               Icon(Icons.download_outlined),
    //                               SizedBox(width: 3,),
    //                               Text('Download'),
    //
    //
    //                             ],
    //                           )
    //                         ],),),
    //
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class CustomDialog extends StatelessWidget {
  final String buttonText_sms, hrmsId, phoneNo, buttonText_otp;
  final int uniquepassno;
  CustomDialog({
    required this.hrmsId,
    required this.uniquepassno,
    required this.phoneNo,
    required this.buttonText_sms,
    required this.buttonText_otp,
  });
  void sendSms() async {
    String url = new UtilsFromHelper().getValueFromKey("issued_pass_sms");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      'uniquePassNo': uniquepassno,
      'hrmsId': hrmsId,
      'mobileNo': phoneNo,
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
      Fluttertoast.showToast(
          msg: "SMS will send at your registered mobile no. $phoneNo",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  void generateOTP() async {
    String url =
        new UtilsFromHelper().getValueFromKey("issued_pass_otpgeneration");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      'uniquePassNo': uniquepassno,
      'hrmsId': hrmsId,
      'mobileNo': phoneNo,
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
      Fluttertoast.showToast(
          msg: "OTP will send at your registered mobile no. $phoneNo",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
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

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 25.0,
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
                "SMS or OTP will send for UPN $uniquepassno at your registered mobile no $phoneNo",
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 5.0),
              SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        sendSms();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        buttonText_sms,
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 13),
                      ),
                    ),
                  ),
                  // Expanded(
                  //
                  //   child: FlatButton(
                  //     onPressed: (){
                  //       generateOTP();
                  //       Navigator.of(context).pop();
                  //     },
                  //
                  //     child: Text(buttonText_otp,style: TextStyle(color:Colors.lightBlueAccent,fontSize: 13),),
                  //   ),
                  // ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 10.0;
  static const double avatarRadius = 66.0;
}
