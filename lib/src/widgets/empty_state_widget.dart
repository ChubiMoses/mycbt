import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/colors.dart';


class EmptyStateWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  EmptyStateWidget(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 120.0, color: Colors.grey[300]),
           Text(
              title, textAlign:TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color:kGrey600),
            ),
            const SizedBox(height: 5.0,),
          ],
        ),
      ),
    );
  }
}
