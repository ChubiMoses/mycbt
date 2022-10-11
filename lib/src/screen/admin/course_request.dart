import 'package:mycbt/src/models/course_request.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

class CourseRequest extends StatefulWidget {
  @override
  _AddCoursesState createState() => _AddCoursesState();
}

class _AddCoursesState extends State<CourseRequest> {
  bool isLoading = true;
  List<CourseRequestModel> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    setState(() {
      isLoading = true;
    });
    await requestQARef.get().then((value) {
      courses = value.docs
          .map((document) => CourseRequestModel.fromDocument(document))
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
        appBar: header(context, strTitle: " Courses Request"),
        body: isLoading
            ? loader()
            : ListView.builder(
                itemCount: courses.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return Card(
                      child: InkWell(
                    onDoubleTap: () => deleteCourse(courses[i].fID),
                    child: ListTile(
                      title: Text(courses[i].course),
                      subtitle: Text(courses[i].school),
                      trailing: Icon(Icons.delete),
                    ),
                  ));
                }));
  }

  void deleteCourse(String id) {
    requestQARef.doc(id).delete();
    fetchCourses();
    displayToast("CourseRequestModel deleted");
  }
}
