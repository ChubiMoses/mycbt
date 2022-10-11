
class OfflineGistModel {
  int? id;
  String? postId;
  String? ownerId;
  String? time;
  int? likes;
  String? username;
  String? description;
  String? url;
  int? comments;
  int? visible;

  OfflineGistModel({
    this.postId,
    this.ownerId,
    this.time,
    this.likes,
    this.username,
    this.description,
    this.url,
    this.visible,
    this.comments,
  });

  OfflineGistModel.withId(
      {
      this.id,
      this.postId,
      this.ownerId,
      this.time,
      this.username,
      this.description,
      this.url,
      this.visible,
      this.comments});

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['postId'] = postId;
    map['visible'] = visible;
    map['ownerId'] = ownerId;
    map['time'] = time;
    map['username'] = username;
    map['description'] = description;
    map['url'] = url;
    map['comments'] = comments;
    return map;
  }

  // Extract a Note object from a Map object
  OfflineGistModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.postId = map['postId'];
    this.ownerId = map['ownerId'];
     this.visible = map['visible'];
    this.time = map['time'];
    this.username = map['username'];
    this.description = map['description'];
    this.comments = map['comments'];
  }
}
