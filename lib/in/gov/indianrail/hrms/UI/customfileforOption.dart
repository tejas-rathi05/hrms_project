import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/pdffile_new.dart';

class CustomOption extends StatelessWidget {
  var title, icon, screen;
  CustomOption(this.title, this.icon, this.screen);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 55,
            margin: EdgeInsets.all(30.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePDF_new()),
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Create Document',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(width: 1, color: HexColor("#ffffff")),
                        ),
                        height: 35,
                        width: 90,
                        child: Icon(
                          FontAwesomeIcons.calculator,
                          color: Colors.lightBlueAccent,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
