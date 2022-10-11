import 'package:mycbt/src/screen/table/time_table_data.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';

class TimeTableTab extends StatefulWidget {
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<TimeTableTab> {
  List category = [
    "MONDAY",
    "TEUSDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
    "SATURDAY",
    "SUNDAY",
  ];

  TabController? _tabController;
  bool adShown = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: category.length,
        child: Scaffold(
          body: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              color: kWhite,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorPadding: EdgeInsets.all(0),
                unselectedLabelColor: kBlack.withOpacity(0.5),
                labelColor: kBlack,
                indicatorColor: kWhite,
                tabs: category.map((tab) => tabs(tab)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: category.map((day) => tabBarView(day)).toList()),
            ),
          ]),
        ));
  }

  Widget tabBarView(String day) {
    return TimeTableData(day: day);
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
