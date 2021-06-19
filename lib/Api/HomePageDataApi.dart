import 'package:http/http.dart'as http;
import 'package:zartek_test/Interface/FoodData.dart';
class HomePageDataApi{
  static var client=http.Client();
  static Future<List<TableMenuList>>  getData()async{
    List<TableMenuList> tableMenuList;
    Uri uri=Uri.parse("https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad");
    var response=await client.get(uri);
    if(response.statusCode==200){
      try{
        // print("this line 1 is working");
        List<FoodData> data=foodDataFromJson(response.body);
        // print("this line 2 is working");
        // print(data);
        FoodData foodData =data[0];
        tableMenuList=foodData.tableMenuList;
      //   print(tableMenuList);
      }catch(e){
        print("error in homepagedataapi:$e");
        tableMenuList=null;
      }
    }else{
      print(response.statusCode.toString());
      tableMenuList=null;
    }
    print("tableMenuList:$tableMenuList");
    return tableMenuList;
  }
}