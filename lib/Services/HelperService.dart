import 'package:hive/hive.dart';
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
      await Hive.openBox("cart");
    }
    if(!b){
      await Hive.openBox("cartTotal");
    }
    if(!c){
      await Hive.openBox("user");
    }
  }
  static clearAllBoxes()async{
    Box cartBox=Hive.box("cart");
    Box cartTotalBox=Hive.box("cartTotal");
    Box userBox=Hive.box("user");
    await cartBox.clear();
    await cartTotalBox.clear();
    await userBox.clear();

  }

}