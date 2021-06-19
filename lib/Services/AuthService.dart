import 'package:firebase_auth/firebase_auth.dart'as fire;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zartek_test/Models/User.dart'as model;
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
class AuthService {
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

  // //phoneSignIn
  // static Future loginWithphone(BuildContext context,String phone)async{
  //
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     verificationCompleted: (PhoneAuthCredential credential) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         AuthService.customSnackBar(
  //           content:
  //           'You are successfully verified',
  //         ),
  //       );
  //       Map map={};
  //       map["result"]="VERIFICATIONCOMPLETED";
  //       map["credential"]=credential;
  //       return credential;
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         AuthService.customSnackBar(
  //           content:
  //           'An error occured :$e',
  //         ),
  //       );
  //       Map map={};
  //       map["result"]="VERIFICATIONFAILED";
  //       return map;
  //     },
  //     codeSent: (String verificationId, int resendToken) {
  //       Map map={};
  //       map["result"]="CODESENT";
  //       map["verificationId"]=verificationId;
  //       map["resendToken"]=resendToken;
  //       return map;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //
  //       Map map={};
  //       map["result"]="CODEAUTORETRIEVALTIMEOUT";
  //       map["verificationId"]=verificationId;
  //       return map;
  //     },
  //   );
  //
  // }
  //  void submitOTP(String otp,String verificationId,fire.PhoneAuthCredential credential,context) {
  //
  //
  //   /// when used different phoneNumber other than the current (running) device
  //   /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
  //   fire.AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
  //
  //   _login(phoneAuthCredential,context);
  // }
  //
  // Future<void> _login(phoneAuthCredential,context) async {
  //   /// This method is used to login the user
  //   /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
  //   /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
  //   try {
  //    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then((value) {
  //      fire.User user=value.user;
  //      Box box=Hive.box("user");
  //      box.put("userId",user.uid);
  //      box.put("userName",user.displayName);
  //      box.put("email",user.email);
  //      box.put("imageUrl",user.photoURL);
  //      Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade), (route) => false);
  //
  //
  //    });
  //
  //   } catch (e) {
  //
  //   print(e.toString());
  //   }
  // }

  //sign out
  static Future<void> signOut({@required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

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
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }


}