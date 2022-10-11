import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/colors.dart';

class MoreCard extends StatelessWidget {
  const MoreCard({
    required this.title,
    required this.press,
  });

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
     // color: kWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.toUpperCase(),
              style:  TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: kBlack),
            ),
            GestureDetector(
              onTap: press,
              child: Row(
                children:  [
                  Text(
                    'VIEW ALL',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
