import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart' ;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../login/security/hrmstokenplugin.dart';
import '../util/apiurl.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
QRViewController? controller;
  String connectivity_check="";
//final ImagePicker _picker = ImagePicker();
bool isFlashOn = false;
String qrCodeResult = "No result";
String fileEncString="";
  String imageEncString="";
  late Directory directory;
  late String hrmsId = "", path = "";

  Uint8List? _bytesImage;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
void dispose() {
  controller?.dispose();
  _connectivitySubscription.cancel();
  super.dispose();
}
  void initState() {
    getPath();
    //_testing();
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    // _connectivity.initialise();
    /*_connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });*/
    // _checkInitialConnectivity();
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   _updateConnectionStatus(result);
    // });
  }
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      print('No internet connection');
    } else {
      print('Connected: ${results.join(", ")}');
    }
  }
  Future<void> getPath() async {
    //path = await ExtStorage.getExternalStoragePublicDirectory(
    //  ExtStorage.DIRECTORY_DOWNLOADS);
    if (Platform.isAndroid) {
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
          path = directory.path;
        }
      }
    } else {
      // for ios
      await getApplicationDocumentsDirectory();
    }
    //print(check_offier);
  }

  Future<void> _checkInitialConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  // void _updateConnectionStatus(ConnectivityResult result) {
  //   setState(() {
  //     if (result == ConnectivityResult.mobile) {
  //       connectivity_check = "Online";
  //     } else if (result == ConnectivityResult.wifi) {
  //       connectivity_check = "Online";
  //     } else {
  //       connectivity_check = "Offline";
  //     }
  //   });
  //   print('sourceConn: $connectivity_check'); // Print the current connection status
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("QR Scanner"),
      actions: [
        IconButton(
          icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
          onPressed: () async {
            if(controller!=null){
              await controller!.toggleFlash();
              bool? flashStatus=await controller?.getFlashStatus();
              setState(() {
              isFlashOn = flashStatus ?? false;
                if(isFlashOn) {
                  Fluttertoast.showToast(
                    msg: "Flashed"  ,
                    toastLength: Toast.LENGTH_SHORT,
                    // Duration of the toast
                    gravity: ToastGravity.BOTTOM,
                    // Position of the toast
                    backgroundColor: Colors.blueAccent,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }else
                  {
                    Fluttertoast.showToast(
                      msg: "Not Flashed"  ,
                      toastLength: Toast.LENGTH_SHORT,
                      // Duration of the toast
                      gravity: ToastGravity.BOTTOM,
                      // Position of the toast
                      backgroundColor: Colors.blueAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
              });
            }
          },
        ),
      ],
    ),
    body: Column(
      children: <Widget>[
        /*Expanded(
          flex: 5,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Chip(
                label: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.blueAccent,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 180,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),*/
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey, // Set the background color to grey
            child: Center(
                child:  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height, // Set height to screen size
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300,
                      ),
                    ),
                  ),
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scanned QR Code Result:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                qrCodeResult,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              /*ElevatedButton(
                onPressed: () {
                  print("Upload QR Scanner page action");
                  //pickImageAndDetectQR();
                },
                child: Text('Upload QR Scanner Page'),
              ),*/
            ],
          ),
        ),
      ],
    ),
  );
}

