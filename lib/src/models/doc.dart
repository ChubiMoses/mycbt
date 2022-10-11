import 'package:cloud_firestore/cloud_firestore.dart';

class DocModel {
  int? id;
  String? fID;
  String? school;
  String? title;
  String? url;
  String? ownerId;
  String? originalTitle;
  int? bytes;
  int? visible;
  int? favorite;
  int? conversation;
  String? likeIds;
  String? code;
  String? category;

  DocModel({this.fID, this.likeIds, this.favorite, this.visible, this.originalTitle, this.conversation, this.code, this.category,  this.bytes,this.ownerId, this.school,  this.title, this.url});

  DocModel.withId({this.id, this.fID, this.likeIds, this.favorite, this.originalTitle,  this.conversation, this.code, this.category,  this.bytes,this.ownerId,  this.visible, this.school,  this.title, this.url});

  factory DocModel.fromDocument(DocumentSnapshot doc) {
    return DocModel(
      fID: doc.id,
      school: doc.data().toString().contains('school') ? doc.get('school') : "", 
      title: doc.data().toString().contains('title') ? doc.get('title') : "", 
      url: doc.data().toString().contains('url') ? doc.get('url') : "",
      originalTitle: doc.data().toString().contains('originalTitle') ? doc.get('originalTitle') : "", 
      category: doc.data().toString().contains('category') ? doc.get('category') : "", 
      code: doc.data().toString().contains('code') ? doc.get('code') : "", 
      conversation: doc.data().toString().contains('conversation') ? doc.get('conversation') : 0,
      bytes: doc.data().toString().contains('bytes') ? doc.get('bytes') : 0, 
      visible: doc.data().toString().contains('visible') ? doc.get('visible') : 0, 
      favorite: doc.data().toString().contains('favorite') ? doc.get('favorite') : 0, 
      likeIds: doc.data().toString().contains('likeIds') ? doc.get('likeIds') :"", 
      ownerId: doc.data().toString().contains('ownerId') ? doc.get('ownerId') : "",
    );
  }

  // Convert a Note object into a Map object
	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
    if (id != null) {	map['id'] = id;}
    map['fID'] = fID;
		map['favorite'] = favorite;
    map['visible'] = visible;
    map['title'] = title;
		map['school'] = school;
		map['url'] = url;
    map['category'] = category;
		map['code'] = code;
    map['conversation'] = conversation;
		map['bytes'] = bytes;
		map['likeIds'] = likeIds;
    map['ownerId'] = ownerId;
		return map;
	}

	// Extract a Note object from a Map object
	DocModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    fID = map['fID'];
		title = map['title'];
    favorite = map['favorite'];
    visible = map['visible'];
		school = map['school'];
    url = map['url'];
    category = map['category'];
		code = map['code'];
    conversation = map['conversation'];
		bytes = map['bytes'];
    ownerId = map['ownerId'];
    likeIds = map['likeIds'];
  }
}
