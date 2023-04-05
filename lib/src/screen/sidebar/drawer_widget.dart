import 'package:flutter/cupertino.dart';
import 'package:mycbt/src/screen/about.dart';
import 'package:mycbt/src/screen/admin/admin_login.dart';
import 'package:mycbt/src/screen/faq.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/testimonial/testimonials.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/points/points.dart';
import 'package:mycbt/src/screen/profile/profile.dart';
import 'package:mycbt/src/screen/subscription/subscription_screen.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/dynamic_link_service.dart';
import 'package:mycbt/src/services/questions_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/services/Authentication.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<DrawerWidget> {
  int count = 0;
  bool sync = false;
  AuthImplementation auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              padding: EdgeInsets.only(top: 40),
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      currentUser == null
                          ? CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/user.png",
                              ),
                              radius: 30.0,
                              backgroundColor: Colors.grey[300],
                            )
                          : currentUser!.url == ""
                              ? CircleAvatar(
                                  child:
                                      Icon(Icons.person, color: Colors.black54),
                                  radius: 30.0,
                                  backgroundColor: Colors.grey[300],
                                )
                              : InkWell(
                                  //  onTap:()=>photoPreview(context,currentUser!.url),
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        currentUser!.url),
                                    radius: 35.0,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          currentUser == null
                              ? "Hello Stranger"
                              : currentUser!.username,
                          style: const TextStyle(
                              color: kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5.0,
                      ),
                      currentUser == null
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(" " + currentUser!.email.toString(),
                                    style: TextStyle(color: kWhite)),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Text(
                                  "|",
                                  style: TextStyle(color: kWhite),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(CupertinoIcons.suit_diamond_fill,
                                    size: 18.0, color: kWhite),
                                Text(points.toString(),
                                    style: TextStyle(color: kWhite)),
                              ],
                            ),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  currentUser == null
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginRegisterPage()));
                          },
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Sign Up",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Profile()));
                          },
                          child: ListTile(
                            leading: Icon(CupertinoIcons.person),
                            title: Text("My Account",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Subscription()));
                    },
                    child: ListTile(
                      leading: Icon(CupertinoIcons.lock_open),
                      title: Text("Subscription",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PointScreen()));
                    },
                    child: ListTile(
                      leading: Icon(CupertinoIcons.suit_diamond),
                      title: Text("Points",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        final result = await checkConnetion();
                        if (result == 0) {
                          displayToast("No internet connection.");
                        } else {
                          displayToast("Please wait...");
                          String _linkMessage = await createDynamicLink(
                              title:"Join student community! Access study material and solve assignments on the fly?",
                              id: '');
                          Share.share(
                            _linkMessage,
                          );
                        }
                      },
                      child: const ListTile(
                        leading: Icon(CupertinoIcons.person_add),
                        title: Text("Invite friends",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      )),
                  InkWell(
                      onTap: () {
                        launchURL(snippet?.whatsapp);
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundImage:
                              AssetImage("assets/images/whatsapp.png"),
                        ),
                        title: Text("Contact us",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      )),
                  InkWell(
                      onTap: () {
                        launchURL("https://www.facebook.com/mycbt1/");
                      },
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 10,
                          backgroundImage:
                              AssetImage("assets/images/facebook.png"),
                        ),
                        title: Text("Facebook",
                            style: Theme.of(context).textTheme.bodyText1),
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TestimonialScreen("")));
                      },
                      child: ListTile(
                        leading: const Icon(Icons.rate_review),
                        title: Text("Testimonials",
                            style: Theme.of(context).textTheme.bodyText1),
                      )),
                  InkWell(
                      onTap: () async {
                        await clearQuizDatabase().then((value) {
                          clearCourses();
                          displayToast("Downloads Cleared");
                        });
                      },
                      child: ListTile(
                        leading: Icon(Icons.sync),
                        title: Text("Clear Downloads",
                            style: Theme.of(context).textTheme.bodyText1),
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => FAQScreen()));
                    },
                    child: ListTile(
                      leading: Icon(CupertinoIcons.question_circle),
                      title: Text("FAQ",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => About()));
                      },
                      child: ListTile(
                        leading: Icon(CupertinoIcons.info),
                        title: Text("About",
                            style: Theme.of(context).textTheme.bodyText1),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  currentUser == null
                      ? const SizedBox.shrink()
                      : currentUser?.email == "mycbt@gmail.com"
                          ? TextButton(
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
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminLogin())),
                              child: const Text("Admin"),
                             )
                          : SizedBox.shrink(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("My CBT v 1.3.30  | 2021 \u00a9Cocreator",
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: Material(
      //   elevation: 2.0,
      //   borderRadius: BorderRadius.circular(30),
      //   child: Container(
      //     height: 45,
      //     width: 100,
      //     decoration: BoxDecoration(
      //         color: kSecondaryColor, borderRadius: BorderRadius.circular(30)),
      //     child: InkWell(
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Icon(
      //               Icons.mail,
      //               color: kWhite,
      //               size: 18,
      //             ),
      //             Text(
      //               "Email Us",
      //               style: TextStyle(color: kWhite, fontSize: 14),
      //             )
      //           ],
      //         ),
      //         splashColor: Colors.white,
      //         onTap: () async {
      //           //  correctQuestions();
      //           _launchMail();
      //         }),
      //   ),
      // ),
    );
  }

  _launchMail() async {
    final Uri params = Uri(
      scheme: "mailto",
      path: "hellomycbt@gmail.com",
      query: "subject=MyCBT 1.3.29",
    );
    final url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch" + url;
    }
  }

  CircleAvatar avatar() {
    return CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.person,
          size: 60.0,
          color: Colors.grey[400],
        ));
  }
}
