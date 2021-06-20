import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Interface/FoodData.dart';




class CartTotalController extends GetxController{


  List _list;
  Box box;
  List get list=>_list;
  CategoryDish dish;


  // var cartItems = List<CategoryDish>.empty(growable: true).obs;
  // int get count => cartItems.length;
  double get totalPrice => list.fold(0, (sum, item) => sum + item.dishPrice);
 CartTotalController(){
   box=Hive.box("cartTotal");
   _list=[].obs;
   for(int i=0;i<box.values.length;i++){
     _list.add(box.getAt(i));
 }

  }

  addToCart(CategoryDish dish) async{
   _list.add(dish);
  await box.add(dish);
  // print("added ${box.keys}");
  }
  removeFromCart(CategoryDish dish)async {
    _list.remove(dish);
   await box.delete(_list.length);
    // print("removed ${box.keys}");
  }
  resetCart()async{
  _list.clear();
   print("list cleared");
   await box.clear();
   print("box cleared");
  }

}

