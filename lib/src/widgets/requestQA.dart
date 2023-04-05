import 'dart:ui';

import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';

class RequestQA extends StatelessWidget {
  final TextEditingController school = TextEditingController();
  final TextEditingController course = TextEditingController();

  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: <Widget>[
          Text("Request Q&A",
              style: TextStyle(fontWeight: FontWeight.w600, color: kBlueGrey)),
        ],
      ),
      children: <Widget>[
        SimpleDialogOption(
          child: Column(
            children: <Widget>[
              TextField(
                controller: school,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Institution',
                    hintText: 'Name of Institution',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue))),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: course,
                decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Course title',
                    labelText: 'Title',
                    helperText: "e.g Philosophy & Human Existence(GST112)",
                    helperStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.grey),
                    //  border: InputBorder.none,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue))),
              ),
              const SizedBox(height: 10.0),
              Container(
                child: ElevatedButtonWidget(btnText: "Send Request".toUpperCase(), 
                   onPressed: () => sendRequest(context),
                )
               
              )
            ],
          ),
        ),
      ],
    );
  }

  void sendRequest(context) async {
    Navigator.pop(context);
    if (school.text.length > 5 && course.text.length > 5) {
      requestQARef.doc().set({
        "school": school.text,
        "course": course.text,
      });
      displayToast("Request Sent, thank you.");
    } else {
      displayToast("please fill out all fields correctly!");
    }
  }
}
