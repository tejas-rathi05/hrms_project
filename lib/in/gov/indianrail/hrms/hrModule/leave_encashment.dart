import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';

class Leave_Encashment extends StatefulWidget {
  @override
  Leave_Encashmentstate createState() => Leave_Encashmentstate();
}

class Leave_Encashmentstate extends State<Leave_Encashment> {
  var amount = 0.0;
  TextEditingController basicPay = TextEditingController();
  TextEditingController da_rate = TextEditingController();
  TextEditingController number_of_days = TextEditingController();
  bool checkBoxValue = false;
  Future calculate_leave() async {
    if (basicPay.text.length == 0) {
      var paylent = basicPay.text.length;
      Fluttertoast.showToast(
          msg: 'Please Enter Basic Pay',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (int.parse(basicPay.text) <= 18000 ||
        int.parse(basicPay.text) > 225000) {
      Fluttertoast.showToast(
          msg: 'Basic pay  should  be grater than 18000 and less than 225000',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (da_rate.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter DA Rate',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (number_of_days.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Number of days',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (int.parse(number_of_days.text) <= 0 ||
        int.parse(number_of_days.text) > 10) {
      Fluttertoast.showToast(
          msg: 'Number Of Days should be between 1 and 10 only.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 5,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      var numberOfDays = int.parse(number_of_days.text);
      var daRate = int.parse(da_rate.text);
      var basic_pay = int.parse(basicPay.text);
      setState(() {
        amount =
            numberOfDays * ((basic_pay + (basic_pay * (daRate / 100))) / 30);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Leave Encashment",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: <Widget>[
                  Column(children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text("Leave Encashment"),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      width: 400,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                      child: Text(
                                        'Enter Your Basic Pay :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: TextField(
                                      controller: basicPay,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0",
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                      ),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                      child: Text(
                                        'DA Rate :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: TextField(
                                      controller: da_rate,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter(
                                            new RegExp(
                                                r'[+-]?([0-9]*[.])?[0-9]+'),
                                            allow: true)
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0",
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                      ),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                      child: Text(
                                        'Number of Days :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: TextField(
                                      controller: number_of_days,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0",
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                      ),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.5, horizontal: 45.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                child: Text(
                                  'Leave Encashment:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                child: Text(
                                  amount.toStringAsFixed(3).toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45.0,
                      margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.lightBlueAccent,
                        child: Container(
                          decoration: BoxDecoration(),
                          child: MaterialButton(
                            onPressed: () {
                              calculate_leave();
                            },
                            child: Text(
                              "Calculate",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
