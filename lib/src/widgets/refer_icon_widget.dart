import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/colors.dart';

class ReferIconWidget extends StatefulWidget {
  @override
  _ReferIconWidgetState createState() => _ReferIconWidgetState();
}

class _ReferIconWidgetState extends State<ReferIconWidget> {
  Color color = kSecondaryColor;
  List<Color> colors = [
    kWhite,
    kSecondaryColor,
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
    return Container(
      padding: EdgeInsets.all(10),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.asset("assets/images/naira.png", color: color),
    );
  }
}
