import 'package:mycbt/src/utils/network_utils.dart';

import 'package:flutter/material.dart';

dynamic networkChecker(BuildContext context, msg) async {
  final result = await checkConnetion();
  if (result == 0) {
    SnackBar snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
