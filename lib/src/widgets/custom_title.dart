import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/colors.dart';
Widget customTitle(context, String code, String course, Color color){
   return  RichText(
     textAlign: TextAlign.center,
        text: TextSpan(
          text:"Want to know how you will perform in  ",
        style: const TextStyle(fontSize: 15.0, fontFamily: "OpenSans",color: kBlack),
        children: [
          TextSpan(
            text:"\n"+course.trim().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0,fontFamily: "OpenSans", color:kBlack),
          ),
           const TextSpan(
            text:"?",
            style: TextStyle(fontFamily: "OpenSans", color:Colors.black),
          ),
          ]
        ),
      );
}