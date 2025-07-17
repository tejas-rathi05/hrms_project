import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/EmployeeSR.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';


class AppointmentTab extends StatefulWidget {
  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {


  var appointmentDate = "",
      modeOfAppointment = "",
      railwayGroup = "",
      gazNonGaz = "",
      examBatch = "",
      DateofIncrementInTimeScale = "",
      currentDepartment = "",
      currentDesignation = "",
      currentZone = "",
      currentUnitDivision = "",
      currentWorkingOffice = "",
      currentStationPlace = "",
      currentBasicPay = "",
      currentPayLevel = "",
      pfNumber = "",
      pran = "",serviceStatus="";

  @override
  void initState() {
    getAppointmentDetails();
    super.initState();
  }


  Future getAppointmentDetails() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    final String url = new UtilsFromHelper().getValueFromKey("show_e_sr_appointment");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "hrmsEmployeeId": await pref.getUsername(),
    };
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    setState(() {
      appointmentDate =
      responseJSON['appointmentDetails']['headerdata']['appointmentDate'];
      try {
        final DateTime todayDate = DateTime.now();
        final String dob = DateFormat('dd/MM/yyyy').format(todayDate);
      } catch (exception) {}

      modeOfAppointment = responseJSON['appointmentDetails']['headerdata']['modeOfAppointment']??'NA';
      railwayGroup = responseJSON['appointmentDetails']['headerdata']['railwayGroup']??'NA';
      gazNonGaz = responseJSON['appointmentDetails']['headerdata']['officerType']??'NA';
      examBatch = responseJSON['appointmentDetails']['headerdata']['examBatch']??'NA';
      DateofIncrementInTimeScale = responseJSON['appointmentDetails']['headerdata']['dateOfIncrement']??'NA';
      currentDepartment = responseJSON['appointmentDetails']['headerdata']['currentDepartment']??'NA';
      currentDesignation = responseJSON['appointmentDetails']['headerdata']['currentDesignation']??'NA';
      currentZone = responseJSON['appointmentDetails']['headerdata']['currentZone']??'';
      currentUnitDivision = responseJSON['appointmentDetails']['headerdata']['currentUnitDivision']??'NA';
      currentWorkingOffice = responseJSON['appointmentDetails']['headerdata']['currentPlace']??'NA';
      currentStationPlace = responseJSON['appointmentDetails']['headerdata']['currentStationPlace']??'NA';
      currentBasicPay = responseJSON['appointmentDetails']['headerdata']['currentBasicPay']??'NA';
      currentPayLevel = responseJSON['appointmentDetails']['headerdata']['currentPayLevel']??'NA';
      pfNumber = responseJSON['appointmentDetails']['headerdata']['pfNumber']??'NA';
      pran = responseJSON['appointmentDetails']['headerdata']['pran']??'NA';
      serviceStatus = responseJSON['appointmentDetails']['headerdata']['st']??'NA';
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
    return  Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white54,
          border: Border.all(
              width: 1,
              color: Colors.white
          )
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      child:Column(
          children:<Widget>[
            Row(
              children: [
                Container(margin: EdgeInsets.fromLTRB(5, 3, 0, 0),child: const Text('Status :', style: TextStyle(fontSize:12,fontWeight:FontWeight.bold))),
                Container(margin: EdgeInsets.fromLTRB(5, 3, 0, 0),padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.grey[100], child: Text(serviceStatus??"NA",textAlign: TextAlign.right, style: TextStyle(fontSize:12,fontWeight:FontWeight.bold,
                        color: Colors.red))),
              ],
            ),
            Container(
              height: 20,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('Appointment Date :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(appointmentDate??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('MODE OF APPOINTMENT :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(modeOfAppointment??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(

                      margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child:Text('RAILWAY GROUP :', textAlign: TextAlign.left,
                        style: TextStyle(fontSize:11,fontWeight: FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(railwayGroup??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:11)),
                ),
              ],
            ),

            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('GAZ/NON-GAZ :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),


                Expanded(
                  child: Text(gazNonGaz??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('EXAM BATCH :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),


                Expanded(
                  child: Text(examBatch??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('DATE OF INCREMENT IN TIME SCALE :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),


                Expanded(
                  child: Text(DateofIncrementInTimeScale??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT DEPARTMENT :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),


                Expanded(
                  child: Text(currentDepartment??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT DESIGNATION :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentDesignation??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT ZONE :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentZone??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT UNIT DIVISION :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentUnitDivision??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT WORKING OFFICE :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentWorkingOffice??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT STATION PLACE  :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentStationPlace ??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT BASIC PAY :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentBasicPay??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('CURRENT PAY LEVEL :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(currentPayLevel??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('PF NUMBER :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(pfNumber??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
            Divider(color:Colors.grey),
            Row(
              children: <Widget>[
                Expanded(

                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child:Text('PRAN :', textAlign: TextAlign.left,style: TextStyle(fontSize:11,fontWeight:
                      FontWeight.bold,color: Colors.grey[600]),)
                  ),
                ),

                Expanded(
                  child: Text(pran??"NA", textAlign: TextAlign.right, style: TextStyle(fontSize:12)),
                ),
              ],
            ),
          ]
      ),
    );

  }

}
