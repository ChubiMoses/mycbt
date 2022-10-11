import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/testimonial/add_testimonial.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/testimonial_tab.dart';
import 'package:flutter/material.dart';

class TestimonialScreen extends StatefulWidget {
  final String view;
  TestimonialScreen(this.view);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<TestimonialScreen> {
  int index = 0;

  var testimonials = [
    {
      'name': 'Madueke Miracle',
      'image': 'assets/images/Miracle.jpg',
      'course': 'Mechanical Engineering',
      'review': 'This is the best CBT app I\'ve ever found. My CBT, the light to all tetiary CBT exams. As a year 1' +
          'student we usually don\'t have much experience with CBT exams, and this gives us a real life experience of what it all is.' +
          'I\'d be bouncing into the exam hall without any doubts any day... God bless MyCBT.',
      'url': 'https://m.facebook.com/profile.php?id=100013067116734'
    },
    {
      'name': 'Saaondo Apkaaku',
      'image': 'assets/images/Apkaku.jpg',
      'course': 'Biology Education',
      'review': 'My CBT is indeed a perfect app for tertiary institution students.' +
          'If you yet to get the app please do so. It is really aiding me in my preparations such that when I\'m studying am just ' +
          'picturing the questions that I will be asked at the end of the day, even when the lecturer is teaching.' +
          'Infact,I appreciate efforts of the people that put this perfect app for us to enjoy, even the cost of activation' +
          'does not even worth it. But note, your reward is in heaven.',
      'url': 'https://m.facebook.com/profile.php?id=100042552964596'
    },
    {
      'name': 'Godfrey Osho',
      'image': 'assets/images/Godfrey osho.jpg',
      'course': 'Biochemistry',
      'review': 'My CBT is the best app I have used to do my personal studies, not withstanding there are some typographical errors which ' +
          'are always been corrected. The app was so helpful during my Exams I wrote all my papers with just studying ' +
          '*MY CBT APP* and guess what, most of the questions I answered in the past question section came out!',
      'url': 'https://m.facebook.com/profile.php?id=100024176984900'
    },
    {
      'name': 'GEMANEN WILFRED',
      'image': 'assets/images/TYONONGU GEMANEN WILFRED.jpg',
      'course': 'Animal Production',
      'review':
          'Sir, we are pleased with this app (My CBT). It really helped us during our exams. I/We ask for more in this second semester too. We will be happy if you update it earlier.' +
              'Thank you sir.',
      'url': 'https://m.facebook.com/profile.php?id=100055198167193'
    },
    {
      'name': 'Aza Mou Eric',
      'image': 'assets/images/Aza Mou Eric.jpg',
      'course': 'Electrical and Electronics Engineering',
      'review': 'My CBT was of so much  help, it guided me through my exams! it was my first exam in the university ' +
          ' and i wrote it without fear, due to so much practice using My CBT.' +
          'I like My CBT because:' +
          '\n\n 1. Past Questions: My CBT provide me with alots of past questions of various courses. Through out the semester ' +
          'I don\'t have to burder  buying  hard copy of these past questions because there are already in MY CBT' +
          'which I can access anytime, anywhere via my mobile phone and that reduce my expenses being on campus. ' +
          '\n\n 2. Time allocated for the exams: With the help of My CBT, I understand and know the time ' +
          'which will be allocated to a particular course  and that really helped me in managing time during exams. ',
      'url': 'https://www.facebook.com/mou.aza.90',
    },
    {
      'name': 'Peter K.  Conerlius',
      'course': 'Electrical and Electronics Engineering',
      'image': 'assets/images/Peter K. Conerlius.jpg',
      'review': 'The App really helped me during my exams. My CBT exposed ' +
          ' me to the school pattern of setting questions, and I saw so many questions from My CBT in my exams. I was like "Answering without reading the question 😊" cause I am already familiar with it ,' +
          ' and with the help of My CBT, I learnt how to manage my time during exams. Thanks to My CBT!',
      'url': 'https://m.facebook.com/profile.php?id=100024176984900',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Testimonials"),
      backgroundColor: kBgScaffold,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(_builtExamsCategory,
                    childCount: testimonials.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0)),
          ),
          SliverPadding(
              padding:
                  EdgeInsets.only(right: 20.0, top: 5.0, bottom: 50, left: 20),
              sliver: SliverToBoxAdapter(
                child:  Container(
                  color: kWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text("We will be glad to receive your testimonial too!", textAlign: TextAlign.center,
                           style: TextStyle(
                                              color: kBlack400,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0)),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                                onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTestimonial())),
                                child: Container(
                                  height: 40,
                                  width:200,
                                  child: Center(
                                    child: Text("WRITE",
                                        style: TextStyle(
                                            color: kWhite,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0)),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
      bottomNavigationBar: widget.view != "newUser"
          ? SizedBox.shrink()
          : Container(
              color: kWhite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(
                          kPrimaryColor),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginRegisterPage())),
                        child: Text("SIGN UP"),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                              child: OutlinedButton(
                                style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  kPrimaryColor),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeTab(
                                      view: "",
                                    ))),
                        child: Text("MAYBE LATER"),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _builtExamsCategory(BuildContext context, int i) {
    return TestimonialTab(
        name: testimonials[i]['name'] ?? "",
        image: testimonials[i]['image'] ?? "",
        testimonial: testimonials[i]['review'] ?? "",
        url: testimonials[i]['url'] ?? "",
        option: testimonials[i]['course'] ?? "");
  }
}
