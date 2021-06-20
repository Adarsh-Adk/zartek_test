import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zartek_test/Constants/CColor.dart';
class CustomTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLength;
  CustomTextInputField({Key key,@required this.controller,@required this.label,@required this.maxLength}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLength: this.maxLength,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: CColor.LoginScreenGoogleBtnRight),
            gapPadding: 5,
          ),
          enabledBorder: OutlineInputBorder(
            gapPadding: 5,
            borderSide: BorderSide(color: CColor.LoginScreenGoogleBtnRight),
          ),
          labelText: label,
          labelStyle: GoogleFonts.roboto(color: CColor.LoginScreenGoogleBtnRight),
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }
}