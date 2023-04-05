
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

displayToast(String msg){
       return Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg:msg,
        backgroundColor: Colors.black54,
        textColor: Colors.white
        );
    }