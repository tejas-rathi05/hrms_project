import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/model/downloadModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/presenter/downloadapar_presenter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';

class DownloadApar extends StatefulWidget {
  @override
  _DownloadAparState createState() => _DownloadAparState();
}

class _DownloadAparState extends State<DownloadApar>
    implements DownloadAparContract {
  late String selectedCategory;
  bool _hasBeenPressed = false;
  late Directory directory;
  late String path, hrmsId;
  late List dataFinYear;

  sharedpreferencemanager pref = sharedpreferencemanager();

  late DownloadAparPresenter _presenter;

  @override
  void initState() {
    _presenter = new DownloadAparPresenter(this);
    getId();
    /*myObject = {"description": "2020-2021", "code": "2020-2021"};*/
    getAparYear();

    super.initState();
  }

  void dispose() {
    // dataFinYear.clear();
  }

  Future<void> getId() async {
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
    //path = await getExternalStorageDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    hrmsId = (await pref.getEmployeeHrmsid())!;
  }

  Future getAparYear() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("get_apar_year");
    print("apar year--> $url");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"hrmsId": await pref.getEmployeeHrmsid()};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON--> $responseJSON');
    setState(() {
      var aparFinYearList = responseJSON["result"] as List;
      print('dataFinYear $aparFinYearList');
      dataFinYear = aparFinYearList;
    });
  }

  Future _write(String textmy, String hrmsId, String selectedCategory) async {
    directory = await Directory('$path/HRMS').create(recursive: true);
    final File file =
        File('${directory.path}/AparRecord_${selectedCategory}_${hrmsId}.pdf');
    var base64str = base64.decode(textmy);

    await file.writeAsBytes(base64str);
    await OpenFilex.open('$path/HRMS/AparRecord_${selectedCategory}_${hrmsId}.pdf');
    Fluttertoast.showToast(
        msg: "Downloaded Successfully:" +
            directory.path +
            '/AparRecord_${selectedCategory}_${hrmsId}.pdf',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 15,
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
        title: Text("Apar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          children: [
            Visibility(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "DOWNLOAD YOUR APAR",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 25),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
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
                              "-- Please Select Apar Year --",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 17),
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
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () {
                          if (selectedCategory == null) {
                            Fluttertoast.showToast(
                                msg: "Please Select Apar Year",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: selectedCategory,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //timeInSecForIos: 5,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            bool fileExist = File(
                                    '$path/HRMS/AparRecord_${selectedCategory}_${hrmsId}.pdf')
                                .existsSync();

                            if (fileExist) {
                              OpenFilex.open(
                                  '$path/HRMS/AparRecord_${selectedCategory}_${hrmsId}.pdf');
                            } else {
                              _presenter.downloadApar(hrmsId, selectedCategory);
                            }
                          }
                        },
                        //width: 150,
                        child: Text(
                          'Download',
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
                )
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
  void onDownloadSuccess(
      DownloadAparModel downloadAparModel, String selectedCategory) {
    // TODO: implement onDownloadSuccess
    print(downloadAparModel.status);
    if (downloadAparModel.status == "true") {
      _write(downloadAparModel.fileString, hrmsId, selectedCategory);
    } else {
      Fluttertoast.showToast(
          msg: downloadAparModel.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 8,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
