import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

class CBTCourseList extends StatefulWidget {
  @override
  _AddCoursesState createState() => _AddCoursesState();
}

class _AddCoursesState extends State<CBTCourseList> {
  bool isLoading = true;
  List<DocModel> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    setState(() {
      isLoading = true;
    });
    await cbtCoursesRef
        .orderBy("visible", descending: false)
        .get()
        .then((value) {
      courses = value.docs
          .map((document) => DocModel.fromDocument(document))
          .toList();
      setState(() {
        courses = courses;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: isLoading
            ? loader()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    itemCount: courses.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, i) => const Divider(
                          height: 2,
                        ),
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onDoubleTap: () => deleteCourse(courses[i].fID ?? ""),
                        child: ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundColor: courses[i].visible == 1
                                  ? Theme.of(context).primaryColor
                                  : kWhite,
                              child: Text("${i + 1}"),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            title: Text(
                              courses[i].title ?? "",
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(courses[i].school ?? ""),
                            trailing: IconButton(
                                onPressed: () {
                                  //make course visible to user
                                  cbtCoursesRef.doc(courses[i].fID).update({
                                    'visible': 1,
                                    'lastAdded':
                                        DateTime.now().millisecondsSinceEpoch,
                                  });
                                  displayToast("Now visible");
                                },
                                icon: const Icon(
                                  Icons.check,
                                ))),
                      );
                    }),
              ));
  }

  void deleteCourse(String id) {
    cbtCoursesRef.doc(id).delete();
    fetchCourses();
    displayToast("Course deleted");
  }
}
