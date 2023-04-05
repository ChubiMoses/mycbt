import 'package:mycbt/src/screen/admin/typing/add_school.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/item.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewSchools extends StatefulWidget {
  @override
  _SelectSchoolAndCourseState createState() => _SelectSchoolAndCourseState();
}

class _SelectSchoolAndCourseState extends State<NewSchools> {
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  String schoolName = "";
  int visibleCount = 0;
  List<Item> list = [];
  String title = "";
  bool atTop = true;

  fetch() async {
    setState(() {
      isLoading = true;
    });

    await newSchoolRef.get().then((value) {
      setState(() {
        isLoading = true;
        list = value.docs
            .map((documentSnapshot) => Item.fromDocument(documentSnapshot))
            .toList();
        list.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          setState(() => atTop = true);
        } else {
          setState(() => atTop = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        body: isLoading
            ? loader()
            : Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30, top: 5.0, bottom: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: isLoading
                            ? loader()
                            : Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: ListView.separated(
                                        controller: scrollController,
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount:
                                            list == null ? 0 : list.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            dense: true,
                                            leading: IconButton(
                                              icon: Icon(
                                                Icons.copy,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddSchool(
                                                                schoolName:
                                                                    list[index]
                                                                        .name)));
                                                Clipboard.setData(ClipboardData(
                                                    text: list[index].name));
                                                displayToast(
                                                    "Copied ClipBoard");
                                              },
                                            ),
                                            title: Text(
                                              list[index].name.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            trailing: GestureDetector(
                                                onTap: () =>
                                                    delete(list[index].id),
                                                child: Icon(Icons.delete)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                      ),
                    ])));
  }

  void delete(String id) {
    newSchoolRef.doc(id).delete();
    fetch();
  }
}
