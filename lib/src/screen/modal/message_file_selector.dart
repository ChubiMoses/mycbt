import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/messages/image_upload.dart';
import 'package:mycbt/src/services/message_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';

class MessageFileSelector extends StatefulWidget {
  final String message;
  final String chatId;
  final String receiverId;
  MessageFileSelector(
      {required this.message, required this.receiverId, required this.chatId});

  @override
  _MessageFileSelectorState createState() => _MessageFileSelectorState();
}

class _MessageFileSelectorState extends State<MessageFileSelector> {
  bool isImage = true;
  File? file;
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  void pickImageFromGallery() async {
    setState(() {
      isImage = true;
    });

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      file = File(path);
      Navigator.pop(context);
      if (file != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageUpload(
                      file: file!,
                      chatId: widget.chatId,
                      receiverId: widget.receiverId,
                      message: widget.message,
                    )));
      }
    }
  }

  void handleSend() async {
    bool isPdf = false;
    setState(() {
      isLoading = true;
    });
    if (controller.text.split(".").last == "pdf") {
      isPdf = true;
    }
    await messageSaver(
        message: controller.text,
        chatId: widget.chatId,
        receiverId: widget.receiverId,
        file: file,
        isPdf: isPdf);
    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  Future<void> selectDoc() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
        controller.text = file!.path.split("/").last;
        isImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: isLoading
            ? loader()
            : Padding(
                padding: EdgeInsets.fromLTRB(14, 10, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 5.0),
                  child: isImage
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => pickImageFromGallery(),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor: kWhite,
                                        child: Icon(CupertinoIcons.camera),
                                      ),
                                      Text(
                                        "Image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => selectDoc(),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: kSecondaryColor,
                                        foregroundColor: kWhite,
                                        child: Icon(Icons.picture_as_pdf),
                                      ),
                                    ),
                                    Text(
                                      "Document",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 5.0),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: kGrey500,
                              foregroundColor: kWhite,
                              child: Icon(Icons.picture_as_pdf),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                  style: TextStyle(
                                      color: kBlack,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  readOnly: true,
                                  enabled: false,
                                  autofocus: false,
                                  controller: controller,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: "File name",
                                  )),
                            ),
                            IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () => handleSend(),
                                color: Theme.of(context).primaryColor)
                          ],
                        ),
                ),
              ),
      ),
    );
  }
}
