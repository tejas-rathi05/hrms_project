// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:math';
//
// Future<File> urlToFile(String imageUrl) async {
// // generate random number.
//   var rng = new Random();
// // get temporary directory of device.
//   Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//   String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//   File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// // call http.get method and pass imageUrl into it to get response.
//   http.Response response = await http.get(imageUrl);
// // write bodyBytes received in response to file.
//   await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//   return file;
// }

// import 'dart:io';
//
// import 'package:compressimage/compressimage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'compressfile.dart';
//
// class Save_compress extends StatefulWidget{
//   @override
//   Save_CompressState  createState() =>Save_CompressState();
//
// }
// class Save_CompressState extends State<Save_compress>{
//
//   List<File> _files = [];
//   File galary;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold (
//       body:Container(
//         child:Column(
//           children: <Widget>[
//             IconButton(
//
//               onPressed: () async{
//
//
//
//                 var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50 );
//
//                 setState(() {
//                   galary = image;
//                 //  GallerySaver.saveImage(galary.path);
//                   print('galary.path');
//                   print(galary.readAsBytesSync().length);
//                   if(galary!=null)
//                   {
//                     List<File> temp = _files;
//                     temp.add(galary);
//                     setState(() {
//                       _files = temp;
//                     });
//                   }
//                   //compressFile(galary);
//                 });
//              //   Navigator.push( context, MaterialPageRoute( builder: (context) => Imagecompress(galary)));
//
//
//
//               },
//
//
//
//               icon:Icon( Icons.add_photo_alternate,size: 30.0, color: Colors.lightBlueAccent),
//             ),
//             Expanded(
//               child: Center(
//                 child:GridView.builder(
//                   itemCount: _files.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                   ),
//                   itemBuilder: (context, index) {
//                     return displaySelectedFile(_files[index]);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//       ),
//     );
//
//   }
//   Widget displaySelectedFile(File file) {
//
//
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: SizedBox(
//
//         child: Container(
//
//           child:GestureDetector(
//               onTap: (){
//                 // Navigator.of(context).pop();
//
//                 Navigator.push( context,
//                   MaterialPageRoute(builder: (context) => Imagecompress(galary)),
//
//                 );
//                 // Navigator.of(context).pop();
//                 //ImageResize
//               },
//               child:Column(
//                 children: <Widget>[
//                   Container(child:  Image.file(galary),height: 200,width: 200,)
//
//                   // , width:widthImage, height:widthImage
//
//
//                   //Image.file(file),
//                   // Text('Resize'),
//                 ],
//               )
//           ),
//
//
//         ),
//
//       ),
//     );
//   }
// }