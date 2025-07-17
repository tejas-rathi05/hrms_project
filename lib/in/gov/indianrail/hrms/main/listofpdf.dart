import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

//import package files

//apply this class on home: attribute at MaterialApp()
class MyPDFList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPDFList(); //create state
  }
}

class _MyPDFList extends State<MyPDFList> {
  List<dynamic>? files;
  Directory? directory;
  String path = "";
  bool order = false;

  /*void getFiles() async {
    //PermissionHandler().requestPermissions([PermissionGroup.storage]);//asyn function to get list of files
    path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    directory = await Directory('$path/ESS').create(recursive: true);

    var fm = FileManager(root: Directory(path)); //
    files = await fm.filesTree(
        excludedPaths: ["$path/ESS"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
        );
    setState(() {}); //update the UI
  }*/

  Future<List<File>> getFiles() async {
    List<File> fileList = [];

    Directory? externalStorageDir = await getExternalStorageDirectory();
    if (externalStorageDir != null) {
      Directory directory = Directory(externalStorageDir.path);
      List<FileSystemEntity> files = directory.listSync();

      for (FileSystemEntity file in files) {
        if (file is File) {
          fileList.add(file);
        }
      }
    }

    return fileList;
  }

  void getExternalStorageFiles() async {
    if(Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        Directory externalStorageDir = Directory(
            '/storage/emulated/0/Download/');
        List<FileSystemEntity>? _files;
        print('extn $externalStorageDir');
        print('path $externalStorageDir');
        print('path ${externalStorageDir?.path}');

        print('path23 ${externalStorageDir?.parent.parent.parent}');
        bool? res = await externalStorageDir?.exists();
        Fluttertoast.showToast(
            msg: "Storage Directory Exists..$res",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //  timeInSecForIos: 15,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
        print('now exists $res');
        print('path123 ${externalStorageDir?.path}');
        _files = Directory('/storage/emulated/0/Download/')?.listSync(
            recursive: true, followLinks: false);
        print('path1234 ${_files!.length}');
        for (FileSystemEntity file in _files) {
          if (file is File) {
            print('File: ${file.path}');
          } else if (file is Directory) {
            print('Directory: ${file.path}');
          }
        }
        setState(() {
          files = _files!;
        });
        print("files:-> $files");
      }
      else {
        print('Permission denied');
      }
    }
    else {
      // List<FileSystemEntity> FileList;
      final directory = await getTemporaryDirectory();
      final dir = directory.path;
      String pdfDirectory = '$dir/';
      print("pdfDirectory:-> $pdfDirectory");
      final myDir = Directory(pdfDirectory);

      bool hasExisted = await myDir.existsSync();
      if (hasExisted) {
        //files = myDir.listSync(recursive: true, followLinks: false);
        files = myDir.listSync();
        setState(() {
          files = files!;
        });
      } else {}

      print("files:-> $files");
    }

  }


  @override
  void initState() {
   // getFiles(); //call getFiles() function on initial state.
    getExternalStorageFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.lightBlueAccent,
            ),
            onPressed: () {
              setState(() {
                files = files!.reversed.toList();
              });
            },
          )
        ]),
        body: files == null
            ? Text("Searching Files")
            : ListView.builder(
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(files![index].path.split('/').last),
                    leading: Icon(Icons.picture_as_pdf),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.redAccent,
                    ),
                  ));
                },
              ));
  }
}
