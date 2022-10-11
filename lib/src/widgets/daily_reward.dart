import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class RewardDialog extends StatefulWidget {
  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: <Widget>[
          Text("Daily Reward",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          Divider()
        ],
      ),
      children: <Widget>[
        Column(
          children: [
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.suit_diamond_fill,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
                Text("2",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0)),
              ],
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                rewardUser(currentUser?.id, 2);
                setState(() {
                  points += 2;
                });
                displayToast("Reward claimed");
              },
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width - 200,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                    child: Text("CLAIM",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        )
      ],
    );
  }
}
