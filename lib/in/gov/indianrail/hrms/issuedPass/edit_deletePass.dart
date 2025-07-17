import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';

class CancelPass extends StatefulWidget {
  @override
  CancelPassState createState() => CancelPassState();
}

class SongDetail {
  String strTitle;
  String isFavorite;
  SongDetail(this.strTitle, this.isFavorite);
}

class CancelPassState extends State<CancelPass> {
  List<String> arrSongList = ["1023", "1024", "1025"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Edit/Delete Pass",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Column(children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  child: Text(
                    "Unique Pass No",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                ),
                new Container(
                  child: Text(
                    "Edit Pass",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                ),
                new Container(
                  child: Text(
                    "Delete Pass",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: arrSongList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    child: Container(
                        height: 45.0,
                        decoration: BoxDecoration(),
                        child: new Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 18.0, right: 15.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                    child: Text(
                                      arrSongList[index].toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0))),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                            passId: "1234",
                                          ),
                                        );
                                      });
                                    },
                                    child: new Container(
                                        margin: const EdgeInsets.all(0.0),
                                        child: new Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 30.0,
                                        )),
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialog(
                                            passId: "1234",
                                          ),
                                        );
                                      });
                                    },
                                    child: new Container(
                                        margin: const EdgeInsets.all(0.0),
                                        child: new Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 30.0,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 0.0),
                              child: Container(
                                height: 1.0,
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ),
            ),
          ])),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CustomDialog extends StatelessWidget {
  final String passId;

  CustomDialog({
    required this.passId,

    // @required this.hrmsId,
    //
    // @required this.description,
    // @required this.buttonText,

    // this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 15.0,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "APPLICATION FOR CANCELLATION OF PASS",
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: HexColor("#757171")),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Text(
                "Please fill the following details to apply for cancellation of pass",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Container(
                    child: Text(
                      "Unique Pass number :",
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "1234",
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // Unique Pass number
              //     : 11430
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Upload Approval Document *",
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlueAccent)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.lightBlueAccent)),
                            //             <--- BoxDecoration here
                            child: GestureDetector(
                                onTap: () async {
                                  Fluttertoast.showToast(
                                      msg: 'Please Wait...',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      //   timeInSecForIos: 5,
                                      backgroundColor: Colors.pink,
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                },
                                child: Text(
                                  "Choose File",
                                  style: TextStyle(fontSize: 10.0),
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "No file chosen",
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 40,
                              color: Colors.lightBlueAccent,
                              child: TextButton(
                                onPressed: () {
                                  //_getDocuments();
                                  //SystemChannels.textInput.invokeMethod('TextInput.hide');

                                  //uploadFile();
                                },
                                child: Text("Upload",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              Container(
                width: double.infinity,
                child: Text(
                  "In case of multiple documents, please merge all documents and then upload single pdf file. ",
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Reason for cancellation of Pass *",
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                maxLines: 10,
                enabled: true,
                style: TextStyle(fontSize: 13),
                maxLength: 400,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FilledButton(
                      //width: 120,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: Color(0xFF40C4FF)),
                      onPressed: () {}),
                  FilledButton(
                    //width: 100,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFF40C4FF)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              // SizedBox(height: 10.0),
              // Container(
              //     width: double.infinity,
              //     child: Text(
              //       hrmsId,
              //       style: TextStyle(
              //         fontSize: 13.0,
              //
              //
              //       ),
              //     )
              //
              // ),
              // SizedBox(height: 10.0),
              // Container(
              //   width: double.infinity,
              //   child:Text(
              //     "Password",
              //     style: TextStyle(
              //       fontSize:13.0,
              //       fontWeight: FontWeight.w700,
              //       color:HexColor("#00796B"),
              //
              //     ),
              //
              //   ),
              // ),
              // SizedBox(height: 10.0),
              // Container(
              //     width: double.infinity,
              //     child:Text(
              //       "Test@123",
              //       style: TextStyle(
              //         fontSize: 13.0,
              //
              //
              //       ),
              //     )
              // ),
              // SizedBox(height: 16.0),
              // Text(
              //   description,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 11.0,
              //       color:Colors.red
              //   ),
              // ),
              // SizedBox(height: 24.0),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //
              //       Navigator.push( context,
              //         MaterialPageRoute(builder: (context) => LoginPage()),
              //
              //
              //       );
              //
              //     },
              //     child: Text(buttonText,style: TextStyle(color:HexColor("#14598e"))),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
