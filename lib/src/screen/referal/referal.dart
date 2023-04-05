import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:mycbt/src/models/referral.dart';
import 'package:mycbt/src/screen/admin/approve_sub.dart';
import 'package:mycbt/src/screen/admin/cancel_sub.dart';
import 'package:mycbt/src/screen/referal/payment_info.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/utils/list.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:intl/intl.dart';

class ReferralProgram extends StatefulWidget {
  @override
  _ActivateMyAppState createState() => _ActivateMyAppState();
}

class _ActivateMyAppState extends State<ReferralProgram> {
  final formatter =  NumberFormat("#,###");
  String path = "";
  File? file;
  String type = "";
  final formkey = GlobalKey<FormState>();
  String id = Uuid().v4();
  bool uploading = false;
  String name = "";
  String number = "";
  String phone = "";
  String bank = "";
  bool refferalActive = false;
  bool pending = false;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  TextStyle labeStyle = TextStyle(color: Colors.black87);
  Referral? referrer;
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    handleReferral();
  }

  void handleReferral() async {
    if (currentUser == null) {
      Navigator.pop(context);
      displayToast("Please login");
    } else {
      setState(() => isLoading = true);
        await agentsRef.doc(currentUser?.id).get().then((value) {
          if (value.exists) {
            setState(() => referrer = Referral.fromDocument(value));
            if (referrer?.elligible == 1) {
              setState(() => pending = true);
            }
             setState(() => isLoading = false);
          } else {
            String code = getRandomString(5);
            agentsRef.doc(currentUser?.id).set({
              "accountName": "",
              "accountNumber": "",
              "bank": "",
              "elligible": 0,
              "balance": 0,
              "phone": "",
              "snippet": "",
              "code": code
            });
            handleReferral();
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Refer & Earn",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        actions: !admin.contains(currentUser!.email) ? null :[
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  CancelSubscription()));
          }, icon: const Icon(Icons.lock))
        ] 
      ),
      body: isLoading
          ? loader()
          : SingleChildScrollView(
              child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).primaryColor,
                    width: MediaQuery.of(context).size.width,
                    height: 130.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("\u{20A6}${formatter.format(referrer?.balance)}",
                            style: const TextStyle(
                                fontSize: 35.0,
                                color: kWhite,
                                fontWeight: FontWeight.bold)),
                        const Text("EARNINGS",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: kWhite,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: !pending
                              ? () => placeWithrawal()
                              : () {
                                  SnackBar snackBar = const SnackBar(
                                      content: Text("Withdrawal pending..."));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                          child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(color: kWhite),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                    child: Text( pending
                                ? "PENDING" :  "WITHDRAW" ,
                                        style: const TextStyle(
                                            color: kWhite,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0)),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  refferalAccount()
                ],
              ),
            )),
    );
  }

  Widget refferalAccount() {
    return Center(
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: kWhite),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 30.0),
                  child: Text(
                      currentUser == null
                          ? "Hello there! Become a My CBT Agent, refer and earn 10%   from each of your referee's  subscription."
                          : "Hello ${currentUser?.username}, Become a My CBT Agent, refer and earn 10%   from each of your referee's  subscription.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 5.0),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: referrer?.code));
                            displayToast(
                                "${referrer?.code} copied to clipboard");
                          },
                          child: Text(referrer!.code,
                              style: TextStyle(
                                  fontSize: 35.0,
                                  color: kGrey600,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text("REFERRAL CODE",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: kGrey600,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height: 20.0),
                Text("How to earn?",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: kGrey600,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 5.0),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kGrey300,
                    radius: 15,
                    child: Text("1"),
                    foregroundColor: kBlack,
                  ),
                  title: Text(
                      "Tell a friend to use your referral code during registration.",
                      style: TextStyle(
                          fontSize: 13.0,
                          color: kBlack400,
                          fontWeight: FontWeight.w500)),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundColor: kGrey300,
                    child: Text("2"),
                    foregroundColor: kBlack400,
                  ),
                  title: Text(
                      "Share links from My CBT & watch your eanings grow!",
                      style: TextStyle(
                          fontSize: 13.0,
                          color: kBlack400,
                          fontWeight: FontWeight.w500)),
                ),
                snippet?.video == "empty"
                    ? SizedBox.shrink()
                    : GestureDetector(
                        onTap: () => launchURL(snippet?.video),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundColor: kGrey300,
                            child: Text("3"),
                            foregroundColor: kBlack,
                          ),
                          title: Container(
                            height: 100,
                            width: 200,
                            decoration: BoxDecoration(
                                color: kBlack,
                                borderRadius: BorderRadius.circular(5)),
                            child: Icon(
                              Icons.play_circle_fill,
                              color: kWhite,
                            ),
                          ),
                          subtitle: Text("Watch a video on how to earn.",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: kBlack400,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                SizedBox(height: 20.0),
                Divider(),
              ],
            ),
          )),
    );
  }

  placeWithrawal() async {
    if (referrer!.balance < 1000) {
      displayToast("You need a thousand naira or more to place withdrawal.");
    } else {
      if (referrer?.accountNumber == "") {
        String text = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPaymentInfo(handleReferral)));
        if (text == "saved") {
          agentsRef.doc(currentUser?.id).update({
            "elligible": 1,
          });
          displayToast("withdrawal Placed!");
        }
      } else {
        agentsRef.doc(currentUser?.id).update({
          "elligible": 1,
        });
        displayToast("withdrawal Placed!");
      }
    }
  }

  final _chars = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
