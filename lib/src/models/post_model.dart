import 'package:cloud_firestore/cloud_firestore.dart';



class Post{
  final String? postId;
  final String? ownerId;
  final Timestamp? timestamp;
  final dynamic? likes;
  final String? username;
  final String? description;
  final String? url;
  final int? comments;
   final int?  visible;
  
  Post({
    this.postId,
    this.ownerId,
    this.timestamp,
    this.likes,
    this.username,
    this.visible,
    this.description,
    this.url,
    this.comments,
  });

  factory Post.fromDocument(DocumentSnapshot doc){
       return Post(
          postId: doc.get('postId') ?? "",
          ownerId: doc.get('ownerId') ?? "",
          likes : doc.get('likes') ?? "",
          username: doc.get('username') ?? "",
          timestamp: doc.get('timestamp') ?? "",
          description: doc.get('description') ?? "",
          url: doc.get('url') ?? "", 
          comments: doc.get('comments') ?? "",  
       );
  }

    
 }
