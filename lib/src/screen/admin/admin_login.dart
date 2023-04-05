import 'package:mycbt/src/screen/admin/home_tab.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController passwordC = TextEditingController();
  TextEditingController usernameC = TextEditingController();

  void login() {
    if (usernameC.text.length == 3) {
      if (passwordC.text == "dash") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AdminHomeTab(view: "",)));
        displayToast("Welcome");
      }
    } else {
      displayToast("Hello Stranger!");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
              child: TextFormField(
                style: textStyle,
                controller: usernameC,
                decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (val) => val!.isEmpty ? "Field empty" : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                controller: passwordC,
                style: textStyle,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (val) => val!.isEmpty ? "Field empty" : null,
              ),
            ),
            ElevatedButtonWidget(btnText: 'Admin login', onPressed: () => login(),)
           
          ],
        ),
      ),
    );
  }
}
