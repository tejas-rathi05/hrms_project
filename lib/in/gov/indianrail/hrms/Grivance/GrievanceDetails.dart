import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';

class GrievanceDetails extends StatefulWidget {
  String complaint_id = "",
      complaint_name = "",
      complaint_sub_name = "",
      complaint_details = "",
      date_created = "",
      followup_remarks = "",
      status = "",
      forwarded_unit_code = "",
      wi_hrmsId = "",
      wi_name = "";
  GrievanceDetails(
      this.complaint_id,
      this.complaint_name,
      this.complaint_sub_name,
      this.complaint_details,
      this.date_created,
      this.followup_remarks,
      this.status,
      this.forwarded_unit_code,
      this.wi_hrmsId);
  bool flag_wi = false;
  var wi_id_name = "";
  @override
  GrivanceDetails_State createState() => GrivanceDetails_State();
}

class GrivanceDetails_State extends State<GrievanceDetails> {
  late List data;
  var remark_text;
  var text_color = Colors.black;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == "Returned") {
      remark_text = widget.status;
      text_color = Colors.red;
    } else if (widget.status == "Registered") {
      remark_text = widget.status;
      text_color = Colors.blue;
    } else if (widget.status == "Withdrawn") {
      remark_text = widget.status;
      text_color = Colors.greenAccent;
    } else if (widget.status == "Forwarded") {
      remark_text = "Under Process";
      text_color = Colors.orange;
    } else if (widget.status == "Closed") {
      remark_text = widget.status;
      text_color = Colors.green;
    }

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Grievance Details",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          // child:Column(children: <Widget>[
          //   Text("* Tab for see Grievance details",style: TextStyle(color: Colors.red),),
          // ],),

          child: ListView.builder(
            //if file/folder list is grabbed, then show here
            //itemCount: files?.length ?? 0,
            itemCount: 1,
            itemBuilder: (context, index) {
              DateTime todayDateExp = DateTime.parse(widget.date_created);
              String exp_date = DateFormat('dd/MM/yyyy').format(todayDateExp);
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white54,
                    border: Border.all(width: 1, color: Colors.white)),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(5, 15, 15, 0),
                child: GestureDetector(
                  child: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'GRIEVANCE ID :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.complaint_id ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'GRIEVANCE TYPE :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.complaint_name ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'GRIEVANCE SUB TYPE :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.complaint_sub_name ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'GRIEVANCE DETAILS :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.complaint_details ?? "Not Available",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DATE REGISTERED :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(exp_date.toString() ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'FOLLOWUP REMARKS :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.followup_remarks ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'STATUS :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(remark_text ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14,
                              color: text_color,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'FORWARDED TO :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.forwarded_unit_code ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MARKED TO :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.wi_hrmsId ?? "Not Available",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey),
                  ]),
                ),
              );
            },
          ),
        ));
  }
}
