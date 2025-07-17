import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../util/session_check.dart';
import 'myLeaveApplication.dart';

class MyLeaveApplicationSearchByYear extends StatefulWidget {
  @override
  MyLeaveApplicationSearchByYearState createState() =>
      MyLeaveApplicationSearchByYearState();
}

class MyLeaveApplicationSearchByYearState
    extends State<MyLeaveApplicationSearchByYear> {
  List<DropdownMenuItem<String>> dropdownItems = [];
  List<DropdownMenuItem<String>> leaveStatusItems = [];
  String? _leaveType;
  String? _leaveStatus;
  int selectedYear=2023;
  List<DropdownMenuItem<int>> yearItems = [];
  SessionCheck sessionCheck=  SessionCheck();

  @override
  void initState() {

    selectedYear = DateTime.now().year;
    print('selectedYear ${selectedYear+1}');
    _fetchLeaveYear();
    _fetchLeaveOptions();
    _fetchLeaveStatus();
    sessionCheck.startTimer(context);
    super.initState();
  }
  Future _fetchLeaveYear() async {
    setState(() {
      for (int year = selectedYear+1; year >= 2023; year--) {
        print('year $year');
        yearItems.add(DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ));
      }
    });
  }

  Future _fetchLeaveStatus() async {
    setState(() {
      leaveStatusItems.add(
        DropdownMenuItem(
          value: "",
          child: Text("ALL",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      leaveStatusItems.add(
        DropdownMenuItem(
          value: "A",
          child: Text("Pending",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      leaveStatusItems.add(
        DropdownMenuItem(
          value: "S",
          child: Text("Sanctioned",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      leaveStatusItems.add(
        DropdownMenuItem(
          value: "R",
          child: Text("Rejected",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      leaveStatusItems.add(
        DropdownMenuItem(
          value: "W",
          child: Text("Withdrawn",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
    });
  }


  Future _fetchLeaveOptions() async {
    setState(() {
      dropdownItems.add(
        DropdownMenuItem(
          value: "",
          child: Text("ALL LEAVES",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "CL",
          child: Text("CASUAL LEAVE (CL)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "RH",
          child: Text("RESTRICTED HOLIDAY (RH)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "LAP",
          child: Text("LEAVE ON AVERAGE PAY (LAP)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
      dropdownItems.add(
        DropdownMenuItem(
          value: "LHAP",
          child: Text("LEAVE ON AVERAGE HALF PAY (LHAP)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (event) {
        sessionCheck.startTimer(context);
      },
      child: Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.lightBlueAccent,
            title: Text("My Leave Applications",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        backgroundColor: Colors.grey,
        body: Center(
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 30, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            padding:EdgeInsets.all(8.0),
                            child: Text(
                              "Search My Leave Application By Leave Type & Leave Year ",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xF5043F8A),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Leave Type : *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFE0),
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Please Select ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: '',
                                  onChanged: (newValue) {
                                    setState(() {
                                      _leaveType = newValue! as String?;
                                    });
                                  },
                                  items: dropdownItems,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Year : *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFE0),
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Please Select ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: selectedYear,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedYear = newValue!;
                                    });
                                  },
                                  items: yearItems,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Leave Status : *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFE0),
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  dropdownColor: Color(0xFFF2F2F2),
                                  hint: Text(
                                    'Please Select ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Not necessary for Option 1
                                  value: '',
                                  onChanged: (newValue) {
                                    setState(() {
                                      _leaveStatus = newValue! as String?;
                                    });
                                  },
                                  items: leaveStatusItems,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                  print('Hi12 $_leaveType');
                                  print('Hi12selectedYear $selectedYear');
                                  Route route = MaterialPageRoute(
                                      builder: (context) => MyLeaveApplication(
                                          _leaveType,_leaveStatus,selectedYear.toString()));
                                  Navigator.push(context, route);

                              },
                              child: Text('Proceed'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
