import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/notification.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

Future<int> unSeenNotificationCount(UserModel? currentUser) async {
  int noteCount = 0;
  if (currentUser != null) {
    await notificationReference
          .doc(currentUser.id)
          .collection("list")
          .where("ownerId", isEqualTo: currentUser.id)
          .where("seen", isEqualTo: 0)
          .get()
        .then((value) {
      return noteCount = value.docs.length;
    });
  }
  return noteCount;
}

 void seenNotification() async {
    if (currentUser != null) {
      await notificationReference
          .doc(currentUser?.id)
          .collection("list")
          .where("ownerId", isEqualTo: currentUser?.id)
          .where("seen", isEqualTo: 0)
          .get()
          .then((value) {
        List<NotificationsItem> notSeen = value.docs
            .map((document) => NotificationsItem.fromDocument(document))
            .toList();
        for (var element in notSeen) {
          notificationReference
              .doc(currentUser?.id)
              .collection("list")
              .doc(element.id)
              .update({'seen': 1});
        }
      });
    }
  }
