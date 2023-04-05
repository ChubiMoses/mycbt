import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  var about = [
      {
       'icon': CupertinoIcons.smiley,
       'Question':'Welcome to My CBT',
       'Answer': 'My CBT is a platform created for students around the world to share study materials and knowledge. ',
     },

     { 'icon': Icons.cloud_download,
       'Question':'Download',
       'Answer': 'Download summaries, past questions, lecture notes, assignments solutions and much more.',
     },
     
      {
       'icon': CupertinoIcons.question_circle,
       'Question':'Ask Question',
       'Answer': 'Can’t figure out the answer to a question? Ask for help and your fellow students will be glad to answer.',
     },
      { 
       'icon':  Icons.notifications_active,
       'Question':'Notification',
       'Answer': 'We will keep you informed of the new documents that other students have uploaded for your courses.',
     },

    {
      'icon': CupertinoIcons.smiley,
      'Question': 'CBT Exams',
      'Answer':'CBT feature to  aid  students preparations  for CBT Examinations and tests.',
    },
    {
      'icon': Icons.lock_clock,
      'Question': 'Time Management',
      'Answer':'Learn how to manage time. Know how much time you have for each question, start with questions you can answer and come back to the rest',
    },
    {
      'icon': CupertinoIcons.book_circle,
      'Question': 'Study Mode',
      'Answer': 'Study with My CBT app by your side, see answers to each questions at your pace.',
    },
    {
      'icon': CupertinoIcons.question_circle,
      'Question': 'Exam Mode',
      'Answer':'Want to know how you will perform in your CBT exams? then, test yourself now.',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, strTitle: "About"),
        body:ListView.builder(
          itemCount: about.length,
          shrinkWrap:true,
          padding: EdgeInsets.all(30),
          itemBuilder:((context, index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                   SizedBox(height: 5.0),
                  Text(about[index]['Question'].toString(),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  Text(about[index]['Answer'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          })
        )
     );
          
  }
}
