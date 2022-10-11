import 'package:mycbt/src/screen/cgpa/with_course.dart';
import 'package:mycbt/src/screen/cgpa/with_semester.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CGPACalculator extends StatefulWidget {
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<CGPACalculator> {
  List category = ["WITH COURSE", "WITH SEMESTER"];
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    systemChrome();
    return DefaultTabController(
        length: category.length,
        child: Scaffold(
          body: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              color: kWhite,
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorPadding: EdgeInsets.all(0),
                unselectedLabelColor: kBlack.withOpacity(0.5),
                labelColor: kBlack,
                indicatorColor: kWhite,
                tabs: category.map((tab) => tabs(tab)).toList(),
              ),
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              WithCourse(),
              WithSemester(),
            ])),
          ]),
        ));
  }

  Widget tabBarView(tab) {
    return Text("");
  }

  Tab tabs(tab) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(tab,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
    ));
  }
}
