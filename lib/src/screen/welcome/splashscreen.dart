import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
     body:Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children:[
         Text(""),
          Container(
            alignment:Alignment.center,
            child:CircleAvatar(
                  backgroundImage:AssetImage("assets/images/logo.png"),
                  radius: 60.0,
                  backgroundColor:Colors.white,
                ),
          ),
           Text("2021 \u00a9cocreator",style:Theme.of(context).textTheme.caption),
       ]
     )
    );
  }
}