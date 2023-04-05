import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/admin/typing/rename_course.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_tile.dart';
import 'package:uuid/uuid.dart';

class ApproveDocs extends StatefulWidget {
  const ApproveDocs({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCoursesState createState() => _AddCoursesState();
}

class _AddCoursesState extends State<ApproveDocs> {
  bool isLoading = true;
  List<DocModel> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    setState(() {
      isLoading = true;
    });
    await studyMaterialsRef
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) {
      courses = value.docs
          .map((document) => DocModel.fromDocument(document))
          .toList();
      setState(() {
        courses = courses;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBgScaffold,
        body: isLoading
            ? loader()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    itemCount: courses.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, i) => const Divider(
                          height: 2,
                        ),
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onLongPress: () =>
                            deleteCourse(courses[i].fID!, courses[i].url!),
                        
                        onTap: () {
                          handleDocsRender(context,
                              title: courses[i].title!,
                              firebaseId: courses[i].fID!,
                              id: 0,
                              conversation: courses[i].conversation!,
                              progress: 0,
                              preview: false,
                              code: courses[i].code!,
                              view: "",
                              refresh: () {},
                              filePath: courses[i].url!);
                        },
                        child: Card(
                          elevation: 0.0,
                          child: ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                backgroundColor: courses[i].visible == 1
                                    ? Theme.of(context).primaryColor
                                    : kWhite,
                                child:IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RenameCourse(courses[i])))
                                , icon: const Icon(Icons.edit)),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              isThreeLine: true,
                              title: Text(
                                "${courses[i].code!.toUpperCase()} - ${courses[i].title!}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(courses[i].school!),
                              trailing: IconButton(
                                  onPressed:()=>approveDoc(courses[i].fID!, courses[i].ownerId!),
                                  icon: const Icon(
                                    Icons.check,
                                  ))),
                        ),
                      );
                    }),
              ));
  }
  
  void approveDoc(String docId, String ownerId){
//Approve document
    studyMaterialsRef
        .doc(docId)
        .update({
      'visible': 1,
      'lastAdded':DateTime.now().millisecondsSinceEpoch,
    });
    displayToast("Now visible");
                                  
    //reward user after verifying document
    if (snippet!.verifyPDF == 2) {
        String nid = const Uuid().v4();
      rewardUser(ownerId, 10);
      usersReference
          .doc(ownerId)
          .get()
          .then((value) {
        if (value.exists) {
          String token =
              UserModel.fromDocument(value)
                  .token;
          notify(
              ownerId:ownerId,
              username:currentUser!.username,
              profileImage:currentUser!.url,
              nid: nid,
              type: "Points",
              body: "You have earned 10 points",
              userId:currentUser!.id,
              token: token);
        }
      });
    }
   
  }
  void deleteCourse(String id, String url) {
    studyMaterialsRef.doc(id).delete();
    // docsStorageRef.child(url).delete();
    fetchCourses();
    displayToast("Course deleted");
  }
}
