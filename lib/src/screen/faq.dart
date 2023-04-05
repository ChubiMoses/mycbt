import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  var faq = [
    {
      'Question': 'What\'s My CBT?',
      'Answer':
          'My CBT is a platform created for students to share learning resource and knowledge.',
    },
   
   
    {
      'Question': 'PRO User?',
      'Answer':'Remove the points system. Get unrestricted access to all  contents and features by becoming a Pro User.',
    },
    {
      'Question': 'How do I share documents?',
      'Answer':
          'You can share document by tapping on the share icon in the document reader screen.',
    },
    {
      'Question': 'How do I earn ranks?',
      'Answer': 'Earn  ranks by answering questions, each 5 likes gotten by your answer earn you a scholar rank.',
    },
    
    {
      'Question': 'How do I report copyright?',
      'Answer':
          'We do not support upload or sharing of copyrighted materials. Found any copyrighted document? report by tapping on the more icon in document reader screen or contact us immediately  and it will be removed.',
    },

    {
      'icon': Icons.lock_clock,
      'Question': 'I can\'t answer questions in free plan why?.',
      'Answer':'In free plan, you have access to 2014 questions(Exam mode) only.',
    },
    {
      'icon': Icons.lock_clock,
      'Question': 'I successfuly paid the subscription fee, but I\'m still on free plan.',
      'Answer': 'Please relaunch app with good internet connection.',
    },
    {
      'icon': CupertinoIcons.question_circle,
      'Question': 'Can I use my subscription on more than one phone?',
      'Answer':'For now My CBT subscription is only valid on one mobile phone(subscribed phone).',
    },
    {
      'icon': CupertinoIcons.question_circle,
      'Question': "I don't see diagram in my question",
      'Answer':'Please turn on your data connection to load the required diagram.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, strTitle: "FAQ"),
        body: ListView.builder(
            itemCount: faq.length,
            itemBuilder: (context, i) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: kGrey200)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
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
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: kWhite,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(faq[i]['Answer'].toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
