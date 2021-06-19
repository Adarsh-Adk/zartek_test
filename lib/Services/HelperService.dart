import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
class HelperService{
  static closeAllBoxes()async{
    Box cartBox=Hive.box("cart");
    Box cartTotalBox=Hive.box("cartTotal");
    Box userBox=Hive.box("user");
    cartBox.close();
    cartTotalBox.close();
    userBox.close();
  }
  static openAllBoxes()async{
    bool a=Hive.isBoxOpen("cart");
    bool b=Hive.isBoxOpen("cartTotal");
    bool c=Hive.isBoxOpen("user");
    if(!a){
      Box cartBox=await Hive.openBox("cart");
    }
    if(!b){
      Box cartTotalBox=await Hive.openBox("cartTotal");
    }
    if(!c){
      Box userBox=await Hive.openBox("user");
    }
  }
  static clearAllBoxes()async{
    Box cartBox=Hive.box("cart");
    Box cartTotalBox=Hive.box("cartTotal");
    Box userBox=Hive.box("user");
    cartBox.clear();
    cartTotalBox.clear();
    userBox.clear();

  }

}