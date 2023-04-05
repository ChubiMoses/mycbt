import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/cbt/courses_view.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/cbt/course_tile.dart';

class CBTCourseTile extends StatefulWidget {
  final int limit;
  const CBTCourseTile({Key? key, required this.limit}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CBTCourseTileState createState() => _CBTCourseTileState();
}

class _CBTCourseTileState extends State<CBTCourseTile> {
  List<DocModel> courses = [];
  bool coursesLoading = true;

  @override
  void initState() {
    super.initState();
    // loadAds();
    fetchcourses();
    super.initState();
  }

  void fetchcourses() async {
    setState(() => coursesLoading = true);
    courses = await getCBTCourses(widget.limit);
    setState(() {
      courses = courses;
      coursesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return courses.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.symmetric(horizontal:ResponsiveHelper.isMobilePhone() ? 10 : 0),
          child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / (ResponsiveHelper.isDesktop(context) ? 1.8 : ResponsiveHelper.isTab(context) ? 3 : 6)),
             
              children: List.generate(6,(i) {
                 if (i == 5) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow:[
                          BoxShadow(
                          color: Colors.grey[300]!, spreadRadius: 1, blurRadius: 5,
                        )],
                        color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text("36+ \n More", textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 20, color: kWhite, fontWeight: FontWeight.bold),)
                        ),
                    );
                  }
                   return CBTCourseTileWidget(
                        docModel:courses[i],
                      );
                },
              )),
        );
  }
}
