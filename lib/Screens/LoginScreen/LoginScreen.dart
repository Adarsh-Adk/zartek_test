import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/CustomWidgets/CustomRaisedGradientButton.dart';
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
import 'package:zartek_test/Screens/PhoneRegisterScreen/PhoneRegisterScreen.dart';
import 'package:zartek_test/Services/AuthService.dart';
class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double gap=SizeConfig.blockSizeVertical*27;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CColor.LoginScreenBGColor,
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child:SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: gap,
              ),
              Container(
                width: SizeConfig.screenWidth*0.3,
                child: Image.asset("assets/logos/logo.png",fit: BoxFit.fitWidth,),
              ),
              SizedBox(
                height:gap-(gap*0.25) ,
              ),
              Container(
                width: SizeConfig.screenWidth*0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomRaisedGradientButton(
                        child:Container(width: SizeConfig.screenWidth*0.6,child: Center(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal*8,
                          decoration: BoxDecoration(shape: BoxShape.circle,color: CColor.LoginScreenBGColor),
                          child: Container(
                              width: SizeConfig.blockSizeHorizontal*4,
                              child: Image.asset("assets/logos/google.png",fit: BoxFit.fitWidth,)),
                      ),
                      Text("Google",style: GoogleFonts.roboto(color: CColor.LoginScreenBGColor,fontSize: SizeConfig.blockSizeVertical*3),),
                      Container(color: Colors.transparent,width: SizeConfig.blockSizeHorizontal*4)
                    ],),
                        ),),
                        gradient: LinearGradient(colors: [CColor.LoginScreenGoogleBtnLeft,CColor.LoginScreenGoogleBtnRight],begin: Alignment.centerLeft,end: Alignment.centerRight),
                        height: SizeConfig.blockSizeVertical*8,
                        onPressed:()=> googleButtonFunction(context),
                        radius:SizeConfig.blockSizeVertical*4),
                    SizedBox(height: SizeConfig.blockSizeVertical*2,),
                    CustomRaisedGradientButton(
                        child:Container(width: SizeConfig.screenWidth*0.6,child: Center(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal*8,
                              // decoration: BoxDecoration(shape: BoxShape.circle,color: CColor.LoginScreenBGColor),
                              child: Container(
                                  width: SizeConfig.blockSizeHorizontal*8,
                                  child: Icon(Icons.phone,color: CColor.LoginScreenBGColor,size:SizeConfig.blockSizeHorizontal*8 ,)),
                            ),
                            Text("Phone",style: GoogleFonts.roboto(color: CColor.LoginScreenBGColor,fontSize: SizeConfig.blockSizeVertical*3),),
                            Container(color: Colors.transparent,width: SizeConfig.blockSizeHorizontal*4)
                          ],),
                        ),),
                        gradient: LinearGradient(colors: [CColor.LoginScreenPhoneBtnLeft,CColor.LoginScreenPhoneBtnRight],begin: Alignment.centerLeft,end: Alignment.centerRight),
                        height: SizeConfig.blockSizeVertical*8,
                        onPressed: ()=>phoneButtonFunction(context),
                        radius:SizeConfig.blockSizeVertical*4),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  googleButtonFunction(BuildContext context) async{
    User user =await AuthService.signInWithGoogle(context);
    print("${user.displayName}${user.uid}${user.email}");
    Box box =Hive.box("user");
    box.put("userName","${user.displayName}");
    box.put("userId","${user.uid}");
    box.put("email","${user.displayName}");
    box.put("imageUrl",user.photoURL);
    String uid=box.get("userId");
    if(uid!=null){
      Navigator.push(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade));
    }

    // Navigator.push(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade));
  }

  phoneButtonFunction(BuildContext context) {
    Navigator.push(context, PageTransition(child: PhoneRegisterScreen(), type: PageTransitionType.fade));
  }
}
