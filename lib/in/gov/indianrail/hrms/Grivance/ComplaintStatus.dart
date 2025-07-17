import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/Grivance/GrievanceDetails.dart';

import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';

import 'package:intl/intl.dart';


class ComplaintStatus extends StatefulWidget {
  @override
  ComplaintStatus_State createState() => ComplaintStatus_State();
}

class ComplaintStatus_State extends State<ComplaintStatus> {
  late List data;
  var text_color = Colors.black;
  var registered_text = 0;
  var complaint_id = "",
      complaint_name = "",
      complaint_sub_name = "",
      complaint_details = "",
      date_created = "",
      followup_remarks = "",
      status = "";
  var remarks_returned = "0",
      remarks_Withdrawn = "0",
      remarks_registered = "0",
      remarks_closed = "0",
      remarks_forwarded = "0";
  var remark_text = "";
  Future getdetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("grievance_status");
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
    var responseJSON = json.decode(value) as List;

    setState(() {
      var complaintList = responseJSON as List;
      if (complaintList.length > 0) {
        try {
          data = complaintList;
          getTotalCount();
        } catch (exception) {}
      } else {
        Fluttertoast.showToast(
            msg: 'No data found',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    });
  }

  Future getTotalCount() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url =
        new UtilsFromHelper().getValueFromKey("get_total_count_remarks");
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
    var responseJSON = json.decode(value) as List;

    if (responseJSON != null && responseJSON != "") {
      setState(() {
        var count_remarks = responseJSON as List;

        for (int i = 0; i < count_remarks.length; i++) {
          if (count_remarks[i]["status"] == "Withdrawn") {
            remarks_Withdrawn = count_remarks[i]["nos"].toString();
          } else if (count_remarks[i]["status"] == "Returned") {
            remarks_returned = count_remarks[i]["nos"].toString();
          } else if (count_remarks[i]["status"] == "Registered") {
            remarks_registered = count_remarks[i]["nos"].toString();
          } else if (count_remarks[i]["status"] == "Closed") {
            remarks_closed = count_remarks[i]["nos"].toString();
          } else if (count_remarks[i]["status"] == "Forwarded") {
            remarks_forwarded = count_remarks[i]["nos"].toString();
          }
        }

        try {} catch (exception) {}
      });
    }
  }

  @override
  void initState() {
    getdetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("My Grievance Dashboard",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
      body: Column(children: <Widget>[
        Container(
          height: 80,
          child: Card(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Registered: $remarks_registered"),
                    Text("Returned: $remarks_returned"),
                    Text("Closed: $remarks_closed"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Withdrawn: $remarks_Withdrawn"),
                    Text("Under Process: $remarks_forwarded"),
                  ],
                ),
              ),
            ],
          )),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              DateTime todayDateExp = DateTime.parse(data[index]["date_created"]);
              String exp_date = DateFormat('dd/MM/yyyy').format(todayDateExp);

              if (data[index]["remarks"] == "Returned") {
                remark_text = data[index]["remarks"];
                text_color = Colors.red;
              } else if (data[index]["remarks"] == "Registered") {
                remark_text = data[index]["remarks"];
                text_color = Colors.blue;
              } else if (data[index]["remarks"] == "Withdrawn") {
                remark_text = data[index]["remarks"];
                text_color = Colors.greenAccent;
              } else if (data[index]["remarks"] == "Forwarded") {
                remark_text = "Under Process";
                text_color = Colors.orange;
              } else if (data[index]["remarks"] == "Closed") {
                remark_text = data[index]["remarks"];
                text_color = Colors.green;
              }
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white54,
                      border: Border.all(width: 1, color: Colors.white)),
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.fromLTRB(5, 15, 15, 0),
                  child: GestureDetector(
                    onTap: () {
                      var remarks = "";
                      if (data[index]["remarks"] == "Forwarded") {
                        remarks = "Under Process";
                      } else if (data[index]["remarks"] == "Returned") {
                        remarks = "Returned";
                      } else {
                        remarks = data[index]["remarks"];
                      }

                      var wi_id_name;
                      var add = " / ";
                      if (data[index]["wi_hrms_id"] == "NODATA" &&
                          data[index]["wi_name"] == null) {
                        wi_id_name;
                      } else if (data[index]["wi_hrms_id"] != "NODATA" &&
                          (data[index]["wi_name"] != null ||
                              data[index]["wi_name"] != "")) {
                        wi_id_name = data[index]["wi_hrms_id"] +
                            add +
                            data[index]["wi_name"];
                      } else if (data[index]["wi_hrms_id"] == "NODATA" &&
                          (data[index]["wi_name"] != null ||
                              data[index]["wi_name"] != "")) {
                        wi_id_name = data[index]["wi_name"];
                      } else if (data[index]["wi_hrms_id"] != "NODATA" &&
                          (data[index]["wi_name"] == null ||
                              data[index]["wi_name"] == "")) {
                        wi_id_name = data[index]["wi_hrms_id"];
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(

                            // GrievanceDetails(this.complaint_id,this.complaint_name,this.complaint_sub_name,this.complaint_details,this.date_created,this.followup_remarks,this.status);
                            builder: (context) => GrievanceDetails(
                                data[index]["complaint_id"].toString(),
                                data[index]["complaint_name"],
                                data[index]["complaint_sub_name"],
                                data[index]["complaint_detail"],
                                data[index]["date_created"],
                                data[index]["followup_remarks"],
                                remarks,
                                data[index]["forwarded_unit_code"],
                                wi_id_name)),
                      );
                    },
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                height: 14,
                                margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                child: Text(
                                  'GRIEVANCE ID :',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                          Expanded(
                            child: Text(
                                data[index]["complaint_id"].toString() ??
                                    "Not Available",
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
                                  'GRIEVANCE TYPE :',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                          Expanded(
                            child: Text(
                                data[index]["complaint_name"] ??
                                    "Not Available",
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
                                  'GRIEVANCE SUB TYPE :',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                          Expanded(
                            child: Text(
                                data[index]["complaint_sub_name"] ??
                                    "Not Available",
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
                                  'DATE REGISTERED :',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                          Expanded(
                            child: Text(exp_date ?? "Not Available",
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
                                  'STATUS :',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                          Expanded(
                            child: Text(remark_text ?? "Not Available",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: text_color,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey),
                    ]),
                  ));
            },
          ),
        )
      ]),
    );
  }
}
