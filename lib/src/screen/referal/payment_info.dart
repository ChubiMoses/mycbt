import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';

class AddPaymentInfo extends StatelessWidget {
  final VoidCallback refresh;
  AddPaymentInfo(this.refresh);

  final formkey = GlobalKey<FormState>();
  bool uploading = false;
  String name =  "";
  String number = "";
  String phone = "";
  String bank = "";
  bool refferalActive = false;
  bool pending = false;
  TextStyle labeStyle = TextStyle(color: Colors.black87);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Account Details"),
      body:SingleChildScrollView(
        child: Form(
        key: formkey,
        child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Column(children: [
            SizedBox(height: 50.0),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)),
                       enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                  fillColor:kWhite,
                  isDense: true,
                  labelText: 'Account Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelStyle: labeStyle,
                ),
                validator: (val) => val!.length < 5 ? "Invalid input" : null,
                onSaved: (val) => name = val!,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)),
                       enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                  fillColor:kWhite,
                  isDense: true,
                  labelText: 'Account Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelStyle: labeStyle,
                ),
                validator: (val) => val!.length < 7 ? "Invalid input" : null,
                onSaved: (val) => number = val!,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)),
                       enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                  fillColor:kWhite,
                  isDense: true,
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelStyle: labeStyle,
                ),
                validator: (val) => val!.length < 2 ? "Invalid input" : null,
                onSaved: (val) => bank = val!,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextFormField(
                 keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)),
                   enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                  fillColor:kWhite,
                  isDense: true,
                  
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelStyle: labeStyle,
                ),
                validator: (val) => val!.length < 9 ? "Invalid input" : null,
                onSaved: (val) => phone = val!,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => validate(context),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Save Details".toUpperCase(),
                    style: TextStyle(color: kWhite),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
      )
      )
    );
  }

  void validate(context) {
  if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
        agentsRef.doc(currentUser?.id).update({
          "accountName": name,
          "accountNumber": number,
          "bank": bank,
          "phone": phone,
        });
    refresh();
    Navigator.of(context).pop("saved");
   }
   }
   }

