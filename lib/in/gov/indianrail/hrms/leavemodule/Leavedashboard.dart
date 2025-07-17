import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/lefticonOption_btn.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/righticonOption_btn.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/leavemodule/pastsanctionedleave.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/leavemodule/qrScannerScreen.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/session_check.dart';

import '../util/logic.dart';
import 'applyLeave.dart';
import 'leavebalance.dart';
import 'liteApplyLeave.dart';
import 'myLeaveApplicationFilter.dart';

class Leavedashboard extends StatefulWidget {
  String hrmsId;

  Leavedashboard(this.hrmsId);

  @override
  LeaveManagementState createState() => LeaveManagementState();
}

class LeaveManagementState extends State<Leavedashboard> {

  Material LeaveItems(IconData icon, String heading, String Screen) {
    return Material(
      color: Colors.grey[200],
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (Screen == "Passapstatus") {
            } else if (Screen == "SMS") {}
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 50.0,
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          //  child:  FaIcon(icon,color: Colors.blue,),
                          child: Icon(
                            icon,
                            color: Colors.blue,
                          )),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: Text(
                              heading,
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              softWrap: false,
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Leave",
            style: TextStyle(
              fontFamily: 'Roboto', // or remove this line to use default
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            )),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaveBalance()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDB3E79),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Icon(
                          Icons.leaderboard,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      Center(
                        child: Text(
                          'My Leave Balances',
                            style: TextStyle(
                              fontFamily: 'Roboto', // or remove this line to use default
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LiteApplyLeave()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF0065C4),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Icon(
                          Icons.directions_walk,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      Center(
                        child: Text(
                          'New Leave Application',
                          style: TextStyle(
                            fontFamily: 'Roboto', // or remove this line to use default
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PastSanctionedLeaveDetails()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1A8F64),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Center(
                          child: Icon(
                            Icons.history,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'View Past Sanctioned Leave Details',
                          style: TextStyle(
                            fontFamily: 'Roboto', // or remove this line to use default
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLeaveApplicationSearchByYear()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0XFFB77729),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      Center(
                        child: Text(
                          'My Leave Applications',
                          style: TextStyle(
                            fontFamily: 'Roboto', // or remove this line to use default
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /*Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TreeView1()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF0065C4),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Icon(
                          Icons.directions_walk,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      Center(
                        child: Text(
                          'New Leave Application',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

}