void _onQRViewCreated(QRViewController controller) {
  bool isScanInProgress = false;
  this.controller = controller;
 /* controller.scannedDataStream.listen((scanData) {
    _handleScan(scanData.code);
  });*/
  if (connectivity_check == "Online") {
    controller.scannedDataStream.listen((scanData) {
      if (!isScanInProgress && scanData.code != null) {
        isScanInProgress =
        true; // Set the flag to true to prevent further scans
        _handleScan(scanData.code);

        // Optionally, stop the QRView to prevent further scans
        controller.pauseCamera();
      }
    });
  }else{
    Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

  Future<void> _handleScan(String? qrData) async {

    final String url =
    new UtilsFromHelper().getValueFromKey("qrdata_url");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "encryptedQrCode": qrData,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

     String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;

    print('responseQrCode $responseJSON');

    try {
      if (responseJSON['status'] == "1") {
        setState(() async {
          // qrCodeResult = qrData!;
          qrCodeResult = responseJSON["message"] ?? '';
          Map<String, dynamic> decodedData = json.decode(responseJSON['decryptedData']);

          var referId = decodedData['referId'].toString();
          bool downloadAvailable = responseJSON['downloadAvailable'] ?? false; // Check for download availability

          print(referId);

          Fluttertoast.showToast(
              msg: "Processing, Please wait...!"+referId,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);

          // Show dialog if required
          //show image
          if(responseJSON['imageStr'] != '[]' &&
              responseJSON['imageStr'] != null){
            String image = responseJSON['imageStr'];
              // Decode the Base64 string to a regular string
              setState(() {
                _bytesImage = Base64Decoder().convert(image);
              });
            } else {
              setState(() {
                _bytesImage = null;
              });
          }
          if(downloadAvailable) {
            if(responseJSON['showDialog'] == false) {
              if (responseJSON['fileString'] != '[]' &&
                  responseJSON['fileString'] != null) {
                String filepdf = responseJSON['fileString'];
                if (Platform.isAndroid) {
                  await _write(filepdf, referId);
                  Fluttertoast.showToast(
                      msg: "Downloaded Successfully:" +
                          directory.path +
                          '/Hrms_QrScanner${referId}.pdf',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.pinkAccent,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {
                  await _ioswrite(filepdf, referId);
                  Fluttertoast.showToast(
                      msg: "Downloaded Successfully",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.pinkAccent,
                      textColor: Colors.white,
                      fontSize: 14.0);
                }
              } else {
                Fluttertoast.showToast(
                    msg: 'Download Failed. Please try later',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 14.0);
              }
            }else{
              //show Dialog true and download
              setState(() {
                fileEncString =responseJSON['fileString'];
              });
                Map<String, dynamic> contentData = json.decode(responseJSON['content']);
                _showResultDialog(context,referId,fileEncString,downloadAvailable, contentData);

            }
          }
          else
          {
            //if download is not available
            if (responseJSON['showDialog'] == true) {
              Map<String, dynamic> contentData = json.decode(responseJSON['content']);
              _showResultDialog(context,referId,fileEncString,downloadAvailable,contentData);
            }
          }
        });
      } else {
        setState(() {
          qrCodeResult = responseJSON["message"] ?? '';
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: responseJSON['message'],
              onConfirmBtnTap: ()  {
                Navigator.of(context).pop();
              }
          );
        });
      }
    }catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: responseJSON['message'],
          onConfirmBtnTap: ()  {
            Navigator.of(context).pop();
          }
      );
      throw Exception(e);
    }
  }



  Future<void> _testing() async {



 // String value = await response.transform(utf8.decoder).join();
  //var responseJSON = json.decode(value) as Map;
    String value = '''{
    "decryptedData": "{\\"key\\":\\"CHP\\", \\"hrmsId\\": \\"HOGBQI\\", \\"referId\\":13048}",
    "showDialog": true,
    "downloadAvailable": false,
    "message": "Success",
    "content": "{\\"member_photo\\":\\"Employee_Personal_details/AAAAIN_025.jpg\\",\\"dialog_content\\":[{\\"UPN\\":13048,\\"Pass Type\\":\\"CHEQUE PASS\\",\\"Validity Period\\":\\"13/10/2024 - 20/10/2024\\",\\"Attendant Allowed\\":\\"YES\\",\\"Class\\":\\" First Class \\",\\"Luggage Allowance\\":\\"70 kg per adult (1/2 per child)\\"}]}",
    "status": "1"
    }''';
  var responseJSON = json.decode(value) as Map;
  print('responseQrCode $responseJSON');

  try {
    if (responseJSON['status'] == "1") {
      setState(() async {
       // qrCodeResult = qrData!;
        qrCodeResult = responseJSON["message"] ?? '';
        Map<String, dynamic> decodedData = json.decode(responseJSON['decryptedData']);

        var referId = decodedData['referId'].toString();
        bool downloadAvailable = responseJSON['downloadAvailable'] ?? false; // Check for download availability

        print(referId);

          Fluttertoast.showToast(
              msg: "Processing, Please wait...!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 14.0);

        // Show dialog if required

       if(downloadAvailable) {
        if(responseJSON['showDialog'] == false) {
          if (responseJSON['fileString'] != '[]' &&
              responseJSON['fileString'] != null) {
            String filepdf = responseJSON['fileString'];
            if (Platform.isAndroid) {
              await _write(filepdf, referId);
              Fluttertoast.showToast(
                  msg: "Downloaded Successfully:" +
                      directory.path +
                      '/Hrms_QrScanner${referId}.pdf',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.pinkAccent,
                  textColor: Colors.white,
                  fontSize: 14.0);
            } else {
              await _ioswrite(filepdf, referId);
              Fluttertoast.showToast(
                  msg: "Downloaded Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.pinkAccent,
                  textColor: Colors.white,
                  fontSize: 14.0);
            }
          } else {
            Fluttertoast.showToast(
                msg: 'Download Failed. Please try later',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        }else{
          setState(() {
             fileEncString =responseJSON['fileString'];
           });
          if (responseJSON['showDialog'] == true) {
            // Decode the content
            Map<String, dynamic> contentData = json.decode(responseJSON['content']);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showResultDialog(
                  context, referId, fileEncString, downloadAvailable,
                  contentData);
            });
          }
        }
       }
       else
         {
           //if download is not available
           if (responseJSON['showDialog'] == true) {
             Map<String, dynamic> contentData = json.decode(responseJSON['content']);
             WidgetsBinding.instance.addPostFrameCallback((_) {
               _showResultDialog(
                   context, referId, fileEncString, downloadAvailable,
                   contentData);
             });
           }
         }
      });
    } else {
      setState(() {
        qrCodeResult = responseJSON["message"] ?? '';
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: responseJSON['message'],
            onConfirmBtnTap: ()  {
              Navigator.of(context).pop();
            }
        );
      });
    }
  }catch (e) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        text: responseJSON['message'],
        onConfirmBtnTap: ()  {
          Navigator.of(context).pop();
        }
    );
    throw Exception(e);
  }
}

