import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

class BioDataTab extends StatefulWidget {
  @override
  State<BioDataTab> createState() => _BioDataTabState();
}

class _BioDataTabState extends State<BioDataTab> {
  var ipasEmployeeId = "",
      hrmsEmployeeId = "",
      employeeName = "",
      employeeNameHindi = "",
      dob = "",
      gender = "",
      fatherName = "",
      bloodGroup = "",
      aadhaarNumber = "",
      maritalStatus = "",
      SpouseName = "",
      nationality = "",
      religion = "",
      community = "",
      heightInCMS = "",
      identificationMark1 = "",
      identificationMark2 = "",
      permanentAddressLine1 = "",
      permanentAddressLine2 = "",
      permanentPincode = "",
      serviceStatus = "";

  @override
  void initState() {
    getBioDataDetails();
    super.initState();
  }

  Future getBioDataDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
    new UtilsFromHelper().getValueFromKey("show_e_sr_biodata");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsEmployeeId": await pref.getUsername(),
    };
    print('url $url');
    print('map $map');
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('reponseJSON $responseJSON');
    setState(() {
      if(responseJSON['bioData']!=null) {
        hrmsEmployeeId =
            responseJSON['bioData']['headerdata']['hrmsEmployeeIdForEsrBiodata'] ??
                'NA';
        ipasEmployeeId =
            responseJSON['bioData']['headerdata']['ipasEmployeeId'] ?? 'NA';
        employeeName =
            responseJSON['bioData']['headerdata']['employeeName'] ?? 'NA';
        employeeNameHindi =
            responseJSON['bioData']['headerdata']['nameHindiLang'] ?? 'NA';
        dob = responseJSON['bioData']['headerdata']['dateOfBirth'] ?? 'NA';
        try {
          final DateTime parsed = DateTime.parse(dob);
          dob = DateFormat('dd/MM/yyyy').format(parsed);
        } catch (exception) {}
        gender = responseJSON['bioData']['headerdata']['gender'] ?? 'NA';
        fatherName =
            responseJSON['bioData']['headerdata']['fatherName'] ?? 'NA';
        bloodGroup =
            responseJSON['bioData']['headerdata']['bloodGroup'] ?? 'NA';
        aadhaarNumber =
            responseJSON['bioData']['headerdata']['aadhaarNumber'] ?? 'NA';
        maritalStatus =
            responseJSON['bioData']['headerdata']['maritalStatus'] ?? 'NA';
        SpouseName =
            responseJSON['bioData']['headerdata']['husbandName'] ?? 'NA';
        nationality =
            responseJSON['bioData']['headerdata']['nationality'] ?? 'NA';
        religion = responseJSON['bioData']['headerdata']['religion'] ?? 'NA';
        community = responseJSON['bioData']['headerdata']['community'] ?? 'NA';
        heightInCMS =
            responseJSON['bioData']['headerdata']['heightInCMS'] ?? 'NA';
        serviceStatus = responseJSON['bioData']['headerdata']['st'] ?? 'NA';
        identificationMark1 =
            responseJSON['bioData']['headerdata']['identificationMark1'] ??
                'NA';
        identificationMark2 =
            responseJSON['bioData']['headerdata']['identificationMark2'] ??
                'NA';
        permanentAddressLine1 =
            responseJSON['bioData']['headerdata']['permanentAddressLine1'] ??
                'NA';
        permanentAddressLine2 =
            responseJSON['bioData']['headerdata']['permanentAddressLine2'] ??
                'NA';
        permanentPincode =
            responseJSON['bioData']['headerdata']['permanentPincode'] ?? 'NA';
      }else
        {
          //No data found
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildStatContainer(),
              ],
            )),
      ),
    );
  }

  Widget _buildStatContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white54,
          border: Border.all(width: 1, color: Colors.white)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      child: Column(children: <Widget>[
        Row(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                child: const Text('Status :',
                    style:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
            Container(
                margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                color: Colors.grey[100],
                child: Text(serviceStatus ?? "NA",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red))),
          ],
        ),
        Container(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
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
              child: Text(hrmsEmployeeId ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
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
              child: Text(ipasEmployeeId ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text(
                    'EMPLOYEE NAME :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(employeeName ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'EMPLOYEE NAME IN HINDI :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(employeeNameHindi ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
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
              child: Text(dob ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'GENDER :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(gender ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'FATHER NAME :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(fatherName ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'BLOOD GROUP :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(bloodGroup ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'AADHAAR NUMBER :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(aadhaarNumber ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'MARITAL STATUS :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(maritalStatus ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'SPOUSE NAME :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(SpouseName ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'NATIONALITY  :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(nationality ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'RELIGION :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(religion ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'COMMUNITY :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(community ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'HEIGHT IN CMS :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(heightInCMS ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'IDENTIFICATION MARK 1 :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(identificationMark1 ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'IDENTIFICATION MARK 2 :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(identificationMark2 ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'PERMANENT ADDRESS LINE 1 :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(permanentAddressLine1 ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'PERMANENT ADDRESS LINE 2 :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(permanentAddressLine2 ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(
                    'PERMANENT PINCODE :',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
            ),
            Expanded(
              child: Text(permanentPincode ?? "NA",
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ]),
    );
  }
}
