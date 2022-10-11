
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

//Check for network connection
Future<int>checkConnetion() async{
    try{
      final result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
       return 1;
      }
    } on SocketException catch(_){
      return 0;
     }
      return 0;
  }
   // ignore: unused_element
   launchURL(url) async{
      if(await canLaunch(url)){
        await launch(url);
      }else{
        throw "Could not luanch " + url;
      }
  }