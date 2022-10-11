// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:mycbt/src/utils/colors.dart';
// import 'package:mycbt/src/utils/firebase_collections.dart';
// import 'package:mycbt/src/models/item.dart';
// import 'package:mycbt/src/utils/list.dart';
// import 'package:mycbt/src/widgets/displayToast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:mycbt/src/widgets/HeaderWidget.dart';
// import 'package:mycbt/src/widgets/ProgressWidget.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import 'package:katex_flutter/katex_flutter.dart';

// class AddYearOneQuestions extends StatefulWidget {
//   @override
//   _AddYearOneQuestionsState createState() => _AddYearOneQuestionsState();
// }

// class _AddYearOneQuestionsState extends State<AddYearOneQuestions> {
//   List schoolList = [
//     'University of Agriculture Makurdi',
//     "Benue State University Makurdi"
//   ];
//   int count = 0;
//   TextEditingController answerController = TextEditingController();
//   TextEditingController option1Controller = TextEditingController();
//   TextEditingController option2Controller = TextEditingController();
//   TextEditingController option3Controller = TextEditingController();
//   TextEditingController questionController = TextEditingController();

//   String question = "";
//   String answer = "";
//   String option1 = "";
//   String option2 = "";
//   String option3 = "";
//   String id = Uuid().v4();
//   bool _uploading = false;
//   List<Item> mylist = [];
//   String selectedYear = "";
//   String selectedSchool = "";
//   String selectedCourse = "";
//   String downloadUrl = "";
//   File? file;

//   pickImageFromGallery() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(allowedExtensions: ['jpg'], type: FileType.custom);
//     String? path = result?.files.single.path;
//     if (path != null) {
//       setState(() {
//         file = File(path);
//       });
//   }

//   Future<void> uploadPhoto(file) async {
//     UploadTask mStorageUploadTask =
//         storageReference.child("CBT_$id.jpg").putFile(file);
//     TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
//     String url = await storageTaskSnapshot.ref.getDownloadURL();
//     setState(() {
//       downloadUrl = url;
//     });
//   }

//   _fetchCourse(context) async {
//     QuerySnapshot querySnapshot = await yearOneCoursesRef.get();
//     mylist = querySnapshot.docs
//         .map((documentSnapshot) => Item.fromDocument(documentSnapshot))
//         .toList();
//     await selectCourse(context, mylist);
//   }

//   void saveQuestion() async {
//     if (selectedCourse != null &&
//         selectedYear != null &&
//         selectedSchool != null) {
//       if (questionController.text.length < 1 ||
//           answerController.text.length < 1 ||
//           option1Controller.text.length < 1 ||
//           option2Controller.text.length < 1 ||
//           option3Controller.text.length < 1) {
//         displayToast("Please fill out all fields");
//       } else {
//         setState(() {
//           _uploading = true;
//           id = Uuid().v4();
//         });

