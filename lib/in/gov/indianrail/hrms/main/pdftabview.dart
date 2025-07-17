import 'package:flutter/material.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/pdffile_new.dart';

import 'listofpdf.dart';





class PdfTabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            bottom: TabBar(
              tabs: [
                Tab(text: "Generate PDF",),
                Tab(text: "PDF List",),

              ],
            ),

          ),
          body: TabBarView(
            children: [
              Container(child:HomePDF_new()),
              Container(child:MyPDFList()),

            ],
          ),
        ),
      ),
    );
  }
}