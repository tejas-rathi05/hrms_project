import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/UI/righticonOption_btn.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/CustomShapeClipper.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/hrModule/essdashboard.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/pass/passdashboard.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../PFModule/my_pfloan.dart';
import '../connectivityfile.dart';
import '../leavemodule/Leavedashboard.dart';
import '../leavemodule/qrScannerScreen.dart';
import 'drawermenu.dart';
import 'new_profile.dart';

var designation = "",
    railwayunit = "",
    dob = "",
    department = "",
    mobileno = "",
    billunit = "",
    ipasempid = "",
    hrmsid = "",
    railwayzone = "",
    profilename = "";

class HomeProfile extends StatefulWidget {
  var username;

  HomeProfile(this.username);

  @override
  HomeProfile11 createState() => HomeProfile11();
}

class HomeProfile11 extends State<HomeProfile> {
 // String? checkConnectivity;
  String connectivity_check="";
  late String hrmsId = "", path = "", hrmsidUrl;

  Uint8List? _bytesImage;

  var check_offier;
  var finYear;
  var profilename = "User Name", phoneNo = "";
  bool npsflag = false;
  bool serviceStatusFlag = true;
  late Directory directory;
  final String url = new UtilsFromHelper().getValueFromKey("file_download");
  sharedpreferencemanager pref = sharedpreferencemanager();
 // Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  Future getNpsDetails() async {
    String? nps = await pref.get_nps_flag();
    String? serviceStatus = await pref.getServiceStatus();
    //print(nps);
    if (nps == "Y") {
      setState(() {
        npsflag = false;
      });
    } else {
      setState(() {
        npsflag = true;
      });

      if (serviceStatus == "RT") {
        setState(() {
          serviceStatusFlag = false;
        });
      } else {
        setState(() {
          serviceStatusFlag = true;
        });
      }
    }
  }

  void initState() {
    getId();
    getNpsDetails();
    downloadPhoto();
    super.initState();
   // _connectivity.initialise();
    /*_connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });*/
    _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results.first); // get first available connection
    });

  }
  Future<void> _checkInitialConnectivity() async {
    var results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results.first);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      if (result == ConnectivityResult.mobile) {
        connectivity_check = "Online";
      } else if (result == ConnectivityResult.wifi) {
        connectivity_check = "Online";
      } else {
        connectivity_check = "Offline";
      }
    });
    print('sourceConn: $connectivity_check'); // Print the current connection status
  }
  Future downloadPhoto() async {
    print('download Photo Back');
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("file_download");

    String? hrmsId = await pref.getEmployeeHrmsid();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);

    Map map = {
      'folder': "profilephoto",
      'file': hrmsId,
      'ext': "jpg",
    };

    String basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;
    print('responseJSONImage $responseJSON');
    String status = responseJSON['status'];
    String image = responseJSON['fileString'];
    if(status=="true"){
      // Decode the Base64 string to a regular string
      setState(() {
        _bytesImage = Base64Decoder().convert(image);
      });
    } else {
      setState(() {
        _bytesImage = null;
      });
    }
  }

  Future moduleCheck(String modulename) async {
    print('moduleCheck');
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("mobile_module_check");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);

    Map map = {
      'moduleName': modulename
    };

    String basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();

    var responseJSON = json.decode(value) as Map;
    print('responseJSONmodulecheck $responseJSON');
    String result = responseJSON['result'];
    if(result=="Y"){
      // show module functionality
      if(modulename=="My Profile") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewProfile()),
        );
      }else if(modulename=="e-SR") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EmployeeSR()),
        );
      }
      else if(modulename=="Pass") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Passdashboard(hrmsId)),
        );
      }else if(modulename=="Leave") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Leavedashboard(hrmsId)),
        );
      }
    } else {
      setState(() {
        alertify(context, modulename+" is currently unavailable.");
      });
    }
  }

  void alertify(BuildContext context, String message) {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future getlogindetails() async {
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
      String ServiceStatus = "";
      if (responseJSON['userProfile']['profile']['servicestatus'] == "CR" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "DS" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "MI" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "RT" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "RE" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "TR" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "VR" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "VM" ||
          responseJSON['userProfile']['profile']['servicestatus'] == "CO") {
        ServiceStatus = "RT";
      } else {
        ServiceStatus = responseJSON['userProfile']['profile']['servicestatus'];
      }
      try {
        sharedpreferencemanager pref = sharedpreferencemanager();
        String paylevel="";
        if(responseJSON['userProfile']['profile']['subpaylevel']!=null){
          paylevel=responseJSON['userProfile']['profile']['subpaylevel'];
        }
        if(responseJSON['userProfile']['profile']['offpaylevel']!=null){
          paylevel=responseJSON['userProfile']['profile']['offpaylevel'];
        }
        pref.employeeProfile(
            responseJSON['userProfile']['profile']['emailAddress']??'',
            responseJSON['userProfile']['profile']['employeeName']??'',
            responseJSON['userProfile']['profile']['gender']??'',
            responseJSON['userProfile']['profile']['designationDescription']??'',
            responseJSON['userProfile']['profile']['designationCode']??'',
            responseJSON['userProfile']['profile']['autype']??'',
            responseJSON['userProfile']['profile']['railwayUnitName']??'',
            responseJSON['userProfile']['profile']['autype_desc']??'',
            responseJSON['userProfile']['profile']['railwayUnitCode']??'',
            responseJSON['userProfile']['profile']['dateOfBirth']??'',
            responseJSON['userProfile']['profile']['departmentDescription']??'',
            responseJSON['userProfile']['profile']['departmentCode']??'',
            responseJSON['userProfile']['profile']['mobileNo']??'',
            responseJSON['userProfile']['profile']['billunit']??'',
            responseJSON['userProfile']['profile']['userId']??'',
            responseJSON['userProfile']['profile']['ipasEmployeeId']??'',
            responseJSON['userProfile']['profile']['stationCode']??'',
            responseJSON['userProfile']['profile']['AU_NO']??'',
            responseJSON['userProfile']['profile']['lienUnit']??'',
            paylevel??'',
            responseJSON['userProfile']['profile']['hrmsEmployeeId']??'',
            responseJSON['userProfile']['profile']['railwayZone']??'',
            responseJSON['userProfile']['profile']['userType']??'',
            ServiceStatus,
            responseJSON['userProfile']['profile']['prcpWidowFlag']??'',
            responseJSON['userProfile']['profile']['superannuationDate']??'',
            responseJSON['userProfile']['profile']['appointmentDate']??'',
            responseJSON['userProfile']['profile']['railwayGroup']??'');
        setState(() async {
          phoneNo = (await pref.getEmployeeMobileno())!;
        });
      } catch (e) {}
    }
  }

  Future<void> getId() async {
    //path = await ExtStorage.getExternalStoragePublicDirectory(
    //  ExtStorage.DIRECTORY_DOWNLOADS);
    if (Platform.isAndroid) {
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
    } else {
      // for ios
      await getApplicationDocumentsDirectory();
    }
    hrmsId = (await pref.getEmployeeHrmsid())!;
    profilename = (await pref.getEmployeeName())!;
    setState(() {});
    phoneNo = (await pref.getEmployeeMobileno())!;

    // PermissionHandler().requestPermissions([PermissionGroup.storage]);
    finYear = await pref.get_finyear();
    check_offier = await pref.get_checkOfficer();
    //print(check_offier);
  }

  Future downloadPdf() async {
    Fluttertoast.showToast(
        msg: "Processing, please wait…!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);

    Map map = {'folder': "Service_Record", 'file': hrmsId, 'ext': "pdf"};
    print('map $map');
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
    print('response sr $responseJSON');
    if (responseJSON['status'] == 'true') {
      String filepdf = responseJSON['fileString'];
      if (Platform.isAndroid) {
        await _write(filepdf, hrmsId);
        Fluttertoast.showToast(
            msg: "Downloaded Successfully:" +
                directory.path +
                '/E-ServiceRecord${hrmsId}.pdf',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        await _ioswrite(filepdf, hrmsId);
        Fluttertoast.showToast(
            msg: "Downloaded Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Scanned SR is not available',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
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
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  Future _ioswrite(String textmy, String hrmsId) async {
    Directory directory = await getTemporaryDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final File file = File(directory.path + "/E-ServiceRecord${hrmsId}.pdf");
    print("Directory Path : $directory");
    print("Directory file : $file");
    var base64str = base64.decode(textmy);
    print(" $textmy");
    await file.writeAsBytes(base64str);
    var existsSync = file.existsSync();
    print("$existsSync");

    OpenFilex.open(directory.path + "/E-ServiceRecord${hrmsId}.pdf");
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    /*switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        checkConnectivity = "Offline";
        break;
      case ConnectivityResult.mobile:
        checkConnectivity = "Online";
        break;
      case ConnectivityResult.wifi:
        checkConnectivity = "Online";
    }*/
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          drawer:
              Drawer_menu(phoneNo, widget.username, hrmsId, serviceStatusFlag),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Please wait…!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.pink,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  downloadPhoto();
                  getlogindetails();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanner()),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner_outlined, color: Colors.white),
              ),
            ],
            backgroundColor: Colors.lightBlueAccent,
            title: Text("HRMS Application",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: CustomShapeClipper(),
                      child: Container(
                        height: 240.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          margin: EdgeInsets.fromLTRB(0, 140, 0, 0),
                          child: GestureDetector(
                            child: CircleAvatar(
                              child: _bytesImage == null
                                  ? new CircleAvatar(
                                backgroundImage:
                                new AssetImage('assets/images/user1.png'),
                                radius: 100.0,
                              )
                                  : new CircleAvatar(
                                backgroundImage: MemoryImage(_bytesImage!),
                                radius: 100.0,
                              ),
                            ),
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        )
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Text(widget.username,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.red,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            )),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.fromLTRB(30.0, 20, 30, 20),
                                child: TextButton(
                                  onPressed: () async {
                                    moduleCheck("My Profile");
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'My Profile',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 1,
                                                  color: HexColor("#ffffff")),
                                            ),
                                            height: 35,
                                            width: 90,
                                            child: Icon(
                                              FontAwesomeIcons.user,
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
                        Visibility(
                          child: Container(
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
                                      if (connectivity_check == "Online") {
                                        showDialog(
                                          context: context,
                                          builder: (context) => new AlertDialog(
                                            title: new Text('SCANNED SR'),
                                            content: new Text(
                                                'Do you want to Download?'),
                                            actions: <Widget>[
                                              new TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: new Text('Cancel'),
                                              ),
                                              new TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);

                                                  bool fileexist = File(
                                                          '$path/HRMS/E-ServiceRecord${hrmsId}.pdf')
                                                      .existsSync();

                                                  if (fileexist) {
                                                    OpenFilex.open(
                                                        '$path/HRMS/E-ServiceRecord${hrmsId}.pdf');
                                                  } else {
                                                    downloadPdf();
                                                  }
                                                },
                                                child: new Text('Download'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Internet Connection",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.pink,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 1,
                                                  color: HexColor("#ffffff")),
                                            ),
                                            height: 35,
                                            width: 90,
                                            child: Icon(
                                              Icons.scanner,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                          Text(
                                            'Scaned SR',
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
                          visible: serviceStatusFlag,
                        ),
                        Visibility(
                          visible: serviceStatusFlag,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: EdgeInsets.fromLTRB(30.0, 20, 30, 20),
                                  child: TextButton(
                                    onPressed: () {
                                      if (connectivity_check == "Online") {
                                        moduleCheck("e-SR");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Internet Connection",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.pink,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'e-SR',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 1,
                                                    color: HexColor("#ffffff")),
                                              ),
                                              height: 35,
                                              width: 90,
                                              child: Icon(
                                                FontAwesomeIcons.database,
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
                        ),
                        SizedBox(
                          height: 3,
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
                                    if (connectivity_check == "Online") {
                                      moduleCheck("Pass");
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "No Internet Connection",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.pink,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                width: 1,
                                                color: HexColor("#ffffff")),
                                          ),
                                          height: 35,
                                          width: 90,
                                          child: Icon(
                                            FontAwesomeIcons.ticketAlt,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                        Text(
                                          'e-Pass',
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
                          height: 7,
                        ),
                        Visibility(
                          visible: serviceStatusFlag,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: EdgeInsets.fromLTRB(30.0, 10, 30, 5),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (connectivity_check == "Online") {
                                        moduleCheck("Leave");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Internet Connection",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.pink,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Leave',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 1,
                                                    color: HexColor("#ffffff")),
                                              ),
                                              height: 35,
                                              width: 90,
                                              child: Icon(
                                                FontAwesomeIcons.personRunning,
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
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Visibility(
                          //visible: serviceStatusFlag,
                          visible: false,
                          child: Visibility(
                            visible: npsflag,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    margin:
                                        EdgeInsets.fromLTRB(30.0, 10, 30, 5),
                                    child: TextButton(
                                      onPressed: () {
                                        if (connectivity_check == "Online") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyPfloanList()),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "No Internet Connection",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.pink,
                                              textColor: Colors.white,
                                              fontSize: 14.0);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 5, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                      HexColor("#ffffff")),
                                                ),
                                                height: 35,
                                                width: 90,
                                                child: Icon(
                                                  FontAwesomeIcons.coins,
                                                  color: Colors.lightBlueAccent,
                                                )),
                                            Text(
                                              'PF Loan',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: serviceStatusFlag,
                            child: Visibility(
                              //visible: npsflag,
                              visible: false,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin:
                                          EdgeInsets.fromLTRB(30.0, 7, 30, 7),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Essdashboard(hrmsId)),
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          HexColor("#ffffff")),
                                                ),
                                                height: 35,
                                                width: 90,
                                                child: Icon(
                                                  FontAwesomeIcons.userEdit,
                                                  color: Colors.lightBlueAccent,
                                                ),
                                              ),
                                              Text(
                                                'ESS',
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
                            )),
                        Visibility(
                          visible: serviceStatusFlag,
                          child: Visibility(
                            visible: !npsflag,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    margin:
                                        EdgeInsets.fromLTRB(30.0, 12, 30, 7),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Essdashboard(hrmsId)),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'ESS',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          HexColor("#ffffff")),
                                                ),
                                                height: 35,
                                                width: 90,
                                                child: Icon(
                                                  FontAwesomeIcons.database,
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
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Visibility(
                            visible: true,
                            child: RightIconBtn(
                              Icon(
                                Icons.question_answer_outlined,
                                color: Colors.lightBlueAccent,
                              ),
                              'Grievance',
                              "",
                              "grivance",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: serviceStatusFlag,
                          child: Visibility(
                            visible: false,
                            child: RightIconBtn(
                              Icon(
                                Icons.question_answer_outlined,
                                color: Colors.lightBlueAccent,
                              ),
                              'APAR',
                              "",
                              "apar",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
              ],
            )),
          ),
        ));
  }
}

