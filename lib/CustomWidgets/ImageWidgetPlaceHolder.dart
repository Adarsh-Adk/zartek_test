import 'package:flutter/material.dart';
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
   }
  }
}