import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';


class FileList extends StatefulWidget {
  List<dynamic>? files;
 // FileList(this.files);
   FileList();
  @override
  _FileListState createState() => new _FileListState();
}

class _FileListState extends State<FileList> {
  List<FileSystemEntity> files = [];
  TextEditingController controller = new TextEditingController();

  Directory? directory;
  bool fileFlag = false;
  String path = "";
  bool order = false;
  late String FilePath;
  List<dynamic>? FileList;
  sharedpreferencemanager pref = sharedpreferencemanager();
  // Get json result and convert it to model. Then add
  void checkfileSize(String FilePath) async {
    final f = File(FilePath);
    int sizeInBytes = f.lengthSync();
    //double sizeInMb = sizeInBytes / (1024 * 1024);
    double sizeInKb = sizeInBytes / (1000);

    if (sizeInKb > 500) {
      FilePath = "";
      Fluttertoast.showToast(
          msg: "File size greater than 500kb. Please select another file.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pinkAccent,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      Navigator.pop(context, FilePath);
    }
  }

  /*void getFiles() async {
    //asyn function to get list of files
    //List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = await ExternalPath.getExternalStorageDirectories();
    //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root as String)); //
    FileList = await fm.filesTree(
        //sortedBy: FileManagerSorting.Alpha,
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
        );
    print('fileList $FileList');
    setState(() {
      //pr.hide();
    }); //update the UI
  }*/
  /*Future<void> getPath() async {
    List<String> paths;
    // getExternalStorageDirectories() will return list containing internal storage directory path
    // And external storage (SD card) directory path (if exists)
    paths = await ExternalPath.getExternalStorageDirectories();
    print('exPath $paths');
    var root = await getExternalStorageDirectory();
    FileList = await FileManager(root: Directory(root)).walk().toList();
    return files;
    setState(() {
      _exPath = paths; // [/storage/emulated/0, /storage/B3AE-4D28]
    });
  }*/

  /*Future<void> getPublicDirectoryPath() async {
    String path;

    path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    Directory directory = Directory(path);
    List<FileSystemEntity> files = directory.listSync();

    for(var file in files){
      if(file is File)
        {
          print("hi");
          Fluttertoast.showToast(
              msg: "file",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0);
        }
    }
    setState(() {
      print("yyy"+path); // /storage/emulated/0/Download
    });
  }
  */
  void getExternalStorageFiles() async {
    if(Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        Directory externalStorageDir = Directory(
            '/storage/emulated/0/Download/');
        List<FileSystemEntity>? _files;

        String directory  = await externalStorageDir.path;

        _files = Directory('/storage/emulated/0/Download/')?.listSync(
            recursive: true, followLinks: false);
        print('path1234 ${_files!.length}');
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: true,
          dialogTitle: 'Select PDF Files',
          withData: true,
          withReadStream: true,
          initialDirectory: directory,
        );
        for (FileSystemEntity file in _files) {
          if (file is File) {
            print('File: ${file.path}');
          } else if (file is Directory) {
            print('Directory: ${file.path}');
          }
        }
        setState(() {
          files = _files!;
          /*if (result != null) {
            setState(() {
              // Convert List<PlatformFile> to List<FileSystemEntity>
              files = result.files.map((file) => File(file.path??'')).toList();
            });
          }*/
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
    getExternalStorageFiles();
    //getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //widget.files.sort((a, b) => a.path.compareTo(b.path));
    if (fileFlag) {
      //getExternalStorageFiles();
      // pr.show();
    } /*else {
      FileList = widget.files;
    }*/
    return new Scaffold(
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
            //scaffoldKey.currentState.showSnackBar(snackBar);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.refresh,
            color: Colors.lightBlueAccent,
          ),
          onPressed: () {
            setState(() {
              //getFiles();
              fileFlag = true;
              Fluttertoast.showToast(
                  msg: "Please Wait...",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  //  timeInSecForIos: 15,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 14.0);

              //FileList=FileList.toList();
            });
            //scaffoldKey.currentState.showSnackBar(snackBar);
          },
        )
      ]),
      body: files == null
          ? Text("Searching Files")
          : new Column(
              children: <Widget>[
                new Container(
                  color: Colors.white,
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: controller,
                          decoration: new InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: files!.length,
                      itemBuilder: (context, index) {
                        if (controller.text.isEmpty) {
                          return ListTile(
                            title: Text(files![index].path.split('/').last),
                            onTap: () {
                              FilePath = files![index].path.toString();
                              checkfileSize(files![index].path);
                            },
                          );
                        } else if (files![index]
                                .path
                                .split('/')
                                .last
                                .toLowerCase()
                                .contains(controller.text) ||
                            files![index]
                                .toString()
                                .toLowerCase()
                                .contains(controller.text)) {
                          return ListTile(
                            title: Text(files![index].path.split('/').last),
                            onTap: () {
                              setState(() {
                                FilePath = files![index].path.toString();
                                checkfileSize(files![index].path);
                              });
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    setState(() {});
  }
}

List<dynamic> _searchResult = [];

