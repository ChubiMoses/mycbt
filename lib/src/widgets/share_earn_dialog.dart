import 'dart:ui';
import 'package:mycbt/src/services/dynamic_link_service.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:share/share.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';

class ReferEarnDialog extends StatefulWidget {
  final String promoText;
  ReferEarnDialog({required this.promoText});

  @override
  _ReferEarnDialogState createState() => _ReferEarnDialogState();
}

class _ReferEarnDialogState extends State<ReferEarnDialog> {
  final TextEditingController promoTextController = TextEditingController();

  @override
  initState() {
    promoTextController.text = widget.promoText;
    super.initState();
  }

  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: <Widget>[
          Text("REFER & EARN",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Theme.of(context).primaryColor)),
        ],
      ),
      children: <Widget>[
        SimpleDialogOption(
          child: Column(
            children: <Widget>[
              TextField(
                style: TextStyle(fontSize: 15),
                controller: promoTextController,
                maxLines: 2,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Custom text',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue))),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                  onTap: () => share(context),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "SHARE",
                        style: TextStyle(color: kWhite),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  void share(context) async {
    Navigator.pop(context);
    if (promoTextController.text.length > 5) {
      final result = await checkConnetion();
      if (result == 0) {
        displayToast("No internet connection");
      } else {
        displayToast("Please wait...");
        String _linkMessage =
            await createDynamicLink(title: promoTextController.text, id: '');
        Share.share(
          _linkMessage,
        );
      }
    } else {
      displayToast("Your promo text is too short.");
    }
  }
}
