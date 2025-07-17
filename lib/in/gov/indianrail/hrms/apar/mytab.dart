import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/apar/reportingOfficer.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/apar/reviewingOfficer.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'acceptingOfficer.dart';
import 'gazettedoffierviewModel.dart';

late List<GazettedOfficerModel> _userlist_reviewing;
late List<GazettedOfficerModel> _userlist_reporting;

late List<GazettedOfficerModel> _userlist_accepting;
int _userlist_Repo = 0;
int _userlist_R = 0;
int _userlist_A = 0;

class ListEmp extends StatefulWidget {
  var hrmsId, finyear;
  ListEmp(this.hrmsId, this.finyear);
  @override
  @override
  TabbedAppBarSample createState() => TabbedAppBarSample();
}

class TabbedAppBarSample extends State<ListEmp> {
  var repo_Officercount = "0",
      review_Officercount = "0",
      accept_Officercount = "0";
  var repo_pendingcount = "0",
      review_pendingcount = "0",
      accept_pendingcount = "0";
  void getemplistunderofficer() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("list_emp_underofficer");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {"hrmsId": widget.hrmsId};
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    _userlist_reviewing;
    _userlist_reporting;
    _userlist_accepting;
    _userlist_R = 0;
    _userlist_A = 0;
    _userlist_Repo = 0;
    if (responseJSON["statusresult"] == true) {
      var userdetails = responseJSON["headerdata"] as List;
      var officer_type = responseJSON['officer_type'];

      setState(() {
        if (officer_type == "reporting_officer") {
          _userlist_reporting = userdetails
              .map<GazettedOfficerModel>(
                  (json) => GazettedOfficerModel.fromJson(json))
              .toList();
          _userlist_Repo = _userlist_reporting.length;
          count_pending_emp_reporting();
        }
        if (officer_type == "reviewing_officer") {
          setState(() {
            _userlist_reviewing = userdetails
                .map<GazettedOfficerModel>(
                    (json) => GazettedOfficerModel.fromJson(json))
                .toList();
            _userlist_R = _userlist_reviewing.length;
            count_pending_emp_reviewing();
          });
        }
        if (officer_type == "accepting_officer") {
          _userlist_accepting = userdetails
              .map<GazettedOfficerModel>(
                  (json) => GazettedOfficerModel.fromJson(json))
              .toList();
          _userlist_A = _userlist_accepting.length;
          count_pending_emp_accepting();
        }
        count_available_emp(officer_type);
      });
    }
  }

  void count_available_emp(String officerType) async {
    final String url =
        new UtilsFromHelper().getValueFromKey("count_available_emp");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      "hrms_employee_id": widget.hrmsId,
      "apar_fin_yr": widget.finyear
    };
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null) {
      setState(() {
        if (officerType == "reporting_officer") {
          repo_Officercount = responseJSON["available1"].toString();
        } else if (officerType == "reviewing_officer") {
          review_Officercount = responseJSON["available1"].toString();
        } else if (officerType == "accepting_officer") {
          accept_Officercount = responseJSON["available1"].toString();
        }
      });
    }
  }

  void count_pending_emp_reporting() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("count_pending_emp_reporting");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      "hrms_employee_id": widget.hrmsId,
    };
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null) {
      setState(() {
        repo_pendingcount = responseJSON["pending"].toString();
      });
    }
  }

  void count_pending_emp_reviewing() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("count_pending_emp_reviewing");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      "hrms_employee_id": widget.hrmsId,
    };
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null) {
      setState(() {
        repo_pendingcount = responseJSON["pending"].toString();
      });
    }
  }

  void count_pending_emp_accepting() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("count_pending_emp_accepting");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      "hrms_employee_id": widget.hrmsId,
    };
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    if (responseJSON != null) {
      setState(() {
        repo_pendingcount = responseJSON["pending"].toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    repo_Officercount = "0";
    review_Officercount = "0";
    accept_Officercount = "0";

    getemplistunderofficer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.lightBlueAccent,
            title: Text("Apar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            automaticallyImplyLeading: false,
            bottom: new TabBar(isScrollable: true, tabs: [
              new Tab(
                  text:
                      'Reporting Officer $repo_Officercount/$repo_pendingcount'),
              new Tab(
                  text:
                      'Reviewing Officer $review_Officercount/$review_pendingcount'),
              new Tab(
                  text:
                      'Accepting Officer $accept_Officercount/$accept_pendingcount'),
            ]),
          ),
          body: new TabBarView(
            children: [
              ReportingOfficer(
                  _userlist_reporting, "Reporting_Officer", _userlist_Repo),
              ReviewingOfficer(
                  _userlist_reviewing, "Reviewing_Officer", _userlist_R),
              AcceptingOfficer(
                  _userlist_accepting, "Accepting_Officer", _userlist_A),
            ],
          ),
        ),
      ),
    );

    // return new MaterialApp(
    //
    // );
  }
}
