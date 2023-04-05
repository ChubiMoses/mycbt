import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/profile/request_school.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/item.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectSchool extends StatefulWidget {
  final String userId;
  SelectSchool({required this.userId});
  @override
  _SelectSchoolAndCourseState createState() => _SelectSchoolAndCourseState();
}

class _SelectSchoolAndCourseState extends State<SelectSchool> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String schoolName = "";
  int visibleCount = 0;
  List<Item> names = [];
  List<Item> searchResult = [];
  String title = "";
  bool atTop = true;

  void fetch() async {
    final result = await checkConnetion();
    if (result == 0) {
      displayToast("Please turn on your internet connection.");
    }
    setState(() {
      isLoading = true;
    });

    await schoolRef.get().then((value) {
      names = value.docs
          .map((documentSnapshot) => Item.fromDocument(documentSnapshot))
          .toList();
      names.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      setState(() {
        names = names;
        isLoading = false;
      });
    });
  }

  void registrationError() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user = _firebaseAuth.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.doc(user?.uid).get();
    if (!documentSnapshot.exists) {
      user?.delete();
      displayToast("An error occured, please try again");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => LoginRegisterPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    fetch();
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          setState(() => atTop = true);
        } else {
          setState(() => atTop = false);
        }
      }
    });
  }

  void handleSearch(String query) {
    if (query.length > 3) {
      setState(() {
        isLoading = true;
      });
      schoolRef
          .where("name", isGreaterThanOrEqualTo: query)
          .get()
          .then((value) {
        searchResult = value.docs
            .map((documentSnapshot) => Item.fromDocument(documentSnapshot))
            .toList();
        searchResult.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        setState(() {
          searchResult = searchResult;
          isLoading = false;
        });
      });
    } else {
      setState(() {
        searchResult = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Item> list = searchResult.isEmpty ? names : searchResult;
    return Scaffold(
        backgroundColor: kBgScaffold,
        appBar: header(
          context,
          strTitle: "Select Institution",
        ),
        body: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 30.0, bottom: 20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              TextFormField(
                onChanged: handleSearch,
                textCapitalization: TextCapitalization.words,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8.0),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: kGrey200, width: 1),
                      borderRadius: BorderRadius.circular(4.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: kGrey200, width: 1),
                      borderRadius: BorderRadius.circular(4.0)),
                  fillColor: kWhite,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Search',
                ),
              ),
              Expanded(
                child: isLoading
                    ? loader()
                    : list.isEmpty
                        ? empty()
                        : Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() =>
                                            schoolName = list[index].name);
                                      },
                                      child: Card(
                                        elevation: 0.0,
                                        color: kWhite,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          dense: true,
                                          trailing:
                                              schoolName == list[index].name
                                                  ? Icon(
                                                      Icons.check,
                                                      color: schoolName ==
                                                              list[index].name
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : kBlack400,
                                                    )
                                                  : null,
                                          title: Text(
                                            list[index].name.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  schoolName == list[index].name
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : kBlack400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  schoolName != ""
                                      ? GestureDetector(
                                          onTap: () => updateUserInfo(),
                                          child: Center(
                                            child: Material(
                                              color: schoolName == ""
                                                  ? Colors.grey
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50,
                                                height: 45,
                                                child: const Center(
                                                    child: Text("Continue",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              ),
                                            ),
                                          ),
                                        )
                                      : atTop
                                          ? Text("You can scroll down",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold))
                                          : Row(
                                              children: [
                                                const Text("School name not found?",
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(width: 5.0),
                                                InkWell(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RequestSchool(
                                                                  userId: widget
                                                                      .userId))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Add School",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                ],
                              ),
                            ],
                          ),
              ),
            ])));
  }

  void updateUserInfo() {
    registrationError();
    usersReference.doc(widget.userId).update({"school": schoolName});
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => UploadProfileImage(userId: widget.userId, view: '',)));
  }

  Widget empty() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(CupertinoIcons.refresh_circled,
              size: 100.0, color: Colors.lightGreen),
          SizedBox(
              width: 150.0,
              child: Text("An error occured.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1)),
          OutlinedButton(
            onPressed: () => fetch(),
            child: const Text("Refresh"),
             style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(
                          kPrimaryColor),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
