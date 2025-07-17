import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/model/downloadModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/presenter/downloadapar_presenter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DownloadApar extends StatefulWidget {
  @override
  _DownloadAparState createState() => _DownloadAparState();
}

class _DownloadAparState extends State<DownloadApar>
    implements DownloadAparContract {
  late String selectedCategory;
  bool _hasBeenPressed = false;
  late Directory directory;
  late String path = "", hrmsId;
  late List dataFinYear;
  sharedpreferencemanager pref = sharedpreferencemanager();
  late Map<String, dynamic> myObject;

  late DownloadAparPresenter _presenter;

  @override
  void initState() {
    _presenter = new DownloadAparPresenter(this);
    getId();
    myObject = {"description": "2020-2021", "code": "2020-2021"};

    dataFinYear.add(myObject);

    super.initState();
  }

  void dispose() {
    // dataFinYear.clear();
  }
  void getId() async {
    //path = await ExtStorage.getExternalStoragePublicDirectory(
    //    ExtStorage.DIRECTORY_DOWNLOADS);
    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    List<Directory>? externalStorageDirectories =
        await getExternalStorageDirectories();

    if (externalStorageDirectory != null) {
      print('External Storage Directory: ${externalStorageDirectory.path}');
    }

    if (externalStorageDirectories != null) {
      print('External Storage Directories:');
      for (Directory directory in externalStorageDirectories) {
        print(directory.path);
        path = directory.path;
      }
    }

    hrmsId = (await pref.getEmployeeHrmsid())!;

    setState(() {});
  }

  Future _write(String textmy, String hrmsId) async {
    directory = await Directory('$path/HRMS').create(recursive: true);
    final File file = File('${directory.path}/AparRecord${hrmsId}.pdf');
    var base64str = base64.decode(textmy);

    await file.writeAsBytes(base64str);
    OpenFilex.open('$path/HRMS/Apar${hrmsId}.pdf');
    Fluttertoast.showToast(
        msg: "Downloaded Successfully:" +
            directory.path +
            '/AparRecord${hrmsId}.pdf',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 15,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    String formatter = DateFormat('y').format(now);
    int yearprev = int.parse(formatter) - 1;
    print(formatter + " " + yearprev.toString());

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Download Apar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          children: [
            Visibility(
                child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "APAR FIN YEAR",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCategory,
                        items: dataFinYear.map((item) {
                          var code;
                          var des;

                          return DropdownMenuItem<String>(
                            value: item["code"].toString(),
                            child: Text(item["description"].toString()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        hint: Container(
                          //and here
                          child: Text(
                            "-- Please Select --",
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.black, decorationColor: Colors.red),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FilledButton(
                      onPressed: () {
                        if (selectedCategory == null) {
                          Fluttertoast.showToast(
                              msg: "Please select type of pass",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              //  timeInSecForIos: 5,
                              backgroundColor: Colors.pink,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        } else {
                          _presenter.downloadApar(hrmsId, selectedCategory);
                        }
                      },
                      //width: 70,
                      child: Text(
                        'Go',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: _hasBeenPressed
                              ? Colors.black38
                              : Colors.lightBlueAccent),
                    ),
                  ],
                ),
              ],
            )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onDownloadError(String error) {
    // TODO: implement onDownloadError
    print(error);
  }

  @override
  void onDownloadSuccess(DownloadAparModel downloadAparModel, String FYyear) {
    // TODO: implement onDownloadSuccess
    print(downloadAparModel.status);
    if (downloadAparModel.status == "true") {
      _write(downloadAparModel.fileString, hrmsId);
    } else {
      Fluttertoast.showToast(
          msg: downloadAparModel.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 8,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
