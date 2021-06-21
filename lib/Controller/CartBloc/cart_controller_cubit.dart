import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:zartek_test/Models/CountModel.dart';

part 'cart_controller_state.dart';

class CartControllerCubit extends Cubit<CartControllerState> {
  CartControllerCubit() : super(CartControllerInitial(0));



  int value=0;
  Map map={};
  Box box=Hive.box("cart");


  void increment(CountModel model)async{
    map=box.toMap();
      if(map.containsKey(model.dishId)){
        int count=map[model.dishId];
        count=count+1;
        map[model.dishId]=count;
        await box.put(model.dishId, count);
      }
      else {
        map[model.dishId] =1;
        await box.put(model.dishId, 1);
      }

    print("count ${map[model.dishId]}");
    emit(CartControllerLoaded(map[model.dishId]));

  }

  void decrement(CountModel model) async{


    map=box.toMap();
    if(map.containsKey(model.dishId)){
      int count=map[model.dishId];
      if(count<=1){
        count=0;
      }else{
        count=count-1;
      }
      map[model.dishId]=count;
      await box.put(model.dishId, count);
    }
    else {
      map[model.dishId] =1;
      await box.put(model.dishId, 1);
    }
    print("count ${map[model.dishId]}");
    emit(CartControllerLoaded(map[model.dishId]));
  }

  void reset()async{
    await box.clear().whenComplete(() {
      print("cartTotal cleared");
      map={};
    });

  }
}
