import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/subscription/subscription_screen.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionModal extends StatefulWidget {
  @override
  _SubscriptionModalState createState() => _SubscriptionModalState();
}

class _SubscriptionModalState extends State<SubscriptionModal> {
  final formatter =  NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: kBgScaffold,
          borderRadius:  BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                   SizedBox(height: 20,),
                  Text("HOW TO SUBSCRIBE", textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: kBlack,
                                fontWeight: FontWeight.w600)),
                    SizedBox(height: 10,),
                  Container(
                    color: kWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          
                          ListTile(
                            leading: Icon(Icons.arrow_right, color: Colors.lightGreen),
                            title: RichText(
                              text: TextSpan(
                                  text: "Transfer or deposit ",
                                  style: Theme.of(context).textTheme.subtitle1,
                                  children: [
                                    TextSpan(
                                      text: snippet == null
                                          ? "\u{20A6}1000 "
                                          : "\u{20A6}${snippet?.amount} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Lato",
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                        text:
                                            "only  to the following account number.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                  ]),
                            ),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.arrow_right, color: Colors.lightGreen),
                            title: Text(
                              "Upload evidence of payment by tapping upload button below.",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.arrow_right, color: Colors.lightGreen),
                            title: Text(
                              "Within 10 - 15  minutes, you will receive a notification, indicating your subcription is successful.",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                        border: Border.all(
                          color: const Color.fromARGB(255, 238, 238, 238),
                        ),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "BANK:  ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "STANBIC IBTC ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "ACCOUNT NAME:  ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "MOSES C. PHILIP",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "ACCOUNT NUMBER:  ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "0037567034",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                            icon: Icon(Icons.copy,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: "0037567034"));
                              displayToast("Account number copied");
                            }),
                      ],
                    ),
                  ),
                   SizedBox(height: 10,),
                Column(
                  children: [
                      Card(
                        elevation: 0.0,
                      color: kWhite,
                      child:ListTile(
                        onTap:()=>launchURL(snippet?.whatsapp),
                        leading:CircleAvatar(
                          backgroundImage: AssetImage("assets/images/whatsapp.png"),
                        ),
                        title: Text("Chat with us on whatsapp"),
                        trailing:Icon(Icons.chevron_right),
                      ),
                    ),
                      Card(
                        elevation: 0.0,
                      color: kWhite,
                      child:ListTile(
                        onTap:()async{
                                await launch("tel:+234" + snippet!.phone);
                        },
                        leading:Icon(Icons.phone),
                        title: Text("Call us now"),
                        trailing:Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (currentUser == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginRegisterPage()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Subscription()));
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 210,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text("UPLOAD",
                                  style: TextStyle(color: kWhite))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 210,
                          decoration: BoxDecoration(
                              color: kSecondaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text("MAYBE LATER",
                                  style: TextStyle(color: kWhite))),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
         
          SizedBox(height: 20.0)
        ],
      ),
    ));
  }
}

activationModal(context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SubscriptionModal();
      });
}
