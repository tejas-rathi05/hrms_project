import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/Grivance/Complaint_page.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/PFModule/my_pfloan.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/PFModule/savepf.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/apar/ui/downloadApar.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/essMobile/basictab.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/essMobile/communication_tab.dart';
//import 'package:hrms_cris/in/gov/indianrail/hrms/home/hrmsurl.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/hrModule/hrCalculation.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedpass/passsetlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/pdftabview.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import '../leavemodule/leavebalance.dart';

class RightIconBtn extends StatefulWidget {
  Icon icon;
  var title;
  var url;
  var userId;

  RightIconBtn(this.icon, this.title, this.userId, this.url);

  @override
  RightIconBtnState createState() => RightIconBtnState();
}

class RightIconBtnState extends State<RightIconBtn> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 55,
            margin: EdgeInsets.fromLTRB(30.0, 12, 30, 11),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                var url_id = widget.url;
                if (url_id == "PDF") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PdfTabBarDemo()),
                  );
                } else if (url_id == "basic-details") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasicTab()),
                  );
                } else if (url_id == "communication-details") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunicationTab()),
                  );
                } else if (url_id == "HR") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HRdashboard()),
                  );
                } else if (url_id == "passset") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PassSetList()),
                  );
                } else if (url_id == "edit_delete") {
                } else if (url_id == "savepf") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPfloanList()),
                  );
                } else if (url_id == "grivance") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoangeGrivance()),
                  );
                } else if (url_id == "apar") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadApar()),
                  );
                } else if (url_id == "leavebalance") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaveBalance()),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(width: 1, color: HexColor("#ffffff")),
                        ),
                        height: 35,
                        width: 90,
                        child: widget.icon
                        // Icon(
                        //
                        //  // Icons.group_work,
                        //   color: Colors.lightBlueAccent,
                        // )
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
