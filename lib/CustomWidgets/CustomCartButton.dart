import 'package:flutter/material.dart';
import 'package:zartek_test/Constants/CColor.dart';

class CustomCartButton extends StatefulWidget {
  final Widget text;
  final Gradient gradient;
  final double buttonWidth;
  final double height;
  final Function addOnPressed;
  final Function removeonPressed;
  final double radius;

  CustomCartButton(
      {
        @required this.gradient,
        @required this.buttonWidth ,
        @required this.height,
        @required this.radius,
        @required this.text,
        @required this.addOnPressed,
        @required this.removeonPressed
      });

  @override
  _CustomCartButtonState createState() => _CustomCartButtonState();
}

class _CustomCartButtonState extends State<CustomCartButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.buttonWidth,
      height: widget.height,
      decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: widget.buttonWidth*0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: widget.removeonPressed,
                    child: Icon(Icons.remove,color: CColor.LoginScreenBGColor,)),
                widget.text,
                GestureDetector(
                  onTap: widget.addOnPressed,
                    child: Icon(Icons.add,color: CColor.LoginScreenBGColor,))
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}