Future _write(String textmy, String referId) async {
  directory = await Directory('$path/HRMS').create(recursive: true);
  final File file = File('${directory.path}/Hrms_QrScanner${referId}.pdf');
  var base64str = base64.decode(textmy);

  await file.writeAsBytes(base64str);
  await OpenFilex.open('$path/HRMS/Hrms_QrScanner${referId}.pdf');
  Fluttertoast.showToast(
      msg: "Downloaded Successfully:" +
          directory.path +
          '/Hrms_QrScanner${referId}.pdf',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.pinkAccent,
      textColor: Colors.white,
      fontSize: 14.0);
}

Future _ioswrite(String textmy, String referId) async {
  Directory directory = await getTemporaryDirectory();
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  final File file = File(directory.path + "/Hrms_QrScanner${referId}.pdf");
  print("Directory Path : $directory");
  print("Directory file : $file");
  var base64str = base64.decode(textmy);
  print(" $textmy");
  await file.writeAsBytes(base64str);
  var existsSync = file.existsSync();
  print("$existsSync");

  await OpenFilex.open(directory.path + "/Hrms_QrScanner${referId}.pdf");
}
  void _showResultDialog(BuildContext context,var referId,String fileEncString,
      bool downloadAvailable, Map<String, dynamic> data) {
    // Assuming the profile picture URL is part of the data
    //String memberPhoto = data['member_photo'] ?? ''; // Update this key if necessary
      // Extract the dialog content
      List<dynamic> dialogContent = data['dialog_content'] ?? [];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Information'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Picture
                 // if (data['member_photo'] != null && data['member_photo']!.isNotEmpty)
                   /* Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          margin: EdgeInsets.fromLTRB(0, 140, 0, 0),
                          child: GestureDetector(
                            child: CircleAvatar(
                              child: _bytesImage == null
                                  ? new CircleAvatar(
                                backgroundImage:
                                new AssetImage('assets/images/noimage.png'),
                                radius: 100.0,
                              )
                                  : new CircleAvatar(
                                backgroundImage: MemoryImage(_bytesImage!),
                                radius: 100.0,
                              ),
                            ),
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        )
                    ),*/
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: _bytesImage == null
                                  ? AssetImage('assets/images/noImage.png') as ImageProvider<Object>
                                  : MemoryImage(_bytesImage!) as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /* Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: AssetImage(data['member_photo']), // Replace with NetworkImage if needed
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),*/

                  SizedBox(height: 16),

                  // Dynamic content display
                  for (var item in dialogContent)
                    for (var entry in item.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: RichText(
                          text: TextSpan(
                            text: '${entry.key}: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Key color
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${entry.value}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black, // Value color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  SizedBox(height: 16),

                  // Download button if available
                  if (downloadAvailable)
                    TextButton(
                      onPressed: () async {
                        print('Download button pressed');
                        downloadPDF(referId,fileEncString);
                      },
                      style: TextButton.styleFrom(
                          elevation: 5,
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(
                              fontSize: 24, fontStyle: FontStyle.normal)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // To make the button size fit its content
                        children: [
                          Icon(Icons.picture_as_pdf, color: Colors.white), // PDF icon
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'Download',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  Future<void> downloadPDF(var referId,String fileEncString) async {

    if (fileEncString != '[]') {
      if (Platform.isAndroid) {
        await _write(fileEncString, referId);
        Fluttertoast.showToast(
            msg: "Downloaded Successfully:" +
                directory.path +
                '/Hrms_QrScanner${referId}.pdf',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        await _ioswrite(fileEncString, referId);
        Fluttertoast.showToast(
            msg: "Downloaded Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pinkAccent,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Download Failed. Please try later',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

// Function to pick image from gallery and detect QR code
/*Future<void> pickImageAndDetectQR() async {
  final XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 600,
    maxHeight: 600,
    imageQuality: 80,
  );

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    String fileExtension = pickedFile.path.split('.').last.toLowerCase();

    // Check if file is .jpg or .jpeg
    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      // Implement QR code detection here (using qr_code_scanner or firebase_ml_vision)
      String qrCodeInImage = await detectQRCodeInImage(file);
      if (qrCodeInImage.isNotEmpty) {
        setState(() {
          qrCodeResult = qrCodeInImage;
          _handleScan(qrCodeResult);
        });
      } else {
        setState(() {
          qrCodeResult = "Error: No QR code found in the selected image.";
          QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              text: qrCodeResult,
              onConfirmBtnTap: ()  {
                Navigator.of(context).pop();
              }
          );
        });
      }
    } else {
      setState(() {
        qrCodeResult = "Error: Only .jpg or .jpeg files are allowed.";
        QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: qrCodeResult,
            onConfirmBtnTap: ()  {
              Navigator.of(context).pop();
            }
        );
      });
    }
  }
}*/

/*Future<String> detectQRCodeInImage(File imageFile) async {
  final inputImage = mlkit.InputImage.fromFile(imageFile);

  // Initialize the barcode scanner
  final barcodeScanner = mlkit.GoogleMlKit.vision.barcodeScanner();

  // Perform barcode scanning on the image
  final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(inputImage);

  // Close the scanner after use
  await barcodeScanner.close();

  // Check if any QR codes were found
  if (barcodes.isEmpty) {
    return ""; // No QR code found
  }

  // Extract the first QR code data from the list of barcodes
  for (mlkit.Barcode barcode in barcodes) {
    if (barcode.format == mlkit.BarcodeFormat.qrCode) {
      // Use rawValue to get the actual content of the QR code
      return barcode.rawValue ?? ""; // Return the QR code data
    }
  }

  return "";
}*/

}


