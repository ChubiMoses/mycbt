import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/profile/reset_password.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/profile/select_school.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/login_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/services/Authentication.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:uuid/uuid.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  TextEditingController referalCodeController = TextEditingController(text: "");
  TextEditingController referrerId = TextEditingController(text: "");

  TextEditingController usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.register;
  String _email = "";
  String _password = "";
  String? _username = "";
  String code = "";
  String formTitle = "Sign Up";
  String _phone = "";
  int visibleCount = 0;
  bool obscurePassword = true;
  bool isLoading = false;
  String loginType = "";
  Icon visibilityIcon = const Icon(Icons.visibility);
  AuthImplementation auth = Auth();
  TextStyle labeStyle = const TextStyle(color: Colors.white, fontSize: 14);
  String nid = const Uuid().v4();

  @override
  void initState() {
    if(!kIsWeb){
      readFile();
    }
    super.initState();
  }

  void readFile() async {
    bool exist = await firstLaunch();
    if (exist) {
      referalCodeController.text = await readReferralCode();
      referrerId.text = await readReferrerId();
    }
  }

  void saveUser(userId) async {
    DocumentSnapshot documentSnapshot = await usersReference.doc(userId).get();
    if (!documentSnapshot.exists) {
      usersReference.doc(userId).set({
        'id': userId,
        'username': _username,
        'url': "",
        'email': _email.toLowerCase(),
        'rate': 0,
        'blocked': 0,
        'timestamp': DateTime.now(),
        'phone': _phone,
        'gender': "",
        'school': "",
        'course': "",
        'token': "",
        'points': 100,
        'hideUsers':"",
        'visited': DateTime.now(),
        'lastSeen': DateTime.now(),
        'code': referalCodeController.text,
        'subscribed': 0,
        'device': "",
        'badges': 0
      });
      notify(
          userId: "",
          body: "",
          token: "",
          nid: nid,
          ownerId: userId,
          username:"",
          profileImage:"",
          type: "Welcome");
      //Replace referal code with " " in case of next registration
      storeRefferalCode("");
      if (referrerId.text != "") {
        //reward referrer with 20 points for inviting current user
        rewardUser(referrerId.text, 20);
        usersReference.doc(referrerId.text).get().then((value) {
          String token = UserModel.fromDocument(value).token;
          notify(
              userId: userId,
              body: "You have earned 20 points for inviting  $_username}",
              token: token,
              nid: nid,
              ownerId: referrerId.text,
              username:"",
              profileImage:"",
              type: "Points");
        });
      }
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (_username == "Admin" || _username == "My CBT") {
        SnackBar snackBar = SnackBar(content: Text("Username reserved...."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        isLoading = true;
      });
      try {
        if (_formType == FormType.login) {
          await auth.SignIn(_email.trim(), _password.trim());
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeTab(
                    view: "",
                  )));
        } else {
          String userId = await auth.SignUp(_email.trim(), _password.trim());
          if (userId != null) {
            saveUser(userId);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SelectSchool(userId: userId)));
          } else {
            displayToast("Email already in use, please try another one.");
          }
        }
      } catch (e) {
        displayToast("Error: " + e.toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void moveToRegister() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
      formTitle = "Sign Up";
    });
  }

  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
      formTitle = "Sign In";
    });
  }

  void visibilityChange() {
    visibleCount++;
    if (visibleCount == 1) {
      setState(() {
        obscurePassword = false;
        visibilityIcon = Icon(Icons.visibility_off);
      });
    } else {
      setState(() {
        obscurePassword = true;
        visibilityIcon = Icon(Icons.visibility);
        visibleCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Theme.of(context).primaryColor,
    ));
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/launch_image.jpg"),
                    fit: BoxFit.cover)),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                color: Colors.black.withOpacity(0.8),
                height: 900.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 70.0),
                            Form(
                              key: formKey,
                              child: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Column(
                                  children: createInput() +
                                      createButtons() +
                                      [
                                        const SizedBox(
                                          height: 30.0,
                                        )
                                      ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  List<Widget> createInput() {
    if (_formType == FormType.login) {
      return [
        Center(
          child: Text(
            formTitle,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 20.0),
          ),
        ),
        SizedBox(
          height: 150.0,
        ),
        TextFormField(
          style: labeStyle,
          keyboardType:TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(8.0),
            prefixIcon: Icon(Icons.email, size: 18.0, color: Colors.grey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            fillColor: Colors.deepPurple.shade100,
            labelText: 'Email',
            labelStyle: labeStyle,
          ),
          validator: (value) {
            return value!.isEmpty ? 'Email is required' : null;
          },
          onSaved: (value) {
            _email = value.toString();
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          style: labeStyle,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(8.0),
            prefixIcon: Icon(
              Icons.lock,
              size: 18.0,
              color: Colors.grey,
            ),
            
            suffixIcon: IconButton(
                icon: visibilityIcon,
                color: Colors.grey,
                iconSize: 16.0,
                onPressed: () => visibilityChange()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen)),
            labelText: 'Password',
            labelStyle: labeStyle,
          ),
          obscureText: obscurePassword ? true : false,
          validator: (value) {
            return value!.isEmpty ? 'Password is required ' : null;
          },
          onSaved: (value) {
            _password = value.toString();
          },
        )
      ];
    } else if (_formType == FormType.register) {
      return [
        Center(
          child: Text(
            formTitle,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                fontFamily: "Lato"),
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
        TextFormField(
          style: labeStyle,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen)),
            fillColor: Colors.deepPurple.shade100,
            labelText: 'Email',
            labelStyle: labeStyle,
          ),
          validator: (value) {
            return value!.isEmpty ? 'Email is required' : null;
          },
          onSaved: (value) {
            _email = value.toString().trim();
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          style: labeStyle,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            labelText: 'Username',
            labelStyle: labeStyle,
          ),
          validator: (value) {
            return value!.isEmpty ? 'Username is required ' : null;
          },
          onSaved: (value) {
            _username = value.toString();
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          style: labeStyle,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            labelText: 'Phone Number',
            labelStyle: labeStyle,
          ),
          validator: (value) {
            return value!.isEmpty ? 'Phone Number is required ' : null;
          },
          onSaved: (value) {
            _phone = value.toString();
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          style: labeStyle,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            labelText: 'Referral Code(optional)',
            labelStyle: labeStyle,
          ),
          controller: referalCodeController,
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          style: labeStyle,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: IconButton(
                icon: visibilityIcon,
                color: Colors.grey,
                iconSize: 16.0,
                onPressed: () => visibilityChange()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen)),
            labelStyle: labeStyle,
            labelText: 'Password',
          ),
          obscureText: obscurePassword ? true : false,
          validator: (value) {
            return value!.isEmpty ? 'Password is required ' : null;
          },
          onSaved: (value) {
            _password = value.toString();
          },
        ),
      ];
    }
    return [];
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        Padding(
            padding:  EdgeInsets.only(
              top: 20.0,
            ),
            child: isLoading
                ? SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                      strokeWidth: 4.0,
                    ),
                  )
                : GestureDetector(
                    onTap: validateAndSubmit,
                    child: Container(
                      height: 45,
                      width: 330,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                         
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                          child:
                              Text("SIGN IN", style: TextStyle(color: kWhite, fontWeight: FontWeight.w700))),
                    ),
                  )),
        Padding(
          padding:  const EdgeInsets.only(top: 0, left: 10.0, right: 10.0),
          child: TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("Forgot password?",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                       )),
                Text(" Reset pasword.",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kPrimaryColor
                    )),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResetUserPassword()));
            },
          ),
        ),

         Padding(
            padding:  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Create new account? ",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey)),

                      GestureDetector(
                        onTap: () => moveToRegister(),
                        child: const Text("Register",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            )),
                      )
                    ]), ),
         const SizedBox(height: 30,),
        LoginOptions()
      ];
    } else {
      return [
        const SizedBox(
          height: 5,
        ),
        Padding(
            padding:  const EdgeInsets.only(
              top: 10.0,
            ),
            child: isLoading
                ? SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                      strokeWidth: 4.0,
                    ),
                  )
                : GestureDetector(
                    onTap: validateAndSubmit,
                    child: Container(
                      height: 45,
                      width: 330,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
    
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                          child:
                              Text("SIGN UP", style: TextStyle(color: kWhite, fontWeight: FontWeight.w700))),
                    ),
                  )),

        SizedBox(
          height: 20,
        ),
        Padding(
            padding:
                 EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("By continuing you accept our",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => launchURL(
                            "https://cbt-exams-bc05c.web.app/mycbt_terms.html"),
                        child: Text("Term of use ",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor)),
                      ),
                      const Text("and ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          )),
                      GestureDetector(
                        onTap: () => launchURL(
                            "https://cbt-exams-bc05c.web.app/mycbt_policy.html"),
                        child: const Text("Privacy Policy ",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            )),
                      )
                    ])
              ],
            )),
        Padding(
            padding:  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account? ",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey)),

                      GestureDetector(
                        onTap:moveToLogin,
                        child: const Text("Login",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            )),
                      )
                    ]), ),
        //  LoginOptions()
      ];
    }
  }
}
