import 'package:flutter/material.dart';
class Non_GazettedOfficerApar extends StatefulWidget{
  @override
  Non_GazettedOfficerstate createState()=>Non_GazettedOfficerstate();

}
class Non_GazettedOfficerstate extends State<Non_GazettedOfficerApar>{
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
        title: Text("Self Appraisal",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),

      ),
      body: Center(
          child:Image(image: new AssetImage("assets/images/underconstruction.gif")),

      ),
    );
  }

}