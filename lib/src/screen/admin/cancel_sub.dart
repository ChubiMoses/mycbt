import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/services/referal_reward.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/course.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class CancelSubscription extends StatefulWidget {
  @override
  _CancelSubscriptionState createState() => _CancelSubscriptionState();
}

class _CancelSubscriptionState extends State<CancelSubscription> {
  TextEditingController controller = TextEditingController();
  TextEditingController codeController = TextEditingController();
  int selectedIndex = 0;
  bool isLoading = false;
  List<UserModel> users = [];
  List<Course> result = [];
  bool emptyState = true;

  @override
  void initState() {
    networkChecker(context, "No internet connection.");
    super.initState();
  }

  void search() async {
    String query = controller.text;
    if (query.length > 1) {
      setState(() {
        users = [];
        emptyState = false;
        isLoading = true;
      });
      await usersReference.where("email", isEqualTo: query).get().then((value) {
        users = value.docs
            .map((documentSnapshot) => UserModel.fromDocument(documentSnapshot))
            .toList();
        setState(() {
          users = users;
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  AppBar searchBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: SizedBox(
            height: 35.0,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controller,
              style: TextStyle(fontSize: 16.0, color: kWhite100),
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Email",
                hintStyle: TextStyle(color: kWhite100),
                filled: true,
                focusColor: Theme.of(context).primaryColor.withOpacity(0.5),
                suffixIcon: IconButton(
                    onPressed: () => search(),
                    icon: Icon(
                      Icons.search,
                      color: kWhite100,
                      size: 20.0,
                    )),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    systemChrome();
    return Scaffold(
        appBar: searchBar(context),
        backgroundColor: kBgScaffold,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: emptyState
              ? emptyStateWidget(
                  "CancelSubscription for your favorite courses.")
              : isLoading
                  ? loader()
                  : users.length == 0
                      ? emptyStateWidget(
                          "Subscription not found, please use  course code as keyword.")
                      : ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: users.length,
                          separatorBuilder: (context, i) => Divider(
                                height: 2,
                              ),
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.all(0),
                                  leading: IconButton(
                                    onPressed: () =>
                                        controllDelete(context, users[i].id),
                                    icon: Icon(Icons.delete),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () =>
                                        subscribeUser(context, users[i].id),
                                    icon: Icon(Icons.check),
                                  ),
                                  title: Text(users[i].username,
                                      style: TextStyle(
                                          color: kBlack,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500)),
                                  subtitle: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    controller: codeController,
                                    style: TextStyle(
                                        fontSize: 16.0, color: kWhite100),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "Code",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                      filled: true,
                                      focusColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
        ));
  }

  Widget emptyStateWidget(String message) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.search, size: 100.0, color: Colors.lightGreen),
          SizedBox(
              width: 150.0,
              child: Text(message,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: kGrey600, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  controllDelete(BuildContext context, String id) {
    activeSubReference.doc(id).get().then((value) {
      if (value.exists) {
        activeSubReference.doc(id).delete();
        displayToast("Subscription cancelled");
      } else {
        displayToast("User is not subcribed");
      }
    });
  }

  subscribeUser(BuildContext context, String id) {
    activeSubReference.doc(id).set({
      "ownerId": id,
      "device": "",
    });
    refferrerReward(codeController.text);
    displayToast("Subscription succesful.");
  }
}
