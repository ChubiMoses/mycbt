import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/testimonial/testimonials.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:onboarding/onboarding.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int index = 0;
  final onboardingPagesList = [
    PageModel(
      widget: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 20.0, top: 70),
              child: Image.asset(
                'assets/images/student.png',
              )),
          Container(
              width: double.infinity,
              child: Text('Welcome', style: pageTitleStyle)),
          Container(
            width: double.infinity,
            child: Text(
              'Guarantee your one sitting! worry no more, easily prepare for exams with My CBT.',
              style: pageInfoStyle,
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 20.0, top: 70),
              child: Image.asset(
                'assets/images/todo.png',
              )),
          Container(
              width: double.infinity,
              child: Text('Student ToDo', style: pageTitleStyle)),
          Container(
            width: double.infinity,
            child: Text(
              'Plan your day, easily access your time table anytime & any where.',
              style: pageInfoStyle,
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 20.0, top: 70),
              child: Image.asset(
                'assets/images/practical1.png',
              )),
          Container(
              width: double.infinity,
              child: Text('Practical Solution', style: pageTitleStyle)),
          Container(
            width: double.infinity,
            child: Text(
              'Get upto date solutions for your practical manual.',
              style: pageInfoStyle,
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 20.0, top: 70),
              child: Image.asset(
                'assets/images/money.png',
              )),
          Container(
              width: double.infinity,
              child: Text('REFER & EARN', style: pageTitleStyle)),
          Container(
            width: double.infinity,
            child: Text(
              'Refer and earn 10% from each of your referee\'s subscription.',
              style: pageInfoStyle,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Theme.of(context).primaryColor,
    ));
    return Scaffold(
      body: Onboarding(
        background: Theme.of(context).primaryColor,
        proceedButtonStyle: ProceedButtonStyle(
          proceedpButtonText: Text(
            "Continue",
            style: TextStyle(color: kWhite),
          ),
          proceedButtonColor: Theme.of(context).primaryColor,
          proceedButtonRoute: (context) {
            return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TestimonialScreen("newUser")));
          },
        ),
        pages: onboardingPagesList,
        isSkippable: true,
        indicator: Indicator(
            indicatorDesign: IndicatorDesign.line(
                lineDesign: LineDesign(
          lineType: DesignType.line_nonuniform,
        ))),
      ),
    );
  }
}
