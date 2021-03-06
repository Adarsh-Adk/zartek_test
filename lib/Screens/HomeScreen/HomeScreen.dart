import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/Controller/CartBloc/cart_controller_cubit.dart';
import 'package:zartek_test/Controller/CartTotalController.dart';
import 'package:zartek_test/Controller/FoodDataController.dart';
import 'package:zartek_test/CustomWidgets/CustomDrawer.dart';
import 'package:zartek_test/CustomWidgets/CustomHomeScreenCard.dart';
import 'package:zartek_test/Interface/FoodData.dart';
import 'package:zartek_test/Models/CountModel.dart';
import 'package:zartek_test/Screens/OrderSummaryScreen/OrderSummaryScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zartek_test/Services/HelperService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final tableController = Get.put(FoodDataController());
  final cartTotalController = Get.put(CartTotalController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    HelperService().openAllBoxes();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: GetX<FoodDataController>(builder: (controller) {
          if (tableController.isLoading.value == true) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // print("table controller:${tableController.tableMenuList.length}");
            return DefaultTabController(
              initialIndex: 0,
              length: tableController.tableMenuList.length,
              child: BlocProvider<CartControllerCubit>(
                create: (ctx) => CartControllerCubit(),
                child: Scaffold(
                  drawer: CustomDrawer(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
               ),
                  key: _scaffoldKey,
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: CColor.HomeScreenAppbarIcon,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                        isScrollable: true,
                        indicatorColor: CColor.HomeScreenTabBarText,
                        tabs: tableController.tableMenuList
                            .map(
                              (element) => Tab(
                                child: Text(
                                  "${element.menuCategory}",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color: CColor.HomeScreenTabBarText),
                                ),
                              ),
                            )
                            .toList()),
                    actions: [
                      Container(
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth * 0.03),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: CColor.HomeScreenAppbarIcon,
                                    size: SizeConfig.blockSizeHorizontal * 9,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: BlocProvider.value(
                                              value: CartControllerCubit(),
                                              child: OrderSummaryScreen(),
                                            ),
                                            type: PageTransitionType.fade));
                                  }),
                              Container(
                                  height: SizeConfig.blockSizeHorizontal * 6,
                                  child: Center(
                                      child: ClipOval(
                                          clipper: CustomOvalClip(),
                                          child: Container(
                                            child: Center(child:
                                                GetX<CartTotalController>(
                                              builder: (controller2) {
                                                Map<String, List<CategoryDish>> dishMap = {};
                                                controller2.list.forEach((element) {
                                                  dishMap[element.dishId] = []..add(element);
                                                });
                                                return Text(
                                                  "${dishMap.keys.length}",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 8,
                                                      color: Colors.white),
                                                );
                                              },
                                            )),
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                            ),
                                          ))))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  body: TabBarView(
                      children: tableController.tableMenuList.map((element) {
                    // print("itemcount: ${element.categoryDishes.length}");
                    return ListView.builder(
                        itemCount: element.categoryDishes.length,
                        itemBuilder: (context, index) {
                          return BlocProvider.value(
                            value: CartControllerCubit(),
                            child: Builder(
                              builder: (ctx) {
                                return CustomCard(
                                  dish: element.categoryDishes[index],
                                  width: SizeConfig.screenWidth * 0.9,
                                  buttonHeight:
                                      SizeConfig.blockSizeVertical * 4,
                                  buttonWidth: SizeConfig.screenWidth * 0.2,
                                  addOnPressed: () {
                                    cartTotalController.addToCart(
                                        element.categoryDishes[index]);
                                    try {
                                      BlocProvider.of<CartControllerCubit>(ctx)
                                          .increment(CountModel(
                                              dishId: element
                                                  .categoryDishes[index].dishId,
                                              dish: element
                                                  .categoryDishes[index]));
                                    } catch (e) {
                                      print(e);
                                      cartTotalController.removeFromCart(
                                          element.categoryDishes[index]);
                                    }
                                  },
                                  removeOnPressed: () {
                                    cartTotalController.removeFromCart(
                                        element.categoryDishes[index]);
                                    try {
                                      BlocProvider.of<CartControllerCubit>(ctx)
                                          .decrement(CountModel(
                                              dishId: element
                                                  .categoryDishes[index].dishId,
                                              dish: element
                                                  .categoryDishes[index]));
                                    } catch (e) {
                                      print(e);
                                      cartTotalController.addToCart(
                                          element.categoryDishes[index]);
                                    }
                                  },
                                  textWidget: ValueListenableBuilder(
                                    valueListenable:
                                        Hive.box('cart').listenable(),
                                    builder: (BuildContext context, Box value,
                                        Widget child) {
                                      return Text(
                                          value
                                                      .get(element
                                                          .categoryDishes[index]
                                                          .dishId)
                                                      .toString() ==
                                                  "null"
                                              ? "0"
                                              : value
                                                  .get(element
                                                      .categoryDishes[index]
                                                      .dishId)
                                                  .toString(),
                                          style: GoogleFonts.roboto(
                                              color:
                                                  CColor.LoginScreenBGColor));
                                    },
                                  ),
                                  cartButtonWidth: SizeConfig.screenWidth * 0.3,
                                );
                              },
                            ),
                          );
                        });
                  }).toList()),
                ),
              ),
            );
          }
        }));
  }
}

class CustomOvalClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, SizeConfig.blockSizeHorizontal * 4.4,
        SizeConfig.blockSizeHorizontal * 5);
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return true;
  }
}
