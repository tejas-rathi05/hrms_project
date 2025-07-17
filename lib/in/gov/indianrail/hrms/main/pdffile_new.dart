//import 'package:compressimage/compressimage.dart';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/crop_image.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/imageSize.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/compressfile.dart';

import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../imageresize.dart';

class HomePDF_new extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePDF_new> {
  int? widthImage;
  List<File> _files = [];
  Directory? directory;
  TextEditingController nameController = TextEditingController();

  final pdf = pw.Document();
  Future<void> _showMyDialog(File file, int indexImage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please select a option for crop and resize Image.'),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        //foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: Text(
                        'Crop Image',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        File result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Crop_Image(file, file)),
                        );
                        setState(() {
                          _files[indexImage] = result;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        //foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: Text(
                        'Resize Image',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Imagecompress(file)),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancle',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  savePdfFile() async {
    DateTime now = DateTime.now();
    if (nameController.text.length == 0) {
      nameController.text = 'ESS_${now}';
    }
    var filename = nameController.text;
    String path = "";
    if(Platform.isAndroid) {
      // PermissionHandler().requestPermissions([PermissionGroup.storage]);
      /*Directory? externalStorageDirectory = await getExternalStorageDirectory();
      List<Directory>? externalStorageDirectories =
      await getExternalStorageDirectories();

      if (externalStorageDirectory != null) {
        print('External Storage Directory: ${externalStorageDirectory.path}');
      }

      if (externalStorageDirectories != null) {
        print('External Storage Directories:');
        for (Directory directory in externalStorageDirectories) {
          print(directory.path);
          path = directory.path;
        }
      }*/
      var status = await Permission.storage.request();
      if(status.isGranted){
        Directory? externalStorageDirectory =Directory(
            '/storage/emulated/0/Download/');
        path = externalStorageDirectory.path;
      }
    }
    else
    {
      final directory = await getTemporaryDirectory();
      path = directory.path;
    }
    directory = await Directory('$path/HRMS/ESS').create(recursive: true);
    final file = File('${directory!.path}/$filename.pdf');

    //await file.writeAsBytes( pdf.save() as List<int>);
    await file.writeAsBytes( await pdf.save());
    await OpenFilex.open('$path/HRMS/ESS/$filename.pdf');
    filename = "";
  }

  @override
  void initState() {
    ImageSize image = new ImageSize();
    widthImage = image.imageWidth;

    //getFiles(); //call getFiles() function on initial state.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              IconButton(
                onPressed: () async {
                  XFile? gallery;
                  gallery = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 400,
                      maxWidth: 400);
                    print('gallery ${gallery?.name}');
                    print('gallery mimeType $_files');
                    List<File> temp = _files;
                    String path = gallery!.path;
                    File file =File(path);
                    temp.add(file);
                    setState(() {
                      _files = temp;
                    });

                },
                icon: Icon(Icons.add_photo_alternate,
                    size: 30.0, color: Colors.lightBlueAccent),
              ),
              SizedBox(width: 8.0),
              IconButton(
                onPressed: () async {
                  XFile? cameraFile;
                  final picker = ImagePicker();
                  cameraFile = await picker.pickImage(
                      source: ImageSource.camera) ;

                    List<File> temp = _files;
                    String path = cameraFile!.path;
                    File file =File(path);
                    temp.add(file);

                    setState(() {
                      _files = temp;
                    });
                },
                icon: Icon(Icons.camera_alt,
                    size: 30.0, color: Colors.lightBlueAccent),
              ),
            ]),
            Expanded(
              child: Center(
                child: GridView.builder(
                  itemCount: _files.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return displaySelectedFile(_files[index], index);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 45,
                              margin: EdgeInsets.fromLTRB(10.0, 10, 150, 10),
                              child: TextButton(
                                onPressed: () {
                                  if (_files.length == 0) {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Image",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        // timeInSecForIos: 5,
                                        backgroundColor: Colors.pink,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                  } else {
                                    for (var i = 0; i < _files.length; i++) {
                                      final Uint8List imageBytes = File(_files[i].path).readAsBytesSync();
                                      var image = PdfImage.file(
                                        pdf.document,
                                       // bytes: File(_files[i].path).readAsBytesSync(),
                                        bytes: imageBytes,
                                      );

                                      pdf.addPage(
                                          pw.Page(
                                              pageFormat: PdfPageFormat.a4,
                                              build: (pw.Context context) {
                                                return pw.Center(
                                                    child: pw.Image(
                                                        pw.MemoryImage(imageBytes)));
                                              }
                                          )
                                      );
                                    }
                                    savePdfFile();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Get PDF',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                width: 1,
                                                color: HexColor("#ffffff")),
                                          ),
                                          height: 35,
                                          width: 60,
                                          child: Icon(
                                            FontAwesomeIcons.filePdf,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 8.0),
                          Text("Download/HRMS/ESS :"),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter Document Name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget displaySelectedFile(File file, int ImageIndex) {
    ImageSize image = new ImageSize();
    if (widthImage == null) {
      widthImage = 100;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        child: Container(
          height: 200.0,
          width: 200.0,
          child: GestureDetector(
              onTap: () {
                _showMyDialog(file, ImageIndex);
              },
              child: Column(
                children: <Widget>[
                  Image(
                      image: ResizeImage(FileImage(file),
                          width: widthImage, height: widthImage))
                ],
              )),
        ),
      ),
    );
  }
}
