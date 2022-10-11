import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/cbt/courses_list.dart';
import 'package:mycbt/src/services/favorite_courses_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/more_tile.dart';
import 'package:mycbt/src/screen/modal/quiz_options_modal.dart';
  List<DocModel> favorite = [];
class CBTCoursesView extends StatefulWidget {
  final List<DocModel> courses;
  // ignore: use_key_in_widget_constructors
  const CBTCoursesView({
    required this.courses,
  });

  @override
  State<CBTCoursesView> createState() => _CourseTileState();
}

class _CourseTileState extends State<CBTCoursesView> {
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
    setState(() => isLoading = true);
    courses = [];
    favorite = [];
  
    //filter cbt courses out of courses list
    for (var item in widget.courses) {
      if (item.url == "") {
        courses.add(item);
      }

      if (item.favorite == 1) {
        favorite.add(item);
      }
    }
    setState(() => courses = courses);
    setState(() => favorite = favorite);
  }

  bool fav = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          favorite.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.count(
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 2.6),
                    children: List.generate(
                        favorite.length > 4 ? 4 : favorite.length, (index) {
                      return CourseTile(
                        i: index,
                        courses: favorite,
                      );
                    }),
                  ),
                ),
          favorite.isEmpty
              ? const SizedBox.shrink()
              : MoreCard(
                  title: "FAVORITE COURSES",
                  press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoursesList(
                              title: "Favorite",
                              refresh: fetchData,
                              courses: favorite))),
                ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GridView.count(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2.6),
              children: List.generate(
                  courses.length <= 10
                      ? courses.length
                      : courses.length > 10
                          ? 10
                          : courses.length, (index) {
                return CourseTile(
                  i: index,
                  courses: courses,
                );
              }),
            ),
          ),
          courses.isEmpty
              ? const SizedBox.shrink()
              : MoreCard(
                  title: "COURSES",
                  press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoursesList(
                              title: "Courses",
                              refresh: fetchData,
                              courses: widget.courses))),
                ),
        ],
      ),
    );
  }
}

class CourseTile extends StatefulWidget {
  final List<DocModel> courses;
  final int i;
  // ignore: use_key_in_widget_constructors
  const CourseTile({required this.i, required this.courses});

  @override
  _CourseTleState createState() => _CourseTleState();
}

class _CourseTleState extends State<CourseTile> {
  bool fav = true;
  @override
  void initState() {
    fav = widget.courses[widget.i].favorite == 1 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String code = widget.courses[widget.i].code!;

    return  InkWell(
      onTap: () => {
        startQuizModal(
          context,
          code,
          widget.courses[widget.i].school!,
          widget.courses[widget.i].title!,
        )
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(code.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: kBlack400,
                    fontWeight: FontWeight.bold,
                  )),
              Text(widget.courses[widget.i].title!.toUpperCase(),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11.0,
                      color: kBlack400,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 25.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      onTap: () {
                        if (fav) {
                          setState(() {
                            fav = false;
                          });
                        } else {
                          setState(() {
                            fav = true;
                          });
                        }
                        addFavorite(
                          context,
                          widget.courses[widget.i],
                        );
                      },
                      child: Icon(
                          fav ? Icons.favorite : Icons.favorite_border,
                          color: Theme.of(context).primaryColor),
                    ),
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addFavorite(BuildContext context, final DocModel courses) {
    if (courses.favorite == 1) {
      deleteFavorite(courses.fID!);
      displayToast("Course removed from favorite.");
    } else {
      addTofavorite(courses.fID!)
          .then((value) => displayToast("Added to favorite courses."));
    }
  }
}
