import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/lefticonOption_btn.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/UI/righticonOption_btn.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/pass/passApplication_newUI.dart';

import 'issuedpasslist_newUI.dart';

class Passdashboard extends StatefulWidget {
  String hrmsId;

  Passdashboard(this.hrmsId);

  @override
  PassState createState() => PassState();
}

class PassState extends State<Passdashboard> {
  Material PassItems(IconData icon, String heading, String Screen) {
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
        title: Text("e-Pass",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.all(30.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PassApplicationStatus_New()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Application Status',
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
                                Icons.chrome_reader_mode,
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
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IssuedPassL()),
                      );
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
                              border: Border.all(
                                  width: 1, color: HexColor("#ffffff")),
                            ),
                            height: 35,
                            width: 90,
                            child: Icon(
                              Icons.sms,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          Text(
                            'Issued Passes',
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
          SizedBox(
            height: 15,
          ),
          RightIconBtn(
            Icon(
              FontAwesomeIcons.book,
              color: Colors.lightBlueAccent,
            ),
            'Apply Pass',
            "",
            "passset",
          ),
          SizedBox(
            height: 15,
          ),
          LeftIconButton(
            Icon(
              FontAwesomeIcons.windowClose,
              color: Colors.lightBlueAccent,
            ),
            'Cancel Pass',
            "",
            "passcancle",
          ),
          // SizedBox(height: 15,),
          //             RightIconBtn(Icon(
          //               FontAwesomeIcons.book,
          //               color: Colors.lightBlueAccent,
          //             ),
          //               'Edit/Delete Pass', "","edit_delete",
          //             ),
        ]),
      ),
    );
  }
}
