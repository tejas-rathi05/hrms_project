import 'package:flutter/material.dart';
class Salary extends StatefulWidget{
  @override
  Salarystate createState()=>Salarystate();

}
class Salarystate extends State<Salary>{
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
        title: Text("Salary",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),

      ),
      body: Center(
          child:Image(image: new AssetImage("assets/images/underconstruction.gif")),

      ),
    );
  }

}