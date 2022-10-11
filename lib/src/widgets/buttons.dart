import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/colors.dart';

class TextButtonWidget extends StatelessWidget {
  final String btnText;
 final  VoidCallback onPressed;
  const TextButtonWidget({Key? key, required this.btnText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      onPressed: () => onPressed,
      child: Text(btnText,
          style: const TextStyle(fontWeight: FontWeight.w600, color: kWhite)),
    );
  }
}


class OutlinedButtonWidget extends StatelessWidget {
  final String btnText;
 final  VoidCallback onPressed;
  const OutlinedButtonWidget({Key? key, required this.btnText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      onPressed: () => onPressed,
      child: Text(btnText,
          style: const TextStyle(fontWeight: FontWeight.w600, color: kWhite)),
    );
  }
}


class ElevatedButtonWidget extends StatelessWidget {
  final String btnText;
 final  VoidCallback onPressed;
  const ElevatedButtonWidget({Key? key, required this.btnText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      onPressed: () => onPressed,
      child: Text(btnText,
          style: const TextStyle(fontWeight: FontWeight.w600, color: kWhite)),
    );
  }
}
