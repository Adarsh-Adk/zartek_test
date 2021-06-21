import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Controller/CartBloc/cart_controller_cubit.dart';
import 'package:zartek_test/Controller/CartTotalController.dart';
import 'package:zartek_test/Services/AuthService.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomDrawer extends StatefulWidget {
  final double height;
  final double width;




  CustomDrawer(
      {Key key,
      @required this.height,
      @required this.width,
      })
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  Box userBox = Hive.box("user");
  CartTotalController cartController=Get.find();

  @override
  void dispose() {
    cartController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CColor.DrawerTopLeft, CColor.DrawerBottomRight]),
      ),
      child: SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: widget.height * 0.3,
                child: DrawerHeader(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                CColor.DrawerTopLeft,
                                CColor.DrawerBottomRight
                              ])),
                      width: double.infinity,
                      height: widget.height / 2.1,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(valueListenable:userBox.listenable() ,
                                builder: (context,Box box,child)  {
                              String imageUrl= box.get("imageUrl");
                              return CircleAvatar(
                                maxRadius: widget.width * 0.1,
                                minRadius: widget.width * 0.06,
                                backgroundImage:imageUrl == null
                                    ? null
                                    : NetworkImage(imageUrl),
                                backgroundColor: CColor.thumbsUp,
                              );
                                }),
                            SizedBox(
                              height: widget.width * 0.03,
                            ),
                            ValueListenableBuilder(valueListenable: userBox.listenable(),
                                builder: (context,Box box,child){
                                  String userName=box.get("userName");
                                  return userName == null
                                      ? Text("User")
                                      : Text(
                                    userName == "null"
                                        ? "username"
                                        : userName,
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: widget.width * 0.05,
                                        fontWeight: FontWeight.w500),
                                  );
                                }),

                            SizedBox(
                              height: widget.width * 0.03,
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: ValueListenableBuilder(valueListenable: userBox.listenable(),
                                  builder: (context,Box box,child){
                                    String userId=box.get("userId");
                                    return userId == null
                                        ? Text("UID")
                                        : Text(
                                      userId == "null"
                                          ? "UID"
                                          : "UID:$userId",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: widget.width * 0.03,
                                          fontWeight: FontWeight.w500),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              BlocProvider.value(
                value: CartControllerCubit(),
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: CColor.HomeScreenAppbarIcon,
                  ),
                  title: Text(
                    "Log out",
                    style:
                        GoogleFonts.poppins(color: CColor.HomeScreenAppbarIcon),
                  ),
                  onTap: () async {
                    await AuthService().signOut(context: context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
