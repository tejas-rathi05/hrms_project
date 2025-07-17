import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/Grivance/Complaint_page.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/essMobile/communication_tab.dart';
//import 'package:hrms_cris/in/gov/indianrail/hrms/home/hrmsurl.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/hrModule/hrCalculation.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/cancelPass.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/pdftabview.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

class LeftIconButton extends StatefulWidget {
  Icon icon;
  var title;
  var url;
  var userId;
  LeftIconButton(this.icon, this.title, this.userId, this.url);
  @override
  LeftIconBtState createState() => LeftIconBtState();
}

class LeftIconBtState extends State<LeftIconButton> {
  String geturl =
      new UtilsFromHelper().getValueFromKey("view_update_family_ess");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.fromLTRB(30.0, 12, 30, 10),
            child: TextButton(
              onPressed: () {
                var url_id = widget.url;
                //  print(url_id);
                if (url_id == "HR") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HRdashboard()),
                  );
                } else if (url_id == "grivance") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoangeGrivance()),
                  );
                } else if (url_id == "PDF") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PdfTabBarDemo()),
                  );
                } else if (url_id == "communication-details") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunicationTab()),
                  );
                } else if (url_id == "HTML") {
                } else if (url_id == "passcancle") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CancelPass()),
                  );
                } else {
                  //var userID = widget.userId;
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(width: 1, color: HexColor("#ffffff")),
                        ),
                        height: 35,
                        width: 90,
                        child: widget.icon),
                    Text(
                      widget.title,
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
    );
  }
}
