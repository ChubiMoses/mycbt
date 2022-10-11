import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/services/message_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class ImageUpload extends StatefulWidget {
  final File file;
  final String message;
  final String chatId;
  final String receiverId;
  ImageUpload({
    required this.file,
    required this.chatId,
    required this.receiverId,
    required this.message,
  });

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool uploading = false;
  File? file;
  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    file = widget.file;
    postController.text = widget.message;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context)),
        actions: uploading
            ? null
            : <Widget>[
                IconButton(
                    icon: Icon(Icons.add_a_photo),
                    color: Colors.white,
                    onPressed: () => pickImageFromGallery()),
                SizedBox(
                  width: 10,
                )
              ],
      ),
      body: GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            uploading ? linearProgress() : SizedBox.shrink(),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file!), fit: BoxFit.contain)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(""),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          trailing: uploading
                              ? null
                              : IconButton(
                                  onPressed: () async {
                                    displayToast("sending...");
                                    setState(() {
                                      uploading = true;
                                    });
                                    await messageSaver(
                                        message: widget.message,
                                        chatId: widget.chatId,
                                        receiverId: widget.receiverId,
                                        file: file,
                                        isPdf: false);
                                    chatsRef
                                        .doc(widget.chatId)
                                        .update({'timestamp': DateTime.now()});
                                    setState(() {
                                      uploading = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: kWhite,
                                  )),
                          title: TextField(
                            autofocus: false,
                            autocorrect: true,
                            maxLines: 2,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(color: Colors.white),
                            controller: postController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),
                                isDense: true,
                                hintText: "Message",
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
