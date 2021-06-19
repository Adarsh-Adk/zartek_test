import 'package:flutter/material.dart';

class CustomRaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final double radius;

  const CustomRaisedGradientButton(
      {
        @required this.child,
        @required this.gradient,
        this.width = double.infinity,
        @required this.height,
        @required this.onPressed,
        @required this.radius});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}