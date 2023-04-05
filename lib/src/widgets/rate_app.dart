

import 'package:mycbt/src/screen/feedback.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

class RateApp extends StatefulWidget {
  @override
  _RateAppState createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  List<IconData> stars = List.generate(5, (i) => Icons.star);

  int rating = 5;

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
                  height: 40.0,
                ),
                 const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Like MyCBT? \n Give us 5 star",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlack,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                 
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
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
                                    size: 40.0,
                                    color: rating >= i
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                         const SizedBox(
                        width: 190,
                        child: Text(
                          "Support us by giving 5 star and a review.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kBlack400,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                       
                      ],
                    ),
                  ),
                ),
                Container(
                 
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child:InkWell(
                            onTap:()=> verifyRate(),
                          child: Container(
                             decoration:BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5)
                          ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 12),
                              child: Center(
                                child: Text("RATE NOW",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kWhite)),
                              ),
                            ),
                            
                            
                          ),
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
