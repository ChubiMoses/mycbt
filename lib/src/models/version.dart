import 'package:cloud_firestore/cloud_firestore.dart';
class Version{
  final double? version;
  final String? date;
  Version({this.version, this.date});

factory Version.fromDocument(DocumentSnapshot doc) {
    return Version(
      version: doc['version'],
      date: doc['date'],
    );
}     
}