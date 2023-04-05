import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:device_info/device_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> activationChecker(
    {required String? userId,
    required int? subscribed,
    required String? device}) async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

  if (subscribed == 1) {
    //subscribed using website
    if (device == "") {
      usersReference.doc(userId).update({
        "device": androidInfo.model,
      });
    }
    //user has changed his or her phone
    if (device != "" && device != androidInfo.model) {
      return false;
    }

    return true;
  } else {
    DocumentSnapshot value = await activeSubReference.doc(userId).get();
    if (value.exists) {
      usersReference.doc(userId).update({
        "subscribed": 1,
        "device": androidInfo.model,
      });
      return true;
    } else {
      return false;
    }
  }
}
