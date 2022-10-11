import 'package:flutter/material.dart';

AppBar header(context,{ bool isAppTitle = false,required String strTitle, disapearBackButton = false}) {
  return  AppBar(
    centerTitle:false,
    elevation: 2.0,
     automaticallyImplyLeading: disapearBackButton ? false : true,
     title: Text(strTitle, style:const TextStyle(color:Colors.white,fontSize: 14, fontWeight: FontWeight.w800),
       overflow: TextOverflow.ellipsis, 
       )
  );
}
