import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/points/share_points.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class PointScreen extends StatelessWidget {
  var faq = [
    {
      'Question': 'How do I spend points?',
      'Answer':
          '1. Reading document online cost 5 points, \n2. Downloading documents cost 15 points, \n3. Asking questions cost 5 points.',
    },
    {
      'Question': 'How do I earn points?',
      'Answer':
          'You can earn points by: \n1. Uploading your study materials(lecture    notes, past exams, practical solution, projects...),\n2. watching free video, \n3. Answering questions,  \n4. Inviting friends and \n5. Daily login.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.suit_diamond_fill,
                      color: kWhite,
                      size: 50,
                    ),
                    Text(points.toString(),
                        style: TextStyle(color: kWhite, fontSize: 25)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                     if (currentUser == null) {
                    displayToast("Please login");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginRegisterPage()));
                     
                  }else{Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SharePoints()));
                    }
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width - 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: kWhite),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                        child: Text("SHARE",
                            style: TextStyle(
                                color: kWhite, fontWeight: FontWeight.bold))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          ListView.builder(
              itemCount: faq.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(faq[i]['Question'].toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: kWhite,
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(faq[i]['Answer'].toString(),
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
