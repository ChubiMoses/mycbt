import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
   final IconData icon;
  final double size;
  final int count;
  const IconBadge({Key? key, required this.icon, required this.size, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          icon,
          size: size,
        ),
       count == 0 ? SizedBox.shrink() : Positioned(
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child:  Padding(
              padding: EdgeInsets.only(top: 1),
              child: Text(
              count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
