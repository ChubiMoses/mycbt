import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/admin/approve_sub.dart';
import 'package:mycbt/src/screen/admin/cancel_sub.dart';
import 'package:mycbt/src/screen/admin/referral.dart';
import 'package:mycbt/src/screen/admin/sub_history.dart';
import 'package:mycbt/src/screen/admin/sub_users.dart';
import 'package:mycbt/src/screen/admin/total_users.dart';
import 'package:mycbt/src/utils/colors.dart';

class UsersTab extends StatefulWidget {
  @override
  _UsersTabState createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  List category = [
    "Subscription",
    "History",
    "Subcribed",
    "Agents",
    "Users",
    "Cancel Sub"
  ];
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard"),
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
                ApproveSubScreen(),
                SubscriptionHistory(),
                SubUsers(),
                ReferralList(),
                TotalUsers(),
                CancelSubscription()
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
