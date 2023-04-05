import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/admin/approve_docs.dart';
import 'package:mycbt/src/screen/admin/preexam.dart/preexam_result.dart';
import 'package:mycbt/src/screen/admin/typing/add_courses.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';

class QuizDashboard {
  final String name;
  final IconData icon;
  final Widget screen;
  QuizDashboard({required this.name,required this.icon,required this.screen});
}


final QuizDashboard result = QuizDashboard(name: "Result", icon: Icons.search, screen: PreeExamResult());
final QuizDashboard courses = QuizDashboard(name: "Courses", icon: Icons.list, screen: ApproveDocs());
final QuizDashboard addCourses = QuizDashboard(name: "Add Courses", icon: Icons.add_circle, screen: AddCourses());
    
List<QuizDashboard> items = [
  result,
  addCourses,
  courses
];

class TypistScreen extends StatefulWidget {
  @override
  _TypistScreenState createState() => _TypistScreenState();
}

class _TypistScreenState extends State<TypistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Dashboard"),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 18),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(_builtExamsCategory,
                      childCount: items.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.05,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0)),
            )
          ],
        ));
  }

  Widget _builtExamsCategory(BuildContext context, int i) {
    return Material(
      elevation: 1.0,
      color: kSecondaryColor,
      borderRadius: BorderRadius.circular(8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => items[i].screen)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      items[i].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Icon(items[i].icon, size: 30, color: Colors.white),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5.0),
                  child: Text("${items[i].name}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            ),
          )),
    );
  }
}
