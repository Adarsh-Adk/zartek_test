import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Interface/FoodData.dart';
import 'package:zartek_test/Services/HelperService.dart';




class CartTotalController extends GetxController{

  @override
  void onInit(){
    print("cartTotal:Open all boxes called");
    HelperService().openAllBoxes();
    super.onInit();
  }

  @override
  void onClose(){
    resetCart();
    super.onClose();
  }

  List _list;
  Box box;
  List get list=>_list;
  CategoryDish dish;


  double get totalPrice => list.fold(0, (sum, item) => sum + item.dishPrice);
 CartTotalController(){

   box=Hive.box("cartTotal");
   _list=[].obs;
   for(int i=0;i<box.values.length;i++){
     print("list length=${_list.length}");
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
   await box.clear().then((value) =>  print("cartTotal: box cleared"));

  }

}

