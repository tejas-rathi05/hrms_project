import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/pinvery.dart';

import '../local_shared_pref/sharedpreferencemanager.dart';
import '../login/fingerprint.dart';
import '../login/loginscreen.dart';

Timer? _timer;
class SessionCheck {
  void startTimer(BuildContext context) {
    print('_startTimer');
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 300), () {
      _timer?.cancel();
      _timer = null;
      sessionAlertify(context, "Your Session is expired. Please login again");
    });
  }

  /*void handleInteraction(BuildContext context) {
    startTimer(context);
  }*/

  Future<void> sessionAlertify(BuildContext context, String message) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    String? pin = await pref.getuserpin() ?? "";
    var keyPrint = await pref.isfingerPrint();
    var username = await pref.getEmployeeName();
    print('get User Pin $pin');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (keyPrint == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fingerprintmain(username!)),
                          (_) => false);
                } else if (pin.isNotEmpty) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Pinverify()),
                          (_) => false);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (_) => false);
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