//         if (file != null) {
//           await uploadPhoto(file);
//         }
//         yearOneQuestionsRef.doc(id).set({
//           "id": id,
//           "subject": "",
//           "category": "",
//           "code": "",
//           "course": selectedCourse,
//           "school": selectedSchool,
//           "year": selectedYear,
//           "question": questionController.text,
//           "answer": answerController.text,
//           "option1": option1Controller.text,
//           "option2": option2Controller.text,
//           "option3": option3Controller.text,
//           "image": downloadUrl,
//           "timestamp": timestamp,
//           'time':DateTime.now().millisecondsSinceEpoch / 1000.floor(),
//         });
//         setState(() {
//           questionController.clear();
//           answerController.clear();
//           option1Controller.clear();
//           option2Controller.clear();
//           option3Controller.clear();
//           downloadUrl = "";
//           _uploading = false;
//           file = null;
//         });
//         displayToast("Question saved");
//         setState(() => count = count + 1);
//       }
//     } else {
//       displayToast("Some parameters are missing!");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle = TextStyle(
//         fontSize: 18.0,
//         fontFamily: "Lato",
//         fontWeight: FontWeight.w500,
//         color: Colors.black);
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: header(context, strTitle: "New Question"),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
//           child: Column(
//             children: <Widget>[
//               Card(
//                   margin: EdgeInsets.symmetric(horizontal: 0),
//                   child: Column(
//                     children: <Widget>[
//                       Divider(),
//                       ListTile(
//                         dense: true,
//                         contentPadding: EdgeInsets.all(0),
//                         leading: Icon(
//                           Icons.info_outline,
//                           color:
//                               selectedSchool == null ? Colors.red : Colors.grey,
//                         ),
//                         title: DropdownButton(
//                             isExpanded: true,
//                             hint: Text("Select Institution"),
//                             value: selectedSchool,
//                             items: schoolList.map((name) {
//                               return DropdownMenuItem(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(name),
//                                 ),
//                                 value: name,
//                               );
//                             }).toList(),
//                             onChanged: (val) {
//                               setState(() {
//                                 selectedSchool = val.toString();
//                               });
//                             }),
//                         subtitle: Text("Selected School"),
//                       ),
//                       Divider(),
//                       ListTile(
//                         dense: true,
//                         contentPadding: EdgeInsets.all(0),
//                         leading: Icon(
//                           Icons.info_outline,
//                           color:
//                               selectedCourse == null ? Colors.red : Colors.grey,
//                         ),
//                         title: Text("$selectedCourse",
//                             style: TextStyle(
//                               fontFamily: "Lato",
//                             )),
//                         subtitle: Text("Selected Course"),
//                         trailing: IconButton(
//                             icon: Icon(Icons.sync),
//                             onPressed: () => _fetchCourse(context)),
//                       ),
//                       Divider(),
//                       ListTile(
//                         dense: true,
//                         contentPadding: EdgeInsets.all(0),
//                         leading: Icon(
//                           Icons.info_outline,
//                           color:
//                               selectedYear == null ? Colors.red : Colors.grey,
//                         ),
//                         title: DropdownButton(
//                             isExpanded: true,
//                             hint: Text("Select Year"),
//                             value: selectedYear,
//                             items: years.map((name) {
//                               return DropdownMenuItem(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(name),
//                                 ),
//                                 value: name,
//                               );
//                             }).toList(),
//                             onChanged: (val) {
//                               setState(() {
//                                 selectedYear = val.toString();
//                               });
//                             }),
//                         subtitle: Text("Selected Year"),
//                       ),
//                     ],
//                   )),
//               _uploading
//                   ? loader()
//                   : Card(
//                       child: Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: TextFormField(
//                               maxLines: 2,
//                               style: textStyle,
//                               controller: questionController,
//                               decoration: InputDecoration(
//                                   labelText: 'Question',
//                                   labelStyle: textStyle,
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(5.0))),
//                               validator: (val) =>
//                                   val!.isEmpty ? "Field empty" : null,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               latexPreview(question),
//                               IconButton(
//                                 onPressed: () => questionTex(),
//                                 icon: Icon(Icons.crop_rotate),
//                               )
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: TextFormField(
//                               maxLines: 2,
//                               style: textStyle,
//                               controller: answerController,
//                               decoration: InputDecoration(
//                                   labelText: 'Answer',
//                                   labelStyle: textStyle,
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(5.0))),
//                               validator: (val) =>
//                                   val!.isEmpty ? "Field empty" : null,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               latexPreview(answer),
//                               IconButton(
//                                 onPressed: () => answerTex(),
//                                 icon: Icon(Icons.crop_rotate),
//                               )
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: TextFormField(
//                               maxLines: 2,
//                               controller: option1Controller,
//                               style: textStyle,
//                               decoration: InputDecoration(
//                                   labelText: 'option1',
//                                   labelStyle: textStyle,
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(5.0))),
//                               validator: (val) =>
//                                   val!.isEmpty ? "Field empty" : null,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               latexPreview(option1),
//                               IconButton(
//                                 onPressed: () => option1Tex(),
//                                 icon: Icon(Icons.crop_rotate),
//                               )
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: TextFormField(
//                               maxLines: 2,
//                               controller: option2Controller,
//                               style: textStyle,
//                               decoration: InputDecoration(
//                                   labelText: 'Option2',
//                                   labelStyle: textStyle,
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(5.0))),
//                               validator: (val) =>
//                                   val!.isEmpty ? "Field empty" : null,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               latexPreview(option2),
//                               IconButton(
//                                 onPressed: () => option2Tex(),
//                                 icon: Icon(Icons.crop_rotate),
//                               )
//                             ],
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: TextFormField(
//                               maxLines: 2,
//                               style: textStyle,
//                               controller: option3Controller,
//                               decoration: InputDecoration(
//                                   labelText: 'Option3',
//                                   labelStyle: textStyle,
//                                   border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(5.0))),
//                               validator: (val) =>
//                                   val!.isEmpty ? "Field empty" : null,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               latexPreview(option3),
//                               IconButton(
//                                 onPressed: () => option3Tex(),
//                                 icon: Icon(Icons.crop_rotate),
//                               )
//                             ],
//                           ),
//                           GestureDetector(
//                             onTap: () => pickImageFromGallery(),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width,
//                               height: 200.0,
//                               color: Colors.grey[200],
//                               child: file == null
//                                   ? Icon(Icons.add_a_photo)
//                                   : Image.file(
//                                       file!,
//                                       height: 200,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: RaisedButton(
//                                     color: Colors.lightGreen,
//                                     textColor: Colors.white,
//                                     child: Text(
//                                       'Save',
//                                       textScaleFactor: 1.5,
//                                     ),
//                                     onPressed: () => saveQuestion(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//             child: Text(count.toString(), style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
//             backgroundColor: Theme.of(context).primaryColor ,
//             splashColor: Colors.white,
//             onPressed: () async {
//               displayToast("Well done Chief.");
//             }));
//   }

//   selectCourse(BuildContext context, List query) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Center(
//             child: SizedBox(
//               height: 300.0,
//               child: Dialog(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Material(
//                     child: ListView.separated(
//                         separatorBuilder: (context, i) => Divider(),
//                         itemCount: query.length,
//                         itemBuilder: (context, i) {
//                           return InkWell(
//                             onTap: () {
//                               setState(() => selectedCourse = query[i].name);
//                               Navigator.pop(context);
//                             },
//                             child: ListTile(
//                               dense: true,
//                               contentPadding: EdgeInsets.all(0.0),
//                               title: Text(
//                                 query[i].name,
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Widget latexPreview(String latex) {
//     return Container(
//         width: MediaQuery.of(context).size.width - 120,
//         child: Builder(
//           builder: (context) => KaTeX(
//             laTeXCode:
//                 Text(latex, style: Theme.of(context).textTheme.bodyText2),
//           ),
//         ));
//   }

//   void questionTex() {
//     setState(() {
//       question = questionController.text;
//     });
//   }

//   void answerTex() {
//     setState(() {
//       answer = answerController.text;
//     });
//   }

//   void option1Tex() {
//     setState(() {
//       option1 = option1Controller.text;
//     });
//   }

//   void option2Tex() {
//     setState(() {
//       option2 = option2Controller.text;
//     });
//   }

//   void option3Tex() {
//     setState(() {
//       option3 = option3Controller.text;
//     });
//   }
// }
