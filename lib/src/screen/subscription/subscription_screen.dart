import 'dart:io';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/modal/subscription_modal.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/services/Authentication.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:flutterwave_payment/flutterwave_payment.dart';

class Subscription extends StatefulWidget {
  @override
  _ActivateMyAppState createState() => _ActivateMyAppState();
}

class _ActivateMyAppState extends State<Subscription> {
  String path = '';
  File? file;
  String type = '';
  final formkey = GlobalKey<FormState>();
  String id = const Uuid().v4();
  bool uploading = false;
  bool uploadDone = false;
  String name = "";
  String account = "";
  String phone = "";
  String code = "";
  bool pending = false;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  TextStyle labeStyle = const TextStyle(color: Colors.black87);
  AuthImplementation auth = Auth();
  bool canContinue = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = true;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = false;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = false;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = true;
  List<SubAccount> subAccounts = [];
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  String publicKey = "FLWPUBK-832ef113eec3cafd5a70fec8ba8de8b3-X";
  String encryptionKey = "6b6e58d17d27b9598a86bc93";
  String txRef = "";
  String orderRef = "";
  String narration = "Subscription";
  String currency = "NGN";
  String country = "NG";
  String error = "";

  @override
  initState() {
    super.initState();
    checkPendingSub();
  }

  void checkPendingSub() async {
    await subReference.doc(currentUser?.id).get().then((value) {
      if (!value.exists) {
        setState(() {
          pending = false;
        });
      } else {
        setState(() {
          pending = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Subscription"),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              !canContinue
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: kGrey200, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 10.0),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Unlimited Downloads",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Study Mode",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Exam Mode",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Unlimited Questions",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Join Conversations",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("CGPA Calculator",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (currentUser == null) {
                                              displayToast("Please login");
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginRegisterPage()));
                                            } else {
                                              if (!pending && !subscribed) {
                                                setState(
                                                    () => canContinue = true);
                                              } else if (pending) {
                                                SnackBar snackBar = SnackBar(
                                                    content: Text(
                                                        "Subcription pending...."));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 45.0,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                  subscribed
                                                      ? "YOU'RE A PRO USER"
                                                      : pending
                                                          ? "PENDING"
                                                          : "BECOME A PRO USER",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontFamily: "bariol",
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: kGrey200, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 10.0),
                                        ListTile(
                                          leading: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          title: Text("Unlimited Downloads",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          title: Text("Study Mode",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          title: Text("Unlimited Questions",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Exam Mode (2014) only",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("Join Conversations",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.done,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: Text("CGPA Calculator",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        Container(
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: kBlack400,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                                subscribed
                                                    ? "FREE MODE"
                                                    : "YOU'RE IN FREE MODE",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 30),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: kGrey200, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              Text(
                                "Automatically become a Pro User  by paying the subscription fee online.",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: kBlack400,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => startPayment(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 5,
                                  child: Center(
                                      child: Text("PAY ONLINE",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text("OR",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                error +
                                    "Become a Pro User by making a transfer and uploading evidence of payment.",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: kBlack400,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  auth.isSignedIn().then((user) {
                                    if (user == null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginRegisterPage()));
                                    } else {
                                      activationModal(context);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 5,
                                  child: Center(
                                      child: Text(
                                          "Manual subscription".toUpperCase(),
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
            ],
          ),
        ));
  }

  dynamic acceptTerms(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Center(
                child: Text(
              "T&C",
              style: TextStyle(fontWeight: FontWeight.bold, color: kBlack400),
            )),
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Get unrestricted access to all My CBT features and content on this phone by making a one time  subscription. \n\nMy CBT subscription is only valid on one mobile phone (subscribed phone).",
                          style: TextStyle(
                            color: kBlack400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "By continuing, you agree not to use My CBT subscription on a different  phone.",
                          style: TextStyle(
                            color: kBlack400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() => canContinue = true);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [kDefaultShadow],
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 40,
                          width: MediaQuery.of(context).size.width - 5,
                          child: Center(
                              child: Text("CONTINUE",
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  // void startPayment() async {
  //   txRef = "rave_flutter-${DateTime.now().toString()}";
  //   orderRef = "rave_flutter-${DateTime.now().toString()}";
  //   var initializer = RavePayInitializer(
  //       amount: double.parse(snippet.amount),
  //       publicKey: publicKey,
  //       encryptionKey: encryptionKey,
  //       subAccounts: subAccounts.isEmpty ? null : null)
  //     ..country = country = country.isNotEmpty ? country : "NG"
  //     ..currency = currency.isNotEmpty ? currency : "NGN"
  //     ..email = currentUser.email
  //     ..fName = currentUser.username
  //     ..lName = currentUser.username
  //     ..narration = narration ?? ''
  //     ..txRef = txRef
  //     ..orderRef = orderRef
  //     ..acceptMpesaPayments = acceptMpesaPayment
  //     ..acceptAccountPayments = acceptAccountPayment
  //     ..acceptCardPayments = acceptCardPayment
  //     ..acceptAchPayments = acceptAchPayments
  //     ..acceptGHMobileMoneyPayments = acceptGhMMPayments
  //     ..acceptUgMobileMoneyPayments = acceptUgMMPayments
  //     ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
  //     ..displayEmail = false
  //     ..displayAmount = false
  //     ..staging = !live
  //     ..isPreAuth = preAuthCharge
  //     ..displayFee = shouldDisplayFee;
  //   var response;
  //   try {
  //     response = await RavePayManager()
  //         .prompt(context: context, initializer: initializer);
  //     displayToast(response?.message);
  //     if (response?.status.toString() == "RaveStatus.success") {
  //       DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //       AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
  //       user.doc(currentUser.id).set({
  //         "ownerId": currentUser.id,
  //         "device": androidInfo.model,
  //       });
  //       refferrerReward(currentUser.code);
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => PaymentSucessful()));
  //     }
  //   } catch (e) {
  //     displayToast(response?.message);
  //   }
  // }

  void startPayment() async {
    displayToast("Not available at the moment");
    // var initializer = RavePayInitializer(
    //     amount: 50,
    //     publicKey: publicKey,
    //     encryptionKey: encryptionKey,
    //     subAccounts: subAccounts.isEmpty ? null : null)
    //   ..country =
    //       country = country != null && country.isNotEmpty ? country : "NG"
    //   ..currency = currency != null && currency.isNotEmpty ? currency : "NGN"
    //   ..email = currentUser!.email
    //   ..fName = currentUser!.username
    //   ..lName = currentUser!.email
    //   ..narration = narration
    //   ..txRef = "rave_flutter-${DateTime.now().toString()}"
    //   ..orderRef = "rave_flutter-${DateTime.now().toString()}"
    //   ..acceptMpesaPayments = acceptMpesaPayment
    //   ..acceptAccountPayments = acceptAccountPayment
    //   ..acceptCardPayments = acceptCardPayment
    //   ..acceptAchPayments = acceptAchPayments
    //   ..acceptGHMobileMoneyPayments = acceptGhMMPayments
    //   ..acceptUgMobileMoneyPayments = acceptUgMMPayments
    //   ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
    //   ..displayEmail = false
    //   ..displayAmount = false
    //   ..staging = !live
    //   ..isPreAuth = preAuthCharge
    //   ..displayFee = shouldDisplayFee;

    // var response = await RavePayManager()
    //     .prompt(context: context, initializer: initializer);
    // setState(() {
    //   error = response.toString();
    // });
  }
}
