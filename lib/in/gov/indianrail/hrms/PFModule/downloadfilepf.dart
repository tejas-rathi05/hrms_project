import 'dart:convert';
import 'dart:io';

/// Flutter code sample for Scaffold

// This example shows a [Scaffold] with a [body] and [FloatingActionButton].
// The [body] is a [Text] placed in a [Center] in order to center the text
// within the [Scaffold]. The [FloatingActionButton] is connected to a
// callback that increments a counter.
//
// ![The Scaffold has a white background with a blue AppBar at the top. A blue FloatingActionButton is positioned at the bottom right corner of the Scaffold.](https://flutter.github.io/assets-for-api-docs/assets/material/scaffold.png)

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:open_filex/open_filex.dart';

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;
  late Directory directory;
  String hrmsId = "DOOHYS";
  String path = "";
  final String url = new UtilsFromHelper().getValueFromKey("file_download");

  Future downloadPdf() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    var hrmsId = await pref.getEmployeeHrmsid();
    Fluttertoast.showToast(
        msg: "Processing, please wait…!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 8,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);

    Map map = {'folder': "Service_Record", 'file': hrmsId, 'ext': "pdf"};

    final String url = new UtilsFromHelper().getValueFromKey("file_download");
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    String msgtext = responseJSON['message'];
    String filepdf = responseJSON['fileString'];

    Fluttertoast.showToast(
        msg: msgtext,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
    _write(filepdf, hrmsId!);
  }

  Future _write(String textmy, String hrmsId) async {
    directory = await Directory('$path/HRMS').create(recursive: true);
    final File file = File('${directory.path}/E-ServiceRecord${hrmsId}.pdf');
    var base64str = base64.decode(textmy);

    await file.writeAsBytes(base64str);
    await OpenFilex.open('$path/HRMS/E-ServiceRecord${hrmsId}.pdf');
    Fluttertoast.showToast(
        msg: "Downloaded Successfully:" +
            directory.path +
            '/E-ServiceRecord${hrmsId}.pdf',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //  timeInSecForIos: 15,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(child: Text('You have pressed the button $_count times.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool fileexist =
              File('$path/HRMS/E-ServiceRecord${hrmsId}.pdf').existsSync();

          if (fileexist) {
            OpenFilex.open('$path/HRMS/E-ServiceRecord${hrmsId}.pdf');
          } else {
            downloadPdf();
          }
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
