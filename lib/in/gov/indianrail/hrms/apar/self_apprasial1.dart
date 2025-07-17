// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hrmsproject/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
//
// import '../util/apiurl.dart';
// import '../local_shared_pref/sharedpreferencemanager.dart';
//
// import 'dart:async';
// import 'dart:convert';
//
//
//
//
//
// var designation="",railwayunit="",dob="",department="",mobileno="",billunit="",ipasempid="",hrmsid="",railwayzone="",
//     profilename="";
//
// class SelfApprasial extends StatefulWidget {
//   var finyear;
//   SelfApprasial(this.finyear);
//   @override
//   SelfApprasialState createState() =>SelfApprasialState();
// }
// class SelfApprasialState extends State<SelfApprasial> {
//   TextEditingController work_done_text_f=TextEditingController();
//   TextEditingController dc_duties_text_f=TextEditingController();
//   TextEditingController property_text_f=TextEditingController();
//
//
//   var aparyear,aparformate, pay_level,operatingunit;
//   var visiblity_con=true;
//   File _image;
//   sharedpreferencemanager pref=sharedpreferencemanager();
//   final String url = new UtilsFromHelper().getValueFromKey("file_download");
//
//
//   Future ReportingOffierdetails() async{
//
//
//     sharedpreferencemanager pref=sharedpreferencemanager();
//     final String url = new UtilsFromHelper().getValueFromKey("login_url");
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
//     String basicAuth = await Hrmstokenplugin.hrmsToken;
//     Map map = {
//       "userId":await pref.getUsername(),
//       "password":await pref.getPassword(),
//
//     };
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
//
//     if(responseJSON['status']=="1"){
//       setState(() {
//
//         profilename= responseJSON['userProfile']['profile']['employeeName'];
//         designation= responseJSON['userProfile']['profile']['designationDescription'];
//         railwayunit=responseJSON['userProfile']['profile']['railwayUnitName'];
//         dob= responseJSON['userProfile']['profile']['dateOfBirth'];
//
//         department= responseJSON['userProfile']['profile']['departmentDescription'];
//         mobileno=responseJSON['userProfile']['profile']['mobileNo'];
//         billunit= responseJSON['userProfile']['profile']['billUnit'];
//         ipasempid=responseJSON['userProfile']['profile']['ipasEmployeeId'];
//         hrmsid=responseJSON['userProfile']['profile']['hrmsEmployeeId'];
//       //  railwayunit= responseJSON['userProfile']['profile']['railwayUnitCode'];
//
//     if(aparformate=="A1"||aparformate=="A2"||aparformate=="A3"||aparformate=="A4"||aparformate=="A5"||aparformate=="H1"||
//                 aparformate=="RBD1"||aparformate=="RBD2"||aparformate=="RBD3"||aparformate=="RBD4")
//             {
//               select_apprasial_emp(widget.finyear);
//
//
//             }
//
//
//
//
//       });
//
//     }
//
//   }
//
//
//   Future select_apprasial_emp(String year) async{
//
//     final String url = new UtilsFromHelper().getValueFromKey("select_self_apprasial");
//
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
//     String basicAuth = await Hrmstokenplugin.hrmsToken;
//
//
//     Map map = {
//
//       "hrms_employee_id":hrmsid,
//       "apar_fin_yr":year
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
//
//
//
//     if(responseJSON!=null||responseJSON!="") {
//       var aparformate;
//       setState(() {
//        if( responseJSON['result']==1)
//          {
//            visiblity_con=false;
//            Fluttertoast.showToast(
//                msg:"self-appraisal already submitted",
//                toastLength: Toast.LENGTH_LONG,
//                gravity: ToastGravity.BOTTOM,
//                timeInSecForIos: 5,
//                backgroundColor: Colors.pink,
//                textColor: Colors.white,
//                fontSize: 14.0
//            );
//          }
//        else{
//          visiblity_con=true;
//        }
//       });
//     }
//
//   }
//
//   @override
//   void initState() {
//
//     //getdetails();
//    // get_fin_year();
//   //  get_no_gazettedofficer(widget.finyear);
//    // get_reporting_section();
//
//     ReportingOffierdetails();
//     super.initState();
//   }
//
//
//   Widget _buildStatContainer() {
//     return  Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(7),
//           color: Colors.white54,
//           border: Border.all(
//               width: 1,
//               color: Colors.white
//           )
//       ),
//       margin: EdgeInsets.all(10),
//       padding: EdgeInsets.all(5),
//       child:Column(
//           children:<Widget>[
//
//             SizedBox(height: 5,),
//
//             Row(
//               children: <Widget>[
//                 Expanded(
//
//                   child: Container(
//                       height:14,
//                       margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
//                       child:Text('HRMS ID :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
//                       FontWeight.bold,color: Colors.grey[600]),)
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Text(hrmsid??"Not Available", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
//                 ),
//               ],
//             ),
//             Divider(color:Colors.grey),
//             Row(
//               children: <Widget>[
//                 Expanded(
//
//                   child: Container(
//                       height:14,
//
//                       margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
//                       child:Text('DESIGNATION :', textAlign: TextAlign.left,
//                         style: TextStyle(fontSize:11,fontWeight: FontWeight.bold,color: Colors.grey[600]),)
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Text(designation??"Not Available", textAlign: TextAlign.right, style: TextStyle(fontSize:11)),
//                 ),
//               ],
//             ),
//
//
//             Divider(color:Colors.grey),
//             Row(
//               children: <Widget>[
//                 Expanded(
//
//                   child: Container(
//                       height:14,
//                       margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
//                       child:Text('DEPARTMENT :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
//                       FontWeight.bold,color: Colors.grey[600]),)
//                   ),
//                 ),
//
//
//                 Expanded(
//                   child: Text(department??"Not Available", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
//                 ),
//               ],
//             ),
//             Divider(color:Colors.grey),
//             Row(
//               children: <Widget>[
//                 Expanded(
//
//                   child: Container(
//                       height:14,
//                       margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
//                       child:Text('PAYLEVEL :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
//                       FontWeight.bold,color: Colors.grey[600]),)
//                   ),
//                 ),
//
//
//                 Expanded(
//                   child: Text(mobileno??"Not Available", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
//                 ),
//               ],
//             ),
//
//
//
//
//             Divider(color:Colors.grey),
//             Row(
//               children: <Widget>[
//                 Expanded(
//
//                   child: Container(
//                       height:14,
//                       margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
//                       child:Text('OPERATING UNIT :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
//                       FontWeight.bold,color: Colors.grey[600]),)
//                   ),
//                 ),
//
//
//                 Expanded(
//                   child: Text(billunit??"Not Available", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
//                 ),
//               ],
//             ),
//             Divider(color:Colors.grey),
//             Row(
//               children: <Widget>[
//                 Expanded(
//
//                   child: Container(
//                       height:14,
//                       margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
//                       child:Text('APAR FORMAT CODE :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
//                       FontWeight.bold,color: Colors.grey[600]),)
//                   ),
//                 ),
//
//                 Expanded(
//                   child: Text(railwayunit??"Not Available", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
//                 ),
//               ],
//             ),
//             Divider(color:Colors.grey),
//
//             Visibility(
//               visible: visiblity_con,
//               child:
//               Column(
//                   children:<Widget>[
//                     SizedBox(height: 20,),
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                           child: Text("Brief description of duties",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
//                         )
//                     ),
//                     Container(
//
//
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 5.5, horizontal: 0.0),
//                       padding: EdgeInsets.fromLTRB(10,0,0,10),
//                       decoration: BoxDecoration(
//
//
//                       ),
//
//                       child: TextField(
//
//                         controller: dc_duties_text_f,
//                         maxLines: 1,
//                         style: TextStyle(
//                             fontSize: 15),
//                         enableInteractiveSelection: true,
//
//
//                       ),
//                       // child: new Row(
//                       //   children: <Widget>[
//                       //     new Expanded(
//                       //       child: TextField(
//                       //
//                       //         controller: remarks,
//                       //         maxLines: 1,
//                       //         style: TextStyle(
//                       //             fontSize: 12),
//                       //         enableInteractiveSelection: true,
//                       //         decoration: new InputDecoration(
//                       //             hintText: 'Enter Remarks'
//                       //
//                       //         ),
//                       //
//                       //       ),
//                       //     ),
//                       //
//                       //   ],
//                       // ),
//                     ),
//
//
//
//
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                           child: Text("Work done in the current year",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
//                         )
//                     ),
//                     Container(
//
//
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 5.5, horizontal: 0.0),
//                       padding: EdgeInsets.fromLTRB(10,0,0,10),
//                       decoration: BoxDecoration(
//
//
//                       ),
//
//                       child: TextField(
//
//                         controller: work_done_text_f,
//                         maxLines: 1,
//                         style: TextStyle(
//                             fontSize: 15),
//                         enableInteractiveSelection: true,
//
//
//                       ),
//
//                     ),
//
//
//
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                           child: Text("Property returns (Y / N)",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
//                         )
//                     ),
//                     Container(
//
//
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 5.5, horizontal: 0.0),
//                       padding: EdgeInsets.fromLTRB(10,0,0,10),
//                       decoration: BoxDecoration(
//
//
//                       ),
// // lxdpql
//                       child: TextField(
//                       maxLength: 1,
//                         textCapitalization: TextCapitalization.characters,
//                         controller: property_text_f,
//                         maxLines: 1,
//                         style: TextStyle(
//                             fontSize: 15),
//                         enableInteractiveSelection: true,
//
//
//                       ),
//
//                     ),
//
//                     Container(
//                       height: 45.0,
//                       margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
//
//                       child: Material(
//                         elevation: 5.0,
//                         borderRadius: BorderRadius.circular(20.0),
//                         color: Colors.lightBlueAccent,
//
//
//                         child:Container(
//                           decoration: BoxDecoration(
//                           ),
//                           child: MaterialButton(
//
//                             child: Text("Submit",
//                               style: TextStyle(color: Colors.white),
//                               textAlign: TextAlign.center,
//
//                             ),
//                           ),
//                         ),
//
//                       ),
//
//                     ),
//
//                   ]),
//             ),
//
//
//
//           ]
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle _nameTextStyle = TextStyle(
//       fontFamily: 'Roboto',
//       color: Colors.black,
//       fontSize: 14.0,
//       fontWeight: FontWeight.w700,
//
//     );
//     Size screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//           leading: new IconButton(
//             icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           backgroundColor: Colors.lightBlueAccent,
//           title: Text( "My Profile",
//               style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold))),
//       body: Stack(
//
//         children: <Widget>[
//
//          // _buildCoverImage(screenSize),
//           SafeArea(
//             child: SingleChildScrollView(
//
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: 20.0),
//
//                   Text(
//                     profilename,
//                     style: _nameTextStyle,),
//                   SizedBox(height: 5.0),
//                   _buildStatContainer(),
//                   SizedBox(height: 15),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }