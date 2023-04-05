import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/admin/active_schools.dart';
import 'package:mycbt/src/screen/admin/approve_docs.dart';
import 'package:mycbt/src/screen/admin/typing/add_courses.dart';
import 'package:mycbt/src/screen/admin/cbt_course_list.dart';
import 'package:mycbt/src/screen/admin/new_schools.dart';
import 'package:mycbt/src/screen/admin/total_users.dart';
import 'package:mycbt/src/utils/colors.dart';

class SchoolsTab extends StatefulWidget {
  @override
  _SchoolsTabState createState() => _SchoolsTabState();
}

class _SchoolsTabState extends State<SchoolsTab> {
  List category = [
    "Approve Docs",
    "New Schools",
    "Active Schools",
    "CBT Courses",
    "Add Courses",
  ];
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(""),
        elevation: 0.0,
      ),
      body: DefaultTabController(
          length: category.length,
          child: Column(children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorPadding: EdgeInsets.all(0),
                unselectedLabelColor: kWhite.withOpacity(0.5),
                indicatorColor: kWhite,
                indicatorWeight: 6.0,
                tabs: category.map((tab) => tabs(tab)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                ApproveDocs(),
                NewSchools(),
                ActiveSchools(),
                CBTCourseList(),
                AddCourses(),
              ]),
            )
          ])),
    );
  }

  Widget tabBarView(tab) {
    return TotalUsers();
  }

  Tab tabs(tab) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(tab.toUpperCase(),
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
    ));
  }
}
