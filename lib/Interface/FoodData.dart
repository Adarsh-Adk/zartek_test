// To parse this JSON data, do
//
//     final foodData = foodDataFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'FoodData.g.dart';

List<FoodData> foodDataFromJson(String str) => List<FoodData>.from(json.decode(str).map((x) => FoodData.fromJson(x)));

String foodDataToJson(List<FoodData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodData {

  FoodData({
    this.restaurantId,
    this.restaurantName,
    this.restaurantImage,
    this.tableId,
    this.tableName,
    this.branchName,
    this.nexturl,
    this.tableMenuList,
  });

  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String tableId;
  String tableName;
  String branchName;
  String nexturl;
  List<TableMenuList> tableMenuList;

  factory FoodData.fromJson(Map<String, dynamic> json) {
    // print("Food data called");
    return FoodData(
    restaurantId: json["restaurant_id"],
    restaurantName: json["restaurant_name"],
    restaurantImage: json["restaurant_image"],
    tableId: json["table_id"],
    tableName: json["table_name"],
    branchName: json["branch_name"],
    nexturl: json["nexturl"],
    tableMenuList: List<TableMenuList>.from(json["table_menu_list"].map((x) => TableMenuList.fromJson(x))),
  );}

  Map<String, dynamic> toJson() => {
    "restaurant_id": restaurantId,
    "restaurant_name": restaurantName,
    "restaurant_image": restaurantImage,
    "table_id": tableId,
    "table_name": tableName,
    "branch_name": branchName,
    "nexturl": nexturl,
    "table_menu_list": List<dynamic>.from(tableMenuList.map((x) => x.toJson())),
  };
}

class TableMenuList {
  TableMenuList({
    this.menuCategory,
    this.menuCategoryId,
    this.menuCategoryImage,
    this.nexturl,
    this.categoryDishes,
  });

  String menuCategory;
  String menuCategoryId;
  String menuCategoryImage;
  String nexturl;
  List<CategoryDish> categoryDishes;

  factory TableMenuList.fromJson(Map<String, dynamic> json) {
    // print("TableMenuList called");
    return TableMenuList(
    menuCategory: json["menu_category"],
    menuCategoryId: json["menu_category_id"],
    menuCategoryImage: json["menu_category_image"],
    nexturl: json["nexturl"],
    categoryDishes: List<CategoryDish>.from(json["category_dishes"].map((x) => CategoryDish.fromJson(x))),
  );}

  Map<String, dynamic> toJson() => {
    "menu_category": menuCategory,
    "menu_category_id": menuCategoryId,
    "menu_category_image": menuCategoryImage,
    "nexturl": nexturl,
    "category_dishes": List<dynamic>.from(categoryDishes.map((x) => x.toJson())),
  };
}
@HiveType(typeId: 2)
class AddonCat {
  AddonCat({
    this.addonCategory,
    this.addonCategoryId,
    this.addonSelection,
    this.nexturl,
    this.addons,
  });

  @HiveField(0)
  String addonCategory;
  @HiveField(1)
  String addonCategoryId;
  @HiveField(2)
  int addonSelection;
  @HiveField(3)
  String nexturl;
  @HiveField(4)
  List<CategoryDish> addons;

  factory AddonCat.fromJson(Map<String, dynamic> json) {
    // print("AddonCat called");
    return AddonCat(
    addonCategory: json["addon_category"],
    addonCategoryId: json["addon_category_id"],
    addonSelection: json["addon_selection"],
    nexturl: json["nexturl"],
    addons: List<CategoryDish>.from(json["addons"].map((x) => CategoryDish.fromJson(x))),
  );}

  Map<String, dynamic> toJson() => {
    "addon_category": addonCategory,
    "addon_category_id": addonCategoryId,
    "addon_selection": addonSelection,
    "nexturl": nexturl,
    "addons": List<dynamic>.from(addons.map((x) => x.toJson())),
  };
}
@HiveType(typeId : 0)
class CategoryDish {
  CategoryDish({
    this.dishId,
    this.dishName,
    this.dishPrice,
    this.dishImage,
    this.dishCurrency,
    this.dishCalories,
    this.dishDescription,
    this.dishAvailability,
    this.dishType,
    this.nexturl,
    this.addonCat,
  });

  @HiveField(0)
  final String dishId;
  @HiveField(1)
  final String dishName;
  @HiveField(2)
  final double dishPrice;
  @HiveField(3)
  final String dishImage;
  @HiveField(4)
  final DishCurrency dishCurrency;
  @HiveField(5)
  final double dishCalories;
  @HiveField(6)
  final String dishDescription;
  @HiveField(7)
  final bool dishAvailability;
  @HiveField(8)
  final int dishType;
  @HiveField(9)
  final String nexturl;
  @HiveField(10)
  final List<AddonCat> addonCat;

  factory CategoryDish.fromJson(Map<String, dynamic> json) {
    // print("CategoryDish called");
   return CategoryDish(
    dishId: json["dish_id"],
    dishName: json["dish_name"],
    dishPrice: json["dish_price"].toDouble(),
    dishImage: json["dish_image"],
    dishCurrency: dishCurrencyValues.map[json["dish_currency"]],
    dishCalories: json["dish_calories"],
    dishDescription: json["dish_description"],
    dishAvailability: json["dish_Availability"],
    dishType: json["dish_Type"],
    nexturl: json["nexturl"] == null ? null : json["nexturl"],
    addonCat: json["addonCat"] == null ? null : List<AddonCat>.from(json["addonCat"].map((x) => AddonCat.fromJson(x))),
  );}

  Map<String, dynamic> toJson() => {
    "dish_id": dishId,
    "dish_name": dishName,
    "dish_price": dishPrice,
    "dish_image": dishImage,
    "dish_currency": dishCurrencyValues.reverse[dishCurrency],
    "dish_calories": dishCalories,
    "dish_description": dishDescription,
    "dish_Availability": dishAvailability,
    "dish_Type": dishType,
    "nexturl": nexturl == null ? null : nexturl,
    "addonCat": addonCat == null ? null : List<dynamic>.from(addonCat.map((x) => x.toJson())),
  };
}
@HiveType(typeId : 1)
enum DishCurrency {
  @HiveField(0)
  SAR
}

final dishCurrencyValues = EnumValues({
  "SAR": DishCurrency.SAR
});

@HiveType(typeId: 3)
class EnumValues<T> {
  @HiveField(0)
  Map<String, T> map;
  @HiveField(1)
  Map<T, String> reverseMap;

  EnumValues(this.map);
  @HiveField(2)
  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
