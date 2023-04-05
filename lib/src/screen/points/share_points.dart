import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';

class SharePoints extends StatefulWidget {
  @override
  State<SharePoints> createState() => _SharePointsState();
}

class _SharePointsState extends State<SharePoints> {
  TextEditingController pointsController = TextEditingController();
  String nid = const Uuid().v4();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void sendPoints() {
    setState(() {
      isLoading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    int sharedPoints = int.parse(pointsController.text);
    if (emailController.text == currentUser!.email) {
      displayToast("You can't share points to yourself");
    } else {
      if (pointsController.text.isNotEmpty) {
        if (sharedPoints > points + 10) {
          displayToast("Insufficient points");
        } else if (emailController.text.isEmpty) {
          displayToast("Please enter email");
        } else {
          usersReference
              .where('email', isEqualTo: emailController.text)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              List<UserModel> users =
                  value.docs.map((e) => UserModel.fromDocument(e)).toList();
              UserModel _user = users[0];

              usersReference.doc(_user.id).update({
                'points': _user.points + sharedPoints,
              });
              //deduct points from sender
              billUser(currentUser!.id, sharedPoints);
              //Notify receiver
              notify(
                  ownerId: _user.id,
                  username:currentUser!.username,
                  profileImage:currentUser!.url,
                  nid: nid,
                  type: "Points",
                  body:"You have recieved $sharedPoints points from ${currentUser!.username}",
                  userId: currentUser!.id,
                  token: _user.token);

              //Notify Sender
              notify(
                  ownerId: currentUser!.id,
                  username:currentUser!.username,
                  profileImage:currentUser!.url,
                  nid: nid,
                  type: "Points",
                  body:
                      "You have sent $sharedPoints points to ${_user.username}",
                  userId: _user.id,
                  token: _user.token);
              displayToast("Points sent");
              setState(() {
                points -= sharedPoints;
              });
            } else {
              displayToast("User not found");
            }
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: pointsController,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                        fontSize: 14,
                        color: kWhite,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusColor: kWhite,
                        contentPadding: const EdgeInsets.all(8.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        fillColor: kWhite,
                        filled: false,
                        prefixIcon: const Icon(
                          CupertinoIcons.suit_diamond,
                          color: kWhite,
                        ),
                        labelText: 'Points',
                        labelStyle: TextStyle(color: kWhite)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: emailController,
                    style: const TextStyle(
                        fontSize: 14,
                        color: kWhite,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusColor: kWhite,
                        contentPadding: const EdgeInsets.all(8.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGrey200, width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: false,
                        prefixIcon: const Icon(
                          CupertinoIcons.person,
                          color: kWhite,
                        ),
                        labelText: 'email',
                        labelStyle: TextStyle(color: kWhite)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isLoading
                    ? SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(kWhite),
                          strokeWidth: 4.0,
                        ),
                      )
                    : GestureDetector(
                        onTap: () => sendPoints(),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 155,
                          decoration: BoxDecoration(
                              border: Border.all(color: kWhite),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Center(
                              child: Text("Share ",
                                  style: TextStyle(
                                      color: kWhite,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
