import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/admin/users_info.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/referral.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ReferralList extends StatefulWidget {
  @override
  _ApproveSubscriptionState createState() => _ApproveSubscriptionState();
}

class _ApproveSubscriptionState extends State<ReferralList> {
  String id = Uuid().v4();
  bool loading = true;
  List<Referral> referral = [];
  String name = "";
  String subId = "";

  @override
  void initState() {
    super.initState();
    fetchReferral();
  }

  void fetchReferral() async {
    setState(() {
      loading = true;
    });
    await agentsRef.orderBy('balance', descending: true).limit(15).get().then((value) {
      referral = value.docs.map((document) => Referral.fromDocument(document)).toList();
      setState(() {
        referral = referral;
        loading = false;
      });
    });
  }

  void approveWithrawal(String id) {
    agentsRef.doc(id).update({
      "balance": 0,
      "elligible": 0,
    });
    fetchReferral();
  }

  Future<void> refferrerReward(String code) async {
    await agentsRef.where("code", isEqualTo: code).get().then((value) {
      List<Referral> codes = value.docs
          .map((documentSnapshot) => Referral.fromDocument(documentSnapshot))
          .toList();
      if (codes != null) {
        String userId = codes[0].id;
        int initialBalance = codes[0].balance;
        int balance = (initialBalance + 100);
        agentsRef.doc(userId).update({'balance': balance});
      } else {
        displayToast("Invalid referral code");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? loader()
          : Container(
              child: ListView.separated(
                itemCount: referral.length,
                physics: BouncingScrollPhysics(),
                 separatorBuilder:(context, i)=>Divider(height: 2,),
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<DocumentSnapshot<Object>>(
                future:usersReference.doc(referral[index].id).get(),
                builder: (context, snap) {
                if (!snap.hasData) {
                  return loader();
                }
                UserModel user = UserModel.fromDocument(snap.data!);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    tileColor: referral[index].elligible == 1 ? Colors.red : Colors.white,
                        onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UsersInfo(user: user, referral:referral[index] )));
                        },
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                    trailing: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.delete),
                    ),
                    leading: CircleAvatar(
                      backgroundColor:kGrey300,
                      backgroundImage:
                          CachedNetworkImageProvider(
                              user.url),
                    ),
                    title:  Text(user.username + " - N"+referral[index].balance.toString(),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500)),
                    
                    subtitle:Text(user.email),
                    
                  ),
                );
              });
                      
                },
              ),
            ),
    );
  }
}
