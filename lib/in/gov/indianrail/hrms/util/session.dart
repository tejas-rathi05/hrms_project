import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/fingerprint.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/loginscreen.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/pinvery.dart';

late Timer timer;
@override
void startTimer(BuildContext context) {
  timer = Timer(Duration(seconds: 5), () {
    timedOut(context);
  });
  /*timer = Timer.periodic(const Duration(seconds: 10), (_) {
      timedOut();
    });*/
}

@override
Future<void> timedOut(BuildContext context) async {
  print('Hello');
  timer.cancel();
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text("Alert"),
      content: Text("You have been logged out due to inactivity..."),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            getLoginDetails(context);
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
  print('hello1');
}

Future getLoginDetails(BuildContext context) async {
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
