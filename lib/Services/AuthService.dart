import 'package:firebase_auth/firebase_auth.dart'as fire;
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zartek_test/CustomWidgets/CustomTextInputField.dart';
import 'package:zartek_test/Models/User.dart'as model;
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
class AuthService {
  String _phoneNo;
  String _smsOTP;
  String _verificationId;
  String _errorMessage = '';
  TextEditingController otpController=TextEditingController();
  final fire.FirebaseAuth _auth = fire.FirebaseAuth.instance;

  //create user object based on FirebaseUser
  model.User _userFromFirebaseUser(fire.User user) {
    return user != null ? model.User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<model.User> get user => _auth.authStateChanges().map(_userFromFirebaseUser);

  //google signin
  static Future<fire.User> signInWithGoogle(BuildContext context)async{
    FirebaseAuth auth = FirebaseAuth.instance;
    fire.User  user;
    final GoogleSignIn googleSignIn=GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthService.customSnackBar(
              content:
              'The account already exists with a different credential.',
            ),
          );
        }
        else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthService.customSnackBar(
              content:
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }
    return user;
  }

  //sign out
  static Future<void> signOut({@required BuildContext context}) async {


    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthService.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<void> verifyPhone(TextEditingController phoneController,BuildContext context) async {
    this._phoneNo=phoneController.text;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this._verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this._phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this._verificationId = verId;
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
      handleError(context,e);
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
                Container(
                  child: CustomTextInputField(
                    maxLength: 6,
                    controller: otpController,
                    label: "OTP",
                  ),
                  // child: TextField(
                  //   onChanged: (value) {
                  //     this._smsOTP = value;
                  //   },
                  // ),
                ),
                (_errorMessage != ''
                    ? Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  User user= _auth.currentUser;
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  } else {
                    signIn(context);
                  }

                },
              )
            ],
          );
        });
  }
  signIn(BuildContext context) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsOTP,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      final User currentUser =  _auth.currentUser;
      assert(user.user.uid == currentUser.uid);
      Box box =Hive.box("user");
      box.put("userName","${user.user.displayName}");
      box.put("userId","${user.user.uid}");
      box.put("email","${user.user.displayName}");
      box.put("imageUrl",user.user.photoURL);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade),(route)=>false);
    } catch (e) {
      handleError(context,e);
    }
  }
  handleError(BuildContext context, error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());

        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content: 'Invalid Code',
          ),
        );
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content: '$_errorMessage',
          ),
        );

        break;
    }
  }


}