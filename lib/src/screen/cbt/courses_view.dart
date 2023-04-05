import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/cbt/courses_list.dart';
import 'package:mycbt/src/screen/web/widgets/custom_image.dart';
import 'package:mycbt/src/services/favorite_courses_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/cbt/course_tile.dart';
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
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
             courses.length, (index) {
            return  CBTCourseTileWidget(
                  docModel:courses[index],
                );
        }),
      ),
    );
  }
}

// class CourseTile extends StatefulWidget {
//   final List<DocModel> courses;
//   final int i;
//   // ignore: use_key_in_widget_constructors
//   const CourseTile({required this.i, required this.courses});

//   @override
//   _CourseTleState createState() => _CourseTleState();
// }

// class _CourseTleState extends State<CourseTile> {
//   bool fav = true;
//   @override
//   void initState() {
//     fav = widget.courses[widget.i].favorite == 1 ? true : false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String code = widget.courses[widget.i].code!;

//     return  InkWell(
//       onTap: () => {
//         startQuizModal(
//           context,
//           code,
//           widget.courses[widget.i].school!,
//           widget.courses[widget.i].title!,
//         )
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             boxShadow:[
//             BoxShadow(
//             color: Colors.grey[300]!, spreadRadius: 1, blurRadius: 5,
//           )],
//           color: kWhite,
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           children: [
//             CustomImage(height: 100, image: '', width:ResponsiveHelper.isTab(context) ? 60 : 100,
//             ),
//             const SizedBox(width: 10,),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                    SizedBox(
//                     width: ResponsiveHelper.isMobile(context) ? 200 : 200,
//                      child: Text(widget.courses[widget.i].title!.split('-').last.trim().toUpperCase(),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: const TextStyle(
//                         fontSize: 12.0,
//                         color: kBlack400,
//                         fontWeight: FontWeight.w600,
//                       )),
                       
//                    ),
                   
//                   Text(code.toUpperCase(),
//                        style: const TextStyle(
//                             fontSize: 11.0,
//                             color: Color(0xff5D5D5D),
//                             fontWeight: FontWeight.w600)),
                  
//                   SizedBox(
//                     height: 25.0,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           splashColor: Theme.of(context).primaryColor,
//                           onTap: () {
//                             if (fav) {
//                               setState(() {
//                                 fav = false;
//                               });
//                             } else {
//                               setState(() {
//                                 fav = true;
//                               });
//                             }
//                             addFavorite(
//                               context,
//                               widget.courses[widget.i],
//                             );
//                           },
//                           child: Icon(
//                               fav ? Icons.favorite : Icons.favorite_border,
//                               color: Theme.of(context).primaryColor),
//                         ),
                        
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void addFavorite(BuildContext context, final DocModel courses) {
//     if (courses.favorite == 1) {
//       deleteFavorite(courses.fID!);
//       displayToast("Course removed from favorite.");
//     } else {
//       addTofavorite(courses.fID!)
//           .then((value) => displayToast("Added to favorite courses."));
//     }
//   }
// }
