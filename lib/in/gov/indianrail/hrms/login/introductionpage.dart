import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
//import 'package:hrmsproject/in/gov/indianrail/hrms/home/hrmsurl.dart';

import 'loginscreen.dart';

class Indroduction extends StatefulWidget {
  @override
  IndroductionState createState() => IndroductionState();
}

class IndroductionState extends State<Indroduction> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.lightBlueAccent,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text(
                                "Go To Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 78.0,
                        width: 78.0,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: new AssetImage(
                              'assets/images/cris_logo_blue_new.png',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Text(
                                    'ABOUT CRIS',
                                    style: TextStyle(
                                      fontSize: 15,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 5
                                        ..color = const Color.fromARGB(
                                            255, 77, 115, 153),
                                    ),
                                  ),
                                  Text(
                                    'ABOUT CRIS',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                "WHO WE ARE",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoMono"),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "CRIS (Centre for Railway Information Systems) is an organization under Ministry of Railways.CRIS is a unique combination of competent IT professionals and experienced Railway personnel enabling it to deliver complex Railway IT systems with stupendous success in core areas.Since its inception, CRIS is developing/maintaining softwares for the following key functional areas of the Indian Railways.",
                                textAlign: TextAlign.justify,
                                textDirection: TextDirection.ltr,
                              ),
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                        child: Text(
                          "TICKETING & PASSNGERS",
                          style: TextStyle(
                              color: HexColor("#2874A6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: HexColor("#F5F5F5"),
                          width: 300,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/cardtkt.jpg',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "1. Facilitate in fulfilling ticketing needs of about 2\n crore passengers daily.\n\n2. More than 25,000 tickets per minute booking capabilities.\n\n3. Handle more than 20 crore enquiries daily regarding train movements and arrival/departure."),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "PNR Enquiry",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "UTS Ticketing",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                        child: Text(
                          "FREIGHT SERVICES",
                          style: TextStyle(
                              color: HexColor("#2874A6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: HexColor("#F5F5F5"),
                          width: 300,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/card8.jpg',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "1. Manage movement of 3.5 MT freight which generates more than 343 Cr. freight earnings daily.\n\n 2. Enable Digital Payments through 98% cashless Revenue collections.\n\n3. Monitor 2.8 lakh wagons spread all over India."),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "FOIS Portal",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                        child: Text(
                          "OPERATIONS",
                          style: TextStyle(
                              color: HexColor("#2874A6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: HexColor("#F5F5F5"),
                          width: 300,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/card3.jpg',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "1. Train Traffic Control and operations for every single train over Indian Railways network.\n\n2. Manage coaches, crew and other operations digitally.\n\n3. Real time tracking of trains through satellite based tracking mechanism."),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "NTES Portal",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                        child: Text(
                          "ASSET MANAGEMENT",
                          style: TextStyle(
                              color: HexColor("#2874A6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: HexColor("#F5F5F5"),
                          width: 300,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/card6.jpg',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "1.Monitoring of Railways infrastructure consisting of Stations, Workshops, Sheds, Yards, etc.\n\n2. Inspection & maintenance of Tracks, Overhead Line, Land, Signals, etc.\n\n3. Management of Rolling Stock Assets viz. Locos, rakes, etc."),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "e-Drishti Portal",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                        child: Text(
                          "HUMAN RESOURCE & ACCOUNTING",
                          style: TextStyle(
                              color: HexColor("#2874A6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: HexColor("#F5F5F5"),
                          width: 300,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/card7.jpg',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "1. HR management of more than 12 lakh employees work-force .\n\n2. Digitalization of Accounting & Finance systems with 100% online expenditure booking.\n\n3. Online Railways Budgeting & Progress monitoring."),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "HRMS Application",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                        child: Text(
                          "PROCUREMENT & AUTOMATION",
                          style: TextStyle(
                              color: HexColor("#2874A6"),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        child: Container(
                          color: HexColor("#F5F5F5"),
                          width: 300,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/card5.jpg',
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "1. Introducing transparency & Accountability with 100% online procurement.\n\n2. Digitalizing Railway working through Office Automation and e-Governance solutions.\n\n3. KPIs based & DSS enabled monitoring and sharing information with public.",
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Rail Madad",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightBlueAccent,
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Text(
                                          "e-Procurement",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: 300,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    // Stroked text as border.
                                    Text(
                                      'INNOVATIVE TECHNOLOGY',
                                      style: TextStyle(
                                        fontSize: 15,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 5
                                          ..color = const Color.fromARGB(
                                              255, 25, 118, 210),
                                      ),
                                    ),
                                    // Solid text as fill.
                                    Text(
                                      'INNOVATIVE TECHNOLOGY',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "BLOOMING TOGETHER IN DIGITAL ERA",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "RobotoMono"),
                                ),
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 5.0,
                                            color: HexColor("#2874A6")),
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      Align(
                                        child: Container(
                                          width: 100,
                                          child: Text(" 2015-2020"),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "MODERNIZING IT SOLUTIONS BY INTRODUCING EMERGING TECHNOLOGIES",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor("#2874A6")),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "Realizing the power of modern emerging technologies, CRIS is introducing emerging technologies like Blockchain, AI, ML, BigData, Business Intelligence, Cloud Services (private as well as public cloud), Agility, Chatbots, IoT, AR/VR, etc. to perform Train Route Optimizations, Capacity Enhancement, Prediction of Train Delays and Waitlist clearance, Predictive maintenance of Rail Assets, forecasting Energy Consumption, Train Timetable Optimization, etc. and thus providing a new dimension to its solutions.",
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ]),
                                    ])),
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 5.0,
                                            color: HexColor("#2874A6")),
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      Align(
                                        child: Container(
                                          width: 100,
                                          child: Text(" 2015-2020"),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "DIGITALIZING RAILWAYS THROUGH SMART MOBILE APPS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor("#2874A6")),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Container(
                                                width: 190,
                                                child: Text(
                                                  "CRIS has delivered a number of public centric mobile apps like UTS, RailConnect, NTES, Rail Madad, Rail Sugam, CoachMitra, Rail Rajbhasha, etc. to cover all aspects of passenger convenience from ticket & freight booking/enquiry to complaint redressal. In addition, a number of internal Railway Mobile Apps like eDrishti, Aapoorti, Chalak Dal, Rail Saver, Hand Held Terminals, etc. have also been delivered to digitalize Railway operations and monitoring. These mobile apps have been provided in various flavours as Native iOS & Android Apps, Hybrid, Flutter, React native, Progressive Web Applications, etc. along with their Backend design, Mobile Analytics & testing activities.",
                                                  textAlign: TextAlign.justify,
                                                )),
                                          ]),
                                    ])),
                                //3
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 5.0,
                                            color: HexColor("#2874A6")),
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      Align(
                                        child: Container(
                                          width: 100,
                                          child: Text(" 2010-2015"),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "PIONEERED IN PROVIDING SEAMLESS IT SOLUTIONS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor("#2874A6")),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Container(
                                                width: 190,
                                                child: Text(
                                                  " CRIS started adopting a number of lightweight, need based technologies like React JS, Angular JS, PHP, Python, Node JS, Ruby on Rails, HTML5, Bootstrap, etc. to provide more fruitful IT solutions. A Next generation e-ticketing solution (NGeT) to promote ticket bookings through internet was rolled out. GIS based Railway Assets and Land Mapping was also envisaged. Railway Security domain was also strengthened through IT based solutions. In all, the foundation of 'Minimum Government Maximum Governance' was laid down through multiple e-Governance solutions in Railways.",
                                                  textAlign: TextAlign.justify,
                                                )),
                                          ]),
                                    ])),
                                //4
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 5.0,
                                            color: HexColor("#2874A6")),
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      Align(
                                        child: Container(
                                          width: 100,
                                          child: Text(" 2005-2010"),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "PATH TOWARDS GLORY",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor("#2874A6")),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Container(
                                                width: 190,
                                                child: Text(
                                                  "CRIS made its mark by becoming one stop destination for Railway IT solutions based on Web-Technologies and started delivering IT solutions for all Railway needs apart from Ticketing, Reservation and Freight Operations. This era marked multi-dimensional versatile evolution of CRIS deliverables viz. Workflow based e-Working and office automation systems using IBM technologies, J2EE based Crew Management System, Payroll and Accounting System, Asset Management Systems, Micorsoft Technologies based Control Charting, etc.",
                                                  textAlign: TextAlign.justify,
                                                )),
                                          ]),
                                    ])),
                                //5
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 5.0,
                                            color: HexColor("#2874A6")),
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      Align(
                                        child: Container(
                                          width: 100,
                                          child: Text(" 1995-2005"),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "FOLLOWING RIGHT STEPS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor("#2874A6")),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Container(
                                                width: 190,
                                                child: Text(
                                                  "CRIS established itself as an IT enterprise and gained expertise in evergreen technologies like C, C++, Visual Studio, Java, SQL, UNIX, etc. Unreserved Ticketing and Train Enquiry Systems were developed using C language and Sybase database. Train Punctuality Application using C language and Internet based Passenger Reservation were introduced in Indian Railways ecosystem. Railway Budget Compilation System using Microsoft Technologies also revolutionized the Railway Budgeting process",
                                                  textAlign: TextAlign.justify,
                                                )),
                                          ]),
                                    ])),
                                //6

                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 5.0,
                                            color: HexColor("#2874A6")),
                                      ),
                                    ),
                                    child: Row(children: <Widget>[
                                      Align(
                                        child: Container(
                                          width: 100,
                                          child: Text(" 1986-1995"),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 190,
                                              child: Text(
                                                "DAWN OF IT IN RAILWAYS",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: HexColor("#2874A6")),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Container(
                                                width: 190,
                                                child: Text(
                                                  "CRIS had mastered FORTRAN, CLIPPER, LISP, BASIC, DBASE, IBM MainFrames, Flat-Files, etc. technologies at that time when most of the enterprises were hesitating to put their foot in IT. CRIS also started digitalization of Railways by introducing IBM Mainframe/BULL Servers based Freight Operations System in Topstran, VAX Systems based Passenger Reservation Systems (Impress) developed in FORTRAN, Claims System in dBase III / Clipper and similar languages. CRIS had also enabled Railways to establish a Smart Journey Planner call center for passengers to facilitate direct/indirect journey planning.",
                                                  textAlign: TextAlign.justify,
                                                )),
                                          ]),
                                    ])),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.lightBlueAccent,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              "Go To Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ]),
              ))),
    ));
  }
}
