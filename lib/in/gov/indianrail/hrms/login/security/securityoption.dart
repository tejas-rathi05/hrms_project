import 'dart:io';
import 'package:flutter/material.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/home/new_homepage.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';

import '../../config/ColorSet.dart';
import '../fingerprint.dart';
import '../generatepin.dart';

class SecurityOption extends StatelessWidget {
  var userName = "", hrmsid = "", userMobile = "";
  sharedpreferencemanager pref = sharedpreferencemanager();

  SecurityOption(this.userName, this.hrmsid, this.userMobile);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold);
    final fingerButton = ElevatedButton.icon(
        label: Text(
          'Use Biometric',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        style: FilledButton.styleFrom(backgroundColor: Color(0xFF345AAD)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Fingerprintmain(userName)),
          );
        }, icon:  Icon(Icons.fingerprint_sharp),);
    final pinButton = ElevatedButton.icon(
        label: Text(
          'Generate PIN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        style: FilledButton.styleFrom(backgroundColor: Color(0xFF007C80)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GenerateOtp(userName)));
        }, icon: Icon(Icons.dialpad),);
    final skipButton = ElevatedButton.icon(
        label: Text(
          'Skip',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        style: FilledButton.styleFrom(backgroundColor: Color(0xFFFF383F)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeProfile(userName)),
          );
        }, icon: Icon(Icons.skip_next),);

    final fingerprintOption = ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Fingerprintmain(userName)),
            );
          },
          label: Text(
            "Use Finger",
            textAlign: TextAlign.left,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ), icon: Icon(Icons.fingerprint_sharp),
        );
    final pinOption = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GenerateOtp(userName)),
          );
        },
        child: Text("Generate PIN",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white, fontSize: 15)),
      ),
    );
    final skipOption = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeProfile(userName)),
          );
        },
        child: Text("Skip",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white, fontSize: 15)),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => exit(0),
          ),
          title: Text("Finger Print/PIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
              image: ExactAssetImage('assets/images/rail.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height:350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.bottomRight,
                      begin: Alignment.topLeft,
                      colors: [
                        Color(0xffF6E1D3).withOpacity(0.8),
                        Color(0xff1E8FD5).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: HexColor("#1976D2")),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 45.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        child: fingerButton,
                      ),
                      Container(
                        height: 45.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        child: pinButton,
                      ),
                      Container(
                        height: 45.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        child: skipButton,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ));
  }
}
