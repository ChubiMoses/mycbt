import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/messages/chart_screen.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/screen/question/questions_tile.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';

class UserInfo extends StatefulWidget {
  final String userId;
  UserInfo(this.userId);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with TickerProviderStateMixin {
  TabController? _tabController;
  List category = ["Questions", "About"];
  bool isLoading = false;
  List<Questions> questions = [];
  bool isOnline = false;
  UserModel? user;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getuserInfo();
    super.initState();
  }

  void getuserInfo() async {
    setState(() {
      isLoading = true;
    });

    usersReference.doc(widget.userId).get().then((value) {
      setState(() {
        user = UserModel.fromDocument(value);
        isOnline = userOnline(user!.id, user!.lastSeen);
      });
    });

    //get users questions
    questionsRef.where("userId", isEqualTo: widget.userId).get().then((value) {
      questions = value.docs
          .map((document) => Questions.fromDocument(document))
          .toList();

      setState(() {
        isOnline = isOnline;
        questions = questions;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
      ),
      body: user == null
          ? loader()
          : Column(
              children: [
                Container(
                  height: 190,
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhotoPreview(user!.url))),
                              child: Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 48,
                                    backgroundColor: kWhite,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundImage:
                                          CachedNetworkImageProvider(user!.url),
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(
                                        left: 70.0, top: 65.0),
                                    child: Container(
                                      decoration:  BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Padding(
                                        padding:  EdgeInsets.all(2.0),
                                        child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: isOnline
                                                ? Theme.of(context).primaryColor
                                                : kGrey200),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:  EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(user!.username,
                                      style:  TextStyle(
                                          fontSize: 15.0,
                                          color: kWhite,
                                          fontWeight: FontWeight.bold)),
                                   SizedBox(
                                    height: 4,
                                  ),
                                 currentUser == null
                                   ? SizedBox.shrink() :
                                  currentUser!.id == widget.userId
                                      ? SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        user: user!,
                                                        view: 'new',
                                                        chatId: '',
                                                        refresh: () {},
                                                      ))),
                                          child:  Chip(
                                            side: BorderSide(color: kWhite),
                                            labelStyle:
                                                TextStyle(color: kWhite),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            avatar: CircleAvatar(
                                              backgroundColor: kWhite,
                                              child: Icon(
                                                Icons.mail,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            label: Text(
                                              "Message",
                                              style: TextStyle(color: kWhite),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: 1.0,
                  child: Container(
                    color: kWhite,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      indicatorPadding: EdgeInsets.all(0),
                      unselectedLabelColor: kBlack.withOpacity(0.5),
                      labelColor: Theme.of(context).primaryColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 2.0,
                      tabs: category.map((tab) => tabs(tab)).toList(),
                    ),
                  ),
                ),
                Expanded(
                    child: TabBarView(controller: _tabController, children: [
                  questions.isEmpty
                      ? EmptyStateWidget("", CupertinoIcons.chat_bubble)
                      : Container(
                          margin: EdgeInsets.only(top: 5),
                          color: kWhite,
                          child: GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: ListView.separated(
                              itemCount: questions.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemBuilder: (BuildContext context, int i) {
                                return QuestionTile(
                                  dislikeIds:questions[i].dislikeIds,
                                  likeIds: questions[i].likeIds,
                                  title: questions[i].title,
                                  id: questions[i].id,
                                  question: questions[i].question,
                                  image: questions[i].image,
                                  answers: questions[i].answers,
                                  timestamp: questions[i].timestamp,
                                  view: "Question",
                                  profileImage: questions[i].profileImage,
                                  userId: questions[i].userId,
                                  username: questions[i].username,
                                );
                              },
                            ),
                          ),
                        ),
                  Container(
                    color: kWhite,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(user!.username),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.school),
                          title: Text(user!.email != "mycbt@gmail.com"
                              ? user!.school
                              : ""),
                        ),
                        currentUser == null
                            ? SizedBox.shrink()
                            : currentUser?.email == "mycbt@gmail.com"
                                ? Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.phone),
                                        title: Text("${user!.phone}"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.email),
                                        title: Text("${user!.email}"),
                                      )
                                    ],
                                  )
                                : SizedBox.shrink()
                      ],
                    ),
                  )
                ])),
              ],
            ),
    );
  }

  Tab tabs(tab) {
    return Tab(
        child: Padding(
      padding:  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(tab,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600)),
    ));
  }
}
