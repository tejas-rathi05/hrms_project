import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'imageSize.dart';
import 'main/pdftabview.dart';

class ImageResize extends StatefulWidget {
  File file;
  List<File> _files;
  ImageResize(this.file, this._files);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<ImageResize> {
  RangeLabels labels = RangeLabels('100', "1000");
  RangeValues values = RangeValues(100, 1000);
  int imagesize = 100;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Resize Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Column(
            children: <Widget>[
              Image(
                  image: ResizeImage(FileImage(widget.file),
                      width: imagesize, height: imagesize)),
              RangeSlider(
                  divisions: 5,
                  activeColor: Colors.red[700],
                  inactiveColor: Colors.red[300],
                  min: 100,
                  max: 1000,
                  values: values,
                  labels: labels,
                  onChanged: (value) {
                    var typesize = value;

                    setState(() {
                      ImageSize image_Size = new ImageSize();
                      values = value;
                      image_Size.image_width = value.start.toInt();

                      labels = RangeLabels(value.start.toInt().toString(),
                          value.end.toInt().toString());
                    });
                  }),
              Center(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PdfTabBarDemo()),
                    );
                  },
                  //width: 200,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                      backgroundColor: Color(0xFF40C4FF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
