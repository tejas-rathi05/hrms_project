import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/config/ColorSet.dart';

class Advance_car_pc extends StatefulWidget {
  @override
  Advance_car_pcstate createState() => Advance_car_pcstate();
}

class Advance_car_pcstate extends State<Advance_car_pc> {
  bool checkBoxValue = false;
  TextEditingController instalment_car = TextEditingController();
  TextEditingController instalment_pc = TextEditingController();
  TextEditingController instalment_scooter = TextEditingController();

  TextEditingController intr_rate_car = TextEditingController();
  TextEditingController intr_rate_pc = TextEditingController();
  TextEditingController intr_rate_scooter = TextEditingController();

  TextEditingController sanc_amt_car = TextEditingController();
  TextEditingController sanc_amt_pc = TextEditingController();
  TextEditingController sanc_amt_scooter = TextEditingController();

  TextEditingController intrestAmtcar = TextEditingController();
  TextEditingController intrestAmtpc = TextEditingController();
  TextEditingController intrestAmtscooter = TextEditingController();

  TextEditingController total_amt_car = TextEditingController();
  TextEditingController total_amt_pc = TextEditingController();
  TextEditingController total_amt_scooter = TextEditingController();

  Future calculate() async {
    if (instalment_car.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Instalment Car',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (instalment_pc.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Instalment PC',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (instalment_scooter.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Instalment Scooter',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (intr_rate_car.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Intr Car',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (intr_rate_pc.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Intr PC',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (intr_rate_scooter.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Intr Scooter',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (sanc_amt_car.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Sanc Amt Car',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (sanc_amt_pc.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Sanc Amt PC',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else if (sanc_amt_scooter.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please Enter Sanc Amt Scooter',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      var scanAmt_car = int.parse(sanc_amt_car.text);
      var instalmentCar = int.parse(instalment_car.text);
      var intr_ratecar = int.parse(intr_rate_car.text);
      var sancAmt_pc = int.parse(sanc_amt_pc.text);
      var instalmentPc = int.parse(instalment_pc.text);
      var intr_ratePc = int.parse(intr_rate_pc.text);
      var sancAmt_scooter = int.parse(sanc_amt_scooter.text);
      var instalmentScooter = int.parse(instalment_scooter.text);
      var intrRate_scooter = int.parse(intr_rate_scooter.text);

      var intrest_car =
          scanAmt_car * (instalmentCar / 2) * (1 / 12) * (intr_ratecar / 100);
      var intrest_pc =
          (sancAmt_pc * (instalmentPc / 2) * (1 / 12) * (intr_ratePc / 100));
      var intrest_scooter = (sancAmt_scooter *
          (instalmentScooter / 2) *
          (1 / 12) *
          (intrRate_scooter / 100));
      intrestAmtcar.text = intrest_car.toStringAsFixed(3).toString();
      intrestAmtpc.text = intrest_pc.toStringAsFixed(3).toString();
      intrestAmtscooter.text = intrest_scooter.toStringAsFixed(3).toString();

      var tot_car = intrest_car + scanAmt_car;
      var tot_pc = intrest_pc + sancAmt_pc;
      var tot_scooter = intrest_scooter + sancAmt_scooter;
      total_amt_car.text = tot_car.toStringAsFixed(3).toString();
      total_amt_pc.text = tot_pc.toStringAsFixed(3).toString();
      total_amt_scooter.text = tot_scooter.toStringAsFixed(3).toString();
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
        title: Text("Advance:: Car-PC-Scooter",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                children: <Widget>[
                  Column(children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text("Advance:: Car-PC-Scooter"),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 600,
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
                                        '',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 3, 0, 0),
                                      child: Text(
                                        'Car',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(15, 3, 0, 0),
                                      child: Text(
                                        'PC',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Scooter",
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
                                        'Sanc. Amt :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: sanc_amt_car,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: sanc_amt_pc,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: sanc_amt_scooter,
                                    ),
                                  ),
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
                                        'Intr. Rate :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: intr_rate_car,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                        controller: intr_rate_pc),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: intr_rate_scooter,
                                    ),
                                  ),
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
                                        'Instalments :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: instalment_car,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: instalment_pc,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: instalment_scooter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey),
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
                                      calculate();
                                    },
                                    child: Text(
                                      "Calculate Interest",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                      child: Text(
                                        'Interest Amount :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: intrestAmtcar,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: intrestAmtpc,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: intrestAmtscooter,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
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
                                        'Total amount  to be repaid= Sanctioned Amt. + Interest Amt. :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: total_amt_car,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: total_amt_pc,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor("#808080"),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                    child: TextField(
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      controller: total_amt_scooter,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Text(
                                    'Note :-\n\n Change the Sanc. Amt and/or Change the Number of Instalments to check how the total repayment varies.',
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
