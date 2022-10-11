import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/cbt/courses_view.dart';
import 'package:mycbt/src/screen/search.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/screen/modal/quiz_options_modal.dart';

class CoursesList extends StatefulWidget {
  final List<DocModel> courses;
  final String title;
  final VoidCallback refresh;
  // ignore: use_key_in_widget_constructors
  const CoursesList({required this.courses, required this.refresh, required this.title});
  @override
  _CoursesListState createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  final List<DocModel> courses = [];

  @override
  void initState() {
    sortCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize:14, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search())),
              icon: Icon(Icons.search)),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.count(
          padding: const EdgeInsets.only(top: 10),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.6),
          children: List.generate(widget.courses.length, (index) {
            String code = widget.courses[index].title!.split('-').first;
            return InkWell(
                onTap: () => {
                      startQuizModal(
                        context,
                        code,
                        widget.courses[index].school!,
                        widget.courses[index].title!,
                      )
                    },
                child: CourseTile(
                  i: index,
                  courses: widget.courses,
                
                ));
          }),
        ),
      ),
    );
  }

  void sortCourses() {
    widget.courses.sort((a, b) {
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });
  }
}
