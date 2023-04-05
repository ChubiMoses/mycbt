import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void systemChrome() {
  return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor:kPrimaryColor,
  ));
}
