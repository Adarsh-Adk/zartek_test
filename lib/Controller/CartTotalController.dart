import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Interface/FoodData.dart';




class CartTotalController extends GetxController{


  List _list;
  Box box;
  List get list=>_list;

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
  print("added ${box.keys}");
  }
  removeFromCart(CategoryDish dish)async {
    _list.remove(dish);
   await box.delete(_list.length);
    print("removed ${box.keys}");
  }

}


//===============================================================
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:zartek_test/Interface/FoodData.dart';
//
//
//
//
// class CartTotalController extends GetxController{
//
//
//
//   var mapp={}.obs;
//   Box box;
//
//
//
//
//   // var cartItems = List<CategoryDish>.empty(growable: true).obs;
//   // int get count => cartItems.length;
//   // double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.dishPrice);
//   CartTotalController(){
//     // box=Hive.box("cartTotal");
//      box=Hive.box("cartTotal");
//   }
//
//   addToCart(CategoryDish dish) async{
//     mapp.value=box.toMap();
//     int value;
//     if(mapp.containsKey(dish.dishId)){
//       value=mapp[dish.dishId].;
//       mapp[dish.dishId]=value+1;
//     }else{
//       mapp[dish.dishId]=1;
//     }
//     await box.put(dish.dishId,value );
//
//   }
//
//   removeFromCart(CategoryDish dish)async {
//
//     int value;
//     if(mapp.containsKey(dish.dishId)){
//       value=mapp[dish.dishId];
//       if(value==0){
//         mapp[dish.dishId]=0;
//       }else{
//         mapp[dish.dishId]=value-1;
//       }
//     }else{
//       mapp[dish.dishId]=0;
//     }
//     await box.put(dish.dishId,value );
//   }
//
// }