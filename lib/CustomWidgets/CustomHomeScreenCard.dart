import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zartek_test/Constants/CColor.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
import 'package:zartek_test/CustomWidgets/CustomCartButton.dart';
import 'package:zartek_test/CustomWidgets/ImageWidgetPlaceHolder.dart';
import 'package:zartek_test/Interface/FoodData.dart';

class CustomCard extends StatefulWidget {
  final double width;
  final CategoryDish dish;
  final double buttonHeight;
  final double buttonWidth;
  final Function addOnPressed;
  final Function removeOnPressed;
  final double cartButtonWidth;
  final Widget textWidget;

  CustomCard({Key key,@required this.dish,@required this.width,@required this.buttonHeight,@required this.buttonWidth,@required this.addOnPressed,@required this.removeOnPressed,@required this.textWidget,@required this.cartButtonWidth}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final double length=20;
  final FontWeight fontWeight=FontWeight.w700;
  final double detailColumnGap=SizeConfig.blockSizeVertical*1;

  @override
  Widget build(BuildContext context) {
    return Card(
      child:Container(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*1),
        width: widget.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              width: widget.width*0.75,
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(child: Text(widget.dish.dishName,style: GoogleFonts.roboto(fontSize: widget.width*0.04,fontWeight: fontWeight),)),
                  Container(padding:EdgeInsets.only(top:detailColumnGap),width: widget.width*0.7,child: Row(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text("RS ${widget.dish.dishPrice}",style: GoogleFonts.roboto(fontSize: widget.width*0.04,fontWeight: fontWeight),),
                    Text("${widget.dish.dishCalories} calories",style: GoogleFonts.roboto(fontSize: widget.width*0.04,fontWeight: fontWeight),)
                  ],),),
                  Container(padding:EdgeInsets.only(top:detailColumnGap),width:widget.width*0.75,child: Text(widget.dish.dishDescription,style: GoogleFonts.roboto(),)),
                  Container(padding:EdgeInsets.only(top:detailColumnGap),child: CustomCartButton(gradient: LinearGradient(colors: [CColor.CustomCartButton,CColor.CustomCartButton]), height: widget.buttonHeight, radius:widget.buttonHeight/2, text: widget.textWidget, addOnPressed: widget.addOnPressed, removeonPressed: widget.removeOnPressed, buttonWidth: widget.cartButtonWidth ,)),
                  widget.dish.addonCat.length==0?Container(padding:EdgeInsets.only(top:detailColumnGap),):Container(padding:EdgeInsets.only(top:detailColumnGap),child: Text("Customizations Available",style: GoogleFonts.roboto(color: CColor.thumbsDown),))
                ],
              ),
            ),
            Container(
              width:widget.width*0.2,
              child: ImageWidgetPlaceholder(imageLink:widget.dish.dishImage, placeholder: Center(child: CircularProgressIndicator(),),),
            )
          ],
        ),
      )
    );
  }
}
