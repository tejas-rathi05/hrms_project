import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/AwardTab.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/DeputationTab.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/FamilyTab.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/PromotionTab.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/PublicationTab.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/esr/QualificationTab.dart';


import 'AppointmentTab.dart';
import 'BioDataTab.dart';
import 'EmployeeFamilyDetails2.dart';
import 'NominationTab.dart';
import 'PayChangeTab.dart';
import 'TrainingTab.dart';
import 'TransferTab.dart';


class EmployeeSR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 12,
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 85.0,
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            backgroundColor: Colors.blue[900],
            bottom: TabBar(
              isScrollable: true,
              indicatorWeight: 5,
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: FaIcon(FontAwesomeIcons.user),child: Text("Bio-Data",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.addressCard),child: Text("Employment",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.users),child: Text("Family",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.userGraduate),child: Text("Qualification",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.medal),child: Text("Awards",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.arrowUp),child: Text("Promotions",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.users),child: Text("Nominations",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.chalkboardTeacher),child: Text("Trainings",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.book),child: Text("Publications",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.upload),child: Text("Deputations",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.rupeeSign),child: Text("Pay Change",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),)),
                Tab(icon: FaIcon(FontAwesomeIcons.peopleArrows),child: Text("Transfer",style: TextStyle(fontSize:10,fontWeight:FontWeight.bold),))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(child:BioDataTab()),
              Container(child:AppointmentTab()),
              Container(child:FamilyTab()),
              Container(child:QualificationTab()),
              Container(child:AwardTab()),
              Container(child:PromtoionTab()),
              Container(child:NominationTab()),
              Container(child:TrainingTab()),
              Container(child:PublicationTab()),
              Container(child:DeputationTab()),
              Container(child:PayChangeTab()),
              Container(child:TransferTab()),
            ],
          ),
        ),
      ),
    );
  }
}
