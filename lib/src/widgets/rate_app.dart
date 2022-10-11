

import 'package:mycbt/src/screen/feedback.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/buttons.dart';

class RateApp extends StatefulWidget {
  @override
  _RateAppState createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  List<IconData> stars = List.generate(5, (i) => Icons.star);

  int rating = -1;

  String message = '';

  changeStar(rating) {
    switch (rating) {
      case 0:
        message = "I hate it";
        break;
      case 1:
        message = "It's ok";
        break;
      case 2:
        message = "I like it";
        break;
      case 3:
        message = "I love it";
        break;
      case 4:
        message = "It's the best";
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 320.0,
        width: 500.0,
        child: Dialog(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo.png"),
                  radius: 40.0,
                  backgroundColor: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Rate My CBT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          height: 30.0,
                          child: ListView.builder(
                              itemCount: stars.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(left: 45.0),
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      rating = i;
                                      changeStar(i);
                                    });
                                  },
                                  child: Icon(
                                    stars[i],
                                    size: 35.0,
                                    color: rating >= i
                                        ? Colors.lightGreen
                                        : Colors.grey,
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        const Text(
                          "Click on stars to rate on play store",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(message),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextButtonWidget(
                          btnText:"Close",
                        onPressed: () => Navigator.pop(context),
                        ) 
                       
                      ),
                      Expanded(
                          child:TextButtonWidget(
                          btnText:"Close",
                        onPressed:()=>
                                  rating == -1 ? null : () => verifyRate(),
                        ) )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 void  verifyRate() {
    if (rating > 2) {
      launchURL("https://play.google.com/store/apps/details?id=com.cc.MyCBT");
      usersReference.doc(currentUser?.id).update({
        "rate": 1,
      });
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FeedBack("Rate")));
    }
    Navigator.pop(context);
  }
}
