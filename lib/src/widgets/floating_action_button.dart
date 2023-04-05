import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/utils/colors.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FloatingActionButtonWidgetState createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> {
  Color color = kPrimaryColor;
  List<Color> colors = [
    kPrimaryColor,
    Colors.white,
  ];
  int colorIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    statrTimer();
  }

  void statrTimer() async {
    const onesec = Duration(seconds: 1);
    timer = Timer.periodic(onesec, (timer) {
      setState(() {
        if (colorIndex == 0) {
          colorIndex = 1;
          color = colors[colorIndex];
        } else {
          colorIndex = 0;
          color = colors[colorIndex];
        }
      });
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
       elevation: 4.0,
        color: getPageIndex == 2 ? kPrimaryColor : color,
        child:  SizedBox(
          height: 55,
          width: 55,
          child: Icon(Icons.cloud_upload, color:getPageIndex == 2? kWhite : colorIndex == 0 ? kWhite : kGrey600,)));
  }
}
