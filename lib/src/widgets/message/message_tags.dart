import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan messageTags(context, String eachText, bool isMe) {
  if (eachText.startsWith("http") || eachText.endsWith(".com")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: Colors.green.shade800, fontFamily: "OpenSans",   fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchURL(eachText);
          });
  } else if (eachText.startsWith("www")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: Colors.green.shade800, fontFamily: "OpenSans",  fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchURL("http://$eachText");
          });
  } else if (eachText.startsWith("@")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color:  isMe ? Colors.white : Colors.black87, fontFamily: "OpenSans",  fontWeight: FontWeight.bold));
  } else if (eachText.startsWith("#")) {
    return TextSpan(
        text: "$eachText ",
        style: TextStyle(color: kBlack),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPDF()));
          });
  } else {
    return TextSpan(
        text: "$eachText ", style:  TextStyle(color:  isMe ? Colors.white : Colors.black87, fontFamily: "OpenSans", fontWeight:FontWeight.w500, fontSize:12));
  }
}
