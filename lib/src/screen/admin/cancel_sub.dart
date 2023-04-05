import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/services/referal_reward.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/course.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class CancelSubscription extends StatefulWidget {
  const CancelSubscription({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
      await usersReference.where("email", isEqualTo: query.trim()).get().then((value) {
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
              style: const TextStyle(fontSize: 16.0, color: kWhite100),
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(8.0),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Email",
                hintStyle: const TextStyle(color: kWhite100),
                filled: true,
                focusColor: Theme.of(context).primaryColor.withOpacity(0.5),
                suffixIcon: IconButton(
                    onPressed: () => search(),
                    icon: const Icon(
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
                  "Cancel/Subscribe Users.")
              : isLoading
                  ? loader()
                  : users.isEmpty
                      ? emptyStateWidget(
                          "Subscription not found")
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: users.length,
                          separatorBuilder: (context, i) => const Divider(
                                height: 2,
                              ),
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Card(
                                  elevation: 2,
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    leading: IconButton(
                                      onPressed: () =>
                                          controllDelete(context, users[i].id),
                                      icon: const Icon(Icons.close),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () =>
                                          subscribeUser(context, users[i].id),
                                      icon: const Icon(Icons.check),
                                    ),
                                    title: Text(users[i].username,
                                        style: const TextStyle(
                                            color: kBlack,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500)),
                                    subtitle: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      keyboardType: TextInputType.text,
                                      controller: codeController,
                                      style: const TextStyle(
                                          fontSize: 16.0, color: kWhite100),
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.all(8.0),
                                        border: const OutlineInputBorder(
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
          const Icon(Icons.lock, size: 100.0, color: Colors.lightGreen),
          SizedBox(
              width: 150.0,
              child: Text(message,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: kGrey600, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  void controllDelete(BuildContext context, String id) {
     usersReference.doc(id).update({
        "subscribed": 0,
      });

    activeSubReference.doc(id).get().then((value) {
      if (value.exists) {
        activeSubReference.doc(id).delete();
        displayToast("Subscription cancelled");
      } else {
        displayToast("User is not subcribed");
      }
      
    });

     subReference.doc(id).get().then((value) {
      if (value.exists) {
         subReference.doc(id).delete();
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
