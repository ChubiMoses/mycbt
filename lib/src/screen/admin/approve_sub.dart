import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/referal_reward.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/subscription.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';
import 'package:mycbt/src/widgets/new_sub_tile.dart';
import 'package:uuid/uuid.dart';

class ApproveSubScreen extends StatefulWidget {
  @override
  _ApproveSubscriptionState createState() => _ApproveSubscriptionState();
}

class _ApproveSubscriptionState extends State<ApproveSubScreen> {
  String id = Uuid().v4();
  bool loading = true;
  List<SubList> sub = [];
  String name = "";
  String subId = "";

  @override
  void initState() {
    super.initState();
    fetchNewSub();
  }

  void fetchNewSub() async {
    setState(() {
      loading = true;
    });
    await subReference.where("approved", isEqualTo: false).get().then((value) {
      sub =
          value.docs.map((document) => SubList.fromDocument(document)).toList();
      setState(() {
        sub = sub;
        loading = false;
      });
    });
  }

  void approveSub(String subId, String ownerId, String device, String code) {
    activeSubReference.doc(ownerId).set({
      "ownerId": ownerId,
      "device": device,
    });

    subReference.doc(subId).update({'approved': true});
     usersReference.doc(ownerId).get().then((value) {
       String token = UserModel.fromDocument(value).token;
       notify(
        userId: currentUser!.id,
        username: currentUser!.username,
        profileImage: currentUser!.url,
        body: "Subscription succesful",
        token:token,
        nid: id,
        ownerId: ownerId,
        type: "Success");
      });
    
    refferrerReward(code);
    fetchNewSub();
  }

  void deleteSub(String subId, ownerId) {
    subReference.doc(subId).get().then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    storageReference.child("sub_$subId.jpg").delete();
    fetchNewSub();
  }

  dynamic controllDelete(mContext, String subId, ownerId) {
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are sure you want to delete?",
                style:
                    TextStyle(color: kBlack400, fontWeight: FontWeight.bold)),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Delete", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  usersReference.doc(ownerId).get().then((value) {
                    String token = UserModel.fromDocument(value).token;
                     notify(
                      userId: "",
                      nid: id,
                      body: "Subscription failed",
                      token:token,
                      ownerId: ownerId,
                      username: currentUser!.username,
                      profileImage: currentUser!.url,
                      type: "Failed");
                  });
                 
                  deleteSub(subId, ownerId);
                },
              ),
            ],
          );
        });
  }

  dynamic controllApprove(
      mContext, String subId, String ownerId, String device, String code) {
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are sure you want to approve?",
                style:
                    TextStyle(color: kBlack400, fontWeight: FontWeight.bold)),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Approve", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  approveSub(subId, ownerId, device, code);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      body: loading
          ? loader()
          : sub.isEmpty
              ? EmptyStateWidget("No manual subscription at the moment.",
                  CupertinoIcons.money_dollar_circle)
              : Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ColorResources.COLOR_WHITE,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: sub.length,
                    padding: EdgeInsets.all(0),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          NewSubTile(
                            title: "${sub[index].school}",
                            orderNo: "${sub[index].name}",
                            date: "${sub[index].date}",
                            amount: "${sub[index].phone}",
                            status:
                                sub[index].approved ? "Approved" : "Pending",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButtonWidget(
                                btnText: "Image",  
                                onPressed: () =>
                                    photoPreview(context, sub[index].url)),
                              
                              ElevatedButtonWidget(
                                btnText: "Approve", 
                              onPressed: () => controllApprove(
                                      context,
                                      sub[index].id,
                                      sub[index].ownerId,
                                      sub[index].device,
                                      sub[index].account)),
                              ElevatedButtonWidget(
                                btnText: "Cancel", 
                               onPressed: () => controllDelete(
                                        context,
                                        sub[index].id,
                                        sub[index].ownerId,
                                      )),

                              

                              IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: sub[index].phone));
                                    displayToast(
                                        "Phone number copied ClipBoard");
                                  }),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  void photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
