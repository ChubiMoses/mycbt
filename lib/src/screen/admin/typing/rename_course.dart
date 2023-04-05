import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class RenameCourse extends StatefulWidget {
  DocModel? course;
  RenameCourse(this.course);

  @override
  State<RenameCourse> createState() => _RenameCourseState();
}

class _RenameCourseState extends State<RenameCourse> {
  final TextEditingController codeController = TextEditingController();

  final TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    codeController.text = widget.course!.code!;
    titleController.text = widget.course!.title!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Rename"),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: codeController,
                      textCapitalization: TextCapitalization.characters,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      maxLines: 1,

                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        fillColor: kWhite,
                        filled: true,
                        labelText: 'Course code',
                      ),
                      validator: (val) {
                        if (val!.trim().length < 3 || val.isEmpty) {
                          return "Invalid course code";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: titleController,
                     
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        fillColor: kWhite,
                        filled: true,
                        helperStyle: TextStyle(color: kBlack400),
                        labelText: 'Enter course title',
                      ),
                      validator: (val) {
                        if (val!.length < 6 || val.isEmpty) {
                          return "Please course title is too short.";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => update(),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text("RENAME",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void update() {
    studyMaterialsRef
        .doc(widget.course!.fID)
        .update({'title': titleController.text, 'code': codeController.text});
    displayToast("Updated");
  }
}
