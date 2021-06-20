import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
import 'package:zartek_test/Screens/LoginScreen/LoginScreen.dart';
import 'package:zartek_test/Services/HelperService.dart';
import 'Interface/FoodData.dart';
import 'Models/User.dart';
import 'Services/AuthService.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory appDir=await getApplicationDocumentsDirectory();
  Hive.registerAdapter(CategoryDishAdapter());
  Hive.registerAdapter(DishCurrencyAdapter());
  Hive.registerAdapter(AddonCatAdapter());
  Hive.registerAdapter(EnumValuesAdapter());
  Hive.init(appDir.path);
  await HelperService.openAllBoxes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService();

    return StreamProvider<User>.value(
      initialData: null,
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


