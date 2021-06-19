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
import 'package:zartek_test/Screens/OrderSummaryScreen/OrderSummaryScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final tableController = Get.put(FoodDataController());
  final cartTotalController = Get.put(CartTotalController());
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  String uId;
  String imageUrl;
  String userName;

  Box box=Hive.box("user");
  @override
  void initState() {
    uId=box.get("userId");
    imageUrl=box.get("imageUrl");
    userName=box.get("userName");
    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //       print('appLifeCycleState inactive');
  //       break;
  //     case AppLifecycleState.resumed:
  //       setState(() {
  //
  //       });
  //       break;
  //     case AppLifecycleState.paused:
  //       print('appLifeCycleState paused');
  //       break;
  //   }
  // }

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
            print("table controller:${tableController.tableMenuList.length}");
            return DefaultTabController(
              initialIndex: 0,
              length: tableController.tableMenuList.length,
              child: BlocProvider<CartControllerCubit>(
                create: (ctx) => CartControllerCubit(),
                child: Scaffold(
                  drawer: CustomDrawer(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth, uid: uId, imageUrl: imageUrl, userName: userName),
                  key: _scaffoldKey,
                  floatingActionButton: FloatingActionButton(
                    child: Icon(
                      Icons.check,
                      color: CColor.thumbsUp,
                    ),
                    backgroundColor: CColor.LoginScreenBGColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: BlocProvider.value(
                                value: CartControllerCubit(),
                                child: OrderSummaryScreen(),
                              ),
                              type: PageTransitionType.fade));
                    },
                  ),
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: (){
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
                              Icon(
                                Icons.shopping_cart,
                                color: CColor.HomeScreenAppbarIcon,
                                size: SizeConfig.blockSizeHorizontal * 9,
                              ),
                              Container(
                                  height: SizeConfig.blockSizeHorizontal * 6,
                                  child: Center(
                                      child: ClipOval(
                                          clipper: CustomOvalClip(),
                                          child: Container(
                                            child: Center(child:
                                                GetX<CartTotalController>(
                                              builder: (controller2) {
                                                return Text(
                                                  "${controller2.list.length}",
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
                                          .increment(
                                              element.categoryDishes[index]);
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
                                          .decrement(
                                              element.categoryDishes[index]);
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
                                                  .categoryDishes[index].dishId)
                                              .toString()=="null"?"0":value
                                              .get(element
                                              .categoryDishes[index].dishId)
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
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:zartek_test/Constants/CColor.dart';
// import 'package:zartek_test/Constants/SizeConfig.dart';
// import 'package:zartek_test/Controller/CartBloc/cart_controller_cubit.dart';
// import 'package:zartek_test/Controller/CartTotalController.dart';
// import 'package:zartek_test/Controller/FoodDataController.dart';
// import 'package:zartek_test/CustomWidgets/CustomDrawer.dart';
// import 'package:zartek_test/CustomWidgets/CustomHomeScreenCard.dart';
// import 'package:zartek_test/Screens/OrderSummaryScreen/OrderSummaryScreen.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   final tableController = Get.put(FoodDataController());
//   final cartTotalController = Get.put(CartTotalController());
//   GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
//   String uId;
//   String imageUrl;
//   String userName;
//
//   Box box=Hive.box("user");
//   @override
//   void initState() {
//     uId=box.get("userId");
//     imageUrl=box.get("imageUrl");
//     userName=box.get("userName");
//     super.initState();
//   }
//
//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   super.didChangeAppLifecycleState(state);
//   //   switch (state) {
//   //     case AppLifecycleState.inactive:
//   //       print('appLifeCycleState inactive');
//   //       break;
//   //     case AppLifecycleState.resumed:
//   //       setState(() {
//   //
//   //       });
//   //       break;
//   //     case AppLifecycleState.paused:
//   //       print('appLifeCycleState paused');
//   //       break;
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.white,
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth,
//         child: GetX<FoodDataController>(builder: (controller) {
//           if (tableController.isLoading.value == true) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             print("table controller:${tableController.tableMenuList.length}");
//             return DefaultTabController(
//               initialIndex: 0,
//               length: tableController.tableMenuList.length,
//               child: BlocProvider<CartControllerCubit>(
//                 create: (ctx) => CartControllerCubit(),
//                 child: Scaffold(
//                   drawer: CustomDrawer(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth, uid: uId, imageUrl: imageUrl, userName: userName),
//                   key: _scaffoldKey,
//                   floatingActionButton: FloatingActionButton(
//                     child: Icon(
//                       Icons.check,
//                       color: CColor.thumbsUp,
//                     ),
//                     backgroundColor: CColor.LoginScreenBGColor,
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                               child: BlocProvider.value(
//                                 value: CartControllerCubit(),
//                                 child: OrderSummaryScreen(),
//                               ),
//                               type: PageTransitionType.fade));
//                     },
//                   ),
//                   appBar: AppBar(
//                     leading: IconButton(
//                       onPressed: (){
//                         _scaffoldKey.currentState.openDrawer();
//                       },
//                       icon: Icon(
//                         Icons.menu,
//                         color: CColor.HomeScreenAppbarIcon,
//                       ),
//                     ),
//                     backgroundColor: Colors.white,
//                     automaticallyImplyLeading: false,
//                     bottom: TabBar(
//                         isScrollable: true,
//                         indicatorColor: CColor.HomeScreenTabBarText,
//                         tabs: tableController.tableMenuList
//                             .map(
//                               (element) => Tab(
//                             child: Text(
//                               "${element.menuCategory}",
//                               style: GoogleFonts.roboto(
//                                   fontWeight: FontWeight.bold,
//                                   color: CColor.HomeScreenTabBarText),
//                             ),
//                           ),
//                         )
//                             .toList()),
//                     actions: [
//                       Container(
//                         height: double.infinity,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: SizeConfig.screenWidth * 0.03),
//                         child: Center(
//                           child: Stack(
//                             alignment: Alignment.topRight,
//                             children: [
//                               Icon(
//                                 Icons.shopping_cart,
//                                 color: CColor.HomeScreenAppbarIcon,
//                                 size: SizeConfig.blockSizeHorizontal * 9,
//                               ),
//                               Container(
//                                   height: SizeConfig.blockSizeHorizontal * 6,
//                                   child: Center(
//                                       child: ClipOval(
//                                           clipper: CustomOvalClip(),
//                                           child: Container(
//                                             child: Center(child:
//                                             GetX<CartTotalController>(
//                                               builder: (controller2) {
//                                                 return Text(
//                                                   "${controller2.mapp.values.fold(0, (previousValue, element) => previousValue+element)}",
//                                                   style: GoogleFonts.roboto(
//                                                       fontSize: 8,
//                                                       color: Colors.white),
//                                                 );
//                                               },
//                                             )),
//                                             width:
//                                             SizeConfig.blockSizeHorizontal *
//                                                 5,
//                                             decoration: BoxDecoration(
//                                               color: Colors.red,
//                                             ),
//                                           ))))
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   body: TabBarView(
//                       children: tableController.tableMenuList.map((element) {
//                         // print("itemcount: ${element.categoryDishes.length}");
//                         return ListView.builder(
//                             itemCount: element.categoryDishes.length,
//                             itemBuilder: (context, index) {
//                               return BlocProvider.value(
//                                 value: CartControllerCubit(),
//                                 child: Builder(
//                                   builder: (ctx) {
//                                     return CustomCard(
//                                       dish: element.categoryDishes[index],
//                                       width: SizeConfig.screenWidth * 0.9,
//                                       buttonHeight:
//                                       SizeConfig.blockSizeVertical * 4,
//                                       buttonWidth: SizeConfig.screenWidth * 0.2,
//                                       addOnPressed: () {
//                                         cartTotalController.addToCart(
//                                             element.categoryDishes[index]);
//                                         try {
//                                           BlocProvider.of<CartControllerCubit>(ctx)
//                                               .increment(
//                                               element.categoryDishes[index]);
//                                         } catch (e) {
//                                           print(e);
//                                           cartTotalController.removeFromCart(
//                                               element.categoryDishes[index]);
//                                         }
//                                       },
//                                       removeOnPressed: () {
//                                         cartTotalController.removeFromCart(
//                                             element.categoryDishes[index]);
//                                         try {
//                                           BlocProvider.of<CartControllerCubit>(ctx)
//                                               .decrement(
//                                               element.categoryDishes[index]);
//                                         } catch (e) {
//                                           print(e);
//                                           cartTotalController.addToCart(
//                                               element.categoryDishes[index]);
//                                         }
//                                       },
//                                       textWidget: ValueListenableBuilder(
//                                         valueListenable:
//                                         Hive.box('cart').listenable(),
//                                         builder: (BuildContext context, Box value,
//                                             Widget child) {
//                                           return Text(
//                                               value
//                                                   .get(element
//                                                   .categoryDishes[index].dishId)
//                                                   .toString(),
//                                               style: GoogleFonts.roboto(
//                                                   color:
//                                                   CColor.LoginScreenBGColor));
//                                         },
//                                       ),
//                                       cartButtonWidth: SizeConfig.screenWidth * 0.3,
//                                     );
//                                   },
//                                 ),
//                               );
//                             });
//                       }).toList()),
//                 ),
//               ),
//             );
//           }
//         }));
//   }
// }
//
// class CustomOvalClip extends CustomClipper<Rect> {
//   @override
//   Rect getClip(Size size) {
//     return Rect.fromLTWH(0, 0, SizeConfig.blockSizeHorizontal * 4.4,
//         SizeConfig.blockSizeHorizontal * 5);
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
//     return true;
//   }
// }
