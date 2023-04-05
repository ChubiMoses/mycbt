import 'package:flutter/cupertino.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/cbt/courses_view.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/cbt/course_tile.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';

class FavoriteCourses extends StatefulWidget {
  @override
  State<FavoriteCourses> createState() => _CourseTileState();
}

class _CourseTileState extends State<FavoriteCourses> {
  int noteCount = 0;
  bool isLoading = true;
  bool adShown = false;
  List<DocModel> courses = [];


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
     courses = await getCoursesList(context);
     print("==================");
     print(courses.length);
    favorite = [];
  
    //filter cbt courses out of courses list
    for (var item in courses) {
      if (item.favorite == 1) {
        favorite.add(item);
      }
    }
    setState(() => favorite = favorite);
  }

  bool fav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favorite.isEmpty
          ? EmptyStateWidget("You don't have favorite courses yet", Icons.favorite)
          : Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: GridView.count(
                 padding: const EdgeInsets.all(0),
                   physics: const BouncingScrollPhysics(),
                   shrinkWrap: true,
                   crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                   crossAxisSpacing: 10.0,
                   mainAxisSpacing: 10.0,
                   childAspectRatio: MediaQuery.of(context).size.width /
                   (MediaQuery.of(context).size.height / (ResponsiveHelper.isDesktop(context) ? 1.8 : ResponsiveHelper.isTab(context) ? 3 : 3.8)),
                children: List.generate(
                    favorite.length, (index) {
                  return  CBTCourseTileWidget(
                    docModel:favorite[index],
                  );
                }),
              ),
            ),
    );
  }
}
