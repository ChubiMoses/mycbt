import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/question/ask_question.dart';
import 'package:mycbt/src/screen/web/components/cbt_course_tile.dart';
import 'package:mycbt/src/screen/web/components/course_tile.dart';
import 'package:mycbt/src/screen/web/components/question_slide.dart';
import 'package:mycbt/src/screen/web/widgets/menu_bar.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
             Container(
               padding:EdgeInsets.symmetric(
              horizontal:ResponsiveHelper.isDesktop(context) ? 100 :
             ResponsiveHelper.isTab(context) ? 50 : 0,
             ),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                   const WebMenuBar(),
                   const SizedBox(height: 30,),
                   Padding(
                      padding:EdgeInsets.symmetric(
                      horizontal:ResponsiveHelper.isDesktop(context) ? 0:
                      ResponsiveHelper.isTab(context) ? 0 : 10),
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text("Latest Study Materials", style: 
                     TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w600),),
                     const SizedBox(height: 30,),
                     const CoursesTile(limit: 10,),
                     const SizedBox(height: 30,),
                     Text("CBT Courses", style: 
                     TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w600),),
                     const SizedBox(height: 30,),
                     const CBTCourseTile(limit: 6,),
                     const SizedBox(height: 30,),
                     Text("Questions You Might Like To Answer", style: 
                     TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w600),),
                     const SizedBox(height: 30,),
                     const QuestileTile(),
                     const SizedBox(height: 100,),
                      ],
                     ),
                   )
                ],
               ),
             ),
             Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color:const Color(0xff222222),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const FloatingActionButtonWidget(),
          const SizedBox(height: 10,),
          FloatingActionButton(
           onPressed: () async {
                (currentUser == null)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginRegisterPage()))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AskQuestion((() {
                                  
                                }))));
              },
            child: const Center(
                child: Text("Ask",
                    style: TextStyle(
                        color: kWhite, fontWeight: FontWeight.bold))),
          ),
        ],
      )
    );
  }
}