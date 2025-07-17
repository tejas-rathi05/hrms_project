import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootServices;

class Crop_Image extends StatefulWidget {
  File file, newFile;
  Crop_Image(this.file, this.newFile);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<Crop_Image> {
  late String path_image;

  /// Variables
  late File imageFile;
  late File croppedImage;
  late File file;

  /// Widget
  @override
  void initState() {
    _cropImage(widget.file.path);
    // TODO: implement initState
    super.initState();
  }

  Future getFile(String textmy) async {
    DateTime now = DateTime.now();
    late String path1;
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
        await Io.Directory('$path1/HRMS/CropedImages').create(recursive: true);
    file = File('${directory.path}/cropedImage_${now}.png');
    var base64str = base64.decode(textmy);
    await file.writeAsBytes(base64str);
    Navigator.pop(context, file);
    // Fluttertoast.showToast(
    //
    //     msg: 'Download/HRMS/CropedImages/cropedImage_${now}.png',
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIos: 15,
    //     backgroundColor: Colors.pinkAccent,
    //     textColor: Colors.white,
    //     fontSize: 14.0
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFF307777),
          title: Text("Image Cropper"),
        ),
        body: Container(
            child: imageFile == null
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Image Selected",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Column(children: <Widget>[
                    Image.file(
                      imageFile,
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                          style: FilledButton.styleFrom(
                              backgroundColor: Color(0xFF40C4FF)),
                          onPressed: () {
                            final bytes =
                                Io.File(croppedImage.path).readAsBytesSync();
                            String img64 = base64Encode(bytes);
                            getFile(img64);
                          }),
                    ),
                  ]))));
  }

  /// Get from gallery
  _getFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    late File file;
    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
    _cropImage(file);
  }

  /// Crop Image
  _cropImage(filePath) async {
    //PermissionHandler().requestPermissions([PermissionGroup.storage]);
    File _storedImage;

    //path_image = await ExtStorage.getExternalStoragePublicDirectory(
    // ExtStorage.DIRECTORY_DOWNLOADS);
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
        path_image = directory.path;
      }
    }
    Directory directory;

    croppedImage = (await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    )) as File;
    if (croppedImage != null) {
      directory = await Directory('$path_image/HRMS/CropedImages')
          .create(recursive: true);
      String path_image1 = directory.path;
      //  final File newImage = await imageFile.copy('$path_image1/image1.png');
      //  _storedImage = imageFile;

      //final fileName =imageFile.path.basename(filePath);

      // final savedImage = await filePath.copy('${directory.path}/TestMina');

      //File(directory.path).writeAsBytes(uint8List);

      // final  fileName = basename(imageFile.path);
      // final File localImage = await imageFile.copy('$path/$fileName');
      // _saveNetworkImage(imageFile.path);

      setState(() {
        imageFile = croppedImage;
        //_storedImage=newImage;
      });
    }
  }
}
