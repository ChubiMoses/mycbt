
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/profile/profile_image.dart';
import 'package:mycbt/src/screen/profile/reset_password.dart';
import 'package:mycbt/src/screen/profile/reset_username.dart';
import 'package:mycbt/src/screen/welcome/welcome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/services/Authentication.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int count = 0;
  bool sync = false;
  AuthImplementation auth = Auth();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: header(context, strTitle: "Account"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UploadProfileImage(userId: currentUser?.id??"", view: 'Update')));
                  },
                  child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Change profile picture",
                        style: Theme.of(context).textTheme.bodyText1),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ResetUserPassword()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text("Change Password",
                        style: Theme.of(context).textTheme.bodyText1),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ResetUsername()));
                    },
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Change Username",
                          style: Theme.of(context).textTheme.bodyText1),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                    )),
                Divider(),
                InkWell(
                  onTap: () async {
                    if (currentUser == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginRegisterPage()));
                    }
                    await auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => WelcomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: ListTile(
                    leading:
                        Icon(currentUser == null ? Icons.login : Icons.logout),
                    title: Text(currentUser == null ? "Sign in" : "Sign Out",
                        style: Theme.of(context).textTheme.bodyText1),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  CircleAvatar avatar() {
    return CircleAvatar(
        radius: 80.0,
        backgroundColor: kGrey300,
        child: Icon(
          Icons.person,
          size: 60.0,
          color: Colors.grey[400],
        ));
  }
}
