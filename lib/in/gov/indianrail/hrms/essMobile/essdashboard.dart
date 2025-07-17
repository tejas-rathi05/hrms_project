
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/lefticonOption_btn.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/righticonOption_btn.dart';

import '../connectivityfile.dart';

class EssdashboardMobile extends StatefulWidget {
  var hrmsId;
  EssdashboardMobile(this.hrmsId);

  @override
  EssdashboardState createState() => EssdashboardState();
}

class EssdashboardState extends State<EssdashboardMobile> {

  String connectivity_check="";
  //Map _source = {ConnectivityResult.none: false};

  //MyConnectivity _connectivity = MyConnectivity.instance;
  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results.first); // get first available connection
    });
    /*_connectivity.initialise();
    _connectivity.myStream.listen((source) {
      //setState(() => _source = source);
      setState(() {
        _source = source;
      });
    });*/
  }
  Future<void> _checkInitialConnectivity() async {
    var results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results.first); // again, use first connection type
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      if (result == ConnectivityResult.mobile) {
        connectivity_check = "Online";
      } else if (result == ConnectivityResult.wifi) {
        connectivity_check = "Online";
      } else {
        connectivity_check = "Offline";
      }
    });
    print('sourceConn: $connectivity_check'); // Print the current connection status
  }
  @override
  Widget build(BuildContext context) {
    /*switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        break;
      case ConnectivityResult.mobile:
        string = "Online";
        break;
      case ConnectivityResult.wifi:
        string = "Online";
    }*/
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text(" IRHRMS-ESS",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            RightIconBtn(
                Icon(
                  Icons.info,
                  color: Colors.lightBlueAccent,
                ),
                "Basic Details",
                widget.hrmsId,
                "basic-details"),
            LeftIconButton(
              Icon(
                Icons.wc,
                color: Colors.lightBlueAccent,
              ),
              'Family Details',
              widget.hrmsId,
              "my-family-details",
            ),
            RightIconBtn(
                Icon(
                  Icons.chrome_reader_mode,
                  color: Colors.lightBlueAccent,
                ),
                "Personal Details",
                widget.hrmsId,
                "my-personal-details"),
            LeftIconButton(
              Icon(
                Icons.border_color,
                color: Colors.lightBlueAccent,
              ),
              'Change Request \n Status',
              widget.hrmsId,
              "change-request-summary",
            ),
            RightIconBtn(
                Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.lightBlueAccent,
                ),
                "Communication \nDetails",
                widget.hrmsId,
                "communication-details"),

            LeftIconButton(
                Icon(
                  Icons.library_books,
                  color: Colors.lightBlueAccent,
                ),
                "Qualification \nDetails",
                widget.hrmsId,
                "my-qualification-details"),

            RightIconBtn(
                Icon(
                  FontAwesomeIcons.calculator,
                  color: Colors.lightBlueAccent,
                ),
                " Create Document",
                widget.hrmsId,
                "PDF"),
            LeftIconButton(
              Icon(
                Icons.description,
                color: Colors.lightBlueAccent,
              ),
              'HR Calculation',
              widget.hrmsId,
              "HR",
            ),
            // RightIconBtn(Icon(
            //   FontAwesomeIcons.calculator,
            //   color: Colors.lightBlueAccent,
            // ),"HR Calculation",widget.hrmsId,"HR"),

            // Container(
            //
            //   child:Column(
            //     children: <Widget>[
            //       Container(
            //
            //         height:55,
            //         margin: EdgeInsets.fromLTRB(30.0,30,30,0),
            //         child: RaisedButton(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(25.0),
            //               side: BorderSide(color: Colors.lightBlueAccent)),
            //           onPressed: () {
            //             if(string=="Online")
            //             {
            //               String get_report_url = new UtilsFromHelper().getValueFromKey("view_update_family_ess");
            //
            //               var userId= widget.hrmsId;
            //
            //               var url=get_report_url+'/android/my-basic-details?hrmsId=$userId&authorizationToken=HrMs@T0k3n';
            //
            //               Navigator.push(
            //                 context,
            //
            //                 MaterialPageRoute(
            //                     builder: (context) => Hrmslink(url,"Basic Details")),
            //
            //
            //               );
            //             }else{
            //
            //               Fluttertoast.showToast(
            //                   msg: "No Internet Connection",
            //                   toastLength: Toast.LENGTH_LONG,
            //                   gravity: ToastGravity.BOTTOM,
            //                   timeInSecForIos: 5,
            //                   backgroundColor: Colors.pink,
            //                   textColor: Colors.white,
            //                   fontSize: 14.0
            //               );
            //
            //             }
            //
            //           },
            //           color: Colors.lightBlueAccent,
            //           child: Padding(
            //             padding: EdgeInsets.fromLTRB(
            //                 5,
            //                 0,
            //                 5,
            //                 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: <Widget>[
            //                 Container(
            //                   decoration: BoxDecoration(
            //
            //                     color:Colors.white,
            //                     borderRadius: BorderRadius.circular(15),
            //                     border: Border.all(
            //                         width: 1,
            //                         color: HexColor("#ffffff")
            //
            //                     ),
            //                   ),
            //
            //                   height:35,
            //                   width: 90,
            //                   child:  Icon(
            //                     Icons.description,
            //                     color: Colors.lightBlueAccent,
            //                   ),
            //                 ),
            //
            //
            //                 Text(
            //                   'Basic Details',
            //                   style: TextStyle(
            //                     fontSize: 17,
            //
            //                     color: Colors.white,
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            // Container(
            //
            //   child:Column(
            //     children: <Widget>[
            //       Container(
            //         height:55,
            //         margin: EdgeInsets.all(30.0),
            //         child: RaisedButton(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(25.0),
            //               side: BorderSide(color: Colors.lightBlueAccent)),
            //           onPressed: () {
            //             if(string=="Online")
            //             {
            //
            //               String geturl = new UtilsFromHelper().getValueFromKey("view_update_family_ess");
            //
            //               var userId= widget.hrmsId;
            //
            //               var url=geturl+'/android/my-personal-details?hrmsId=$userId&authorizationToken=HrMs@T0k3n';
            //
            //               Navigator.push(
            //                 context,
            //
            //                 MaterialPageRoute(
            //                     builder: (context) => Hrmslink(url,"Personal Details")),
            //
            //
            //               );
            //
            //
            //
            //
            //
            //
            //             }else{
            //               Fluttertoast.showToast(
            //                   msg: "No Internet Connection",
            //                   toastLength: Toast.LENGTH_LONG,
            //                   gravity: ToastGravity.BOTTOM,
            //                   timeInSecForIos: 5,
            //                   backgroundColor: Colors.pink,
            //                   textColor: Colors.white,
            //                   fontSize: 14.0
            //               );
            //             }
            //           },
            //           color: Colors.lightBlueAccent,
            //           child: Padding(
            //             padding: EdgeInsets.fromLTRB(
            //                 5,
            //                 0,
            //                 5,
            //                 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: <Widget>[
            //                 Text(
            //                   'Personal Details',
            //                   style: TextStyle(
            //                     fontSize: 17,
            //
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 Container(
            //                     decoration: BoxDecoration(
            //
            //                       color:Colors.white,
            //                       borderRadius: BorderRadius.circular(15),
            //                       border: Border.all(
            //                           width: 1,
            //                           color: HexColor("#ffffff")
            //
            //                       ),
            //                     ),
            //
            //                     height:35,
            //                     width: 90,
            //                     child:
            //                     Icon(
            //                       Icons.chrome_reader_mode,
            //                       color: Colors.lightBlueAccent,
            //                     )
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            // LeftIconButton(Icon(
            //   Icons.description,
            //   color: Colors.lightBlueAccent,
            // ),
            //     'Communication \nDetail', widget.hrmsId,"my-basic-details",
            // ),
            // Container(
            //
            //   child:Column(
            //     children: <Widget>[
            //       Container(
            //
            //         height:55,
            //         margin: EdgeInsets.fromLTRB(30.0,0,30,0),
            //         child: RaisedButton(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(25.0),
            //               side: BorderSide(color: Colors.lightBlueAccent)),
            //           onPressed: () {
            //             if(string=="Online")
            //             {
            //               String get_report_url = new UtilsFromHelper().getValueFromKey("view_update_family_ess");
            //
            //               var userId= widget.hrmsId;
            //
            //               var url=get_report_url+'/android/change-request-summary?hrmsId=$userId&authorizationToken=HrMs@T0k3n';
            //
            //               Navigator.push(
            //                 context,
            //
            //                 MaterialPageRoute(
            //                     builder: (context) => Report(url,"Change Request Satus")),
            //
            //
            //               );
            //             }else{
            //
            //               Fluttertoast.showToast(
            //                   msg: "No Internet Connection",
            //                   toastLength: Toast.LENGTH_LONG,
            //                   gravity: ToastGravity.BOTTOM,
            //                   timeInSecForIos: 5,
            //                   backgroundColor: Colors.pink,
            //                   textColor: Colors.white,
            //                   fontSize: 14.0
            //               );
            //
            //             }
            //
            //           },
            //           color: Colors.lightBlueAccent,
            //           child: Padding(
            //             padding: EdgeInsets.fromLTRB(
            //                 5,
            //                 0,
            //                 5,
            //                 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: <Widget>[
            //                 Container(
            //                   decoration: BoxDecoration(
            //
            //                     color:Colors.white,
            //                     borderRadius: BorderRadius.circular(15),
            //                     border: Border.all(
            //                         width: 1,
            //                         color: HexColor("#ffffff")
            //
            //                     ),
            //                   ),
            //
            //                   height:35,
            //                   width: 90,
            //                   child:  Icon(
            //                     Icons.sms,
            //                     color: Colors.lightBlueAccent,
            //                   ),
            //                 ),
            //
            //
            //                 Text(
            //                   'Change Request',
            //                   style: TextStyle(
            //                     fontSize: 17,
            //
            //                     color: Colors.white,
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            // RightIconBtn(Icon(
            //   Icons.description,
            //   color: Colors.lightBlueAccent,
            // ),"Family Details",widget.hrmsId,"my-basic-details"),
            // Container(
            //
            //   child:Column(
            //     children: <Widget>[
            //       Container(
            //         height:55,
            //         margin: EdgeInsets.fromLTRB(30.0,0,30,30),
            //         child: RaisedButton(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(25.0),
            //               side: BorderSide(color: Colors.lightBlueAccent)),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //
            //               MaterialPageRoute(
            //                   builder: (context) => HomePDF_new()),
            //
            //
            //             );
            //
            //           },
            //           color: Colors.lightBlueAccent,
            //           child: Padding(
            //             padding: EdgeInsets.fromLTRB(
            //                 5,
            //                 0,
            //                 5,
            //                 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: <Widget>[
            //                 Text(
            //                   'Create Document',
            //                   style: TextStyle(
            //                     fontSize: 17,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 Container(
            //                     decoration: BoxDecoration(
            //
            //                       color:Colors.white,
            //                       borderRadius: BorderRadius.circular(15),
            //                       border: Border.all(
            //                           width: 1,
            //                           color: HexColor("#ffffff")
            //
            //                       ),
            //                     ),
            //
            //                     height:35,
            //                     width: 90,
            //                     child:
            //                     Icon(
            //                       FontAwesomeIcons.calculator,
            //                       color: Colors.lightBlueAccent,
            //                     )
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            // Container(
            //
            //   child:Column(
            //     children: <Widget>[
            //       Container(
            //         height:55,
            //         margin: EdgeInsets.fromLTRB(30.0,0,30,0),
            //         child: RaisedButton(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(25.0),
            //               side: BorderSide(color: Colors.lightBlueAccent)),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //
            //               MaterialPageRoute(
            //                   builder: (context) => HRdashboard()),
            //
            //
            //             );
            //
            //           },
            //           color: Colors.lightBlueAccent,
            //           child: Padding(
            //             padding: EdgeInsets.fromLTRB(
            //                 5,
            //                 0,
            //                 5,
            //                 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: <Widget>[
            //                 Text(
            //                   'HR Calculation',
            //                   style: TextStyle(
            //                     fontSize: 17,
            //
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 Container(
            //                     decoration: BoxDecoration(
            //
            //                       color:Colors.white,
            //                       borderRadius: BorderRadius.circular(15),
            //                       border: Border.all(
            //                           width: 1,
            //                           color: HexColor("#ffffff")
            //
            //                       ),
            //                     ),
            //
            //                     height:35,
            //                     width: 90,
            //                     child:
            //                     Icon(
            //                       FontAwesomeIcons.calculator,
            //                       color: Colors.lightBlueAccent,
            //                     )
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),

            //other url
          ],
        )),
      ),
    );
  }
}
