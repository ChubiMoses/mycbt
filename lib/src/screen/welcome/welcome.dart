import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:onboarding/onboarding.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int index = 0;
  late Material materialButton;

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: Colors.white,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 3;
            setIndex(3);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: Colors.white,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginRegisterPage()));
        },
        child:  Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Sign up',
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  final onboardingPagesList = [
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 20.0, top: 70),
                child: Image.asset(
                  'assets/images/student.png',
                )),
            const SizedBox(
                width: double.infinity,
                child: Text('Welcome', style: pageTitleStyle)),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Get Better Grades! Study and solve assignments easily on your phone.',
                style: pageInfoStyle,
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 20.0, top: 70),
                child: Image.asset(
                  'assets/images/todo.png',
                )),
            const SizedBox(
                width: double.infinity,
                child: Text('Student ToDo', style: pageTitleStyle)),
            const SizedBox(
              width: double.infinity,
              child:  Text(
                'Plan your day, easily access your time table anytime & any where.',
                style: pageInfoStyle,
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 20.0, top: 70),
                child: Image.asset(
                  'assets/images/practical.png',
                )),
            const SizedBox(
                width: double.infinity,
                child: Text('Study Materials', style: pageTitleStyle)),
            const SizedBox(
              width: double.infinity,
              child:  Text(
                'Access quality and latest study materials on My CBT.',
                style: pageInfoStyle,
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 20.0, top: 70),
                child: Image.asset(
                  'assets/images/money.png',
                )),
            const SizedBox(
                width: double.infinity,
                child: Text('REFER & EARN', style: pageTitleStyle)),
            const SizedBox(
              width: double.infinity,
              child:  Text(
                'Refer and earn 10% from each of your referee\'s subscription.',
                style: pageInfoStyle,
              ),
            ),
          ],
        ),
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
      backgroundColor:Theme.of(context).primaryColor,
      body:Onboarding(
          pages: onboardingPagesList,
          onPageChange: (int pageIndex) {
            index = pageIndex;
          },
          startPageIndex: 0,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color:Colors.white,
                border: Border.all(
                  width: 0.0,
                  color:Theme.of(context).primaryColor,
                ),
              ),
              child: ColoredBox(
               color:Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          indicatorDesign: IndicatorDesign.line(
                            lineDesign: LineDesign(
                              lineType: DesignType.line_uniform,
                            ),
                          ),
                        ),
                      ),
                      index == pagesLength - 1
                          ? _signupButton
                          : _skipButton(setIndex: setIndex)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    
    );
  }
}
