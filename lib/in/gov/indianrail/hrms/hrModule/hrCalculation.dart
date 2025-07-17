import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';

import '../connectivityfile.dart';

import 'car_pc_scooter.dart';

import 'leave_encashment.dart';
import 'webview_screen.dart';

class HRdashboard extends StatefulWidget {
  HRdashboard();

  @override
  HRdashboardState createState() => HRdashboardState();
}

class HRdashboardState extends State<HRdashboard> {
  late String string;
  //Map _source = {ConnectivityResult.none: false};

  MyConnectivity _connectivity = MyConnectivity.instance;
  @override
  void initState() {
    super.initState();
   /* _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      //setState(() => _source = source);
      setState(() {
        _source = source;
      });
    });*/
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
        title: Text(" HR Calculation",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),

      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  margin: EdgeInsets.all(30.0),
                  child: TextButton(
                    onPressed: () {
                      if (string == "Online") {
                       /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebViewLoad("assets/settle.html")),
                        );*/
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Internet Connection",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Settlement',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1, color: HexColor("#ffffff")),
                              ),
                              height: 35,
                              width: 90,
                              child: Icon(
                                FontAwesomeIcons.calculator,
                                color: Colors.lightBlueAccent,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                  child: TextButton(
                    onPressed: () {
                      if (string == "Online") {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebViewLoad("assets/pay_fix.html")),
                        );*/
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Internet Connection",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: HexColor("#ffffff")),
                            ),
                            height: 35,
                            width: 90,
                            child: Icon(
                              FontAwesomeIcons.moneyBill,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          Text(
                            'Pay Fixation',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  margin: EdgeInsets.all(30.0),
                  child: TextButton(
                    onPressed: () {
                      if (string == "Online") {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebViewLoad("assets/ot_nda.html")),
                        );*/
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Internet Connection",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'FOT & NDA ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1, color: HexColor("#ffffff")),
                              ),
                              height: 35,
                              width: 90,
                              child: Icon(
                                FontAwesomeIcons.stackExchange,
                                color: Colors.lightBlueAccent,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                  child: TextButton(
                    onPressed: () {
                      if (string == "Online") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Leave_Encashment()),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Internet Connection",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: HexColor("#ffffff")),
                            ),
                            height: 35,
                            width: 90,
                            child: Icon(
                              FontAwesomeIcons.calendarAlt,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          Text(
                            ' Leave Encashment',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  margin: EdgeInsets.all(30.0),
                  child: TextButton(
                    onPressed: () {
                      if (string == "Online") {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebViewLoad("assets/it2021.html")),
                        );*/
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Internet Connection",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'IT-Forecast ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1, color: HexColor("#ffffff")),
                              ),
                              height: 35,
                              width: 90,
                              child: Icon(
                                FontAwesomeIcons.getPocket,
                                color: Colors.lightBlueAccent,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                  child: TextButton(
                    onPressed: () {
                      if (string == "Online") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Advance_car_pc()),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "No Internet Connection",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIos: 5,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: HexColor("#ffffff")),
                            ),
                            height: 35,
                            width: 90,
                            child: Icon(
                              FontAwesomeIcons.carAlt,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          Text(
                            ' Advance Car \n PC Scooter',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
//      Container(
//
//        margin: EdgeInsetsDirectional.fromSTEB(5, 15, 5, 0),
//        child:GridView.count(
//          shrinkWrap: true,
//          crossAxisCount: 2,
//          crossAxisSpacing: 0.0,
//          mainAxisSpacing: 0.0,
//          children: <Widget>[
//
//            EssItems(FontAwesomeIcons.calculator, "Settlement","setelment") ,
//            EssItems(FontAwesomeIcons.moneyBill, " Pay Fixation ","payfix"),
//            EssItems(FontAwesomeIcons.stackExchange, " FOT & NDA ","fot_nda"),
//            EssItems(FontAwesomeIcons.calendarAlt, " Leave Encashment ","leave_encashment"),
//            EssItems(FontAwesomeIcons.carAlt, " Advance Car_PC_Scooter ","car_pc_scooter"),
//            EssItems(FontAwesomeIcons.getPocket, " IT-Forecast ","budget"),
//
//
//
//
//          ],
//
//        ),
//      ),
    );
  }
}
