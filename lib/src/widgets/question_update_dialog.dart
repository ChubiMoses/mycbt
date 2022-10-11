import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/services/questions_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flushbar/flushbar.dart';

dynamic downloadModal(mContext, String course, String school) {
  return showDialog(
      context: mContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Center(
            child: Text("Alert",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    "This course requires an update. \nThereafter, you can practice it offline.",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButtonWidget(
                  btnText: "Later",
                  onPressed: () async {
                    Navigator.pop(context);
                  }),
              SizedBox(
                width: 10.0,
              ),
              TextButtonWidget(
                  btnText: "Update",
                  onPressed: () async {
                    final result = await checkConnetion();
                    if (result == 0) {
                      displayToast("No internet connection");
                    } else {
                      String schoolName = school;
                      if (school == "JS Tarka University") {
                        schoolName = "University of Agriculture Makurdi";
                      }
                      loaderWidget(context);
                      await questionUpdate(course, schoolName);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Flushbar(
                        title: "Successful.",
                        messageText: const Text(
                          "Update successful, now you can  practice it offline.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        duration: const Duration(seconds: 10),
                        backgroundColor: Theme.of(context).primaryColor,
                        flushbarPosition: FlushbarPosition.TOP,
                        icon: const Icon(
                          CupertinoIcons.rocket_fill,
                          color: Colors.white,
                        ),
                      ).show(context);
                    }
                  })
            ])
          ],
        );
      });
}

loaderWidget(
  mContext,
) {
  return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
            backgroundColor: kBlack400,
            title: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kWhite),
                        strokeWidth: 4.0,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Updating...",
                      style: TextStyle(color: kWhite, fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ));
      });
}
