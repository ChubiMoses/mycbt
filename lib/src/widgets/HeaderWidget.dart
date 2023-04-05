import 'package:flutter/material.dart';
import 'package:mycbt/src/services/responsive_helper.dart';

AppBar header(context,{ bool isAppTitle = false,required String strTitle, disapearBackButton = false}) {
  return  AppBar(
    automaticallyImplyLeading:ResponsiveHelper.isMobilePhone() ? true : disapearBackButton ? false : false ,
        centerTitle: ResponsiveHelper.isMobilePhone() ? false : true,
    elevation: 0.0,
     title: Text(strTitle, style:const TextStyle(color:Colors.white,fontSize: 14, ),
       overflow: TextOverflow.ellipsis, 
       )
  );
}
