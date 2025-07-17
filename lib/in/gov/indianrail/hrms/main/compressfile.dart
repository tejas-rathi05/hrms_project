import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class Imagecompress extends StatefulWidget {
  Io.File Image_file;
  Imagecompress(this.Image_file);
  @override
  Save_CompressState createState() => Save_CompressState();
}

class Save_CompressState extends State<Imagecompress> {
  RangeLabels labels = RangeLabels('10', "100");
  RangeValues values1 = RangeValues(10, 100);
  int quality_range = 100;
  late Io.Directory directory;
  var beforeCompress, afterCompress = "0";
  late File image13;
  Future getFile(String textmy) async {
    DateTime now = DateTime.now();
    //String path1 = await ExtStorage.getExternalStoragePublicDirectory(
    //    ExtStorage.DIRECTORY_DOWNLOADS);
    String path1 = "";
    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    List<Directory>? externalStorageDirectories =
        await getExternalStorageDirectories();

    if (externalStorageDirectory != null) {
      print('External Storage Directory: ${externalStorageDirectory.path}');
    }

    if (externalStorageDirectories != null) {
      print('External Storage Directories:');
      for (Directory directory in externalStorageDirectories) {
        print(directory.path);
        path1 = directory.path;
      }
    }
    Io.Directory directory =
        await Io.Directory('$path1/HRMS/ResizedImages').create(recursive: true);

    final File file = File('${directory.path}/resizedImage_${now}.png');
    var base64str = base64.decode(textmy);
    await file.writeAsBytes(base64str);
    Fluttertoast.showToast(
        msg: 'Download/HRMS/ResizedImages/resizedImage_${now}.png',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 15,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
    //Navigator.pop(context);
  }

  /*Future<Io.File> compressFile(Io.File file) async {
    Io.File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: quality_range);

    setState(() {
      image13 = compressedFile;
      afterCompress = filesize(compressedFile.readAsBytesSync().length);

      final bytes = Io.File(compressedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);

      getFile(img64);
    });

    setState(() {});
    return compressedFile;
  }
*/
  @override
  Widget build(BuildContext context) {
    beforeCompress = filesize(widget.Image_file.readAsBytesSync().length);
    image13 = widget.Image_file;
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),

          Image.file(image13),
          SizedBox(
            height: 10,
          ),

          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'File Size : $beforeCompress',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File Compress Size $afterCompress'),
                  ),
                ],
              )),

          SizedBox(
            height: 10,
          ),
          RangeSlider(
              divisions: 5,
              activeColor: Colors.red[700],
              inactiveColor: Colors.red[300],
              min: 10,
              max: 100,
              values: values1,
              labels: labels,
              onChanged: (value) {
                setState(() {
                  quality_range = value.start.toInt();
                  values1 = value;
                  labels = RangeLabels(value.start.toInt().toString(),
                      value.end.toInt().toString());
                });
              }),

          Center(
            child: FilledButton(
                child: Text(
                  'Save Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                style:
                    FilledButton.styleFrom(backgroundColor: Color(0xFF40C4FF)),
                onPressed: () {
                  setState(() {
                    //compressFile(widget.Image_file);
                  });
                }),
          ),
          //  FlatButton(onPressed: (){
          //   compressFile(widget.Image_file);
          // }, child: Text(
          //   'Save Image'
          // ))
        ],
      )),
    );
  }
}
