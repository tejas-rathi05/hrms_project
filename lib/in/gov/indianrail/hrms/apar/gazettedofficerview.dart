import 'dart:convert';
import 'dart:io';
import 'dart:js_interop';

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

class GazettedOfficerView extends StatefulWidget {
  var hrmsId;
  GazettedOfficerView(this.hrmsId);
  @override
  GazettedOfficerViewState createState() => GazettedOfficerViewState();
}

class DynamicTabContent {
  String heading;
  String count;

  DynamicTabContent.name(this.heading, this.count);
}

class GazettedOfficerViewState extends State<GazettedOfficerView> {
  var fruitMap = null;
  late List<DynamicTabContent> data;

  late int repo_Officercount = 0, review_Officercount, accept_Officercount;

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
        }
        if (officer_type == "reviewing_officer") {
          setState(() {
            _userlist_reviewing = userdetails
                .map<GazettedOfficerModel>(
                    (json) => GazettedOfficerModel.fromJson(json))
                .toList();
            _userlist_R = _userlist_reviewing.length;
          });
        }
        if (officer_type == "accepting_officer") {
          _userlist_accepting = userdetails
              .map<GazettedOfficerModel>(
                  (json) => GazettedOfficerModel.fromJson(json))
              .toList();
          _userlist_A = _userlist_accepting.length;
        }
      });
    }
  }

  void count_available_emp() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("count_available_emp");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {"hrms_employee_id": "OOLUZR", "apar_fin_yr": "2019-2020"};
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
        var count = responseJSON["available1"];
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
      "hrms_employee_id": "OOLUZR",
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
        var count = responseJSON["available1"];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    repo_Officercount = 0;
    review_Officercount = 0;
    accept_Officercount = 0;
    count_available_emp();
    count_pending_emp_reporting();

    data.add(new DynamicTabContent.name("Reporting Officer", "1/1"));
    data.add(new DynamicTabContent.name("Reviewing Officer", "1/1"));
    data.add(new DynamicTabContent.name("Accepting Officer", "1/2"));
    fruitMap = data.asMap();
    getemplistunderofficer();
    super.initState();
  }

  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Apar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SafeArea(
        child: CustomTabView(
          initPosition: initPosition,
          itemCount: data.length,
          tabBuilder: (context, index) => Tab(text: fruitMap[index].toString()),
          pageBuilder: (context, index) =>
              Center(child: Container(child: Text("Text"))),
          onPositionChange: (index) {
            initPosition = index;
          },
          onScroll: (position) => print('$position'),
        ),
      ),
    );
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  //final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    // this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();
      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }
      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }
      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
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
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}
