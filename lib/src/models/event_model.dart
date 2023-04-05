class EventModel {
  int? id;
  String? day;
  String? title;
  String? starts;
  String? ends;

  EventModel({
    this.day,
    this.title,
    this.starts,
    this.ends,
  });

  EventModel.withId({
    this.id,
    this.day,
    this.title,
    this.starts,
    this.ends,
  });


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['day'] = day;
    map['title'] = title;
    map['starts'] = starts;
    map['ends'] = ends;
    return map;
  }

  // Extract a Note object from a Map object
  EventModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.day = map['day'];
    this.title = map['title'];
    this.starts = map['starts'];
    this.ends = map['ends'];
  }
}
