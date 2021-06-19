import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Services/AuthService.dart';
import 'package:zartek_test/Services/HelperService.dart';
class CustomDrawer extends StatelessWidget {
  final double height;
  final double width;
  final String uid;
  final String imageUrl;
  final String userName;

  CustomDrawer({Key key,@required this.height,@required this.width,@required this.uid,@required this.imageUrl,@required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [CColor.DrawerTopLeft,CColor.DrawerBottomRight]),
    ),
        child: SafeArea(
          child: Drawer(
          child: ListView(
            children: [
              DrawerHeader
                (padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  child:
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                    gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [CColor.DrawerTopLeft,CColor.DrawerBottomRight])
                ),
                width: double.infinity,
                height: height/2.3,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: width*0.1,
                        minRadius: width*0.06,
                        backgroundImage:imageUrl==null?null:NetworkImage(imageUrl),
                        backgroundColor: CColor.thumbsUp,
                      ),
                      SizedBox(
                        height: width*0.03,
                      ),
                      Text(userName==null?"username":userName,style: GoogleFonts.roboto(color: Colors.black,fontSize: width*0.05,fontWeight: FontWeight.w500),),
                      SizedBox(
                        height: width*0.03,
                      ),
                      FittedBox(fit:BoxFit.contain,child: Text(uid==null?"UID":uid,style: GoogleFonts.roboto(color: Colors.black,fontSize: width*0.035),),),
                    ],
                  ),
                ),
              )),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: CColor.HomeScreenAppbarIcon,),
                title: Text("Log out",style: GoogleFonts.poppins(color: CColor.HomeScreenAppbarIcon),),
                onTap: (){
                  AuthService.signOut(context: context);
                  HelperService.clearAllBoxes();
                },
              )
            ],
          ),
      ),
        ),
    );
  }
}
