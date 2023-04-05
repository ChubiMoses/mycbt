import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

final usersReference = FirebaseFirestore.instance.collection("Users");
final feedbackRef = FirebaseFirestore.instance.collection("Feedback");

final settingsReference = FirebaseFirestore.instance.collection("Settings");

final reportReference = FirebaseFirestore.instance.collection("Reports");
final testimonialReference = FirebaseFirestore.instance.collection("Testimonials");


final questionsRef = FirebaseFirestore.instance.collection("Questions");
final answersRef = FirebaseFirestore.instance.collection("Answers");

final chatsRef = FirebaseFirestore.instance.collection("Chat ID");
final messageRef = FirebaseFirestore.instance.collection("Messages");

final preExamsQuestions = FirebaseFirestore.instance.collection("Preexams Questions");
final preExamResult = FirebaseFirestore.instance.collection("Preexams Result");

final docConversationRef = FirebaseFirestore.instance.collection("Document Conversation");
final notificationReference = FirebaseFirestore.instance.collection("Notifications");
final yearOneQuestionsRef = FirebaseFirestore.instance.collection("YearOne Questions");

final yearOneCoursesRef = FirebaseFirestore.instance.collection("YearOne Courses");
final conversationRef = FirebaseFirestore.instance.collection("Questions Conversations");
final convCommentsRef = FirebaseFirestore.instance.collection("Conv Comments");

final schoolRef = FirebaseFirestore.instance.collection("Schools");
final newSchoolRef = FirebaseFirestore.instance.collection("New Insttitution");


final subReference = FirebaseFirestore.instance.collection("New Subscription");
final agentsRef = FirebaseFirestore.instance.collection("Agents");

final activeSubReference = FirebaseFirestore.instance.collection("Active Subcription");

final versionRef = FirebaseFirestore.instance.collection("Version");

final qaDocRef = FirebaseFirestore.instance.collection("Courses");

final cbtCoursesRef = FirebaseFirestore.instance.collection("CBT Courses");
final studyMaterialsRef = FirebaseFirestore.instance.collection("Study Materials");

final snippetRef = FirebaseFirestore.instance.collection("Snippets");
final storageReference = FirebaseStorage.instance.ref().child('Uploaded Images');
final docsStorageRef = FirebaseStorage.instance.ref().child('Study Materials');
final requestQARef = FirebaseFirestore.instance.collection("QA Request");

// final DateTime timestamp = DateTime.now();
// String date = DateFormat('yyyy-MM-dd').format(timestamp);
  var formatter = DateFormat("yyyy-MM-dd");
