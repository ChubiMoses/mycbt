import 'package:cloud_firestore/cloud_firestore.dart';
class Course{
  int? id;
  String? fID;
  String? school;
  String? name;

  Course({
    required this.fID,
    required this.school,
    required this.name,
  });

  Course.withId({
    required this.id,
    required this.fID,
    required this.school,
    required this.name,
  });

  factory Course.fromDocument(DocumentSnapshot doc) {
    return Course(
      fID:doc.id,
      school: doc.get('school') ?? "",
      name: doc.get('name') ?? "",
      );
   }

   // Convert a Note object into a Map object
	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
    if (id != null) {	map['id'] = id;}
    map['fID'] = fID;
		map['name'] = name;
		map['school'] = school;
		return map;
	}

	// Extract a Note object from a Map object
	Course.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    fID = map['fID'];
		name = map['name'];
		school = map['school'];
  }
}


