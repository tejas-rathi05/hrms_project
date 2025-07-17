import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/pass/passapplicationstatusModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';


import '../../local_shared_pref/sharedpreferencemanager.dart';

class PassApplicationStatus_New extends StatefulWidget {
  @override
  PassApplicationStatusState createState() => PassApplicationStatusState();
}

class PassApplicationStatusState extends State<PassApplicationStatus_New> {
  sharedpreferencemanager pref = sharedpreferencemanager();
  late List<Pass_ApplicationStatusModel> _userInfo;
  int listsize = 0;

  @override
  void initState() {
    super.initState();
    getPassdetails();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]);
  }

  @override
  dispose() {
    super.dispose();
  }

  void getPassdetails() async {
    var user_Id = await pref.getEmployeeUserid();

    String url =
        new UtilsFromHelper().getValueFromKey("pass_application_status");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      'userId': user_Id,
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
      if (responseJSON != null && responseJSON.containsKey("passApplicationDetails")) {
        setState(() {
          var passdetails = responseJSON["passApplicationDetails"] as List?;
          if(passdetails != null) {
            _userInfo = passdetails
            !.map<Pass_ApplicationStatusModel>(
                    (json) => Pass_ApplicationStatusModel.fromJson(json))
                .toList();
          }
          listsize = _userInfo.length;
          print("listsize $listsize");
          if (_userInfo.length == 0) {
            print("HI");
            Fluttertoast.showToast(
                msg: 'No data found',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                //  timeInSecForIos: 5,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        });
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg:  e.toString(),
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
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("e-Pass Application Status",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Center(
          child: ListView.builder(
        // current the spelling of length here
        itemCount: listsize,
        itemBuilder: (context, index) {
          var exp_date = _userInfo[index].submitted_date;
          try {
            DateTime todayDate_exp = DateTime.parse(exp_date);
            exp_date = DateFormat('dd/MM/yyyy').format(todayDate_exp);
          } catch (exception) {}

          //  IssuedPassModel project = snapshot.data;
          return Container(
              color: Colors.grey[300],
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: ClipPath(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Colors.lightBlueAccent, width: 5))),
                    child: new Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      "Appl. No",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _userInfo[index].pan.toString() ?? "NA",
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
                                      "Pass Status",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _userInfo[index].status_flag.toString() ??
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
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerLeft,
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
                                      "Submitted Date",
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
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
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
                                      _userInfo[index].full_half_set_flag ??
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
                                    Text("To Station",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
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
                                      "Via/Break JS",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _userInfo[index].breakjo ?? "NA",
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
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      "Remarks",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _userInfo[index].remarks ?? "NA",
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
                      ],
                    ),
                  ),
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
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
