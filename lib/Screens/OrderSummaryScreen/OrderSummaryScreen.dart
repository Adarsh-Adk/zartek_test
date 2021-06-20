import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/Controller/CartBloc/cart_controller_cubit.dart';
import 'package:zartek_test/Controller/CartTotalController.dart';
import 'package:zartek_test/CustomWidgets/CustomRaisedGradientButton.dart';
import 'package:zartek_test/CustomWidgets/CustomSummaryCard.dart';
import 'package:zartek_test/Interface/FoodData.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
import 'package:zartek_test/Models/CountModel.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  Box cartBox = Hive.box("cart");
  Box cartTotalBox = Hive.box("cartTotal");
  List isempty;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CColor.CustomSummaryTitleColor),
        backgroundColor: Colors.white,
        title: Text(
          "Order Summary",
          style: GoogleFonts.roboto(color: CColor.CustomSummaryTitleColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                    top: SizeConfig.screenHeight * 0.03,
                    bottom: SizeConfig.screenHeight * 0.08),
                child: Card(
                    child: Container(
                  width: double.infinity,
                  height: SizeConfig.screenHeight * 0.65,
                  child: GetX<CartTotalController>(
                    builder: (controller) {
                      List<CategoryDish> dishes = [];
                      Map<String, List<CategoryDish>> dishMap = {};
                      controller.list.forEach((element) {
                        dishes.add(element);
                      });
                      dishes.forEach((e) {
                        dishMap[e.dishId] = []..add(e);
                        print("added ${e.dishId}");
                      });

                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 3),
                            width: SizeConfig.screenWidth * 0.7,
                            height: SizeConfig.blockSizeVertical * 10,
                            decoration: BoxDecoration(
                              color: CColor.CustomSummaryButton,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                "${dishMap.keys.length} Dishes ${controller.list.length} items",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 6.5),
                              ),
                            ),
                          ),
                          Container(
                            height: SizeConfig.screenHeight * 0.44,
                            child: controller.list.isNotEmpty
                                ? ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: dishMap.keys.length,
                                    itemBuilder: (context, index) {
                                      List list =
                                          dishMap.values.elementAt(index);
                                      // print("list is $list");
                                      return BlocProvider.value(
                                          value: BlocProvider.of<
                                              CartControllerCubit>(context),
                                          child: Builder(
                                            builder: (ctx) {

                                              return CustomSummaryCard(
                                                dish: list[0],
                                                width: SizeConfig.screenWidth *
                                                    0.8,
                                                buttonHeight: SizeConfig
                                                        .blockSizeVertical *
                                                    4,
                                                buttonWidth:
                                                    SizeConfig.screenWidth *
                                                        0.17,
                                                addOnPressed: () {
                                                  controller
                                                      .addToCart(dishes[index]);
                                                  BlocProvider.of<
                                                              CartControllerCubit>(
                                                          ctx)
                                                      .increment(CountModel(
                                                          dishId: dishes[index]
                                                              .dishId,
                                                          dish: dishes[index]));
                                                },
                                                removeOnPressed: () {
                                                  controller.removeFromCart(
                                                      dishes[index]);
                                                  BlocProvider.of<
                                                              CartControllerCubit>(
                                                          ctx)
                                                      .decrement(CountModel(
                                                          dishId: dishes[index]
                                                              .dishId,
                                                          dish: dishes[index]));
                                                },
                                                textWidget:
                                                    ValueListenableBuilder(
                                                  valueListenable:
                                                      Hive.box("cart")
                                                          .listenable(),
                                                  builder: (context, Box box,
                                                      child) {
                                                    return Text(
                                                        "${box.get(list[0].dishId)}",
                                                        style: GoogleFonts.roboto(
                                                            color: CColor
                                                                .LoginScreenBGColor));
                                                  },
                                                ),
                                                // Hive.box("cartTotal")
                                                cartButtonWidth:
                                                    SizeConfig.screenWidth *
                                                        0.3,
                                                priceWidget:
                                                    ValueListenableBuilder(
                                                  valueListenable:
                                                      Hive.box("cart")
                                                          .listenable(),
                                                  builder: (context, Box box,
                                                      child) {
                                                    return Text(
                                                        "${dishes[index].dishPrice * box.get(list[0].dishId)}",
                                                        style: GoogleFonts.roboto(
                                                            fontSize: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                4,
                                                            color: CColor
                                                                .HomeScreenAppbarIcon));
                                                  },
                                                ),
                                              );
                                            },
                                          ));
                                    },
                                    separatorBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.screenWidth * 0.06),
                                        child: Divider(
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    child: Center(
                                      child: Text(
                                        "Nothing in the cart",
                                        style: GoogleFonts.ubuntu(
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    7),
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth * 0.8,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 8),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: GoogleFonts.roboto(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5),
                                  ),
                                  Text(
                                    "${controller.totalPrice.toStringAsFixed(2)}",
                                    style: GoogleFonts.roboto(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5,
                                        color: CColor.thumbsUp),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.8,
                child: GetX<CartTotalController>(builder: (controller2) {
                  return BlocProvider.value(
                    value: CartControllerCubit(),
                    child: CustomRaisedGradientButton(
                      child: Text(
                        controller2.list.isNotEmpty
                            ? "Place Order"
                            : "Cart is Empty",
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w100, color: Colors.white),
                      ),
                      gradient: LinearGradient(
                          colors: [
                            CColor.PlaceOrderButton,
                            CColor.PlaceOrderButton
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      onPressed: () async {
                        openDialog(context, controller2);
                      },
                      radius: SizeConfig.screenHeight * 0.04,
                      height: SizeConfig.screenHeight * 0.08,
                    ),
                  );
                }),
                height: SizeConfig.screenHeight * 0.08,
              )
            ],
          ),
        ),
      ),
    );
  }

  void openDialog(BuildContext context, CartTotalController controller2) {
    showDialog(
        context: context,
        builder: (cont) {
          Future.delayed(Duration(seconds: 4), () async {
            Navigator.pop(this.context);
            if (controller2.list.isNotEmpty) {
              controller2.resetCart();
              BlocProvider.of<CartControllerCubit>(context).reset();
              Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                      child: HomeScreen(), type: PageTransitionType.fade),
                  (route) => false);
            }
          });
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
                width: SizeConfig.screenWidth * 0.7,
                height: SizeConfig.screenHeight * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      controller2.list.isNotEmpty == true
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_sharp,
                      size: SizeConfig.blockSizeHorizontal * 10,
                      color: controller2.list.isNotEmpty == true
                          ? CColor.thumbsUp
                          : CColor.thumbsDown,
                    ),
                    Text(
                      controller2.list.isNotEmpty == true
                          ? "Order Successfully placed"
                          : "There is nothing in the cart",
                      style: GoogleFonts.ubuntu(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        color: controller2.list.isNotEmpty == true
                            ? CColor.thumbsUp
                            : CColor.thumbsDown,
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
