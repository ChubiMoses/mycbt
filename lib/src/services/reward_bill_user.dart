import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

billUser(String userId, int points){
 usersReference.doc(userId).get().then((value){
            if(value.exists){
              UserModel? data = UserModel.fromDocument(value);
              int p = (data.points - points);
              usersReference.doc(userId).update({
                "points": p,
              });
            }
        });
}
rewardUser( String? userId,  int points){
   usersReference.doc(userId).get().then((value){
      if(value.exists){
        UserModel? data = UserModel.fromDocument(value);
        int p = (data.points + points);
        usersReference.doc(userId).update({
          "points": p,
        });
      }
   });

   
}

 
