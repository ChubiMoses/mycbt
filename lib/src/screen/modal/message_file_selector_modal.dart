import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/data/models/group_message_model.dart';
import 'package:mycbt/src/services/doc_conv_services.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/screen/conversation/image_upload.dart';
import 'package:mycbt/src/widgets/message/doc_message_tile.dart';

class MessageFileSelector extends StatefulWidget {
  final String code;
  final String docId;
  final String message;
  final List<DocConversationTile> messages;
  final VoidCallback refresh;
  MessageFileSelector(
      {required this.message,
      required this.docId,
      required this.code,
      required this.refresh,
      required this.messages});

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
                builder: (context) => ImageUploaderScreen(
                    file: file!,
                    docId: widget.docId,
                    code: widget.code,
                    messages: widget.messages,
                    message: widget.message,
                    refresh: widget.refresh)));
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
    await sendMessage(widget.messages, widget.code, controller.text,
        widget.docId, file, isPdf);
    setState(() {
      isLoading = false;
    });

    widget.refresh();
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
                  padding:  EdgeInsets.symmetric(
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
                                    children:  [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor: kWhite,
                                        child: Icon(CupertinoIcons.camera),
                                      ),
                                      Text(
                                        "Image",
                                        style: TextStyle(fontSize: 12),
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
                                      "PDF",
                                      style: TextStyle(fontSize: 12),
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
                              backgroundColor: Theme.of(context).primaryColor,
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
