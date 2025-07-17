import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/Grivance/ComplaintStatus.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


bool dialog_flag = false;

class LoangeGrivance extends StatefulWidget {
  @override
  LoangeGrivance_State createState() => LoangeGrivance_State();
}

class LoangeGrivance_State extends State<LoangeGrivance> {
  bool _selected = false;
  late String result;

  TextEditingController controller_deatils = TextEditingController();

  var file_path;
  var emp_type;
  var files;
  var fileUploaded = "";
  var profilename = "",
      designation = "",
      railwayunit = "",
      department = "",
      billunit = "",
      railwayzone = "",
      hrmsId = "",
      mobileno = "",
      ipasempid = "",
      railwayunitcode = "",
      stationCode = "",
      designationcode = "",
      departmentCode = "";
  late List data;
  late List data_subcategory;
  bool dala_flag = false;

  late String selectsubCategory;

  late String selectedCategory;

  Future getdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("user_details");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsId": await pref.getUsername(),
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON['status'] == "1") {
      setState(() {
        profilename = responseJSON['userProfile']['profile']['employeeName'];
        designation =
            responseJSON['userProfile']['profile']['designationDescription'];
        railwayunit = responseJSON['userProfile']['profile']['railwayUnitName'];

        designationcode = responseJSON['userProfile']['profile']
                ['designationcode']
            .toString();
        departmentCode =
            responseJSON['userProfile']['profile']['departmentCode'].toString();
        department =
            responseJSON['userProfile']['profile']['departmentDescription'];
        mobileno = responseJSON['userProfile']['profile']['mobileNo'];
        billunit = responseJSON['userProfile']['profile']['billUnit'];
        ipasempid = responseJSON['userProfile']['profile']['ipasEmployeeId'];
        hrmsId = responseJSON['userProfile']['profile']['hrmsEmployeeId'];
        railwayzone = responseJSON['userProfile']['profile']['railwayZone'];
        stationCode = responseJSON['userProfile']['profile']['stationcode'];
      });
      getEmp_type();
    }
  }

  Future get_complaintList() async {
    data.clear();
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper()
        .getValueFromKey("get_grievance_category_complaint");
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {"test": "1"};

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;

    setState(() {
      var Complaintdetails = responseJSON["jsonResult"]["headerdata"] as List;

      data = Complaintdetails;
    });
  }

  Future get_sub_complaintList(String complaintId) async {
    int id = int.parse(complaintId);
    data_subcategory.clear();

    final String url = new UtilsFromHelper()
        .getValueFromKey("get_grievance_sub_category_complaint");
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "complaint_type": id,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null && responseJSON != "") {
      setState(() {
        var sub_category_complaint = responseJSON["headerdata"] as List;

        data_subcategory = sub_category_complaint;
      });
    }
  }

  Future getEmp_type() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("find_employee_type");
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    var designation_code = int.parse(designationcode);
    Map map = {
      "designation_code": designation_code,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON["result"] != null && responseJSON["result"] != "") {
      emp_type = responseJSON["result"];
    }
  }

  Future save() async {
    DateTime now = new DateTime.now();
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("save_complaint_data");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;

    Map map = {
      "hrms_employee_id": hrmsId,
      "emp_type": emp_type,
      "ipas_id": ipasempid,
      "unit_code": railwayunitcode,
      "department": departmentCode,
      "standard_designation_code": designationcode,
      "designation": designation,
      "billunit": billunit,
      "mobileno": mobileno,
      "complaint_type": selectedCategory,
      "complaint_sub_type": selectsubCategory,
      "complaint_detail": controller_deatils.text,
      "complaint_file": fileUploaded,
      "date_created": now.toString(),
      "created_by": hrmsId,
      "received_from": "M",
      "stationcode": stationCode
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON["result"]) {
      var complaintid = responseJSON["complaintid"];
      Fluttertoast.showToast(
          msg:
              'Your Grievance Saved Successfully And Complaint Id is $complaintid',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ComplaintStatus()));
    } else {
      Fluttertoast.showToast(
          msg: 'Please Try Later!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  /*void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
        );
  }*/

  Future<List<File>> getFiles() async {
    List<File> fileList = [];

    Directory? externalStorageDir = await getExternalStorageDirectory();
    if (externalStorageDir != null) {
      Directory directory = Directory(externalStorageDir.path);
      List<FileSystemEntity> files = directory.listSync();

      for (FileSystemEntity file in files) {
        if (file is File) {
          fileList.add(file);
        }
      }
    }

    return fileList;
  }

  Future uploadFile() async {
    EasyLoading.show(status: 'Please wait...');
    dialog_flag = true;

    final bytes = Io.File(file_path).readAsBytesSync();

    String img64 = base64Encode(bytes);

    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("upload_file");
    basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsEmployeeId': hrmsId,
      "module": "Grievance",
      "subModule": "Grievance",
      "documentType": "GDU",
      "documentKey": "Grievance",
      "file": img64,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.headers.set('authorization', basicAuth);

    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    //  print(responseJSON);
    if (responseJSON["status"]) {
      setState(() {
        fileUploaded = responseJSON["file_path"];
      });
    }
    Fluttertoast.showToast(
        msg: responseJSON['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);
    setState(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    getFiles();
    getdetails();

    get_complaintList();

    super.initState();
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 380.0, // Change as per your requirement
      width: 430.0, // Change as per your requirement
      child: ListView.builder(
        //if file/folder list is grabbed, then show here
        itemCount: files?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(
              files[index].path.split('/').last,
              style: TextStyle(fontSize: 10),
            ),
            onTap: () {
              setState(() {
                file_path = files[index].path;
                final f = File(file_path);

                int sizeInBytes = f.lengthSync();
                double sizeInMb = sizeInBytes / (1024 * 1024);

                if (sizeInMb > 2) {
                  file_path = null;
                  Fluttertoast.showToast(
                      msg:
                          "File size greater than 2MB.Please select another file.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.pinkAccent,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {}
              });
              Navigator.pop(context);
            },
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data == null || data.length == 0) {
      dala_flag = false;
    } else {
      dala_flag = true;
    }
        return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Lodge Grievance",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white54,
              border: Border.all(width: 1, color: Colors.white)),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
          child: Column(children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text(
              profilename,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.red,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        'HRMS ID :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(hrmsId ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: Text(
                        'DESIGNATION :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(designation ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 11)),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        'DEPARTMENT :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(department ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Divider(color: Colors.grey),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        'BILLUNIT :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(billunit ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        'RAILWAY UNIT :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(railwayunit ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        'RAILWAY ZONE :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(railwayzone ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),

            Divider(color: Colors.grey),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 14,
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        'STATION CODE :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      )),
                ),
                Expanded(
                  child: Text(stationCode ?? "Not Available",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Grievance Category"),
            ),
            //  data==null ? : Container(),
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              hint: Text("Please select grievance category"),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = "";
                  selectsubCategory;
                  selectedCategory = newValue!;
                  if (newValue != "" && newValue != null) {
                    get_sub_complaintList(newValue);
                  }
                });
              },
              items: data?.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["complaint_type"].toString(),
                      child: Text(item["complaint_name"]),
                    );
                  })?.toList() ??
                  [],
            ),

            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Grievance Sub Category"),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text("Please grievance sub category"),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (listValue) {
                setState(() {
                  _selected = true;
                  selectsubCategory = listValue!;
                });
              },
              items: data_subcategory?.map((list_item) {
                    return DropdownMenuItem<String>(
                      value: list_item["complaint_sub_type"].toString(),
                      child: Text(list_item["complaint_sub_name"]),
                    );
                  })?.toList() ??
                  [],
              value: _selected ? selectsubCategory : null,
              isDense: true,
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Grievance Details"),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              maxLines: 10,
              enabled: true,
              style: TextStyle(fontSize: 13),
              maxLength: 500,
              controller: controller_deatils,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF2F2F2),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Supporting Proof Document"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.lightBlueAccent)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),

                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.lightBlueAccent)),
                                //             <--- BoxDecoration here
                                child: GestureDetector(
                                    onTap: () async {
                                      Fluttertoast.showToast(
                                          msg: 'Please Wait...',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                      EasyLoading.show(status: 'Please wait...');
                                      /*result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileList(files)),
                                      );*/
                                      result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileList()),
                                      );
                                      if (this.mounted) {
                                        // check whether the state object is in tree
                                        setState(() {
                                          file_path = result;
                                          EasyLoading.dismiss();
                                        });
                                      }
                                    },
                                    //  onTap: () {
                                    //
                                    //   setState(() {
                                    //
                                    //     showDialog(
                                    //         context: context,
                                    //         builder: (BuildContext context) {
                                    //           return AlertDialog(
                                    //             title: Text('Select file'),
                                    //             content: setupAlertDialoadContainer(),
                                    //           );
                                    //         });
                                    //
                                    //   });
                                    //
                                    // },
                                    child: Text(
                                      "Choose File",
                                      style: TextStyle(fontSize: 10.0),
                                    )),
                                // child: Text(
                                //   "Choose File",
                                //   style: TextStyle(fontSize: 10.0),
                                // ),
                              ),
                              Expanded(
                                child: Text(
                                  file_path ?? "No file chosen",
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 40,
                                  color: Colors.lightBlueAccent,
                                  child: TextButton(
                                    onPressed: () {
                                      uploadFile();
                                    },
                                    child: Text("Upload",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FilledButton(
                    //width: 140,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFF40C4FF)),
                    onPressed: () {
                      if (selectedCategory == null || selectedCategory == "") {
                        Fluttertoast.showToast(
                            msg: 'Please Select Grievance Category',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else if (selectsubCategory == null ||
                          selectsubCategory == "") {
                        Fluttertoast.showToast(
                            msg: 'Please Select Sub Grievance Category',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else if (controller_deatils.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Enter Grievance Details',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      } else {
                        save();
                      }
                    }),
                FilledButton(
                    //width: 140,
                    child: Text(
                      'My Grievance',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFF40C4FF)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComplaintStatus()));
                    }),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
