import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Interface/FoodData.dart';

part 'cart_controller_state.dart';

class CartControllerCubit extends Cubit<CartControllerState> {
  CartControllerCubit() : super(CartControllerInitial(0));



  int value=0;


  void increment(CategoryDish dish)async{

    value=value+1;
    Box box=Hive.box("cart");
    box.put(dish.dishId,value);
    var val=box.get(dish.dishId);
    if(val==null){
      value=1;
    }else{
      value=val;
    }
    box.put(dish.dishId,value);
    emit(CartControllerLoaded(value));

  }

  void decrement(CategoryDish dish) async{

    if(value<=0){
      value=0;
    }else{
      value=value-1;
    }
    Box box=Hive.box("cart");
    box.put(dish.dishId,value);
    var val=box.get(dish.dishId);
    if(val==null){
      value=0;
    }else{
      value=val;
    }
    box.put(dish.dishId,value);
    emit (CartControllerLoaded(value));
  }
}
