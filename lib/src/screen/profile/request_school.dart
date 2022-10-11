import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RequestSchool extends StatefulWidget {
  final String userId;
  RequestSchool({required this.userId});
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<RequestSchool> {
  TextEditingController controller = TextEditingController();
  String id = Uuid().v4();

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30, top: 5.0, bottom: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200.0,
                    alignment: Alignment.centerLeft,
                    child: Text("Name of institution",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w500)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Container(
                      child: TextField(
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(color: Colors.black),
                        controller: controller,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            prefixIcon: Icon(Icons.flag,
                                color: Colors.grey, size: 30.0),
                            labelText: "School name",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () => requestschool(),
                    child: Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text("Request School",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ])));
  }

  void requestschool() {
    if (controller.text.length > 10) {
      newSchoolRef.doc().set({
        "name": controller.text,
      });

      updateUserInfo();

      displayToast('Welcome');
    } else {
      displayToast('School name is too short. please try again');
    }
  }

  void updateUserInfo() {
    usersReference
        .doc(widget.userId)
        .update({"school": controller.text}).then((value) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeTab(view:"",)));
    });
  }
}
