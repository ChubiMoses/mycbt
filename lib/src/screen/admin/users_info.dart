import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/referral.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/services/Authentication.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class UsersInfo extends StatefulWidget {
  final UserModel user;
  final Referral? referral;
  const UsersInfo({required this.user, required this.referral});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UsersInfo> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  AuthImplementation auth = Auth();
  File? file;
  int catIndex = 0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.username;
    addressController.text = widget.user.school;
    phoneController.text = widget.user.phone;
    mailController.text = widget.user.email;
    balanceController.text = widget.referral!.balance.toString();
    accountNameController.text = widget.referral!.accountName;
    accountNumberController.text = widget.referral!.accountNumber;
  }

  void approveWithrawal(String id) {
    agentsRef.doc(id).update({
      "balance": 0,
      "elligible": 0,
    });
  }

  dynamic controllApprove(mContext) {
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are sure you want to Pay?",
                style: TextStyle(
                  color: kBlack400,
                )),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Pay", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  approveWithrawal(widget.referral!.id);
                  displayToast("Paid out");
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {},
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        child: CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.white,
                            child: Hero(
                                tag: widget.user.url,
                                child: GestureDetector(
                                  onTap: () =>
                                      photoPreview(context, widget.user.url),
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.user.url),
                                    radius: 70.0,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      buildNameFormField(context),
                      SizedBox(
                        height: 15,
                      ),
                      buildEmailFormField(context),
                      SizedBox(
                        height: 15,
                      ),
                      buildWhatsappField(context),
                      SizedBox(
                        height: 15,
                      ),
                      buildPhoneFormField(context),
                      SizedBox(
                        height: 15,
                      ),
                      accountName(context),
                      SizedBox(
                        height: 15,
                      ),
                      accountNumber(context),
                      SizedBox(
                        height: 15,
                      ),
                      balance(context),
                      SizedBox(
                        height: 15,
                      ),
                      OutlinedButtonWidget(btnText: "Pay Out", 
                       onPressed: () async {
                            controllApprove(
                              context,
                            );
                          })
                     
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }

  TextFormField buildNameFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Full name',
        suffixIcon: Icon(Icons.label),
        labelText: 'name',

        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildEmailFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: mailController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Email',
        suffixIcon: Icon(Icons.mail),
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildWhatsappField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: addressController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Address',
        suffixIcon: Icon(CupertinoIcons.location),
        labelText: 'Address',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildPhoneFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Phone number',
        labelText: 'Phone number',
        suffixIcon: Icon(Icons.phone),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField accountName(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: accountNameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Account name',
        labelText: 'Account name',
        suffixIcon: Icon(Icons.label),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField accountNumber(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: accountNumberController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Account number',
        labelText: 'Account number',
        suffixIcon: Icon(Icons.label),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField balance(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: balanceController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Account balance',
        labelText: 'Account balance',
        suffixIcon: Icon(Icons.money),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }
}
