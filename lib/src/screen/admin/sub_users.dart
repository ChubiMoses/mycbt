import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/subscription.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/admin/users_info.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';

class SubUsers extends StatefulWidget {
  @override
  _SubUsersState createState() => _SubUsersState();
}

class _SubUsersState extends State<SubUsers> {
  bool isLoading = true;
  List<UserModel> users = [];
  List<Subs> sublist = [];
  String name = "";
  String subId = "";

  @override
  void initState() {
    super.initState();
    fetchReferral();
  }

  void fetchReferral() async {
    setState(() {
      isLoading = true;
    });
    await activeSubReference.get().then((value) {
      sublist =
          value.docs.map((document) => Subs.fromDocument(document)).toList();
      setState(() {
        sublist = sublist;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(0),
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          // height: SizeConfig.screenHeight * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              boxShadow: [kDefaultShadow]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kBlack),
                                  ),
                                  Text(
                                    sublist.length.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: kBlack),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
            Container(
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
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text("Users", textAlign: TextAlign.left),
                    isLoading
                        ? loader()
                        :  ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 20,
                            separatorBuilder:(context, i)=>Divider(height: 2,),
                            itemBuilder: (context, i) {
                              return FutureBuilder<DocumentSnapshot<Object>>(
                                future:usersReference.doc(sublist[i].ownerId).get(),
                                builder: (context, snap) {
                                if (!snap.hasData) {
                                  return loader();
                                }
                                UserModel? user = UserModel.fromDocument(snap.data!);
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: ListTile(
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => UsersInfo(user: user, referral: null,)));
                                        },
                                    dense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    trailing: IconButton(
                                      onPressed: () =>
                                          controllDelete(context, user.id),
                                      icon: Icon(Icons.delete),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.url),
                                    ),
                                    title:  Text(user.username,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500)),
                                    
                                    subtitle:Text(user.school),
                                  ),
                                );
                              });
                            }),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  dynamic controllDelete(mContext, userId) {
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are sure you want to delete?",
                style: TextStyle(color: Colors.black, fontSize: 14)),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Delete", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  //    deleteUser(userId);
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
