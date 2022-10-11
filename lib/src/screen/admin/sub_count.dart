import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/subscription.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:uuid/uuid.dart';

class SubCount extends StatefulWidget {
  @override
  _ApproveSubscriptionState createState() => _ApproveSubscriptionState();
}

class _ApproveSubscriptionState extends State<SubCount> {
  String id = Uuid().v4();
  bool loading = true;
  List<Subs> sublist = [];
  String name = "";
  String subId = "";

  @override
  void initState() {
    super.initState();
    fetchReferral();
  }

  void fetchReferral() async {
    setState(() {
      loading = true;
    });
    await activeSubReference.get().then((value) {
      sublist =
          value.docs.map((document) => Subs.fromDocument(document)).toList();
      setState(() {
        sublist = sublist;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, strTitle: "Native"),
      body: loading
          ? loader()
          : Container(
              child: ListView.builder(
                itemCount: sublist.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("$index"),
                          Text("${sublist[index].device}"),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
