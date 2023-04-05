import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';


   List<String> schoolList = [
     'SCHOOL',
    'Lagos State University',
    'Federal University of Technology Minna',
    'University of Agriculture Makurdi',
    "Benue State University Makurdi",
  ];


class AddCourses extends StatefulWidget {
  @override
  _AddCoursesState createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();

  String selectedSchool = "SCHOOL";

  void addCourse() {
    if (selectedSchool != "SCHOOL" && courseNameController.text.isNotEmpty) {
       cbtCoursesRef.doc().set({
        "school": selectedSchool,
        'url': "",
        "title": courseNameController.text,
        "timestamp": DateTime.now(),
        "ownerId": currentUser?.id,
        "bytes": 0,
        "originalTitle":"",
        "likeIds": "",
        "conversation":0,
        "visible":0,
        "favorite":0,
        "category":"",
        "code": courseCodeController.text,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        'lastAdded': DateTime.now().millisecondsSinceEpoch,
      });
     
     //Colllections for older version 
      qaDocRef.doc().set({
        "school": selectedSchool,
        'url': "",
        'updated': false,
        'visible': true,
        'type': 0,
        "title": courseCodeController.text + " - " + courseNameController.text,
        "timestamp": DateTime.now(),
        'time': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
      });

      yearOneCoursesRef.doc().set({
        "school": selectedSchool,
        "name": courseCodeController.text + " - " + courseNameController.text,
      });

      setState(() {
        courseNameController.clear();
        courseCodeController.clear();
      });

      displayToast("Course added to database");
    } else {
      displayToast("Please fill out all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: DropdownButton(
                    isExpanded: true,
                    hint: Text("Select Institution"),
                    value: selectedSchool,
                    items: schoolList.map((school) {
                      return DropdownMenuItem(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(school),
                        ),
                        value: school,
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedSchool = val.toString();
                      });
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  maxLines: 1,
                  controller: courseCodeController,
                  style: Theme.of(context).textTheme.bodyText2,
                   textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "Code",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  maxLines: 1,
                  controller: courseNameController,
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    labelText: "Course Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:TextButtonWidget(btnText:'Save', onPressed: () => addCourse()) 
                    ),
                  ],
                ),
              ),
            ],
          )),
    ));
  }
}
