import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/CustomWidgets/CustomCartButton.dart';
import 'package:zartek_test/Interface/FoodData.dart';


class CustomSummaryCard extends StatefulWidget {
  final double width;
  final CategoryDish dish;
  final double buttonHeight;
  final double buttonWidth;
  final Function addOnPressed;
  final Function removeOnPressed;
  final double cartButtonWidth;
  final Widget textWidget;
  final Widget priceWidget;

  CustomSummaryCard({Key key,@required this.dish,@required this.width,@required this.buttonHeight,@required this.buttonWidth,@required this.addOnPressed,@required this.removeOnPressed,@required this.textWidget,@required this.cartButtonWidth,@required this.priceWidget}) : super(key: key);

  @override
  _CustomSummaryCardState createState() => _CustomSummaryCardState();
}

class _CustomSummaryCardState extends State<CustomSummaryCard> {
  final double length=20;
  final FontWeight fontWeight=FontWeight.w700;
  final double detailColumnGap=SizeConfig.blockSizeVertical*1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*1),
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Container(
                height: length*0.4,
                decoration: BoxDecoration(
                    color: widget.dish.dishType==1?CColor.thumbsDown:CColor.thumbsUp,
                    shape: BoxShape.circle
                ),
              ),
            ),
            height: length,
            width: length,
            decoration: BoxDecoration(
                border: Border.all(color: widget.dish.dishType==1?CColor.thumbsDown:CColor.thumbsUp,)
            ),
          ),
          Container(

            width: widget.width*0.4,
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(child: Text(widget.dish.dishName,style: GoogleFonts.roboto(fontSize: widget.width*0.04,fontWeight: fontWeight),)),
                Container(padding:EdgeInsets.only(top:detailColumnGap),width: widget.width*0.7,child:Text("RS ${widget.dish.dishPrice}",style: GoogleFonts.roboto(fontSize: widget.width*0.04,fontWeight: fontWeight),),),
                Container(padding:EdgeInsets.only(top:detailColumnGap),width: widget.width*0.7,child:Text("${widget.dish.dishCalories} calories",style: GoogleFonts.roboto(fontSize: widget.width*0.04,fontWeight: fontWeight),),),
              ],
            ),
          ),
          Container(width:widget.width*0.3,child: CustomCartButton(gradient: LinearGradient(colors: [CColor.CustomSummaryButton,CColor.CustomSummaryButton]), height: widget.buttonHeight, radius:widget.buttonHeight/2, text: widget.textWidget, addOnPressed: widget.addOnPressed, removeonPressed: widget.removeOnPressed, buttonWidth: widget.cartButtonWidth ,)),
          Container(
            width:widget.width*0.15,
            child: widget.priceWidget,
          )
        ],
      ),
    );
  }
}
