import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

class UploadPaymentEnvidence extends StatefulWidget {
  @override
  _UploadPaymentEnvidenceState createState() => _UploadPaymentEnvidenceState();
}

class _UploadPaymentEnvidenceState extends State<UploadPaymentEnvidence> {
  String path = "";
  File? file;
  String type = "";
  final formkey = GlobalKey<FormState>();
  String id = Uuid().v4();
  bool uploading = false;
  bool uploadDone = false;
  String name = "";
  String account = "";
  String phone = "";
  String code = "";
  bool pending = false;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  TextStyle labeStyle = TextStyle(color: Colors.black87);

  initState() {
    super.initState();
    checkPendingSub();
  }

  void checkPendingSub() async {
    await subReference.doc(currentUser?.id).get().then((value) {
      if (!value.exists) {
        setState(() {
          pending = false;
        });
      } else {
        setState(() {
          pending = true;
        });
      }
    });
  }

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

  void activateApp() async {
    setState(() {
      uploading = true;
      id = Uuid().v4();
    });

    String downloadUrl = await uploadPhoto();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    subReference.doc(currentUser?.id).set({
      "id": currentUser?.id,
      "ownerId": currentUser?.id,
      "image": currentUser?.url ?? "",
      "url": downloadUrl,
      "device": androidInfo.model,
      "phone": phone,
      "account": code,
      "school": currentUser?.school,
      "name": name,
      "approved": false,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'timestamp': DateTime.now()
    });

//update user phone number
    usersReference.doc(currentUser?.id).update({
      "phone": phone,
    });

    setState(() {
      uploading = false;
      uploadDone = true;
      file = null;
    });
  }

  Future<String> uploadPhoto() async {
    UploadTask mStorageUploadTask =
        storageReference.child("Sub_$id.jpg").putFile(file!);
    TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void validate() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      activateApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Payment  Evidence"),
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: subscribed
              ? customMessage(
                  "Activation successful", "Thank you for choosing My CBT.")
              : pending
                  ? customMessage(
                      "Verifying payment details", "Give us some minutes...")
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: uploadDone
                          ? customMessage("Verifying payment details",
                              "Give us some minutes...")
                          : Form(
                              key: formkey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 5.0),
                                  Text(
                                    "Payment Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.0),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen)),
                                        isDense: true,
                                        labelText: 'Full name',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: labeStyle,
                                      ),
                                      validator: (val) => val!.length < 5
                                          ? "Invalid input"
                                          : null,
                                      onSaved: (val) => name = val!,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen)),
                                        isDense: true,
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: labeStyle,
                                      ),
                                      initialValue: currentUser?.phone,
                                      validator: (val) => val!.length < 9
                                          ? "Invalid input"
                                          : null,
                                      onSaved: (val) => phone = val!,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: TextFormField(
                                      initialValue: currentUser?.code,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen)),
                                        isDense: true,
                                        labelText: 'Referral code(optional)',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: labeStyle,
                                      ),
                                      onSaved: (val) => code = val!,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Container(
                                          color: Colors.grey[200],
                                          height: 130.0,
                                          width: 130.0,
                                          child: file != null
                                              ? Image.file(file!,
                                                  fit: BoxFit.cover,
                                                  height: 200)
                                              : IconButton(
                                                  icon: Icon(Icons.add_a_photo,
                                                      size: 30.0,
                                                      color: Colors.black),
                                                  onPressed: () =>
                                                      pickImageFromGallery())),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Debit Screenshort/Evidence of payment.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: kGrey600),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  uploading
                                      ? const SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                kPrimaryColor),
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: file == null
                                              ? null
                                              : () => validate(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: file == null
                                                  ? kGrey400
                                                  : Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: 45,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            child: Center(
                                                child: Text("VERIFY",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                          ),
                                        ),
                                ],
                              ),
                            )),
        ));
  }

  Widget customMessage(String msg, btnText) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(msg),
              SizedBox(
                height: 5,
              ),
              TextButton(
                child: Text(
                  btnText ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
                onPressed: () => Navigator.pop(context),
                 style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(
                          kPrimaryColor),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
