import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/home/CustomShapeClipper.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/fingerprint.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/loginscreen.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/pinvery.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:url_launcher/url_launcher.dart';

import '../util/session_check.dart';
import 'editCommunicationDetails.dart';
import 'new_homepage.dart';

class NewProfile extends StatefulWidget {
  @override
  NewProfileState createState() => NewProfileState();
}

class NewProfileState extends State<NewProfile> {
  String? designation;
  String? railwayunit;
  String? dob;
  String? department;
  String? mobileno;
  String? billunit;
  String? ipasempid;
  String? hrmsid;
  String? railwayzone;
  String profilename = "";
  SessionCheck sessionCheck=  SessionCheck();

  @override
  void initState() {
    getdetails();
    sessionCheck.startTimer(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    print('responseJSON $responseJSON');
    if (responseJSON['status'] == "1") {
      setState(() {
        profilename = responseJSON['userProfile']['profile']['employeeName'];
        designation =
            responseJSON['userProfile']['profile']['designationDescription'];
        railwayunit = responseJSON['userProfile']['profile']['railwayUnitName'];
        dob = responseJSON['userProfile']['profile']['dateOfBirth'];
        try {
          DateTime todayDate = DateTime.parse(dob!);
          dob = DateFormat('dd/MM/yyyy').format(todayDate);
        } catch (exception) {}

        department =
            responseJSON['userProfile']['profile']['departmentDescription'];
        mobileno = responseJSON['userProfile']['profile']['mobileNo'];
        billunit = responseJSON['userProfile']['profile']['billUnit'];
        ipasempid = responseJSON['userProfile']['profile']['ipasEmployeeId'];
        hrmsid = responseJSON['userProfile']['profile']['hrmsEmployeeId'];
        railwayzone = responseJSON['userProfile']['profile']['railwayZone'];
      });
    }
  }

  Widget _buildStatContainer() {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (event) {
        sessionCheck.startTimer(context);
      },
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
                      'IPAS EMPLOYEE ID :',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    )),
              ),
              Expanded(
                child: Text(ipasempid ?? "Not Available",
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                      'HRMS ID :',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    )),
              ),
              Expanded(
                child: Text(hrmsid ?? "Not Available",
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 11)),
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
                      'DATE OF BIRTH :',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    )),
              ),
              Expanded(
                child: Text(dob ?? "Not Available",
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                      'MOBILE NUMBER :',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    )),
              ),
              Expanded(
                child: Text(mobileno ?? "Not Available",
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
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
                    textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Divider(color: Colors.grey),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            /*FlatButton(
              child: Text(
                'Edit ',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditContact()),
                );
              },
            ),*/
          ],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("My Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            ProfileScreenTopPart(),
            _buildStatContainer(),
          ],
        )),
      ),
    );
  }
}

class ProfileScreenTopPart extends StatefulWidget {
  @override
  ProfileScreenTopPartState createState() => ProfileScreenTopPartState();
// TODO: implement createState
}

class ProfileScreenTopPartState extends State<ProfileScreenTopPart> {
  Uint8List? _bytesImage;
  ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;
  String? _base64Image;

  bool _isLoading =true;
  @override
  void initState() {
    super.initState();
    downloadPhoto();
  }

  Future downloadPhoto() async {
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
    //String msgtext = responseJSON['message'];
    String image = responseJSON['fileString'];
    if (image == "" || image == "[]") {
      Fluttertoast.showToast(
          msg: "Profile Image Not Found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      // Decode the Base64 string to a regular string
      setState(() {
        _isLoading=false;
        _bytesImage = Base64Decoder().convert(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 240.0,
            color: Colors.lightBlueAccent,
          ),
        ),
        /* Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 105.0,
              width: 105.0,
              margin: EdgeInsets.fromLTRB(0, 140, 0, 0),
              child: GestureDetector(
                  onTap: (){
                    //_pickImage(ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    child: _bytesImage == null
                    ?  Column(
                      children: [
                        CircleAvatar(
                            backgroundImage:
                                new AssetImage('assets/images/user1.png'),
                            radius: 100.0,
                          ),
                      ],
                    )

                    : new CircleAvatar(
                        backgroundImage: MemoryImage(_bytesImage!),
                        radius: 100.0,
                      ),
                    ),
                  ),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
              ),
            )),*/
        Positioned(
            top: 140,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  _bytesImage == null
                      ? CircleAvatar(
                          //backgroundImage: isUploadImage && selectedImage != null ? FileImage(File(selectedImage)) : AssetImage('assets/face.jpg') as ImageProvider,
                          //backgroundImage:
                          //    new AssetImage('assets/images/user1.png',) as ImageProvider,
                          radius: 100.0,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/user1.png',
                              // Replace with your image path
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          child: GestureDetector(
                            onTap: () {
                              print('Hello');
                              showAlertDialog(context);
                            },
                            child: new ClipOval(
                                child: _isLoading
                                    ? Center(
                                        child:
                                            CircularProgressIndicator(), // Replace with your custom loading widget
                                      )
                                    : Image.memory(
                                        _bytesImage!,
                                        fit: BoxFit.fill,
                                        width: 100,
                                        height: 100,
                                      )),
                          ),
                        ),
                  Positioned(
                      bottom: -5,
                      left: 0,
                      right: -80,
                      child: RawMaterialButton(
                        onPressed: () async {
                          await _pickImage();
                        },
                        elevation: 2.0,
                        fillColor: const Color(0xFFFFFFFF),
                        padding: const EdgeInsets.all(5.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blueAccent,
                        ),
                      )),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> uploadProfileImage(String _bytesImage) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("upload_profile_image");

    String? hrmsId = await pref.getEmployeeHrmsid();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Map map = {
      'imgString': _bytesImage,
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
    print('responseJSONUploadImage $responseJSON');
    String status = responseJSON['status'];
    String message = responseJSON['message'];
    if (status == "1") {
      Fluttertoast.showToast(
          msg: message +
              ' please restart the HRMS Application in order to see latest updated profile image',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.purple,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      // Decode the Base64 string to a regular string
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    setState(() {
      _isLoading=false;
      downloadPhoto();
    });
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      int imageSize = await imageFile.length(); // Get image size in bytes
      double imageSizeKB = imageSize / 1024; // Convert to KB

      if (imageSizeKB >= 50 && imageSizeKB <= 200) {
        setState(() {
          _pickedImage = imageFile;
          print('picked Image $_pickedImage');
          _base64Image = base64Encode(imageFile.readAsBytesSync());
          print('_base64Image Image $_base64Image');
          _bytesImage = Base64Decoder().convert(_base64Image!);
        });
        await uploadProfileImage(_base64Image!);

      } else {
        // Show an error message or take appropriate action
        print('Image size must be between 50 KB and 200 KB.$imageSizeKB');
        Fluttertoast.showToast(
            msg: "Image size must be between 50 KB and 200 KB.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
  }

  Future<void> removeProfileImage() async {

    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
    new UtilsFromHelper().getValueFromKey("remove_profile_image");

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
    String message = responseJSON['message'];
    if (status == "1") {
      Fluttertoast.showToast(
          msg: message ,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.purple,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      // Decode the Base64 string to a regular string
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      }
    setState(() {
      _bytesImage=null;
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () async {
        await  removeProfileImage();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to remove Profile image?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
