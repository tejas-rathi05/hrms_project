import 'package:flutter/cupertino.dart';






class CustomShapeClipper extends CustomClipper<Path>
{
  @override
  getClip(Size size) {
    // TODO: implement getClip
    final Path path=Path();
    path.lineTo(0.0, size.height);
    var firstEndPoint =Offset(size.width*.5,size.height-35.0);
    var firstControlPoint=Offset(size.width*0.25,size.height-50.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondEndPoint =Offset(size.width,size.height-80.0);
    var secondControlPoint=Offset(size.width*0.75,size.height-18);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
   return true;
  }

}