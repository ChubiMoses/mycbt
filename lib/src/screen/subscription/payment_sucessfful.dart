import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/utils/colors.dart';

class PaymentSucessful extends StatefulWidget {
  @override
  _PreExamsState createState() => _PreExamsState();
}

class _PreExamsState extends State<PaymentSucessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, right: 55),
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/pass2.png')),

                  SizedBox(height: 20,),
                Text(
                  'Pro User',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.1,
                      fontSize:30,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: 300,
                    child: Text(
                      'You now have access to My CBT exclusive content and features.',
                      textAlign:TextAlign.center, 
                      style: TextStyle(
                          fontSize:16,
                          letterSpacing: 1.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 20,),
                 GestureDetector(
                  onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeTab(view: '',)));
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text("CONTINUE", style: TextStyle(color: kWhite))),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
