import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/Grivance/ComplaintStatus.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/BuildConfig.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/loginscreen.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/helpvideolink.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'package:share_plus/share_plus.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'aboutus.dart';
import 'changepassword.dart';
import 'contactus.dart';

class Drawer_menu extends StatefulWidget {
  var phoneNo, profilename, hrmsId;
  bool serviceStatusFlag;

  Drawer_menu(
      this.phoneNo, this.profilename, this.hrmsId, this.serviceStatusFlag);

  @override
  Drawer_menuState createState() => Drawer_menuState();
}

class Drawer_menuState extends State<Drawer_menu> {
  final String rate_url = "https://play.google.com/store/apps/details?id=" +
      BuildConfig.APPLICATION_ID;
  late String username, phoneno;
  sharedpreferencemanager pref = sharedpreferencemanager();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        color: Colors.white,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          new DrawerHeader(
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    /*Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Image(
                            image: AssetImage("assets/images/user.png"),
                            height: 80.0,
                            width: 80.0,
                            color: Colors.white,
                          ),
                        )
                    ),*/
                    SizedBox(
                      height: 65,
                    ),
                    Container(
                      child: Text(
                        widget.profilename,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 8, 0, 5),
                    ),
                    Container(
                      child: Text(
                        '+91-' + widget.phoneNo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    ),
                  ]),
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            padding: EdgeInsets.fromLTRB(10, 15, 0, 5),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text("Contact Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Contact_us()));
            },
            leading: Icon(
              Icons.phone,
              color: Colors.blue,
            ),
          ),
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
          /*ListTile(
            title: Text("Rate Us"),
            onTap: () {
              launch(rate_url);
            },
            leading: Icon(
              Icons.star,
              color: Colors.blue,
            ),
          ),*/
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
          ListTile(
              title: Text("Share Us"),
              onTap: () {
                Share.share(
                    'HRMS Mobile Application v${BuildConfig.VERSION_NAME}  '
                    'Click https://play.google.com/store/apps/details?id=${BuildConfig.APPLICATION_ID} to download the HRMS Mobile Application.');
              },
              leading: Icon(
                Icons.share,
                color: Colors.blue,
              )),
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
          ListTile(
            title: Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About_us()));
            },
            leading: Icon(
              Icons.people,
              color: Colors.blue,
            ),
          ),
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
          ListTile(
            title: Text("Change Password"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangePassword(widget.hrmsId, widget.profilename)));
            },
            leading: Icon(
              Icons.build,
              color: Colors.blue,
            ),
          ),
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
          Visibility(
            visible: false,
            child: ListTile(
              title: Text("My Grievance"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ComplaintStatus()));
              },
              leading: Icon(
                Icons.error,
                color: Colors.blue,
              ),
            ),
          ),
          /*ListTile(
            title: Text("Help Videos"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HelpVideoLink()));
            },
            leading: Icon(
              Icons.play_circle_fill,
              color: Colors.blue,
            ),
          ),*/
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.blue,
            ),
            onTap: () {
              pref.logout();
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route route) => false,
              );
            },
          ),
          Divider(
            height: 1,
            color: HexColor("#778899"),
          ),
        ]),
      ),
    );
  }
}
