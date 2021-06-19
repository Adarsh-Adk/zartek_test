// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:zartek_test/Constants/CColor.dart';
// import 'package:zartek_test/Constants/SizeConfig.dart';
// import 'package:zartek_test/Controller/CartBloc/cart_controller_cubit.dart';
// import 'package:zartek_test/Controller/CartTotalController.dart';
// import 'package:zartek_test/CustomWidgets/CustomRaisedGradientButton.dart';
// import 'package:zartek_test/CustomWidgets/CustomSummaryCard.dart';
// import 'package:zartek_test/Interface/FoodData.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:zartek_test/Screens/HomeScreen/HomeScreen.dart';
// import 'package:zartek_test/Services/HelperService.dart';
//
// class OrderSummaryScreen extends StatefulWidget {
//
//   @override
//   _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
// }
//
// class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
//
//   @override
//   Widget build(context) {
//     return Scaffold(
//       appBar: AppBar(iconTheme: IconThemeData(color: CColor.CustomSummaryTitleColor),backgroundColor: Colors.white,title: Text("Order Summary",style: GoogleFonts.roboto(color: CColor.CustomSummaryTitleColor),),),
//       body: SafeArea(
//         child: Container(
//           height: SizeConfig.screenHeight,
//           width: SizeConfig.screenWidth,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,right:SizeConfig.blockSizeHorizontal*3,top: SizeConfig.screenHeight*0.03,bottom: SizeConfig.screenHeight*0.08),
//                 child: Card(child: Container(
//                   width: double.infinity,
//                   height: SizeConfig.screenHeight*0.65,
//                   child: GetX<CartTotalController>(
//                     builder: (controller){
//                       List dishesId=[];
//                       List<CategoryDish> dishes=[];
//                       List<CategoryDish>elem=[];
//
//                       controller.list.forEach((element) {
//                         // print(element.runtimeType);
//                         // print("element is $element");
//                         elem.add(element);
//                       });
//                       elem.forEach((element) {
//                         if(!dishesId.contains(element.dishId)){
//                           dishesId.add(element.dishId);
//                           dishes.add(element);
//                         }
//                       });
//
//                       return Column(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3),
//                             width: SizeConfig.screenWidth*0.7,
//                             height: SizeConfig.blockSizeVertical*10,
//                             decoration: BoxDecoration(
//                               color: CColor.CustomSummaryButton,
//                               borderRadius: BorderRadius.all(Radius.circular(10)),
//                             ),
//                             child: Center(
//                               child: Text("${dishesId.length} Dishes ${controller.list.length} items",style: GoogleFonts.roboto(color: Colors.white,fontSize: SizeConfig.blockSizeHorizontal*6.5),),
//                             ),
//                           ),
//                           Container(
//                             height: SizeConfig.screenHeight*0.44,
//                             child: ListView.separated(
//                               // physics: NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               scrollDirection: Axis.vertical,
//                               itemCount: dishes.length,
//                               itemBuilder: (context,index){
//                                 return BlocProvider.value(
//                                     value: BlocProvider.of<CartControllerCubit>(context),
//                                     child:Builder(builder: (ctx){
//                                       // Box box=Hive.box("cart");
//                                       // BlocProvider.of<CartControllerCubit>(ctx)
//                                       //     .initial(dishes[index], 0);
//                                       return CustomSummaryCard(
//                                           dish: dishes[index],
//                                           width: SizeConfig.screenWidth * 0.8,
//                                           buttonHeight: SizeConfig.blockSizeVertical * 4,
//                                           buttonWidth: SizeConfig.screenWidth * 0.17,
//                                           addOnPressed: (){
//                                             controller.addToCart(dishes[index]);
//                                             BlocProvider.of<CartControllerCubit>(ctx)
//                                                 .increment(dishes[index]);
//                                           },
//                                           removeOnPressed:(){
//                                             controller.removeFromCart(
//                                                dishes[index]);
//                                             BlocProvider.of<CartControllerCubit>(ctx).decrement(dishes[index]);
//                                           },
//                                           textWidget: ValueListenableBuilder(
//                                             valueListenable: Hive.box("cart").listenable(),
//                                             builder: (context,Box box,child){
//                                             return  Text("${box.get(dishes[index].dishId)}",
//                                                   style: GoogleFonts.roboto(
//                                                       color:
//                                                       CColor.LoginScreenBGColor));
//                                             },
//                                           ),
//                                           cartButtonWidth: SizeConfig.screenWidth * 0.3,
//                                         priceWidget: BlocBuilder<CartControllerCubit,
//                                             CartControllerState>(
//                                           builder: (ctx, state) {
//                                             if (state is CartControllerLoaded) {
//                                               return Text("test",
//                                                   style: GoogleFonts.roboto(
//                                                     fontSize: SizeConfig.blockSizeHorizontal*5,
//                                                       color:
//                                                       CColor.LoginScreenBGColor));
//                                             }else{
//                                               return Text("test2",
//                                                   style: GoogleFonts.roboto(
//                                                       color:
//                                                       CColor.LoginScreenBGColor));
//                                           }}
//                                         ),);
//                                     },)
//                                     );
//                               },
//                               separatorBuilder: (context,index){
//                                 return Container(
//                                   width:SizeConfig.screenWidth*0.8,
//                                   child: Divider(),);
//                               }, ),
//                           ),
//                           Container(width:SizeConfig.screenWidth*0.8,padding: EdgeInsets.symmetric(vertical: 5),child: Divider(thickness: 1,color:Colors.black ,),),
//                           Container(
//
//                             padding:EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*8),
//                             child: Center(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Total Amount",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal*5),),
//                               Text("INR 65.0",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal*5,color: CColor.thumbsUp),)
//                             ],
//                           ),
//                           ),)
//                         ],
//                       );
//                     },
//                   ),
//                 )),
//               ),
//               Container(
//                 width:SizeConfig.screenWidth*0.8,
//                 child: CustomRaisedGradientButton(child: Text("Place Order",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w100,color: Colors.white),), gradient: LinearGradient(colors: [CColor.PlaceOrderButton,CColor.PlaceOrderButton],begin: Alignment.centerLeft,end: Alignment.centerRight), onPressed: (){
//                   showDialog(context: context, builder: (cont){
//                     Future.delayed(Duration(seconds: 4),(){
//                       Navigator.pop(context);
//                       Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade), (route) => false);
//                       HelperService.clearAllBoxes();
//                     });
//                     return Dialog(
//                       insetPadding: EdgeInsets.zero,
//                       child: Container(
//                         width:SizeConfig.screenWidth*0.7,
//                         height: SizeConfig.screenHeight*0.3,
//                         child:Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(Icons.check_circle_outline,size: SizeConfig.blockSizeHorizontal*8,color: CColor.thumbsUp,),
//                             Text("Order Successfully placed",style: GoogleFonts.ubuntu(fontSize: SizeConfig.blockSizeHorizontal*5,color: CColor.thumbsUp,),)
//                           ],
//                         )
//                       ),
//                     );
//                   });
//                 },radius:SizeConfig.screenHeight*0.04), height: SizeConfig.screenHeight*0.08 , )],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
import 'package:zartek_test/Services/HelperService.dart';

