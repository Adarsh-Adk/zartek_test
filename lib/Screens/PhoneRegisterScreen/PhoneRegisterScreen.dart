import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/CustomWidgets/CustomRaisedGradientButton.dart';
import 'package:zartek_test/CustomWidgets/CustomTextInputField.dart';
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';


class PhoneRegisterScreen extends StatefulWidget {
  PhoneRegisterScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PhoneRegisterScreenState createState() => _PhoneRegisterScreenState();
}

class _PhoneRegisterScreenState extends State<PhoneRegisterScreen> {

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  final double gap=SizeConfig.blockSizeVertical*27;
  TextEditingController phoneController=TextEditingController();

  Future<void> verifyPhone() async {
    this.phoneNo=phoneController.text;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: ( exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                 User user= _auth.currentUser;
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      signIn();
                    }

                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      final User currentUser =  _auth.currentUser;
      assert(user.user.uid == currentUser.uid);
      Box box =Hive.box("user");
      box.put("userName","${user.user.displayName}");
      box.put("userId","${user.user.uid}");
      box.put("email","${user.user.displayName}");
      box.put("imageUrl",user.user.photoURL);
      String uid=box.get("userId");
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade),(route)=>false);
    } catch (e) {
      handleError(e);
    }
  }

  handleError( error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

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
                CustomTextInputField(controller: phoneController, label: "Phone"),
                SizedBox(height:gap*0.3,),
                CustomRaisedGradientButton(child: Text("Submit",style: GoogleFonts.roboto(color: CColor.LoginScreenBGColor,fontSize: SizeConfig.blockSizeVertical*3),),gradient: LinearGradient(colors: [CColor.LoginScreenGoogleBtnLeft,CColor.LoginScreenGoogleBtnRight],begin: Alignment.centerLeft,end: Alignment.centerRight), height: SizeConfig.blockSizeVertical*8, onPressed:()=> verifyPhone(), radius: SizeConfig.blockSizeVertical*4),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ],
            )),
          ),
        ),
      ),
    );
  }
}
