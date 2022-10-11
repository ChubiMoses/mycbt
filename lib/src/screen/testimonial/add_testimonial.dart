import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';

class NewTestimonial extends StatefulWidget {
  const NewTestimonial({Key? key}) : super(key: key);

  @override
  _NewTestimonialState createState() => _NewTestimonialState();
}

class _NewTestimonialState extends State<NewTestimonial> {
  TextEditingController testController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  String path = "";
  File? file;
  bool isLoading = false;
  bool enableUpload = false;
  String id = Uuid().v4();

  void pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
      });
    }
  }

  void submitTestimonial() async {
    if (currentUser == null) {
      displayToast("Please login");
    } else if (file == null) {
      displayToast("Please upload your cute photo");
    } else if (nameController.text.isEmpty ||
        schoolController.text.isEmpty ||
        courseController.text.isEmpty ||
        testController.text.isEmpty) {
      displayToast("Please fill out all fields");
    } else {
      setState(() {
        isLoading = true;
      });

      String downloadUrl = await uploadPhoto(file!, id);
      testimonialReference.doc(currentUser!.id).update({
        "image": downloadUrl,
        "name": nameController.text,
        "school": schoolController.text,
        "course": courseController.text,
        "testimonial": testController.text
      });

      setState(() {
        isLoading = false;
        file = null;
      });
      SnackBar snackBar = SnackBar(content: Text("Thanks for taking out time, we appreciate you."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: kBgScaffold,
            appBar: header(context, strTitle: "Testimonial"),
            body: isLoading
                ? loader()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 50.0),
                        file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Container(
                                  width: 150.0,
                                  height: 150.0,
                                  child: Image.file(
                                    file!,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 70.0,
                                backgroundColor: Colors.grey[300],
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      size: 40.0,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () => pickImageFromGallery()),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            fillColor: kWhite,
                            filled: true,
                            prefixIcon: const Icon(CupertinoIcons.person),
                            labelText: 'Full name',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: schoolController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            fillColor: kWhite,
                            filled: true,
                            prefixIcon: const Icon(CupertinoIcons.flag),
                            labelText: 'School name',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: courseController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            fillColor: kWhite,
                            filled: true,
                            prefixIcon: const Icon(CupertinoIcons.book_circle),
                            labelText: 'Course of study',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: testController,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 6,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: kGrey200, width: 1),
                                borderRadius: BorderRadius.circular(4.0)),
                            fillColor: kWhite,
                            filled: true,
                            prefixIcon: const Icon(Icons.reviews),
                            labelText: 'Testimonial',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => submitTestimonial(),
                          child: Container(
                            height: 40,
                            width: 200,
                            child: Center(
                              child: Text("SUBMIT",
                                  style: TextStyle(
                                      color: kWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0)),
                            ),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: file == null
                ? SizedBox.shrink()
                : FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: pickImageFromGallery,
                    tooltip: "Add Image",
                    child: Icon(Icons.add_a_photo, color: Colors.lightGreen),
                  )));
  }
}
