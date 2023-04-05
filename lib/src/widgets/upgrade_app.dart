import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/buttons.dart';

class UpgradeApp extends StatefulWidget {
  final String message;
  final bool expired;
  UpgradeApp({required this.message, required this.expired});

  @override
  _RateAppState createState() => _RateAppState();
}

class _RateAppState extends State<UpgradeApp> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: <Widget>[
          Text("Update App", style: Theme.of(context).textTheme.subtitle1),
          const Divider()
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

                const Center(
                    child: Icon(
                  CupertinoIcons.time,
                  color: Colors.grey,
                  size: 80.0,
                )),
                const SizedBox(
                  height: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(widget.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: <Widget>[
                 Expanded(
                  child:TextButtonWidget(
                      btnText: "UPDATE",
                       onPressed: () => launchURL(
                          "https://play.google.com/store/apps/details?id=com.ccr.mycbt"),
                          ) 
                          
                )
            ],
          ),
        )
      ],
    );
  }
}
