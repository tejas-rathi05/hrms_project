import 'package:flutter/material.dart';
class EmployeeMater extends StatefulWidget{
  @override
  EmployeeMaterstate createState()=>EmployeeMaterstate();

}
class EmployeeMaterstate extends State<EmployeeMater>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () { Navigator.of(context).pop();

          },
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Employee Master",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),


      ),
      body: Center(
        child:Image(image: new AssetImage("assets/images/underconstruction.gif")),
      ),
    );
  }

}