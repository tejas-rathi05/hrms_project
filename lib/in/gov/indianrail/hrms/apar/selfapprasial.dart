// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
// import 'package:hrmsproject/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
// import 'package:hrmsproject/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
// import 'package:hrmsproject/in/gov/indianrail/hrms/util/apiurl.dart';
//
// import 'aparProfile.dart';
// import 'gazettedoffierviewModel.dart';
// int listsize;
// class AppraisalOfficer extends StatefulWidget{
//   List<GazettedOfficerModel> userlist;
//   var title,arraysize;
//
//   //AppraisalOfficer(this.userlist,this.title,this.arraysize);
//
//
//   @override
//   AppraisalOfficerState createState() => AppraisalOfficerState();
//
// }
// class AppraisalOfficerState extends State<AppraisalOfficer>{
//   sharedpreferencemanager pref=sharedpreferencemanager();
//   // List<GazettedOfficerModel> _userInfo;
//
//   Future get_reporting_section() async{
//
//     final String url = new UtilsFromHelper().getValueFromKey("get_reporting_section");
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
//     String basicAuth = await Hrmstokenplugin.hrmsToken;
//
//
//     Map map = {
//
//       "hrms_employee_id":"DOOHYS",
//
//
//     };
//
//
//
//
//     HttpClientRequest request = await client.postUrl(Uri.parse(url));
//     request.headers.set('content-type', 'application/json');
//     request.headers.set( 'Accept','application/json');
//
//     request.headers.set('authorization',basicAuth);
//     request.add(utf8.encode(json.encode(map)));
//     HttpClientResponse response = await request.close();
//
//     String value = await response.transform(utf8.decoder).join();
//     var responseJSON = json.decode(value) as Map;
//     // print('Insert json$responseJSON');
//
//
//
//     if(responseJSON!=null||responseJSON!="") {
//       var aparformate;
//       setState(() {
//        var aparyear=  responseJSON['apar_fin_yr'];
//         aparformate= responseJSON['apar_format_code'];
//        var pay_level=  responseJSON['pay_level_flag'];
//        var operatingunit=responseJSON['operating_unit'];
//
//       });
//     //‘A1’,’A2’,’A3’,’A4’,’A5’,’H1’,’RBD1’,’RBD2’,’RBD3’,’RBD4’
//       if(aparformate=="A1"||aparformate=="A2"||aparformate=="A3"||aparformate=="A4"||aparformate=="A5"||aparformate=="H1"||
//           aparformate=="RBD1"||aparformate=="RBD2"||aparformate=="RBD3"||aparformate=="RBD4")
//         {
//
//         }
//
//     }
//
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     // getDetails();
//     // getPassdetails();
//   }
//
//
//
// //   List<Widget> _getTitleWidget() {
// //     return [
// //       Row(
// //           children: <Widget>[
// //             FlatButton(
// //               padding: EdgeInsets.all(0), child: _getTitleItemWidget('HRMS ID',100),),
// // //            FlatButton(
// // //              padding: EdgeInsets.all(0), child: _getTitleItemWidget('Employee Name',130),),
// //
// //           ]
// //       ),
// //       _getTitleItemWidget('Emp Name', 120),
// //       _getTitleItemWidget('Designation', 120),
// //       _getTitleItemWidget('Department', 120),
// //       _getTitleItemWidget('Pay Level', 120),
// //       _getTitleItemWidget('Operating Unit', 120),
// //
// //       _getTitleItemWidget('Apar Format Code', 100),
// //       _getTitleItemWidget('Fin-Year', 100)
// //
// //
// //
// //     ];
// //   }
// //
// //   Widget _getTitleItemWidget(String label, double width) {
// //     return Container(
// //       child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
// //       width: width,
// //       height: 56,
// //       padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
// //       alignment: Alignment.centerLeft,
// //     );
// //   }
// //   Widget _generateFirstColumnRow(BuildContext context, int index) {
// //
// //     return Row(children: <Widget>[
// //       Container(
// //         child: GestureDetector(
// //           onTap: () {
// //             Navigator.pop(context);
// //             Navigator.push(
// //                 context,
// //
// //
// //                 MaterialPageRoute(builder: (context) =>AparProfile(widget.userlist[index].hrmsEmployeeId,widget.userlist[index].employeeName,widget.userlist[index].Designation,widget.userlist[index].vafCode,widget.userlist[index].aparFinYr,"selfapprasial"))
// //             );
// //           },
// //           child: Text("hrmsEmployeeId"??"Not Available",style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold) ),
// //
// //         ),
// //         width: 100,
// //         height: 52,
// //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
// //         alignment: Alignment.centerLeft,
// //       ),
// //     ],);
// //   }
// //   Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
// //
// //     return Row(
// //       children: <Widget>[
// //
// //         Container(
// //
// //           child: Text("employeeName"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,)),
// //           width: 120,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.centerLeft,
// //         ),
// //
// //         Container(
// //
// //           child: Text("degignation"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,),),
// //           width: 100,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.center,
// //         ),
// //         Container(
// //
// //           child: Text("department"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,),),
// //           width: 100,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.center,
// //         ),
// //         Container(
// //
// //           child: Text("pay"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,),textAlign: TextAlign.center,),
// //           width: 100,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.centerLeft,
// //         ),
// //         Container(
// //
// //           child: Text("operating"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,),textAlign: TextAlign.center,),
// //           width: 120,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.centerLeft,
// //         ),
// //         Container(
// //
// //           child: Text("code"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,),textAlign: TextAlign.center,),
// //           width: 130,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.centerLeft,
// //         ),
// //         Container(
// //
// //           child: Text("aparFinYr"??"Not Available ",style: TextStyle(color: Colors.grey[500],fontSize: 12.0,),textAlign: TextAlign.center,),
// //           width: 100,
// //           height: 52,
// //           padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
// //           alignment: Alignment.centerLeft,
// //         ),
// //
// //
// //
// //
// //       ],
// //     );
// //   }
//   @override
//   Widget build(BuildContext context) {
//
//     if(widget.arraysize==0)
//     {
//       return Align(alignment: Alignment.center,
//       child: Text("No data found",));
//     }
//     else{
// //      listsize=widget.userlist.length;
//       return Scaffold(
//         appBar: AppBar(
//           leading: new IconButton(
//             icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
//             onPressed: () { Navigator.of(context).pop();},
//           ),
//           backgroundColor: Colors.lightBlueAccent,
//           title: Text("Self Apprasial",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
//
//         ),
//         body: Container(
//           // child: HorizontalDataTable(
//           //   leftHandSideColumnWidth: 120,
//           //   rightHandSideColumnWidth:800,
//           //   isFixedHeader: true,
//           //   headerWidgets: _getTitleWidget(),
//           //   leftSideItemBuilder: _generateFirstColumnRow,
//           //   rightSideItemBuilder: _generateRightHandSideColumnRow,
//           //  itemCount:1 ?? 0,
//           //   rowSeparatorWidget: const Divider(
//           //     color: Colors.black54,
//           //     height: 1.0,
//           //     thickness: 0.0,
//           //   ),
//           //   leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
//           //   rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
//           // ),
//           height: MediaQuery
//               .of(context)
//               .size
//               .height,
//         ),
//       );
//     }
//
//
//   }
//
// }