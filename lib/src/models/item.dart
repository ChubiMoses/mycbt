import 'package:cloud_firestore/cloud_firestore.dart';
class Item{
  final String id;
  final String name;

  Item({
   required this.id,
   required this.name,
  });

  factory Item.fromDocument(DocumentSnapshot doc) {
    return Item(
      id: doc.id,
      name: doc['name'],
      );
   }
}


