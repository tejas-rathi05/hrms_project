import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemoState extends StatefulWidget {
  @override
  _DemoStateState createState() => _DemoStateState();
}

class _DemoStateState extends State<DemoState> {

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(child: Scaffold(
        body: Row(children: [
          Stack(children: [
            Text("sdhsjd"),
          ],)
         ],),

      ));
  }
}
