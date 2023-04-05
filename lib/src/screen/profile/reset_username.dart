import 'dart:async';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/services/users_service.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class ResetUsername extends StatefulWidget {
  @override
  _ResetUserPasswordState createState() => _ResetUserPasswordState();
}

class _ResetUserPasswordState extends State<ResetUsername> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final formkey = GlobalKey<FormState>();
  String username = "";

  changeUsername() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (username == "Admin" || username == "admin") {
        displayToast("Username is reserved!");
      } else {
        change(username);
      }
    }
  }

  void change(username) async {
    try {
      usersReference
          .doc(currentUser?.id)
          .update({"username": username}).then((value) {
        displayToast("Username changed successfully.");
         updateCollections(currentUser!.id, username, "", false);
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => HomeTab(view: "")));
        });
      });
      //updete changes across collections
     
    } catch (e) {
      displayToast("Message: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Change Username"),
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0, right: 30, top: 0.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          if (val!.trim().length < 3 || val.isEmpty) {
                            return "New Username";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val!,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            // isDense: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 16.0),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text("Please enter your new username",
                        style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => changeUsername(),
                child: Container(
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text("Change Username",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: "bariol",
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
