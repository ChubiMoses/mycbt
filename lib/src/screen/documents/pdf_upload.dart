

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/admin/typing/add_courses.dart';
import 'package:mycbt/src/screen/documents/pdf_view.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_upload.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

class PDFUploadScreen extends StatefulWidget {

  @override
  _PDFUploadScreenState createState() => _PDFUploadScreenState();
}

class _PDFUploadScreenState extends State<PDFUploadScreen> {
  List<String> pdfCategory = [
    "CATEGORY",
    "PAST QUESTIONS",
    "LECTURE NOTE",
    "PRACTICAL",
    "PROJECT"
  ];

  int _bytes = 0;
  final bool _isValidating = false;
  final formKey = GlobalKey<FormState>();
  List<DocModel> validPdf = [];

  String id = Uuid().v4();
  File? file;
  String _selectedCat = "CATEGORY";
  String _selectedSchool = "SCHOOL";
  TextEditingController codeController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Future<void> selectDocs() async {
    if (currentUser! == null) {
      displayToast("Please login");
    } else {
      if (snippet!.verifyPDF == 0) {
        displayToast("Please try again later");
      } else {
        
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['pdf',], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
          setState(() {
            file = File(path);
            _bytes = file!.lengthSync();
          });
        }
      }
    }
  }

  validateAndSave(context) {
    if (codeController.text.isEmpty || titleController.text.isEmpty) {
      displayToast("Please fill out all fields");
    } else {
      if (_selectedCat == "CATEGORY") {
        displayToast("Please select category");
      } else if (currentUser!.email == "editor@gmail.com" &&
          _selectedSchool == "SCHOOL") {
        displayToast("Please select school");
      } else {
        uploadDocs(context);
      }
    }
  }

  uploadDocs(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async {
                setState(() {
                  _selectedCat = "CATEGORY";
                  _selectedSchool = "SCHOOL";
                  codeController.text = "";
                  titleController.text = "";
                });
                return true;
              },
              child: PDFDocUpload(
                file: file!,
                school: currentUser!.email == 'editor&gmail.com'
                    ? _selectedSchool
                    : currentUser!.school,
                bytes: _bytes,
                title: titleController.text,
                category: _selectedCat,
                code: codeController.text,
              ));
        });
  }

  Widget _pdfList() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 0,
              color: kWhite,
              child: ListTile(
                onTap: () async {
                  displayToast("Please wait...");
                  try {
                    String assetPDFPath = await preview(file!.path);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => PdfView(
                              path: assetPDFPath,
                              title: file!.path.split("/").last,
                              progress: 0,
                              preview: true,
                              view: "Offline",
                              code: '',
                              firebaseId: '',
                              reads: null,
                              url: '', conversation: 0, refresh: () {  }, id: 0,
                            )));
                  } catch (e) {
                    displayToast("Storage permission denied.");
                  }
                },
                title: Text(file!.path.split("/").last,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            //Allow admin to select school options
            currentUser!.email == "editor@gmail.com"
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: kGrey200),
                        color: kWhite,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: DropdownButton(
                            underline: SizedBox.shrink(),
                            isExpanded: true,
                            hint: const Text(
                              "Select School",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            value: _selectedSchool,
                            items: schoolList.map((t) {
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    t.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                value: t,
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedSchool = val!.toString();
                              });
                            }),
                      ),
                    ),
                  )
                : CheckboxListTile(
                    activeColor: kGrey500,
                    value: true,
                    title: Text(
                      currentUser!.school.toUpperCase(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("School tag"),
                    onChanged: (value) {}),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: kGrey200),
                  color: kWhite,
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: DropdownButton(
                      underline: SizedBox.shrink(),
                      isExpanded: true,
                      hint: Text(
                        "Select Category",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      value: _selectedCat,
                      items: pdfCategory.map((t) {
                        return DropdownMenuItem(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              t.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                          value: t,
                        );
                      }).toList(),
                      onChanged: ( val) {
                        setState(() {
                          _selectedCat = val.toString();
                        });
                      }),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: codeController,
                      textCapitalization: TextCapitalization.characters,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      readOnly: _isValidating ? true : false,
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
                      readOnly: _isValidating ? true : false,
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
                        if (val!.trim().length < 6 || val.isEmpty) {
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
              height: 10.0,
            ),
            GestureDetector(
              onTap: () => validateAndSave(context),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text("UPLOAD",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Upload PDF"),
        body: file != null
            ? _pdfList()
            : Center(
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: kWhite),
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.0),
                          Image(
                              image: AssetImage("assets/images/student1.png")),
                          SizedBox(height: 20.0),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Text(
                                "Help us grow! Upload and share your study materials with other students.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () => selectDocs(),
                            child: Container(
                              height: 40,
                              width: 200,
                              child: Center(
                                child: Text("UPLOAD AND SHARE",
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
                    )),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => selectDocs(),
          backgroundColor: kPrimaryColor,
          splashColor: kSecondaryColor,
          child: Icon(Icons.add, size: 25.0, color: Colors.white),
        ));
  }
}
