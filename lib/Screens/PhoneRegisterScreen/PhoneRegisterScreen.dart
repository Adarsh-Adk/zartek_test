import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/CustomWidgets/CustomRaisedGradientButton.dart';
import 'package:zartek_test/CustomWidgets/CustomTextInputField.dart';
import 'package:zartek_test/Services/AuthService.dart';


class PhoneRegisterScreen extends StatefulWidget {
  PhoneRegisterScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PhoneRegisterScreenState createState() => _PhoneRegisterScreenState();
}

class _PhoneRegisterScreenState extends State<PhoneRegisterScreen> {


  final double gap=SizeConfig.blockSizeVertical*27;
  TextEditingController phoneController=TextEditingController();






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text(widget.title),
      // ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth*0.1),
          child: Center(
            child: Form(child:
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextInputField(controller: phoneController, label: "Phone", maxLength: 14,hint: "eg: +919249XXXXXX",),
                SizedBox(height:gap*0.3,),
                CustomRaisedGradientButton(child: Text("Submit",style: GoogleFonts.roboto(color: CColor.LoginScreenBGColor,fontSize: SizeConfig.blockSizeVertical*3),),gradient: LinearGradient(colors: [CColor.LoginScreenGoogleBtnLeft,CColor.LoginScreenGoogleBtnRight],begin: Alignment.centerLeft,end: Alignment.centerRight), height: SizeConfig.blockSizeVertical*8, onPressed:()=> AuthService().verifyPhone(phoneController, context), radius: SizeConfig.blockSizeVertical*4),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
