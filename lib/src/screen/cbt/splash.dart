import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mycbt/src/screen/cbt/cbt_answers.dart';
import 'package:mycbt/src/utils/colors.dart';

class CongratulationSplash extends StatefulWidget {
  final int score;
  final int total;
  final String year;
  final String course;
  final answers;
  final quiz;
  const CongratulationSplash(
      this.year, this.course, this.score, this.total, this.answers, this.quiz);

  @override
  _CongratulationSplashState createState() => _CongratulationSplashState();
}

class _CongratulationSplashState extends State<CongratulationSplash>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  bool _skyShot = false;
  double _bottom = -150;
  double averageScore = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller!.addListener(() {
      if (_controller!.isCompleted) {
        setState(() {
          _skyShot = true;
          _bottom = MediaQuery.of(context).size.height * 10 / 100;
        });
      }
    });
    averageScore = widget.score / widget.total;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          if (!_skyShot)
            Lottie.asset(
              "assets/animations/2.json",
              fit: BoxFit.fitHeight,
              controller: _controller,
              repeat: false,
              onLoaded: (composition) {
                _controller!
                  ..duration =
                      composition.duration - const Duration(milliseconds: 1000)
                  ..forward();
              },
            ),
          if (_skyShot) Lottie.asset("assets/animations/3.json"),

          //   if (_skyShot) Lottie.asset("assets/animations/3.json"),
          // Image.asset(
          //   "assets/images/7k.png",
          //   height: 800,
          // ),

          ZoomIn(
            duration: const Duration(milliseconds: 2000),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Congratulations",
                    style: TextStyle(
                      color: Color(0xFFFF8C09),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "You Scored",
                    style: TextStyle(
                      color: Color(0xFFFF8C09),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.score} Points",
                    style: TextStyle(
                      color: averageScore > 0.5 ? Colors.green : Colors.red,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   const SizedBox(
                    height: 3,
                  ),
                  Text(
                    averageScore < 0.5 ? "Remember you can do better." : "You're quite a genius!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_skyShot)
            Positioned(
              left: -width * 33 / 100,
              width: width,
              bottom: height * 13 / 100,
              child: FadeInLeft(
                child: SizedBox(
                  height: 300,
                  child: Lottie.asset(
                    "assets/animations/4.json",
                  ),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            bottom: _bottom,
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => CBTAnswers(
                                    widget.year,
                                    widget.course,
                                    widget.score,
                                    widget.total,
                                    widget.answers,
                                    widget.quiz,
                                  )));
                    },
                    child: Container(
                      height: 40,
                      width: 160,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "ANSWERS",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lottie.asset("assets/animations/4.json"),
          // Center(child: Lottie.asset("assets/animations/1.json")),
        ],
      ),
    );
  }
}