class OrderSummaryScreen extends StatefulWidget {

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: CColor.CustomSummaryTitleColor),backgroundColor: Colors.white,title: Text("Order Summary",style: GoogleFonts.roboto(color: CColor.CustomSummaryTitleColor),),),
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,right:SizeConfig.blockSizeHorizontal*3,top: SizeConfig.screenHeight*0.03,bottom: SizeConfig.screenHeight*0.08),
                child: Card(child: Container(
                  width: double.infinity,
                  height: SizeConfig.screenHeight*0.65,
                  child: GetX<CartTotalController>(
                    builder: (controller){
                      List<CategoryDish> dishes=[];
                      List dishIds=[];
                      List<CategoryDish> dish=[];
                      controller.list.forEach((element) {
                        dishes.add(element);
                      });
                      dishIds.addAll(dishes.map((e){
                      if(!dish.contains(e.dishId)){
                        dish.add(e);
                      }}));




                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3),
                            width: SizeConfig.screenWidth*0.7,
                            height: SizeConfig.blockSizeVertical*10,
                            decoration: BoxDecoration(
                              color: CColor.CustomSummaryButton,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text("${dish.length} Dishes ${controller.list.length} items",style: GoogleFonts.roboto(color: Colors.white,fontSize: SizeConfig.blockSizeHorizontal*6.5),),
                            ),
                          ),
                          Container(
                            height: SizeConfig.screenHeight*0.44,
                            child: ListView.separated(
                              // physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: dish.length,
                              itemBuilder: (context,index){
                                return BlocProvider.value(
                                    value: BlocProvider.of<CartControllerCubit>(context),
                                    child:Builder(builder: (ctx){
                                      // Box box=Hive.box("cart");
                                      // BlocProvider.of<CartControllerCubit>(ctx)
                                      //     .initial(dishes[index], 0);
                                      return CustomSummaryCard(
                                        dish: dish[index],
                                        width: SizeConfig.screenWidth * 0.8,
                                        buttonHeight: SizeConfig.blockSizeVertical * 4,
                                        buttonWidth: SizeConfig.screenWidth * 0.17,
                                        addOnPressed: (){
                                          controller.addToCart(dishes[index]);
                                          BlocProvider.of<CartControllerCubit>(ctx)
                                              .increment(dishes[index]);
                                        },
                                        removeOnPressed:(){
                                          controller.removeFromCart(dishes[index]);
                                          BlocProvider.of<CartControllerCubit>(ctx).decrement(dishes[index]);
                                        },
                                        textWidget: ValueListenableBuilder(
                                          valueListenable: Hive.box("cart").listenable(),
                                          builder: (context,Box box,child){
                                            return  Text("${box.get(dishes[index].dishId)}",
                                                style: GoogleFonts.roboto(
                                                    color:
                                                    CColor.LoginScreenBGColor));
                                          },
                                        ),
                                        cartButtonWidth: SizeConfig.screenWidth * 0.3,
                                        priceWidget: BlocBuilder<CartControllerCubit,
                                            CartControllerState>(
                                            builder: (ctx, state) {
                                              if (state is CartControllerLoaded) {
                                                return Text("test",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: SizeConfig.blockSizeHorizontal*5,
                                                        color:
                                                        CColor.LoginScreenBGColor));
                                              }else{
                                                return Text("test2",
                                                    style: GoogleFonts.roboto(
                                                        color:
                                                        CColor.LoginScreenBGColor));
                                              }}
                                        ),);
                                    },)
                                );
                              },
                              separatorBuilder: (context,index){
                                return Container(
                                  width:SizeConfig.screenWidth*0.8,
                                  child: Divider(),);
                              }, ),
                          ),
                          Container(width:SizeConfig.screenWidth*0.8,padding: EdgeInsets.symmetric(vertical: 5),child: Divider(thickness: 1,color:Colors.black ,),),
                          Container(

                            padding:EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*8),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Amount",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal*5),),
                                  Text("${controller.totalPrice}",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal*5,color: CColor.thumbsUp),)
                                ],
                              ),
                            ),)
                        ],
                      );
                    },
                  ),
                )),
              ),
              Container(
                width:SizeConfig.screenWidth*0.8,
                child: CustomRaisedGradientButton(child: Text("Place Order",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w100,color: Colors.white),), gradient: LinearGradient(colors: [CColor.PlaceOrderButton,CColor.PlaceOrderButton],begin: Alignment.centerLeft,end: Alignment.centerRight), onPressed: (){
                  showDialog(context: context, builder: (cont){
                    Future.delayed(Duration(seconds: 4),(){
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(context, PageTransition(child: HomeScreen(), type: PageTransitionType.fade), (route) => false);
                      HelperService.clearAllBoxes();
                    });
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: Container(
                          width:SizeConfig.screenWidth*0.7,
                          height: SizeConfig.screenHeight*0.3,
                          child:Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline,size: SizeConfig.blockSizeHorizontal*8,color: CColor.thumbsUp,),
                              Text("Order Successfully placed",style: GoogleFonts.ubuntu(fontSize: SizeConfig.blockSizeHorizontal*5,color: CColor.thumbsUp,),)
                            ],
                          )
                      ),
                    );
                  });
                },radius:SizeConfig.screenHeight*0.04, height: SizeConfig.screenHeight*0.08,), height: SizeConfig.screenHeight*0.08 , )],
          ),
        ),
      ),
    );
  }
}
