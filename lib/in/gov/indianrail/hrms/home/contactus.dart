import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

class Contact_us extends StatelessWidget {
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
          title: Text("Contact Us",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
        ),
        body: Container(
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: 200.0,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text(
                      "Helpdesk Contact Details",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Email-Id :  ',
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Text("irhrms@cris.org.in",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 13)),
                          /*Text("(",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue)),
                          GestureDetector(
                            onTap: () {
                              _emaillaunchURL('irhrms@cris.org.in',
                                  'HRMS email Id', 'Hello');
                            },
                            child: Text(
                              "click here",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          ),
                          Text(")",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue)),*/
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Help Document  :  ',
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Text("(",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue)),
                          GestureDetector(
                            onTap: () {
                              _launchURL();
                            },
                            child: Text(
                              "click here",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          ),
                          Text(")",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue)),
                        ],
                      ),
                    ),
                  ]),
            )));
  }

  _launchURL() async {
    //const url = 'https://flutter.dev';
    var url = 'http://bit.ly/38pOUfm';
    Uri uri = Uri.parse(url);
    //if (await canLaunchUrl(uri)) {

    await launchUrl(uri);
    //} else {}
  }

  _emaillaunchURL(String toMailId, String subject, String body) async {
    /*var url = 'mailto:$toMailId';
    Uri uri = Uri.parse(url);
    print('uri $uri');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }*/
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto:',
      path: toMailId,
      queryParameters: {
        'subject': 'CallOut user Profile',
        'body': 'Hi'
      },
    );
    launchUrl(emailLaunchUri);
  }
}
