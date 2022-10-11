
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/documents/pdf_upload.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/notification.dart';
import 'package:mycbt/src/screen/messages/messages.dart';
import 'package:mycbt/src/screen/referal/referal.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/refer_icon_widget.dart';



AppBar homeAppBar(BuildContext context, VoidCallback refreshMessage, VoidCallback refreshNotification, int noteCount, int messageCount){  
  return AppBar(
     title:const Text("My CBT", style: TextStyle(fontWeight: FontWeight.w700, fontSize:15),),
     elevation: 0,
      actions: [
          Row(
          children: [
          
             GestureDetector(
               onTap:()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                            ReferralProgram())),
               child: ReferIconWidget()
               ),
             SizedBox(width:4,),
              GestureDetector(
              onTap: (){
                if(currentUser == null){
                  displayToast("Please login");
                }else{
                   Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Messages(refreshMessage)));
                }
              },
              child: Stack(
                children: [
                  Icon(Icons.mail, size: 25, color: kWhite),
                  messageCount == 0
                      ? SizedBox.shrink()
                      : Positioned(
                          right: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 10,
                                  offset: Offset(0,
                                      1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.deepOrange,
                              child: Text(messageCount.toString(),
                                  style: TextStyle(fontSize: 8, color: kWhite)),
                            ),
                          ),
                        )
                ],
              ),
            ),
            SizedBox(width:8),
            GestureDetector(
              onTap: (){
                 if(currentUser == null){
                  displayToast("Please login");
                }else{
               Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      NotificationScreen(refreshNotification:refreshNotification)));
                }
              },
              child: Stack(
                children: [
                  Icon(Icons.notifications, size: 25, color: kWhite),
                  noteCount == 0
                      ? SizedBox.shrink()
                      : Positioned(
                          right: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 10,
                                  offset: Offset(0,
                                      1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.deepOrange,
                              child: Text(noteCount.toString(),
                                  style: TextStyle(fontSize: 8, color: kWhite)),
                            ),
                          ),
                        )
                ],
              ),
            ),
            SizedBox(width:20),
          ],
        ),
      ],
    );
}
