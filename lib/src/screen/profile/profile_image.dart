import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/services/users_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

class UploadProfileImage extends StatefulWidget {
  final String userId;
  final String view;
  UploadProfileImage({
    required this.userId, required this.view
  });
  @override
  _UploadProfileImageState createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  String path = "";
  File? file;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _uploading = false;
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


  void savePhoto(context) async {
    setState(() {
      _uploading = true;
    });

    String downloadUrl = await uploadPhoto(file!, id);
    usersReference.doc(widget.userId).update({
      "url": downloadUrl,
    });

    setState(() {
      _uploading = false;
      file = null;
    });
    Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => HomeTab(view: "")));
    if(widget.view == "Update"){
      //updete changes across collections
      updateCollections(currentUser!.id, "", downloadUrl, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:
              const Text("Update photo", style: TextStyle(color: Colors.white)),
          actions: widget.view == "Update" ? null : [
            TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeTab(
                              view: "",
                            ))),
                child:
                    const Text("Skip", style: TextStyle(color: Colors.white)))
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
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
            SizedBox(height: 10.0),
            file == null
                ? ElevatedButton(
                    onPressed: () => pickImageFromGallery(),
                    child: Text("Select Image",
                        style: TextStyle(color: Colors.white)),
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
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: TextButton(
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
                      child: _uploading
                          ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 2.0,
                              ),
                            )
                          : Text("Upload",
                              style: TextStyle(color: Colors.white)),
                      onPressed: () => savePhoto(context),
                    ),
                  ),
          ]),
        ),
        floatingActionButton: file == null
            ? SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: pickImageFromGallery,
                tooltip: "Add Image",
                child: Icon(Icons.add_a_photo, color: Colors.lightGreen),
              ));
  }
}
