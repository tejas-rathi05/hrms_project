import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldUI extends StatefulWidget {
  var hintText;
  Icon icon;
  double withText, withCon;
  TextInputType inputType;
  TextEditingController hrmsidController;
  int length;

  TextFieldUI(this.hintText, this.icon, this.hrmsidController, this.withText,
      this.withCon, this.inputType, this.length);

  @override
  TextFieldState createState() => TextFieldState();
}

class TextFieldState extends State<TextFieldUI> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      width: widget.withCon,
      height: 50,
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color(0xFF0C3A57),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Icon(Icons.person,color: Colors.white,),
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 9, 15, 10),
                child: widget.icon),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              width: widget.withText,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  keyboardType: widget.inputType,
                  controller: widget.hrmsidController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    fillColor: Colors.white,
                    filled: true,
                    counterText: '',
                  ),
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(widget.length),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
