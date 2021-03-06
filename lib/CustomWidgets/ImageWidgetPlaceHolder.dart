import 'package:flutter/material.dart';
import 'package:zartek_test/Constants/SizeConfig.dart';
class ImageWidgetPlaceholder extends StatelessWidget {
  const ImageWidgetPlaceholder({
    Key key,
    @required this.imageLink,
    @required this.placeholder,
  }) : super(key: key);
  final String imageLink;
  final Widget placeholder;
  @override
  Widget build(BuildContext context) {
   try{
     return Image.network(
       imageLink,
       errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
         return Container(
           child:Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text("☹️",style: TextStyle(color: Colors.red,fontSize: SizeConfig.blockSizeHorizontal*8),),
               Text("Unable to load Image",style: TextStyle(color: Colors.red,fontSize: SizeConfig.blockSizeHorizontal*3,),textAlign: TextAlign.center,),
             ],
           )
         );
       },
       fit: BoxFit.fitWidth,
       frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
         if (wasSynchronouslyLoaded) {
           return child;
         } else {
           return AnimatedSwitcher(
             duration: const Duration(milliseconds: 500),
             child: frame != null ? child : placeholder,
           );
         }
       },
     );
   }catch(e){
     print(e);
     return Container(
         child:Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Text("☹️",style: TextStyle(color: Colors.red,fontSize: SizeConfig.blockSizeHorizontal*8),),
             Text("Unable to load Image",style: TextStyle(color: Colors.red,fontSize: SizeConfig.blockSizeHorizontal*3,),textAlign: TextAlign.center,),
           ],
         )
     );
   }
  }
}