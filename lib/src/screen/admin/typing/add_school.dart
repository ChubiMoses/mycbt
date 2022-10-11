import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

class AddSchool extends StatefulWidget {
  final String schoolName;
  AddSchool({required this.schoolName});
  @override
  _AddCoursesState createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddSchool> {
  TextEditingController schoolName = TextEditingController();

  void saveSchool() {
    if (schoolName.text != "") {
      schoolRef.doc().set({
        "name": schoolName.text,
      });

      setState(() {
        schoolName.clear();
      });

      displayToast("Added to database");
    } else {
      displayToast("Please fill out all fields");
    }
  }

  @override
  void initState() {
    schoolName.text = widget.schoolName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Add School"),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      maxLines: 2,
                      controller: schoolName,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child:ElevatedButtonWidget(btnText:'Save', onPressed: () => saveSchool()) 
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
