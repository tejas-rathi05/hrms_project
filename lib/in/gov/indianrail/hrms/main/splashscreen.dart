import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/introductionpage.dart';
import '../login/fingerprint.dart';
import '../login/loginscreen.dart';
import '../util/pinvery.dart';
import '../local_shared_pref/sharedpreferencemanager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    var keyIn = await pref.isKeyIn();
    var keyPrint = await pref.isfingerPrint();
    var username = await pref.getEmployeeName();
    if (keyPrint == true) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Fingerprintmain(username!)),
      );
    } else if (keyIn == true) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Pinverify()),
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      getdetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    image: AssetImage('assets/images/rail.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              color: Color.fromRGBO(255, 255, 255, 0.19),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 2.5, 35.0, 0, 5.0),
              height: 60.0,
              width: 60.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  image: new AssetImage(
                    'assets/images/railway.png',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 100.0, 0, 5.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Indian Railways",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 2.5, 0, 5.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Human Resource Management System",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 2.2, 0, 5.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Employee's Mobile Application",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                height: 100,
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 1.3, 0, 5.0),
                width: MediaQuery.of(context).size.width,
                child: new Image.asset(
                  "assets/images/cris_logo_primary.png",
                )),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 1.15, 0, 5.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Centre for Railway Information Systems",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 1.1, 0, 5.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                  " (An Organisation of the Ministry of Railways, Govt. of India)",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
