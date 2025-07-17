import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'package:url_launcher/url_launcher.dart';

class HelpVideoLink extends StatefulWidget {
  @override
  HelpVideoLinkState createState() => new HelpVideoLinkState();
}

class HelpVideoLinkState extends State<HelpVideoLink> {
  List<String> notes = [
    "Introduction HRMS Employee Mobile Application with new Modules",
    "ESS module: To view and edit Employee data",
    "Retired employee: How to change Mobile no",
    "Office Order Signature location help",
    "Pass Application for Retired Employee",
    "How to Fill APAR Online in HRMS Application",
    "How to Apply for PF in Mobile App",
    "Change Your Mobile in HRMS in Mobile App directly",
    "Change Your Mobile in HRMS Website in 1 Minute. (No ESS)",
    "How to View and Edit Your basic detail in ESS ?",
    "How to Change Personal Details Indian Railway HRMS Mobile App ",
    "How to Know you Login ID & Password in Mobile App",
    "How to use Digital Sign in Office Order ? (English)",
    "Grievance Module Training ",
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Help Videos",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, position) {
              return Card(
                child: GestureDetector(
                  child: ListTile(
                    leading: Icon(
                      Icons.play_circle_fill,
                      color: Colors.lightBlueAccent,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[300],
                      size: 20,
                    ),
                    title: Text(notes[position].toString()),
                    onTap: () {
                      //boolList[index] = !boolList[index];
                      if (position == 0) {
                        _launchURL("https://youtu.be/ZVES5D8oB24");
                      }
                      else if (position == 1) {
                        _launchURL("https://youtu.be/VPUFkpTF5fY");
                      }
                      else if (position == 2) {
                        _launchURL("https://youtu.be/QZtXe3-erGY");
                      }
                      else if (position == 3) {
                        _launchURL("https://youtu.be/NImqcp_G-qE");
                      }
                      else if (position == 4) {
                        _launchURL("https://youtu.be/DiOFHJifE8c");
                      }
                      else if (position == 5) {
                        _launchURL("https://youtu.be/Kk-SgjoyULU");
                      }
                      else if (position == 5) {
                        _launchURL("https://youtu.be/ZVES5D8oB24");
                      }
                      // else  if(position==6){
                      //   _launchURL("https://youtu.be/Lrx3VnW4M_g");
                      // }
                      else if (position == 7) {
                        _launchURL("https://youtu.be/RAhYTFA-0LE");
                      }
                      else if (position == 8) {
                        _launchURL("https://youtu.be/QXpThS5rDU0");
                      }
                      else if (position == 9) {
                        _launchURL("https://youtu.be/Chl0mwiUkt4");
                      }
                      else if (position == 10) {
                        _launchURL("https://youtu.be/FW_awd2NuHs");
                      }
                      else if (position == 11) {
                        _launchURL("https://youtu.be/vE35IaGB9Lw");
                      }
                      else if (position == 12) {
                        _launchURL("https://youtu.be/M2f3MpQkWh0");
                      }
                      else if (position == 13) {
                        _launchURL("https://www.youtube.com/watch?v=_BUmD9UXMYk");
                      }
                    },
                  ),
                ),
              );
            },
          ),
    );
  }

  _launchURL(urlvideolink) async {
    if (!await launchUrl(Uri.parse(urlvideolink),mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlvideolink');
    }
  }
}
