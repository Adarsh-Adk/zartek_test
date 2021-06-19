import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
import 'package:zartek_test/Screens/LoginScreen/LoginScreen.dart';

import 'Interface/FoodData.dart';
import 'Models/User.dart';
import 'Services/AuthService.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory appDir=await getApplicationDocumentsDirectory();
  await Hive.registerAdapter(CategoryDishAdapter());
  await Hive.registerAdapter(DishCurrencyAdapter());
  await Hive.registerAdapter(AddonCatAdapter());
  await Hive.registerAdapter(EnumValuesAdapter());
  await Hive.init(appDir.path);
  Box box=await Hive.openBox("cart");
  Box box2=await Hive.openBox("cartTotal");
  Box box3=await Hive.openBox("user");
  box.clear();
  box2.clear();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<User>(context);
    if (user == null) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}


