import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String loginType = "";
  String nid = Uuid().v4();



  void googleSignIn() async {

     displayToast("Not available at the moment");
    // setState(() => loginType = "google");
    // User gUser;
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    // // get the credentials to (access / id token)
    // // to sign in via Firebase Authentication
    // final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    // try {
    //   gUser = (await _auth.signInWithCredential(credential)).user;
    //   saveUserInfo(
    //       email: gUser.email,
    //       userId: gUser.uid,
    //       username: gUser.displayName,
    //       photo: gUser.photoURL);
    //   displayToast('Login successful!');
    // } catch (e) {
    //   displayToast("Error: " + e.message.toString());
    // }
    // setState(() => loginType = " ");
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(color: Colors.white, width: 73.0, height: 1.0),
          Text("Or continue with", style: TextStyle(color: Colors.grey)),
          Container(color: Colors.white, width: 73.0, height: 1.0),
        ],
      ),
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          OutlinedButton(
            child: loginType == "google"
                ? showLoader(context)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      CircleAvatar(
                        radius: 10.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/images/google.png"),
                      ),
                      SizedBox(width: 10),
                      Text("Google",
                          style: TextStyle(
                              color: Colors.grey, fontFamily: "Lato")),
                    ],
                  ),
            onPressed: () => googleSignIn(),
          
          ),
          OutlinedButton(

            child: loginType == "facebook"
                ? showLoader(context)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      CircleAvatar(
                        radius: 11.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage("assets/images/facebook.png"),
                      ),
                      SizedBox(width: 10),
                      Text("Facebook",
                          style: TextStyle(
                              color: Colors.grey, fontFamily: "Lato")),
                    ],
                  ),
            onPressed: () => faceBookSignIn(),
          ),
        ],
      )
    ]);
  }

  void faceBookSignIn() async {
    displayToast("Not available at the moment");
    // setState(() => loginType = "facebook");
    // final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final token = result.accessToken.token;
    //     final AuthCredential credential =
    //         FacebookAuthProvider.credential(token);
    //     try {
    //       User fUser = (await _auth.signInWithCredential(credential)).user;
    //       saveUserInfo(
    //           email: fUser.email,
    //           userId: fUser.uid,
    //           username: fUser.displayName,
    //           photo: fUser.photoURL);
    //       displayToast('Login successful!');
    //     } catch (e) {
    //       displayToast("Error: " + e.message.toString());
    //     }
    //     //final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    //     //final profile = jsonDecode(graphResponse.body);
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     displayToast('Login cancelled!');
    //     break;
    //   case FacebookLoginStatus.error:
    //     displayToast('Sign in Error: ${result.errorMessage}');
    //     break;
    // }
    // setState(() => loginType = " ");
  }

  Widget showLoader(context) {
    return SizedBox(
        width: 15.0,
        height: 15.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
          strokeWidth: 3.0,
        ));
  }
}
