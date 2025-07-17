import 'package:flutter/material.dart';

class About_us extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("About Us",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: 78.0,
                    width: 78.0,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: new AssetImage(
                          'assets/images/railway.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "HRMS application is being developed for 12.5 lac employee of Indian railways With this app, an employee will be able to view his/her historical data since the date of joining in Indian Railways including details related to increments, postings, leaves, promotions, awards, training, transfers etc.",
                      style: TextStyle(fontSize: 15),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "Major Benefits of of HRMS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "1. Employee Empowerment as all information and processes will be available online.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Text(
                    "2. Information Transparency for Employee.",
                    style: TextStyle(fontSize: 15),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Text(
                    "3. Single Sign-on for Employee for all HR related software in IR.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Text(
                    "4. Ease of Access for Employee.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Text(
                    "5. Decision Enabler for Management.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Text(
                    "6. MIS at a click for Management.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Center(
                  child: Container(
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
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "Developed by CRIS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                      "CRIS (Centre for Railway Information Systems) is an organization under Ministry of Railways. CRIS is a unique combination of competent IT professionals and experienced Railway personnel enabling it to deliver complex Railway IT systems with stupendous success in core areas. Since its inception, CRIS is developing/maintaining softwares for the following key functional areas of the Indian Railways"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
