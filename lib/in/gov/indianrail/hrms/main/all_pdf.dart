import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//import package files

//apply this class on home: attribute at MaterialApp()
class AllPDFList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllPDFList(); //create state
  }
}

class _AllPDFList extends State<AllPDFList> {
  late List<dynamic> files;
  List<dynamic> _searchResult = [];

  late Directory directory;
  String path = "";
  bool order = false;

  /*void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        //set fm.dirsTree() for directory/folder tree list
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
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

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state.
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
                files = files.reversed.toList();
              });
              //scaffoldKey.currentState.showSnackBar(snackBar);
            },
          )
        ]),
        body: files == null
            ? Text("Searching Files")
            : ListView.builder(
                // reverse: order,//if file/folder list is grabbed, then show here
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(files[index].path.split('/').last),
                    leading: Icon(Icons.picture_as_pdf),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      /*Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ViewPDF(pathPDF:files[index].path.toString());
                      //open viewPDF page on click
                    }));*/
                    },
                  ));
                },
              ));
  }
}

/*class ViewPDF extends StatelessWidget {
  String pathPDF = "";
  ViewPDF({this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold( //view PDF
        appBar: AppBar(
          title: Text("Document"),
          backgroundColor: Colors.lightBlueAccent,
        ),
        path: pathPDF
    );
  }

}*/
