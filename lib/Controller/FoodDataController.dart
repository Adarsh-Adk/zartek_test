import 'package:get/get.dart';
import 'package:zartek_test/Api/HomePageDataApi.dart';
import 'package:zartek_test/Interface/FoodData.dart';
class FoodDataController extends GetxController{
  var isLoading=true.obs;
  var tableMenuList=List<TableMenuList>.empty(growable: true).obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData()async{
    try{
      isLoading(true);
      var tables=await HomePageDataApi.getData();
      if(tables!=null){
        tableMenuList.value=tables;
      }
      // print("tables:${tables}");
      isLoading(false);
    }catch(e){
      print("FoodDataController:$e");
      isLoading(true);
    }

  }
}