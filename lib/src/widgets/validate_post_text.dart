import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan validateText(context, String eachText) {
  if (eachText.startsWith("http") || eachText.endsWith(".com")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: kPrimaryColor, fontFamily: "OpenSans",   fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchURL(eachText);
          });
  } else if (eachText.startsWith("www")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: kPrimaryColor, fontFamily: "OpenSans",  fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchURL("https://$eachText");
          });
  } else if (eachText.startsWith("@")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: kBlack, fontFamily: "OpenSans",  fontWeight: FontWeight.bold));
  } else if (eachText.startsWith("#")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: kBlack,fontFamily: "Lato",  fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPDF()));
          });
  } else {
    return TextSpan(
        text: "$eachText ", style:  TextStyle(color: kBlack400, fontFamily: "OpenSans", fontWeight:FontWeight.w500,));
  }
}
