import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';

spinner() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircleAvatar(
      backgroundImage: AssetImage("assets/images/pinwheel.gif"),
      radius: 40.0,
      backgroundColor: Colors.white,
    ),
  );
}

Widget loader() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12.0),
      child: const CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation(
         kPrimaryColor
        ),
      ));
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
    ),
  );
}
