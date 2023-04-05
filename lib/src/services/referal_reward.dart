import 'package:mycbt/src/models/referral.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

Future<void> refferrerReward(String code) async {
  if (code.length == 5) {
    await agentsRef
        .where("code", isEqualTo: code.trim().toUpperCase())
        .get()
        .then((value) {
      List<Referral>codes = value.docs
          .map((documentSnapshot) => Referral.fromDocument(documentSnapshot))
          .toList();
      if (codes != null) {
        String? userId = codes[0].id;
        int initialBalance = codes[0].balance;
        int balance = (initialBalance + 100);
        agentsRef.doc(userId).update({'balance': balance});
      } else {
        displayToast("Invalid referral code");
      }
    });
  }
}
